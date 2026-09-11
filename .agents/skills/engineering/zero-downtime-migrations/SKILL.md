---
name: zero-downtime-migrations
description: "Zero-downtime database schema migrations: expand/contract patterns, online index creation, lock timeout hygiene, non-locking batched backfills, and forbidden operations catalog. Use when designing, reviewing, or applying database migrations in production environments."
---

# Zero-Downtime Migrations

In modern high-availability architectures, deploying database changes must never cause user-facing downtime, lock connection pools, or interrupt application traffic.

This skill establishes the engineering discipline, execution patterns, and safety guardrails required for safe schema evolution on production databases (PostgreSQL, MySQL).

---

## 1. The Expand/Contract (Parallel Run) Pattern

### The Fundamental Law of Zero-Downtime
> **Deployments and migrations are asynchronous.**
> During any rolling deployment, canary release, or blue-green switch, **Version $N$ (old code)** and **Version $N+1$ (new code)** run simultaneously and access the same database.

Any schema modification must remain backwards-compatible with the old application version and forward-compatible with the new application version.

```
Timeline:
─────────────────────────────────────────────────────────────────────────────►
Phase 1: Expand      Phase 2: Dual-Write  Phase 3: Backfill   Phase 4: Read Cutover  Phase 5: Contract
(Add new column)    (App writes both)    (Worker migrates)   (App reads new)        (Drop old column)
Old App: works       Old App: works       Old App: works       New App: live          New App: live
New App: ready       New App: writing     New App: writing     Old App: drained       Old App: gone
```

---

### The 5-Phase Sequence

#### Phase 1: Expand (Additive Schema Migration)
Add the new column, table, or relation to the database.
- **Rule:** The new column **MUST be nullable** or have a safe default value that does not rewrite table rows.
- **Application State:** Version $N$ is running in production and completely ignores the new column.

```sql
-- Phase 1 Migration (PostgreSQL / MySQL)
ALTER TABLE users ADD COLUMN full_name VARCHAR(255) NULL;
```

#### Phase 2: Dual-Write (Application Rollout A)
Deploy application code that writes to **both** the old column and the new column, while still reading exclusively from the old column.
- Any newly created or updated record will have valid data in both locations.
- **Application State:** Rolling deployment of Version $N+1$ (Dual-Write). Reads still come from `first_name` and `last_name`.

```typescript
// Application Write Path (Version N+1)
async function updateUser(user: User, data: UserInput): Promise<void> {
  await db.users.update({
    where: { id: user.id },
    data: {
      first_name: data.firstName,           // Old representation
      last_name: data.lastName,             // Old representation
      full_name: `${data.firstName} ${data.lastName}`, // New representation (Dual-write)
    },
  });
}
```

#### Phase 3: Non-Locking Batched Backfill (Data Parity)
Run a background worker or script that populates the new column for all historical rows created prior to Phase 2.
- Execute in bounded batches with pacing intervals (see Section 4).
- Verify data parity using checksums or count queries:
  ```sql
  SELECT COUNT(*) FROM users WHERE full_name IS NULL; -- Must reach 0
  ```

#### Phase 4: Read Cutover (Application Rollout B)
Deploy application code that reads from the new column (`full_name`).
- Writes continue dual-writing (or write only to the new column once all nodes are on Version $N+2$).
- If regressions or format bugs appear, reverting to reading the old column is instantaneous without data loss.

```typescript
// Application Read Path (Version N+2)
function getUserDisplayName(user: User): string {
  return user.full_name; // Switched to new representation
}
```

#### Phase 5: Contract (Subtractive Migration & Cleanup)
Once 100% of running application containers are on Version $N+2$ and no active code reads or writes the old column:
1. Deploy code that removes all code references to the old column.
2. Execute the final cleanup migration to drop the old column/table.

```sql
-- Phase 5 Migration (PostgreSQL / MySQL)
ALTER TABLE users DROP COLUMN first_name;
ALTER TABLE users DROP COLUMN last_name;
```

---

## 2. Online Index Creation

Standard index creation (`CREATE INDEX`) acquires an exclusive table lock (`ShareLock` in Postgres, locking writes; `ALGORITHM=COPY` in older MySQL), stalling all incoming write traffic.

### PostgreSQL: `CREATE INDEX CONCURRENTLY`
```sql
CREATE INDEX CONCURRENTLY idx_users_email ON users (email);
```

#### Critical Rules for Postgres:
1. **Disable Transaction Blocks:** `CONCURRENTLY` **CANNOT** run inside a transaction block (`BEGIN ... COMMIT`).
   - Rails: `disable_ddl_transaction!`
   - Laravel: `$this->withoutTransactions();`
   - Flyway: Set `executeInTransaction=false` in migration header.
   - Raw psql: Ensure `AUTOCOMMIT ON`.
2. **Handling Failed / Invalid Indexes:**
   If `CREATE INDEX CONCURRENTLY` is cancelled or fails (e.g. unique constraint violation), Postgres leaves an `INVALID` index in the catalog:
   ```sql
   -- Check for invalid indexes
   SELECT indisvalid, indexrelid::regclass
   FROM pg_index
   WHERE NOT indisvalid;
   ```
   An invalid index consumes disk space and is still updated on inserts, slowing down writes!
   **Remediation:** Drop the invalid index and recreate it:
   ```sql
   DROP INDEX CONCURRENTLY IF EXISTS idx_users_email;
   CREATE INDEX CONCURRENTLY idx_users_email ON users (email);
   ```

### MySQL (InnoDB): Online DDL
InnoDB supports online index creation without table locks using the `INPLACE` algorithm:
```sql
ALTER TABLE users
  ADD INDEX idx_users_email (email),
  ALGORITHM=INPLACE,
  LOCK=NONE;
```
- `ALGORITHM=INPLACE`: Modifies index data structures directly without copying the table.
- `LOCK=NONE`: Allows concurrent `SELECT`, `INSERT`, `UPDATE`, and `DELETE`.
- **Pre-check:** Ensure sufficient temporary disk space (`tmpdir`) and monitor replication lag (`Seconds_Behind_Source`) on read replicas.
- For extremely large tables (> 50M rows), prefer tooling like `gh-ost` or `pt-online-schema-change`.

---

## 3. Lock Timeout Hygiene

### The DDL Lock Queuing Catastrophe
DDL operations (like `ALTER TABLE`) require an `AccessExclusiveLock` in PostgreSQL.
1. DDL requests `AccessExclusiveLock`.
2. A single long-running read query (e.g. an analytical `SELECT` taking 30 seconds) holds an `AccessShareLock`.
3. The DDL statement waits behind that read query.
4. **The Disaster:** Postgres queues all subsequent incoming queries (even fast 2ms `SELECT` queries) **behind the waiting DDL**.
5. Within 5–10 seconds, all available database connections are stuck waiting in line. The application connection pool exhausts, returning HTTP 500/504 errors across the entire system.

```
Incoming fast SELECTs ──┐
Incoming fast UPDATEs ──┼──► [QUEUED / BLOCKED] ──► [Connection Pool Exhaustion]
                        │             ▲
              ALTER TABLE (Waiting) ──┘
                        ▲
                        │
            Slow SELECT (Executing)
```

### The Solution: Mandatory Lock Timeouts
Every migration script running DDL **MUST** set a strict `lock_timeout`:

```sql
-- PostgreSQL
SET lock_timeout = '2s';
SET statement_timeout = '5s';

ALTER TABLE orders ADD COLUMN fulfillment_status VARCHAR(50);
```

```sql
-- MySQL
SET SESSION lock_wait_timeout = 2;

ALTER TABLE orders ADD COLUMN fulfillment_status VARCHAR(50);
```

### Automated Retry Loop Pattern
If the migration fails to acquire the table lock within 2 seconds, it aborts immediately without blocking the connection queue. The migration runner catches error `55P03` (`lock_not_available`) and retries after a randomized delay:

```bash
# Migration Runner Retry Loop
for attempt in {1..10}; do
  psql "$DATABASE_URL" -c "
    SET lock_timeout = '2s';
    ALTER TABLE orders ADD COLUMN fulfillment_status VARCHAR(50);
  " && break || {
    echo "Lock acquisition timed out. Retrying in 5 seconds..."
    sleep $((RANDOM % 5 + 3))
  }
done
```

---

## 4. Non-Locking Batched Backfills

### The Danger of Unbounded Updates
Never run massive updates across an entire table in a single transaction:
```sql
-- ⛔ FORBIDDEN: Locks millions of rows, floods WAL, creates catastrophic replication lag
UPDATE users SET full_name = CONCAT(first_name, ' ', last_name);
```
- Holds row locks on every row in the table until the transaction completes.
- Saturates Write-Ahead Logs (WAL) / InnoDB Undo Logs, causing storage bloat.
- Replicas fall tens of minutes behind due to single-threaded replication apply.

### Batched Primary Key Seek Pattern
Iterate through the table in bounded batches (500 to 2,000 rows) using indexed primary key pagination, with a mandatory sleep between batches:

```python
import time
import psycopg2

def backfill_full_name(conn, batch_size=1000, sleep_seconds=0.05):
    with conn.cursor() as cur:
        last_id = 0
        total_updated = 0

        while True:
            # 1. Update bounded batch by primary key seek
            cur.execute("""
                WITH batch AS (
                    SELECT id FROM users
                    WHERE id > %s AND full_name IS NULL
                    ORDER BY id ASC
                    LIMIT %s
                )
                UPDATE users
                SET full_name = TRIM(CONCAT(first_name, ' ', last_name))
                WHERE id IN (SELECT id FROM batch)
                RETURNING id;
            """, (last_id, batch_size))

            rows = cur.fetchall()
            if not rows:
                print(f"Backfill complete! Total updated: {total_updated}")
                break

            last_id = rows[-1][0]
            total_updated += len(rows)
            conn.commit()

            print(f"Updated {total_updated} rows... last_id: {last_id}")

            # 2. Yield CPU, WAL flush, and allow replica sync
            time.sleep(sleep_seconds)
```

---

## 5. Forbidden Single Operations (The Danger Catalog)

Never attempt the following single-step operations on production databases. Always replace them with their zero-downtime multi-step recipe:

| Forbidden Single Operation | Failure Mode | Zero-Downtime Multi-Step Recipe |
|---|---|---|
| **Renaming a column in-place**<br>`ALTER TABLE t RENAME COLUMN a TO b;` | Old app instances immediately fail with `Column 'a' not found`. | **Expand/Contract:**<br>1. Add column `b`<br>2. Dual-write to `a` & `b`<br>3. Backfill `b` from `a`<br>4. Cut over reads to `b`<br>5. Drop column `a`. |
| **Altering column type in-place**<br>`ALTER TABLE t ALTER COLUMN id TYPE BIGINT;` | Rewrites entire table on disk, holding an exclusive table lock for hours. | **Expand/Contract:**<br>1. Add `id_v2 BIGINT`<br>2. Dual-write to both<br>3. Backfill `id_v2`<br>4. Cut over foreign keys & reads<br>5. Drop old column. |
| **Adding a `NOT NULL` constraint directly**<br>`ALTER TABLE t ADD COLUMN status VARCHAR NOT NULL;` | Fails if existing rows exist, or scans entire table locking writes. | **Two-Step Constraint Addition:**<br>1. Add column as `NULL`<br>2. Backfill default values<br>3. Add check constraint `NOT VALID` (no scan)<br>4. `VALIDATE CONSTRAINT` asynchronously. |
| **Adding column with volatile default**<br>`ALTER TABLE t ADD COLUMN created_at TIMESTAMP DEFAULT now();` | In Postgres < 11, volatile defaults force a full table rewrite. | 1. Add column as `NULL`<br>2. Set default for future inserts: `ALTER TABLE t ALTER COLUMN created_at SET DEFAULT now();`<br>3. Backfill historical rows in batches. |
| **Adding Foreign Key constraint directly**<br>`ALTER TABLE orders ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id);` | Scans entire child table holding `ShareRowExclusiveLock`, blocking writes. | **Postgres Safe FK:**<br>1. `ALTER TABLE orders ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) NOT VALID;`<br>2. `ALTER TABLE orders VALIDATE CONSTRAINT fk_user;` (runs without blocking writes). |
| **Dropping a column while code still runs**<br>`ALTER TABLE t DROP COLUMN obsolete_field;` | Cached queries and active app servers will crash on `SELECT *` or insert maps. | 1. Deploy app version with `ignored_columns` / fields removed from model mappings.<br>2. Verify zero queries reference the column in APM/logs.<br>3. Run `ALTER TABLE ... DROP COLUMN`. |

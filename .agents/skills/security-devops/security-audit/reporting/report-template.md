# Security Audit Report Template

Use this template to document security audit results. This report format implements the **Evidence-First, Closed-Loop Defensive Standard**: findings are categorized by standardized confidence tiers, proven via unbroken taint traces and native reproduction tests (with zero offensive payloads), resolved through architectural root patches, and bounded by honest negative reporting.

---

## 1. Executive Summary & Findings Matrix

### Audit Overview
- **Repository / Target**: [Repository Name / Path]
- **Audit Date**: [YYYY-MM-DD]
- **Audit Scope**: [e.g., Full Codebase / API Gateway & Authentication Services / Commit Range]
- **Primary Tech Stack**: [e.g., Node.js / TypeScript, PostgreSQL, Express - extracted from manifests]

### Findings Summary
| Severity | Verified Static Flaw | Contract Mismatch | Manual Review Required | Total |
|---|---|---|---|---|
| **Critical** | 0 | 0 | 0 | **0** |
| **High** | 0 | 0 | 0 | **0** |
| **Medium** | 0 | 0 | 0 | **0** |
| **Low** | 0 | 0 | 0 | **0** |
| **Total** | **0** | **0** | **0** | **0** |

### Findings Matrix
| ID | Title | Threat Dimension | Severity | Confidence Tier | Location | Status |
|---|---|---|---|---|---|---|
| SEC-01 | [e.g., Unparameterized Query Interpolation] | D1: Injection | Critical | `[VERIFIED STATIC FLAW]` | `src/users/repo.ts:42` | Open |
| SEC-02 | [e.g., Undocumented Admin Param in User Update] | API Contracts | High | `[CONTRACT MISMATCH]` | `src/controllers/user.ts:88` | Open |
| SEC-03 | [e.g., Dynamic Reflection in Plugin Loader] | D8: Deserialization | Medium | `[MANUAL REVIEW REQUIRED]` | `src/plugins/loader.ts:15` | Open |

---

## 2. Detailed Findings

*(Repeat this section for each finding listed in the matrix)*

### [SEC-01] Title of Vulnerability

#### A. Classification & Confidence Tier
- **Threat Model Dimension**: [e.g., D1: Injection / API Contracts / Webhooks & Event Integrity]
- **Severity**: [Critical / High / Medium / Low]
- **Confidence Tier**: `[VERIFIED STATIC FLAW]` | `[CONTRACT MISMATCH]` | `[MANUAL REVIEW REQUIRED]`
- **CWE ID**: [e.g., CWE-89: SQL Injection / CWE-915: Mass Assignment]

#### B. Taint Flow Proof
Provide the exact, unbroken data flow from untrusted source to dangerous sink, verified via AST analysis.

```text
[SOURCE]     src/controllers/user.controller.ts:45 -> req.params.userId
               │
               ▼
[PROPAGATOR] src/services/user.service.ts:28 -> fetchUserRecord(userId)
               │
               ▼
[SINK]       src/repositories/user.repository.ts:64 -> db.raw(`SELECT * FROM users WHERE id = '${userId}'`)
               (AST Confirmed: BinaryExpression interpolation into raw query without parameter binding)
```

**Affected Code Excerpt (`src/repositories/user.repository.ts:62-66`):**
```typescript
62: export async function fetchUserRecord(userId: string) {
63:   // Untrusted input concatenated directly into raw query
64:   const result = await db.raw(`SELECT * FROM users WHERE id = '${userId}'`);
65:   return result.rows[0];
66: }
```

#### C. Closed-Loop Reproduction Test Harness
*(Authored in the project's native test framework using non-offensive boundary inputs. ZERO offensive exploit payloads.)*

**Test Location:** `test/security/user-repository.security.test.ts`
```typescript
import { describe, it, expect } from 'vitest';
import { fetchUserRecord } from '../../src/repositories/user.repository';

describe('Defensive Invariant: fetchUserRecord Boundary Handling', () => {
  it('should safely query IDs containing single quotes without query syntax disruption', async () => {
    // Boundary input: Legitimate character that disrupts raw query string concatenation
    const boundaryId = "user'test";

    // Expected invariant: The query parser handles this strictly as literal data without throwing syntax errors
    await expect(fetchUserRecord(boundaryId)).resolves.toBeDefined();
  });
});
```
- **Pre-Patch Execution Result**: **FAILED (RED)** — Throws `DatabaseError: syntax error at or near "test"`.

#### D. Root Cause Analysis & Architectural Patch
- **Root Cause**: The query is assembled via string interpolation rather than passing arguments through the database driver's parameter binding interface.
- **Architectural Solution**: Migrate from raw string concatenation to parameterized binding, enforcing physical separation between query instructions and user-supplied data.

**Remediation Diff:**
```diff
--- a/src/repositories/user.repository.ts
+++ b/src/repositories/user.repository.ts
@@ -61,5 +61,5 @@
 export async function fetchUserRecord(userId: string) {
-  const result = await db.raw(`SELECT * FROM users WHERE id = '${userId}'`);
+  const result = await db.raw('SELECT * FROM users WHERE id = ?', [userId]);
   return result.rows[0];
 }
```

#### E. Regression Verification
- **Post-Patch Reproduction Test**: **PASSED (GREEN)** — Query executes safely with parameterized binding.
- **Project Test Suite Status**: **142 tests passed, 0 failed**. Zero regressions detected.

---

## 3. Unverified Scope & Negative Findings

Honest declaration of verification boundaries, statically unprovable vectors, and areas requiring dynamic runtime testing.

### A. Statically Unverifiable Vectors
- **Runtime Environment & Secret Management**: Production values of environment variables (e.g., `SECRET_KEY`, `DATABASE_URL`) could not be inspected statically. Ensure KMS or secret manager enforces $\ge 256$-bit entropy.
- **Dynamic Reflection / External RPC**: Endpoint `POST /api/v1/auth/federated` delegates claims validation to external OIDC identity provider (`https://auth.enterprise.com`). The remote token signing and verification logic is outside local codebase boundaries.
- **Network Perimeter & WAF**: Static analysis does not evaluate network firewalls, rate-limiting reverse proxies, or cloud load balancer rules.

### B. Excluded Files & Directories
- `node_modules/` / `vendor/`: Audited solely via lockfile dependency scanning (`npm audit` / `composer audit`), not deep line-by-line manual code analysis.
- `dist/` / `build/`: Generated artifacts excluded; source files in `src/` audited directly.
- `tests/` / `fixtures/`: Test harnesses excluded from candidate sink vulnerability hunting.

### C. Recommended Dynamic & Operational Verifications
1. **Rate Limiting & Abuse Prevention**: Verify at the API gateway / ingress controller that `POST /api/v1/auth/login` enforces a rate limit (e.g., max 5 attempts per minute per IP).
2. **Clock Skew Tolerances**: In staging, verify that webhook consumer timestamp verification allows no more than a 300-second drift between remote publisher and local server time.
3. **Database Transaction Isolation**: Validate that the financial balance update workflow in `PaymentService` runs under `SERIALIZABLE` or `REPEATABLE READ` transaction isolation to prevent concurrent double-spending under high load.

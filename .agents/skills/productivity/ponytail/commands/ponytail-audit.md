# Ponytail Audit (`ponytail-audit`)

> *"Every codebase accumulates speculative cruft, obsolete dependencies, and ceremonial abstractions. An audit exposes the dead weight before it calcifies."*

`ponytail-audit` is a whole-codebase over-engineering and dead-weight audit guide shaped as a **SCOUT task contract**. A dispatched subagent (*Codebase Scout*) executes strictly read-only scans, identifies deletion and pruning candidates, and produces a structured markdown audit report without mutating codebase files.

---

## 1. SCOUT Task Contract Rules

When running a Ponytail Audit, the subagent MUST operate strictly within these bounds:
1. **Strictly Read-Only:** Zero file edits, zero file deletions, zero package installs.
2. **Deterministic Evidence:** Every finding must cite file paths, line numbers, and concrete evidence (e.g. call counts, replacement stdlib APIs).
3. **Categorized Tiers:** Group findings into risk-calibrated deletion tiers so the Captain can approve pruning batches with confidence.

---

## 2. Audit Dimensions & Scan Recipes

### Dimension 1: Single-Use Helper & Indirection Scan
Detect helper functions that are defined in utility or helper files but only invoked once across the entire codebase.

**Grep / Ripgrep Discovery Recipe:**
```bash
# 1. Find all exported functions in utils/ or helpers/
rg --no-heading -o "export (const|function) [a-zA-Z0-9_]+" src/utils/

# 2. For each identified helper, count occurrences across src/
# If count == 1 (only the definition itself) -> Dead code
# If count == 2 (definition + 1 call site) -> Candidate for inlining
rg -w "<helper_name>" src/ | wc -l
```

### Dimension 2: Pass-Through Wrapper Scan
Detect functions or classes that merely forward arguments to an underlying library or framework function without transforming data, validating inputs, or adding business logic.

**Pattern Signatures:**
```typescript
// Pass-through wrapper with zero added value:
export function getJson(url: string) {
  return fetch(url).then(r => r.json());
}
```
**Scan Recipe:**
- Inspect files named `*wrapper*`, `*adapter*`, `*client*`, or `*bridge*`.
- Check if the method body is $\le 3$ lines consisting purely of `return underlyingCall(...args)`.

### Dimension 3: Replaceable Third-Party Dependencies
Audit package manifests (`package.json`, `composer.json`, `pyproject.toml`) for packages that modern runtimes or standard libraries have rendered obsolete.

**Common Culprits & Modern Replacements:**
| Installed Package | Modern Standard / Native Replacement | Language / Runtime |
| :--- | :--- | :--- |
| `uuid` | `crypto.randomUUID()` | Node 16+, Browsers, Bun |
| `lodash.clonedeep` | `structuredClone()` | Node 17+, Browsers, Bun |
| `query-string` / `qs` | `new URLSearchParams()` | Web API, Node, Deno |
| `rimraf` / `mkdirp` | `fs.rmSync(p, { recursive: true })` / `fs.mkdirSync(p, { recursive: true })` | Node 14+ |
| `moment` / `moment-timezone` | `Intl.DateTimeFormat` or native `Date` | Modern JS / TS |
| `is-odd` / `is-even` | `n % 2 !== 0` | Native expression |
| `axios` (simple use cases) | Native `fetch()` | Node 18+, Browsers |
| `python-dateutil` | `datetime.fromisoformat()` | Python 3.11+ |
| `ramda` / `lodash` (for `map`/`filter`) | Native `Array.prototype` methods | Modern JS / TS |

### Dimension 4: Single-Implementation Interfaces & Abstract Factories
Find interfaces or abstract classes designed for hypothetical flexibility but possessing only one concrete implementation in the repository.

**Ripgrep Scan Recipe:**
```bash
# Find interface definitions
rg --no-heading "^export interface I[A-Z]" src/

# Search for implementers of interface:
# If only 1 class implements it, the interface adds pure ceremony.
rg "implements <InterfaceName>" src/
```

### Dimension 5: Dead Files & Orphan Modules
Detect files that exist in the repository but are never imported or referenced by any active entry point.

**Scan Recipe:**
```bash
# List source files and check if their basename is imported anywhere
for f in $(git ls-files 'src/**/*.ts'); do
  base=$(basename "$f" .ts)
  count=$(rg -w "$base" src/ | wc -l)
  if [ "$count" -eq 0 ]; then
    echo "Potential orphan: $f"
  fi
done
```

---

## 3. Categorized Deletion Tiers

Findings must be classified into three operational risk tiers:

### Tier 1: Zero-Risk Deletions (Immediate Win)
- Dead, unreferenced files.
- Single-use packages that have drop-in standard library replacements (`uuid`, `lodash.clonedeep`).
- Functions with 0 call sites across the entire repository.

### Tier 2: Low-Risk Simplifications (Pruning)
- Single-use helpers that can be safely inlined into their single call site.
- Pass-through wrappers that can be replaced with direct calls to the underlying API.
- Redundant helper functions that duplicate an existing canonical utility.

### Tier 3: Medium-Risk Refactors (Architectural Collapse)
- Single-implementation interfaces and abstract factories that can be collapsed into a direct concrete class.
- Custom heavy UI components that can be replaced by native HTML elements (`<dialog>`, `<details>`, `FormData`).
- Multi-layered data patterns (Repository + DAO + Manager) collapsed into idiomatic ORM queries.

---

## 4. SCOUT Audit Report Template

The subagent formats its findings using this markdown report structure:

```markdown
# 🥋 Ponytail Codebase Audit Report

## 1. Executive Summary
- **Total Files Scanned:** [Count]
- **Estimated Dead Weight Lines:** [Count]
- **Replaceable Dependencies Found:** [Count]
- **Potential Net Lines Saved:** [Count]

---

## 2. Tier 1: Zero-Risk Deletions
*Files and dependencies that can be removed with near-zero breakage risk.*

| Item | File / Package | Evidence | Recommended Action | Lines Saved |
| :--- | :--- | :--- | :--- | :--- |
| `uuid` dependency | `package.json` | 3 call sites can use `crypto.randomUUID()` | Remove package from deps | -1 dep / -40KB |
| `src/utils/oldFormatter.ts` | File | 0 imports in codebase | `git rm` file | -45 lines |

---

## 3. Tier 2: Low-Risk Simplifications (Inlining & De-wrapping)
*Single-use helpers and redundant wrappers that add cognitive indirection.*

| Helper / Wrapper | Location | Call Site | Inlining Strategy |
| :--- | :--- | :--- | :--- |
| `formatUserSlug()` | `src/utils/slug.ts#L12` | `src/controllers/user.ts#L45` | Inline 1-line string transform |

---

## 4. Tier 3: Medium-Risk Refactors (Architectural Collapse)
*Over-abstracted patterns, single-implementation interfaces, and heavy custom widgets.*

| Abstraction | Location | Issue | Recommended Simplification |
| :--- | :--- | :--- | :--- |
| `IUserRepository` | `src/interfaces/userRepo.ts` | Only 1 implementer (`PostgresUserRepo`) | Delete interface, use concrete repository or direct ORM |

---

## 5. Next Steps for Control Plane
1. Dispatch `Backend Specialist` or `Frontend UI Specialist` to prune Tier 1 items under a bounded `SHIP` contract.
2. Run test suite to verify 100% pass rate post-pruning.
```

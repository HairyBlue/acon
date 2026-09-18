# Anti-Hallucination & Evidence-First Verification

In automated and AI-assisted security auditing, hallucination (claiming a flaw exists without definitive structural evidence, or asserting exploitability based on superficial naming) is the primary failure mode. This document defines the strict, invariant evidence-first protocol required for every finding.

---

## 1. The Evidence-First Principle

An auditor must never report a vulnerability based on conjecture, typical patterns, or suspicious naming conventions. Every reported security finding **MUST** be backed by concrete, verifiable evidence extracted directly from the target codebase.

### Core Mandates:
1. **Zero Assumption Rule**: Never assume a function or helper is insecure simply because of its name (e.g., assuming `processInput()` or `handleQuery()` does not sanitize input). The auditor must inspect the actual implementation or declare it unverified.
2. **Verified Sinks Only**: A sink can only be labeled dangerous if the code actually executes an unsafe operation on unvalidated data at that exact call site.
3. **Continuous Data-Flow Proof**: A vulnerability exists only when a continuous, unbroken path from an untrusted source to a dangerous sink is demonstrated. Gaps in the flow invalidate a verified finding.
4. **No Code Fabrication**: Never invent, guess, or extrapolate code snippets, parameter names, or database column structures that do not exist in the repository.

---

## 2. Evidence Requirements Checklist

Before assigning a finding a confirmed status, verify that all four mandatory evidence pillars are satisfied:

| Pillar | Mandatory Requirement | Unacceptable Shortcut |
|---|---|---|
| **Pillar 1: File & Line Exactness** | Exact repository-relative path and precise line numbers (`path/to/file.ext:42-45`). | Vague module references (e.g., "in the authentication service"). |
| **Pillar 2: Verbatim Code Excerpt** | Verbatim code snippet from the repository matching the cited lines. | Paraphrased pseudo-code or synthetic examples. |
| **Pillar 3: Taint Chain Trace** | Step-by-step variable propagation trace from Source $\rightarrow$ Transformations $\rightarrow$ Sink. | "User input reaches the query string." |
| **Pillar 4: Sink Call Semantics** | Confirmation that the sink actually invokes dynamic execution (not a parameterized or safely abstracted wrapper). | Assuming `execute()` is raw SQL without checking the method signature or binding parameters. |

---

## 3. Contrast: Grounded Evidence vs. Hallucination

### Example: SQL Construction

#### ❌ Hallucination / Speculation (Rejected)
> "The `getUserProfile` method in `UserService.ts` is vulnerable to SQL injection because it accepts a `userId` parameter and queries the database. Attackers can bypass authentication and dump tables."
>
> *Why Rejected*: No line numbers, no code excerpt, assumes database query is raw without checking whether an ORM or parameterized query is used.

#### ✅ Grounded & Verified (Accepted)
> "In `src/services/UserService.ts:78-83`, user-controlled input `req.params.userId` (Source) flows into `userId` without type coercion or validation. At line 82, it is directly concatenated into a raw SQL query string passed to `db.raw()` (Sink):
> ```typescript
> 78: const { userId } = req.params;
> ...
> 82: const result = await db.raw(`SELECT * FROM users WHERE id = '${userId}'`);
> ```
> Control flow is reachable via the public route `GET /api/users/:userId` defined at `src/routes/user.routes.ts:24` without preceding authentication middleware."

---

## 4. Manifest Grounding (No Ghost Dependencies)

Security claims involving third-party libraries, framework behaviors, or runtime features must be grounded in the project manifest:

1. **Verify Exact Versions**: Inspect `package.json`, `Cargo.toml`, `pyproject.toml`, `composer.json`, `go.mod`, or `pom.xml`. Do not claim a library is vulnerable to a specific CVE without verifying that the pinned version in the lockfile (`package-lock.json`, `Cargo.lock`, `composer.lock`, etc.) falls within the affected range.
2. **Configuration Verification**: Do not assert that a framework security setting is disabled (e.g., CSRF protection, CORS policies, secure session cookies) unless the configuration file explicitly disables it or the framework default in that specific installed version is insecure.

---

## 5. Handling Incomplete Information

When static code analysis reaches a boundary that cannot be fully traced (e.g., dynamic imports, reflection, compiled binary extensions, external RPC services):

- **Do NOT claim a confirmed vulnerability.**
- **Do NOT remain silent** if a high-risk structural pattern is present.
- **Categorize honestly**: Tag the finding as `[CONTRACT MISMATCH]` or `[MANUAL REVIEW REQUIRED]` under the Negative Findings section (see `negative-reporting.md`). Explicitly declare what was verified, what could not be traced, and the specific condition required to prove or disprove the risk.

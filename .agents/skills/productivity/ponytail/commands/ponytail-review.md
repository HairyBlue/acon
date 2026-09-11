# Ponytail Review (`ponytail-review`)

> *"Reviewing code is not measuring how many patterns you can spot; it is measuring how much dead weight you can prune."*

`ponytail-review` is an anti-complexity and YAGNI review protocol. It is used by the Control Plane, subagents, and human engineers to evaluate incoming PRs, branch diffs, and specialist deliverables before merging.

---

## 1. The 4-Question Review Gate

Every pull request or diff must pass the 4-Question Gate. If any question fails, the reviewer must provide an actionable subtraction request.

```
+-------------------------------------------------------------------------------+
|                       THE 4-QUESTION REVIEW GATE                              |
|                                                                               |
|  [1] Did we build something nobody asked for?        -> STRIP IT              |
|  [2] Can this file or function be deleted entirely?  -> DELETE IT             |
|  [3] Is this helper earning its keep?                -> INLINE IT             |
|  [4] Are we creating future maintenance debt?        -> COLLAPSE TO PRIMITIVES|
+-------------------------------------------------------------------------------+
```

### Gate 1: Did we build something nobody asked for? (YAGNI Check)
- **Warning Signs:**
  - Config options or environment flags that are always set to default.
  - Generics, type parameters, or abstract classes with exactly one concrete implementation.
  - "Future-proof" extension points, hook systems, or plugin registries that no other code uses.
  - API endpoints, query filters, or sorting modes not required by the active task contract.
- **Actionable Remediation:**
  - Strip the unused parameters, interfaces, and options. Hardcode the single active requirement until an actual second use case exists.

### Gate 2: Can this file or function be deleted entirely? (Redundancy Check)
- **Warning Signs:**
  - Pass-through wrappers that merely forward arguments (`function fetchUsers(params) { return api.get('/users', params); }`).
  - Custom functions duplicating standard library methods (e.g. hand-rolled UUID, date parsing, object cloning, or URL parameter building).
  - New utilities that duplicate functions already present elsewhere in `src/utils/` or vendor libraries.
- **Actionable Remediation:**
  - Replace the calls with the native stdlib or existing codebase method, and `git rm` the redundant file/function.

### Gate 3: Is this helper earning its keep? (Indirection Check)
- **Warning Signs:**
  - Single-use 2-to-5 line functions extracted into separate files under `helpers/` or `utils/`.
  - Functions whose name is longer than the code inside them (e.g., `validateIsStringNotEmptyAndTrimmed(str)` containing `return Boolean(str?.trim());`).
  - Cognitive jump fatigue: Understanding a simple workflow requires navigating across 4 or more files.
- **Actionable Remediation:**
  - Inline the logic directly at the call site. Code that is read together should live together.

### Gate 4: Are we creating future maintenance debt for zero present benefit? (Complexity Check)
- **Warning Signs:**
  - Introducing a new third-party dependency for something doable in 5 lines of vanilla code.
  - Inventing custom state management or event emitters where language or platform primitives suffice.
  - Layered architectures (Controller $\rightarrow$ Service $\rightarrow$ Manager $\rightarrow$ Repository $\rightarrow$ DAO) for simple CRUD operations.
- **Actionable Remediation:**
  - Collapse layers into a direct, idiomatic service or controller method. Reject any unvetted dependency.

---

## 2. Quantitative Review Heuristics & Metrics

Use these four concrete metrics to audit diffs objectively:

| Metric | Threshold / Target | Violation Trigger | Remediation |
| :--- | :--- | :--- | :--- |
| **Cognitive Hop Count** | $\le 2$ file hops per execution path | $\ge 4$ files to trace one user action | Collapse intermediary pass-through layers into call site. |
| **Diff Subtraction Ratio** | Net neutral or net negative when refactoring | Adding $+100$ lines for a 5-line bug fix | Challenge speculative scaffolding; demand minimal diff. |
| **Rule of Three for Abstraction** | Exactly 3 distinct call sites | Abstracting when only 1 or 2 callers exist | Keep implementations concrete and duplicated until 3rd instance. |
| **Single-Use Helper Penalty** | Zero single-use files | Creating a new file for a helper called once | Inline helper logic into the calling module. |

### The Rule of Three
> *Duplication is far cheaper than the wrong abstraction.*  
> — Sandi Metz

- **1 Instance:** Write the concrete implementation directly.
- **2 Instances:** Tolerate the duplication. The pattern is not yet fully known.
- **3 Instances:** Now you have sufficient evidence of commonality to extract a shared function or abstraction.

---

## 3. The Ponytail Review Checklist

When performing a review, copy and complete this markdown checklist:

```markdown
### 🥋 Ponytail Code Complexity Review

#### 1. 7-Rung Ladder Compliance
- [ ] **Rung 1 (YAGNI):** No speculative parameters, unused options, or unrequested features.
- [ ] **Rung 2 (Codebase Reuse):** Reuses existing project utilities; zero duplicated helpers.
- [ ] **Rung 3 (Stdlib):** Uses language runtime/stdlib methods (`crypto.randomUUID`, `structuredClone`, `pathlib`).
- [ ] **Rung 4 (Platform Natives):** Uses native HTML/CSS/browser primitives (`<dialog>`, `FormData`, CSS grid) where applicable.
- [ ] **Rung 5 (Zero New Deps):** 0 new dependencies added to package/manifest files.
- [ ] **Rung 6 (Inline Clarity):** No single-use micro-helpers creating indirection; inline clarity preserved.
- [ ] **Rung 7 (Minimum Working Diff):** Diff is the smallest possible changeset that satisfies requirements.

#### 2. The Safety Invariants (Non-Negotiable)
- [ ] **Security:** Parameterized queries, CSRF tokens, sanitization, zero unvetted inputs.
- [ ] **Input Validation:** Strict runtime schema parsing at network/IO boundaries (Zod/Pydantic/FormRequest).
- [ ] **Error Handling:** Explicit error handling and meaningful status codes; zero empty catch blocks.
- [ ] **Accessibility (a11y):** Semantic elements, ARIA attributes, keyboard navigation supported.
- [ ] **Automated Tests:** 100% test pass rate with meaningful assertion coverage of the changes.

#### 3. Pruning Recommendations
- *Files/functions to delete:* [List items or "None"]
- *Helpers to inline:* [List items or "None"]
- *Speculative code to strip:* [List items or "None"]

#### 4. Verdict
- [ ] **APPROVED (Shipshape & Lean)**
- [ ] **CHANGES REQUESTED (Prune Dead Weight)**
```

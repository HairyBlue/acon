Mode: advisory

## State
The evaluator receives the drafted task brief (Template H or M) and its assigned target file list.

## Mechanical Checks
| Check | Condition | Forced Status | Forced Outcome | Description |
| :--- | :--- | :--- | :--- | :--- |
| `FILE_COUNT_EXCEEDED` | Target file list contains more than 3 files | `OK` | `BLOCKED` | Anti-gobble rule: tasks must touch $\le 3$ files (typically 1–2 production + 1 test file) |
| `WORD_COUNT_EXCEEDED` | Brief visibly exceeds ~1,500 words (~2,000 tokens) | `OK` | `BLOCKED` | Context slicing rule: worker briefs must remain $\le 2\text{k}$ tokens to prevent degradation |
| `MISSING_MANDATORY_SECTIONS` | Mandatory sections (`Objective`, `Scope`, `Deliverable`) not all present | `OK` | `BLOCKED` | Calibrated briefs rule: brief must contain all three mandatory boundary headers |
| `COLLIDING_FILE_SCOPE` | Any target file also appears in another active worker's assigned scope | `OK` | `BLOCKED` | Zero-overlapping boundary rule: no two workers may ever share a target file |
| `EMPTY_STATE` | Input state is empty, whitespace-only, or missing | `OK` | `BLOCKED` | Missing task brief or file list prevents pre-flight verification |

## Questions
| id | type | rubric |
| :--- | :--- | :--- |
| `hasAutomatedVerification` | `boolean` | Expect true. Rate high (`p >= 0.7`) if the task includes closed-loop automated verification (deterministic test runner, compiler, linter, or CLI check with exit code 0). Rate low (`p <= 0.3`) if verification relies on manual human checking, eyeball review, or has no automated check. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `isBoundedScope` | `boolean` | Expect true. Rate high (`p >= 0.7`) if scope is strictly bounded to the assigned files and explicit contracts, with zero speculative cleanup, open-ended refactors, future-proofing, or unrequested architectural changes. Rate low (`p <= 0.3`) if scope contains open-ended exploration or unconstrained tasks. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `touchesHumanCoreDomain` | `boolean` | Expect false. Rate high (`p >= 0.6`) if the task authors or alters high-stakes core domain algorithms (monetary/billing calculations, cryptographic code, authentication/authorization policies, state machines). Rate low (`p <= 0.2`) if restricted to test harnesses, edge-case mocks, UI layout, plumbing, or non-critical connectors. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. Note: A failure here blocks AI authoring and mandates `[HUMAN-CORE / AI-TEST]`. |
| `isBugFix` | `boolean` | Informational condition. Rate high (`p >= 0.5`) if the task is explicitly a defect ticket, bug fix, or regression resolution. Rate low (`p <= 0.2`) for greenfield features, routine styling, documentation, or planned refactors. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `briefHasReproTestFirst` | `boolean` | Conditional expect true (active only when `isBugFix >= 0.5`). Rate high (`p >= 0.7`) if the brief explicitly mandates authoring a failing reproduction test before modifying production code (red $\rightarrow$ minimal fix $\rightarrow$ green). Rate low (`p <= 0.3`) if the brief permits modifying production code without a reproduction test. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `needsNewTests` | `boolean` | Informational condition. Rate high (`p >= 0.5`) if the task touches business logic, calculations, enterprise invariants, or service boundaries per the Pragmatic Testing Standard (§8, Property 8). Rate low (`p <= 0.3`) for routine UI styling, obvious CRUD, mechanical renames, or glue verified via linter/compiler. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `briefSpecifiesTests` | `boolean` | Conditional expect true (active only when `needsNewTests >= 0.5`). Rate high (`p >= 0.7`) if the brief explicitly specifies the creation or update of automated tests and defines their expected pass criteria. Rate low (`p <= 0.3`) if new tests are required but the brief fails to specify them. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |

## Outcome Rules
Rule recipe: CHECKLIST.
For each evaluated item, unexpected probability $u$ is calculated as:
- For expect-true items: $u = 1.0 - p$
- For expect-false items: $u = p$

Evaluation thresholds for each active item:
- **Fail:** $u \ge 0.6$
- **Uncertain:** $u \in [0.4..0.5]$
- **Pass:** $u \le 0.3$

Conditional activation rules:
- `briefHasReproTestFirst` is active if and only if `isBugFix >= 0.5`.
- `briefSpecifiesTests` is active if and only if `needsNewTests >= 0.5`.

Outcome determination (first-match-wins):

| Priority | Rule Name | Condition | Status | Outcome | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | `MECHANICAL_HIT` | Any mechanical check (`FILE_COUNT_EXCEEDED`, `WORD_COUNT_EXCEEDED`, `MISSING_MANDATORY_SECTIONS`, `COLLIDING_FILE_SCOPE`, `EMPTY_STATE`) triggered | `OK` | `BLOCKED` | Mechanical violation forces immediate block; reshape brief before dispatch |
| 2 | `CHECKLIST_FAIL` | Any active checklist item fails ($u \ge 0.6$) | `OK` | `BLOCKED` | Anti-slop violation; task brief fails eligibility properties (failed items listed in result) |
| 3 | `CHECKLIST_UNCERTAIN` | Any active checklist item is uncertain ($u \in [0.4..0.5]$) and no item failed | `UNCERTAIN` | `UNCERTAIN` | Borderline eligibility; halts for manual audit and calibration by Control Plane |
| 4 | `CHECKLIST_PASS` | All active checklist items pass ($u \le 0.3$) | `OK` | `ELIGIBLE` | All 8 Anti-Slop properties satisfied; task is eligible for autonomous execution |

## Tight Order
1. `BLOCKED` (tightest: brief fails Anti-Slop standard; must be reshaped, partitioned, or rejected)
2. `UNCERTAIN` (intermediate: borderline brief; requires manual audit by Control Plane)
3. `ELIGIBLE` (loosest: fully calibrated brief; authorized for autonomous worker dispatch)

## On Uncertain
`UNCERTAIN`

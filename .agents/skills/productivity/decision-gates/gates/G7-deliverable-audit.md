Mode: advisory

## State
The evaluator receives the worker git diff, automated test/linter output, and original task contract.

## Mechanical Checks
| Check | Condition | Forced Status | Forced Outcome | Description |
| :--- | :--- | :--- | :--- | :--- |
| `NON_ZERO_EXIT_CODE` | Compiler, typechecker, linter, or test runner returned a non-zero exit code | `OK` | `REJECT_RETRY` | Deterministic verification failure: all automated checks must pass with exit code 0 |
| `OUT_OF_BOUNDS_FILES` | Git diff modifies any file path outside the assigned task file boundaries | `OK` | `REJECT_RETRY` | Boundary violation: workers are strictly forbidden from modifying unassigned files |
| `MISSING_VERIFICATION_OUTPUT` | Test or compiler output is missing when the task contract required verification | `OK` | `REJECT_RETRY` | Closed-loop verification failure: proof of execution is required before approval |
| `EMPTY_STATE` | Git diff is empty, whitespace-only, or missing | `OK` | `REJECT_RETRY` | Missing deliverable evidence prevents synthesis |

## Questions
| id | type | rubric |
| :--- | :--- | :--- |
| `scopeCreep` | `boolean` | Expect false. Rate high (`p >= 0.4`) if the diff introduces unassigned features, modifies unrelated functions, performs unrequested refactoring, or includes speculative future-proofing. Rate low (`p <= 0.1`) if the diff is strictly bounded to the exact requirements of the task contract. Verbatim quote from diff required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `unauthorizedDeps` | `boolean` | Expect false. Rate high (`p >= 0.3`) if the diff alters package manifests (`package.json`, `composer.json`, `Cargo.toml`, etc.) or introduces imports of new third-party libraries without explicit Captain authorization. Rate low (`p <= 0.1`) if zero new dependencies or unauthorized imports are introduced. Verbatim quote from diff required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `ponytailViolation` | `boolean` | Expect false. Rate high (`p >= 0.5`) if the diff violates the Ponytail 7-Rung Decision Ladder (e.g., adds unnecessary abstraction layers, wrapper classes, duplicate utility helpers, or premature generalizations where inline simplicity or stdlib suffices). Rate low (`p <= 0.2`) if the code is lean, minimal, and respects YAGNI. Verbatim quote from diff required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `testsSufficient` | `boolean` | Expect true. Rate high (`p >= 0.7`) if automated regression and unit tests pass with 100% success rate, provide full coverage of new business logic/calculations, and include reproduction tests for bug fixes. Rate low (`p <= 0.4`) if required tests are absent, skipped, commented out, or fail to exercise critical edge cases. Verbatim quote from test output or diff required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |

## Outcome Rules
Rule recipe: Universal Verification Gate.
Evaluated in strict first-match-wins order against questions `[scopeCreep, unauthorizedDeps, ponytailViolation, testsSufficient]`:

| Priority | Rule Name | Condition | Status | Outcome | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | `MECHANICAL_FAILURE` | Any mechanical check (`NON_ZERO_EXIT_CODE`, `OUT_OF_BOUNDS_FILES`, `MISSING_VERIFICATION_OUTPUT`, `EMPTY_STATE`) triggered | `OK` | `REJECT_RETRY` | Hard failure; reject deliverable and dispatch retry worker with explicit failure logs |
| 2 | `VERIFICATION_DEFECT` | Any violation triggered: `scopeCreep p >= 0.4` OR `unauthorizedDeps p >= 0.3` OR `ponytailViolation p >= 0.5` OR `testsSufficient p <= 0.4` | `OK` | `REJECT_RETRY` | Quality gate failed; worker violated scope, dependency, anti-overengineering, or test standards |
| 3 | `BORDERLINE_UNCERTAIN` | Any question in uncertain range: `scopeCreep` in `[0.2..0.3]` OR `unauthorizedDeps == 0.2` OR `ponytailViolation` in `[0.3..0.4]` OR `testsSufficient` in `[0.5..0.6]` | `UNCERTAIN` | `ESCALATE_CAPTAIN` | Ambiguous deliverable quality; escalate diff and trade-off analysis to Captain's Call |
| 4 | `VERIFICATION_PASSED` | All checks clean: `scopeCreep <= 0.1` AND `unauthorizedDeps <= 0.1` AND `ponytailViolation <= 0.2` AND `testsSufficient >= 0.7` | `OK` | `APPROVE` | Universal verification satisfied; deliverable approved for Phase IV Central Synthesis |

## Tight Order
1. `REJECT_RETRY` (tightest: rejects deliverable, worker must resolve defects in isolated worktree)
2. `ESCALATE_CAPTAIN` (intermediate: borderline diff presented in Captain's Call for steering)
3. `APPROVE` (loosest: approved for integration and synthesis by Control Plane)

## On Uncertain
`ESCALATE_CAPTAIN`

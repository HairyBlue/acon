Mode: advisory

<!-- Adapted from Fleet skills/orchestration-verification/SKILL.md at 0af843fa2c92413ea16c50e50bd8a9e24f1d1995. Local MIT notice: [crew reference](../../../../reference/crew/README.md#provenance-and-mit-notice). -->

## State
The evaluator receives the worker git diff, automated test/linter output, and original task contract. For missions using the assertion contract, read TaskContract requirements and parity inventory together with ShipDiff `assertion_evidence`; the schema files are canonical for field definitions. A gate result must reflect current evidence and full inventory coverage, not report prose or aggregate test counts alone.

## Mechanical Checks
| Check | Condition | Forced Status | Forced Outcome | Description |
| :--- | :--- | :--- | :--- | :--- |
| `NON_ZERO_EXIT_CODE` | Compiler, typechecker, linter, or test runner returned a non-zero exit code | `OK` | `REJECT_RETRY` | Deterministic verification failure: all automated checks must pass with exit code 0 |
| `OUT_OF_BOUNDS_FILES` | Git diff modifies any file path outside the assigned task file boundaries | `OK` | `REJECT_RETRY` | Boundary violation: workers are strictly forbidden from modifying unassigned files |
| `MISSING_VERIFICATION_OUTPUT` | Test or compiler output is missing when the task contract required verification | `OK` | `REJECT_RETRY` | Closed-loop verification failure: proof of execution is required before approval |
| `EMPTY_STATE` | Git diff is empty, whitespace-only, or missing | `OK` | `REJECT_RETRY` | Missing deliverable evidence prevents synthesis |
| `UNPROVEN_REQUIREMENT` | A required assertion/revision has no current relevant evidence record, is not `PROVEN`, or required evidence is unknown | `OK` | `REJECT_RETRY` | Absence, uncertainty, or a test without applicable evidence is not success; incomplete/legacy reports are not silently accepted |
| `FAILED_REQUIREMENT` | Current evidence contradicts a required assertion | `OK` | `REJECT_RETRY` | A contrary observation fails the deliverable |
| `STALE_EVIDENCE` | Evidence refers to an obsolete assertion revision or observed state, or a relevant correction/state change has not invalidated and rerun affected proof | `OK` | `REJECT_RETRY` | Keep historical evidence, mark affected records UNPROVEN, set `invalidated_by`, and re-establish current proof before approval |
| `PARITY_GAP` | Any inventoried touchpoint/member lacks applicable evidence, or inventory coverage cannot be established | `OK` | `REJECT_RETRY` | An exemplar passing does not prove its siblings; unknown completeness cannot approve |

## Evidence and Correction Rules
- ShipDiff contains exactly one `assertion_evidence` record per dispatched requirement revision. Assess its named artifact, locator, command/exit code where applicable, `observed_state`, status, reason, and invalidation; verify evidence exists and actually supports the stated assertion. YAML shape and passing a compiler do not establish semantic relevance.
- `PROVEN` requires relevant evidence for the current revision/state and no invalidation. `UNPROVEN`, missing records, stale references, and uncertain artifact relevance never count as success; a contrary observation is `FAILED`. Runtime behavior needs runtime observation when that is the assertion's proof kind; source or test prose cannot establish an unobserved runtime result.
- Check every member/site in the parity inventory, not just its exemplar. Every in-scope pair must map to relevant proof; reviewers assess inventory completeness, including stated exclusions and rationale. A claim of parity without this mapping triggers `PARITY_GAP`.
- On correction or relevant state change, keep requirement IDs, increment revisions when assertion meaning changes, retain superseded evidence as historical, mark affected records `UNPROVEN`, set `invalidated_by` to the correction/revision, and rerun affected proof and parity before redispatch. Unaffected proof survives only with an explicit dependency rationale. Compaction rereads assertion text, inventory, and evidence—not counts-only summaries. A later correction does not erase a previously observed failure; acceptance requires current re-verification.
- `COMPLETED` requires current `PROVEN` evidence for every required assertion and complete applicable parity. Receipt/acknowledgment is not completion. A report lacking the migrated schema fields is incomplete, not implicitly compliant.

## Questions
| id | type | rubric |
| :--- | :--- | :--- |
| `scopeCreep` | `boolean` | Expect false. Rate high (`p >= 0.4`) if the diff introduces unassigned features, modifies unrelated functions, performs unrequested refactoring, or includes speculative future-proofing. Rate low (`p <= 0.1`) if the diff is strictly bounded to the exact requirements of the task contract. Verbatim quote from diff required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `unauthorizedDeps` | `boolean` | Expect false. Rate high (`p >= 0.3`) if the diff alters package manifests (`package.json`, `composer.json`, `Cargo.toml`, etc.) or introduces imports of new third-party libraries without explicit Captain authorization. Rate low (`p <= 0.1`) if zero new dependencies or unauthorized imports are introduced. Verbatim quote from diff required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `ponytailViolation` | `boolean` | Expect false. Rate high (`p >= 0.5`) if the diff violates the Ponytail 7-Rung Decision Ladder (e.g., adds unnecessary abstraction layers, wrapper classes, duplicate utility helpers, or premature generalizations where inline simplicity or stdlib suffices). Rate low (`p <= 0.2`) if the code is lean, minimal, and respects YAGNI. Verbatim quote from diff required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `testsSufficient` | `boolean` | Expect true. Rate high (`p >= 0.7`) if automated regression and unit tests pass with 100% success rate, provide full coverage of new business logic/calculations, and include reproduction tests for bug fixes. Rate low (`p <= 0.4`) if required tests are absent, skipped, commented out, or fail to exercise critical edge cases. Verbatim quote from test output or diff required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |

## Outcome Rules
Rule recipe: Universal Verification Gate. Evaluate the four evidence defects (`UNPROVEN_REQUIREMENT`, `FAILED_REQUIREMENT`, `STALE_EVIDENCE`, `PARITY_GAP`) as rejection conditions alongside existing mechanical failures, before any approval rule. Retain existing gate questions, thresholds, and outcomes:

| Priority | Rule Name | Condition | Status | Outcome | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | `MECHANICAL_FAILURE` | Any existing execution/scope check (`NON_ZERO_EXIT_CODE`, `OUT_OF_BOUNDS_FILES`, `MISSING_VERIFICATION_OUTPUT`, `EMPTY_STATE`) triggered | `OK` | `REJECT_RETRY` | Hard failure; reject deliverable and dispatch retry worker with explicit failure logs |
| 2 | `ASSERTION_OR_PARITY_FAILURE` | Any evidence defect (`UNPROVEN_REQUIREMENT`, `FAILED_REQUIREMENT`, `STALE_EVIDENCE`, `PARITY_GAP`) triggered | `OK` | `REJECT_RETRY` | Required evidence is missing, contrary, stale, invalidated, or incomplete across the inventory; correct and rerun affected checks |
| 3 | `VERIFICATION_DEFECT` | Any violation triggered: `scopeCreep p >= 0.4` OR `unauthorizedDeps p >= 0.3` OR `ponytailViolation p >= 0.5` OR `testsSufficient p <= 0.4` | `OK` | `REJECT_RETRY` | Quality gate failed; worker violated scope, dependency, anti-overengineering, or test standards |
| 4 | `BORDERLINE_UNCERTAIN` | Any question in uncertain range: `scopeCreep` in `[0.2..0.3]` OR `unauthorizedDeps == 0.2` OR `ponytailViolation` in `[0.3..0.4]` OR `testsSufficient` in `[0.5..0.6]` | `UNCERTAIN` | `ESCALATE_CAPTAIN` | Ambiguous deliverable quality; escalate diff and trade-off analysis to Captain's Call |
| 5 | `VERIFICATION_PASSED` | All checks clean: `scopeCreep <= 0.1` AND `unauthorizedDeps <= 0.1` AND `ponytailViolation <= 0.2` AND `testsSufficient >= 0.7`, with every required assertion current `PROVEN` and parity complete | `OK` | `APPROVE` | Universal verification satisfied; deliverable approved for Phase IV Central Synthesis |

An uncertainty about whether an artifact supports an assertion or covers inventory is not a passing condition; treat as `UNPROVEN_REQUIREMENT`/`PARITY_GAP` and reject for correction, or escalate if the evaluator cannot resolve artifact relevance without inventing proof.

## Tight Order
1. `REJECT_RETRY` (tightest: rejects deliverable, worker must resolve defects in isolated worktree)
2. `ESCALATE_CAPTAIN` (intermediate: borderline diff presented in Captain's Call for steering)
3. `APPROVE` (loosest: approved for integration and synthesis by Control Plane)

## On Uncertain
`ESCALATE_CAPTAIN`

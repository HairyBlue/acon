Mode: advisory

## State
The evaluator receives the task objective plus the proposed architectural decomposition summary.

## Mechanical Checks
| Check | Condition | Forced Status | Forced Outcome | Description |
| :--- | :--- | :--- | :--- | :--- |
| `EXPLICIT_PLAN_COMMAND` | State literally contains `/plan` or `"write a plan"` (case-insensitive) | `OK` | `REQUIRED` | Explicit Captain directive mandates formal plan in `docs/plans/` |
| `EMPTY_STATE` | Input state is empty, whitespace-only, or missing | `OK` | `REQUIRED` | Missing architectural context forces formal planning gate |

## Questions
| id | type | rubric |
| :--- | :--- | :--- |
| `newSystemFromScratch` | `boolean` | Rate high (`p >= 0.6`) if creating a brand new system, top-level module, major component, or standalone service from a blank slate. Rate low (`p <= 0.2`) if extending, updating, or modifying an established codebase module. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `largeRefactorOrMigration` | `boolean` | Rate high (`p >= 0.6`) for subsystem-wide refactors, framework migrations, fundamental interface redesigns, or rewriting core abstractions. Rate low (`p <= 0.2`) for localized edits, additive changes, or non-breaking extensions. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `schemaChange` | `boolean` | Rate high (`p >= 0.6`) for database schema migrations, table additions/deletions, altering columns, state machine transitions, or non-trivial query pipelines. Rate low (`p <= 0.2`) if the task touches no database, schema, or persistence model. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `coreBusinessLogic` | `boolean` | Rate high (`p >= 0.6`) if touching mission-critical invariants (monetary/billing calculations, crypto, authentication/authorization rules, state machines). Rate low (`p <= 0.2`) for plumbing, UI layout, logging, or non-critical glue code. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `highAmbiguityTradeoffs` | `boolean` | Rate high (`p >= 0.6`) if multiple viable architectural approaches exist with significant downstream trade-offs. Rate low (`p <= 0.2`) if there is a single established, obvious implementation path. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `designOrStylingOnly` | `boolean` | Rate high (`p >= 0.7`) if task is strictly limited to visual styling, Tailwind classes, CSS, colors, typography, or cosmetic polish. Rate low (`p <= 0.3`) if application state, logic, APIs, or data models are affected. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `mechanicalRefactor` | `boolean` | Rate high (`p >= 0.7`) if task is a repetitive, syntax-level refactor across files (symbol renames, import updates, mechanical formatting) with zero architectural variance. Rate low (`p <= 0.3`) if control flow or interfaces change. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `obviousSinglePath` | `boolean` | Rate high (`p >= 0.7`) for bug fixes with known root cause, straightforward boilerplate/CRUD, or routine glue code requiring zero architectural debate. Rate low (`p <= 0.3`) if multiple solutions or trade-offs exist. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |

## Outcome Rules
Rule recipe: ANY-TRIGGER with exemption (`requiredAt: 0.6`, `uncertainAt: 0.4`, `exemptAt: 0.7`).
Triggers: `[newSystemFromScratch, largeRefactorOrMigration, schemaChange, coreBusinessLogic, highAmbiguityTradeoffs]`.
Exemptions: `[designOrStylingOnly, mechanicalRefactor, obviousSinglePath]`.

Evaluated in strict first-match-wins order:

| Priority | Rule Name | Condition | Status | Outcome | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | `MECHANICAL_HIT` | Any mechanical check (`EXPLICIT_PLAN_COMMAND`, `EMPTY_STATE`) triggered | `OK` | `REQUIRED` | Explicit Captain directive forces formal implementation plan in `docs/plans/` |
| 2 | `TRIGGER_DOMINANT` | Any trigger `p >= 0.6` | `OK` | `REQUIRED` | High architectural impact; author plan in `docs/plans/` and secure Captain sign-off |
| 3 | `BORDERLINE_EXEMPT` | Any trigger `p >= 0.4` AND at least one verified exemption `p >= 0.7` | `OK` | `NOT_REQUIRED` | Borderline trigger overridden by verified design, mechanical, or obvious exemption |
| 4 | `BORDERLINE_UNCERTAIN` | Any trigger `p >= 0.4` without a verified exemption `p >= 0.7` | `UNCERTAIN` | `REQUIRED` | Ambiguous trigger without verified exemption; safe default forces plan |
| 5 | `ALL_TRIGGERS_LOW` | All triggers `p <= 0.3` | `OK` | `NOT_REQUIRED` | Low architectural impact; plan exempt, proceed directly to execution |

*Note:* An exemption never overrides a trigger at or above `0.6` because `TRIGGER_DOMINANT` is evaluated first.

## Tight Order
1. `REQUIRED` (tightest: requires authoring formal plan in `docs/plans/` and securing Captain sign-off)
2. `NOT_REQUIRED` (loosest: plan-exempt, direct execution permitted)

## On Uncertain
`REQUIRED`

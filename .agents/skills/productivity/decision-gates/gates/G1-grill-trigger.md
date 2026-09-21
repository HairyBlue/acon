Mode: advisory

## State
The evaluator receives the Captain's raw objective plus the `prompt-master` 9-dimension intent extraction summary.

## Mechanical Checks
| Check | Condition | Forced Status | Forced Outcome | Description |
| :--- | :--- | :--- | :--- | :--- |
| `EMPTY_STATE` | Input state is empty, whitespace-only, or missing | `OK` | `ASK` | Missing input context forces immediate front-loaded alignment |

## Questions
| id | type | rubric |
| :--- | :--- | :--- |
| `unresolvedFork` | `boolean` | Rate high (`p >= 0.6`) if the objective contains two or more competing, mutually exclusive implementation architectures or product paths where the Captain has not explicitly chosen (e.g., REST vs GraphQL, Redis vs Postgres, library choice). Rate low (`p <= 0.2`) if the technical direction is unified or pre-determined. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `ambiguousIntent` | `boolean` | Rate high (`p >= 0.6`) if core goals, scope boundaries, or acceptance criteria are vague, contradictory, or open to conflicting interpretations. Rate low (`p <= 0.2`) if expected outcomes and deliverables are concrete and clear. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `missingCriticalConstraint` | `boolean` | Rate high (`p >= 0.6`) if essential operational bounds (e.g., target environment, breaking migration tolerance, security bounds, credentials) are absent and cannot be safely inferred from existing codebase conventions. Rate low (`p <= 0.2`) if all necessary constraints are declared or evident. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |

## Outcome Rules
Rule recipe: ANY-TRIGGER (`requiredAt: 0.6`, `uncertainAt: 0.4`).
Evaluated in strict first-match-wins order against questions `[unresolvedFork, ambiguousIntent, missingCriticalConstraint]`:

| Priority | Rule Name | Condition | Status | Outcome | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | `MECHANICAL_EMPTY` | Mechanical check `EMPTY_STATE` triggered | `OK` | `ASK` | Missing state forces upfront Captain consultation |
| 2 | `TRIGGER_REQUIRED` | Any trigger `p >= 0.6` | `OK` | `ASK` | Significant ambiguity or fork; trigger `grill-me` for 1–3 sharp questions |
| 3 | `TRIGGER_UNCERTAIN` | Any trigger `p >= 0.4` | `UNCERTAIN` | `ASK` | Borderline ambiguity; safe default halts for Captain alignment |
| 4 | `TRIGGERS_CLEAR` | All triggers `p <= 0.3` | `OK` | `SKIP` | Intent is crisp and unambiguous; proceed autonomously to task shaping |

## Tight Order
1. `ASK` (tightest: halts execution to secure Captain alignment via `grill-me`)
2. `SKIP` (loosest: allows autonomous flight to Phase II task shaping)

## On Uncertain
`ASK`

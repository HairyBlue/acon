Mode: advisory

## State
The evaluator receives the task specification plus intended file boundaries and deliverable requirements.

## Mechanical Checks
| Check | Condition | Forced Status | Forced Outcome | Description |
| :--- | :--- | :--- | :--- | :--- |
| `INTERACTIVE_REQUIREMENT` | Task specification explicitly requires interactive user interview, live steering, or external credential intake | `OK` | `shape: SCOUT`, `tier: TIER_1` | Human interaction or external input forces read-only scout with Tier 1 full calibration |
| `EMPTY_STATE` | Input state is empty, whitespace-only, or missing | `OK` | `shape: SCOUT`, `tier: TIER_1` | Missing task specification forces conservative read-only scout investigation |

## Questions
| id | type | rubric |
| :--- | :--- | :--- |
| `shape` | `choice` | Closed options: <br>• `SHIP`: Concrete code deliverable with explicit file boundaries, compile/lint/test verification, and diff presentation. Assign high probability (`p >= 0.6`) when task mutates AST, writes/edits production code or tests, or executes fixes.<br>• `SCOUT`: Strictly read-only investigation, diagnostic spike, dependency audit, or feasibility report producing structured findings. Assign high probability (`p >= 0.6`) when task inspects, measures, or reads without modifying files.<br>Probabilities across `[SHIP, SCOUT]` must sum to 1.0 ($\pm 0.1$). Verbatim evidence quote required from state. |
| `tier` | `choice` | Closed options: <br>• `TIER_1`: Multi-agent Ship missions, architectural changes, concurrent workers, or Plan-First Gate triggers requiring full calibration (Template H, Anti-Slop audit, Ponytail constraints). Assign high probability (`p >= 0.6`) for multi-worker, architectural, or plan-required tasks.<br>• `TIER_2`: Single-agent Ship tasks, plan-exempt multi-file tasks (styling, mechanical refactors, CRUD), or complex Scout investigations requiring standard brief (Template M). Assign high probability (`p >= 0.6`) for bounded single-agent tasks.<br>• `TIER_3`: Simple single-file lookups or quick read-only inspections requiring lightweight dispatch. Assign high probability (`p >= 0.6`) for trivial single-file checks.<br>Probabilities across `[TIER_1, TIER_2, TIER_3]` must sum to 1.0 ($\pm 0.1$). Verbatim evidence quote required from state. |

## Outcome Rules
Rule recipe: PICK-CHOICE (`minTop: 0.6`).
Evaluated independently for `shape` and `tier`:

### Shape Outcome Rules
| Priority | Rule Name | Condition | Status | Outcome | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | `MECHANICAL_SHAPE` | Any mechanical check (`INTERACTIVE_REQUIREMENT`, `EMPTY_STATE`) triggered | `OK` | `SCOUT` | Interactive requirement or empty state forces read-only scout |
| 2 | `CLEAR_SHAPE` | Top choice probability `p >= 0.6` | `OK` | Top choice (`SHIP` or `SCOUT`) | Classification meets certainty threshold |
| 3 | `UNCERTAIN_SHAPE` | Top choice probability `p < 0.6` or tie | `UNCERTAIN` | `SCOUT` | Ambiguous deliverable nature; safe default forces read-only scout |

### Tier Outcome Rules
| Priority | Rule Name | Condition | Status | Outcome | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | `MECHANICAL_TIER` | Any mechanical check (`INTERACTIVE_REQUIREMENT`, `EMPTY_STATE`) triggered | `OK` | `TIER_1` | High-coordination requirement or empty state forces Tier 1 full calibration |
| 2 | `CLEAR_TIER` | Top choice probability `p >= 0.6` | `OK` | Top choice (`TIER_1`, `TIER_2`, `TIER_3`) | Dispatch calibration tier meets certainty threshold |
| 3 | `UNCERTAIN_TIER` | Top choice probability `p < 0.6` or tie | `UNCERTAIN` | `TIER_1` | Ambiguous scope complexity; safe default forces Tier 1 full calibration |

## Tight Order
### Shape Tight Order
1. `SCOUT` (tightest: strictly read-only, zero codebase mutation)
2. `SHIP` (loosest: autonomous codebase mutation and testing)

### Tier Tight Order
1. `TIER_1` (tightest: full calibration, 9-dimension intent, Anti-Slop audit, Template H, Ponytail constraints)
2. `TIER_2` (intermediate: standard brief, Template M, 3+ dimension constraints)
3. `TIER_3` (loosest: lightweight single-Scout dispatch)

## On Uncertain
- `shape`: `SCOUT`
- `tier`: `TIER_1`

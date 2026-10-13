# Handoff State

Readable contract specification corresponding to the former `handoff-state.yaml` (JSON Schema Draft 2020-12). This is a human-readable parity specification, not executable validation.

## Envelope

| Property | Type | Required | Constraints |
|---|---|---:|---|
| `session_id` | string | Yes | No additional constraint is specified. |
| `timestamp` | string | Yes | No format or pattern is specified. |
| `plan_file` | string | Yes | No path pattern is specified. |
| `baseline_status` | string | Yes | Exactly `CLEAN`, `DIRTY_UNTESTED`, or `BROKEN`. |
| `invariants_preserved` | boolean | No | No additional constraint is specified. |
| `completed_tasks` | array of strings | No | No item-count or item-pattern constraint is specified. |
| `modified_files` | array of strings | Yes | No item-count or item-pattern constraint is specified. |
| `active_blockers` | array of strings | Yes | No item-count or item-pattern constraint is specified. |
| `exact_next_step` | object | Yes | Contains the required fields listed below. |

## Exact next step

| Property | Type | Required | Constraints |
|---|---|---:|---|
| `action` | string | Yes | Exactly `DISPATCH_WORKER`, `AWAIT_CAPTAIN`, or `RUN_TESTS`. |
| `target_task` | string | Yes | No additional constraint is specified. |
| `prompt_brief` | string | Yes | No additional constraint is specified. |

## Parity notes

The contract does not declare objects closed to additional properties. It specifies no timestamp format, session/task/path patterns, array bounds, uniqueness rules, or conditional requirements among fields. Requiredness and the `action` and `baseline_status` enums above are exhaustive; no further constraints are inferred from the handoff skill's prose guidance.

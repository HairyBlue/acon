# BearingsDigest

Canonical human-readable field contract for the four-section Fleet Bearings status report. This document specifies content; it is not an executable schema.

## Object contract

| Field | Type | Required | Item/object contract |
|---|---|---:|---|
| `captains_call` | array | yes | Each item is an object with the fields below. |
| `recently_landed` | array | yes | Each item is an object with the fields below. |
| `underway` | array | yes | Each item is an object with the fields below. |
| `charted_next` | array | yes | Each item is an object with the fields below. |

All four sections must be rendered, including as empty arrays when there is nothing to report. Their order is Captain's Call, Recently Landed, Underway, Charted Next.

## Item contracts

| Section / field | Type | Required | Constraint / meaning |
|---|---|---:|---|
| `captains_call[].item` | string | yes | Action item needing Captain attention. |
| `captains_call[].type` | string | yes | Exactly `DECISION`, `BLOCKER`, `APPROVAL`, or `CREDENTIAL`. |
| `captains_call[].action_needed` | string | yes | Action requested from the Captain. |
| `recently_landed[].task_id` | string | yes | Identifier of completed work. |
| `recently_landed[].description` | string | yes | Bounded completion description. |
| `recently_landed[].status` | string | yes | Exactly `MERGED`, `VERIFIED`, or `PASSED`. |
| `underway[].specialist` | string | yes | Active specialist identity or role. |
| `underway[].task_id` | string | yes | Identifier of active work. |
| `underway[].current_action` | string | yes | Current action/state, one line per active specialist. |
| `charted_next[].task_id` | string | yes | Identifier of queued work. |
| `charted_next[].description` | string | yes | Bounded description of queued work. |
| `charted_next[].blocked_by` | array of strings | yes | Dependencies/blockers; use an empty array when none. |

No additional enum, pattern, numeric bound, or conditional constraint is imposed by the source contract beyond the listed required fields and types.
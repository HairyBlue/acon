# TaskContract

Readable normative field contract for implementation-plan atomic task boundaries. This document specifies shape and acceptance rules; it is not an executable validator or machine-schema appendix.

**Source parity:** paired with the formerly canonical `task-contract.yaml` (2020-12 JSON Schema representation). Preserve provenance: assertion/parity adaptation is informed by Fleet `orchestration-verification/SKILL.md`; routing ideas derive from `docs/PHILOSOPHY.md` and `.pi/agents/model-profiles.yaml` (ideas only), Fleet revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`. Local MIT notice: [portable fleet](../crew/README.md#provenance-and-mit-notice). Requirements/parity are required for subsequent missions; legacy contracts without them are incomplete, not silently accepted. Routing is optional and absent routing means the current Captain-authorized inherited default. IDs are never recycled or renumbered; changed assertion meaning increments revision and retired IDs remain historical. Reviewers check mission-wide ID uniqueness/history, revision changes, touchpoint inventory completeness/exclusions, every site/member proof mapping, and routing availability/approvals/expiry/fallback at dispatch, resume, and completion acceptance. Discovery grants no spending authority.

## Envelope

| Property | Normative value |
|---|---|
| Title / kind | `TaskContract`; object |
| Required top-level fields | `task_id`, `title`, `eligibility`, `scope`, `consumes`, `produces`, `verification`, `requirements`, `parity` |
| Optional top-level field | `routing` |
| Additional fields | No restriction is asserted by the source contract. |

## Field and constraint parity

| Field / path | Type; requiredness | Constraints and semantics |
|---|---|---|
| `task_id` | string; required | Must match `^TASK-[0-9]{2}$`. |
| `title` | string; required | No further constraint specified. |
| `eligibility` | object; required | Required members: `closed_loop`, `anti_gobble_file_count`, `domain_criticality`. |
| `eligibility.closed_loop` | boolean; required within eligibility | No further constraint specified. |
| `eligibility.anti_gobble_file_count` | integer; required within eligibility | Maximum 3; no minimum specified. |
| `eligibility.domain_criticality` | string; required within eligibility | Enum: `AUTONOMOUS-SHIP`, `HUMAN-CORE / AI-TEST`. |
| `scope` | object; required | Required members `create`, `modify`, `forbidden`. |
| `scope.create`, `.modify`, `.forbidden` | array of strings; required within scope | No item-count bounds specified. |
| `consumes` | array; required | Each item is an object requiring `symbol` and `source_module`, both strings. No array bounds specified. |
| `produces` | array; required | Each item is an object requiring `symbol` and `type_signature`, both strings. No array bounds specified. |
| `verification` | object; required | Requires `command` (string), `expected_exit_code` (integer; default 0), and `verification_type` (string enum). |
| `verification.verification_type` | string; required within verification | Enum: `TDD_TEST_SUITE`, `TYPECHECK_OR_LINT`, `COMPILER_BUILD`, `DOCUMENTATION_CHECK`. |
| `requirements` | array; required | At least 1 item. Each object requires `requirement_id`, `revision`, `assertion`, `proof_kind`, `touchpoint_ids`. |
| `requirements[].requirement_id` | string; required | Pattern `^REQ-[0-9]{3}$`; globally unique within mission, never recycled/renumbered. Retired IDs stay in history. |
| `requirements[].revision` | integer; required | Minimum 1; increment when assertion meaning changes. |
| `requirements[].assertion` | string; required | Minimum length 1. |
| `requirements[].proof_kind` | string; required | Enum: `TEST`, `RUNTIME_OBSERVATION`, `STATIC_CHECK`, `CAPTAIN_CONFIRMATION`. |
| `requirements[].touchpoint_ids` | array of strings; required | Each string minimum length 1; no item-count bound specified. |
| `parity` | object; required | Requires `applicable`, `exemplar`, `members`, `touchpoints`; optional `reason`. Scout inventories flags, branches, display, validation, translations, fixtures, tests, and explicit excluded categories/reasons. Firstmate accepts inventory; every site/member pair needs proof, not only exemplar. |
| `parity.applicable` | boolean; required | Drives conditional contract below. |
| `parity.exemplar` | string; required | If applicable true: minimum length 1. If false: exactly empty string. |
| `parity.members` | array of unique strings; required | Each item minimum length 1. If applicable true: at least 1; if false: zero items. |
| `parity.touchpoints` | array; required | Each item requires `touchpoint_id`, `path`, `section_or_symbol`, `requirement_ids`, `members`. If applicable true: at least 1; if false: zero items. |
| `parity.touchpoints[].touchpoint_id`, `.path`, `.section_or_symbol` | strings; required per touchpoint | Each minimum length 1. |
| `parity.touchpoints[].requirement_ids` | array; required per touchpoint | At least 1; each string matches `^REQ-[0-9]{3}$`. |
| `parity.touchpoints[].members` | array of unique strings; required per touchpoint | At least 1; each item minimum length 1. |
| `parity.reason` | string; conditionally required | When `applicable` is false, required and minimum length 1. No constraint specified when applicable true. |
| `routing` | object; optional | RoleAuthorization record; task-local evidence only, never global provider configuration. Requires all fields listed below. |
| `routing.task_id` | string; required within routing | Minimum length 1. |
| `routing.role` | string; required within routing | Enum `MAIN_LEAD`, `HEAVY_CODER`, `REVIEWER`; if selection is `AUTHORIZED_TEMPORARY`, restricted to `MAIN_LEAD` or `HEAVY_CODER`. |
| `routing.selection` | string; required within routing | Enum `INHERIT`, `AUTHORIZED_TEMPORARY`. |
| `routing.capability_requirements` | array of strings; required | Each item minimum length 1; no array bounds specified. |
| `routing.available_choice_ref` | string; required | Minimum length 1; task-local reference to an available permitted choice. |
| `routing.approval_ref` | string; required | If `AUTHORIZED_TEMPORARY`, minimum length 1; otherwise no further constraint. |
| `routing.expires_at` | string; required | For `AUTHORIZED_TEMPORARY`: minimum length 1, date-time format, and pattern `^[0-9]{4}-[0-9]{2}-[0-9]{2}[Tt][0-9]{2}:[0-9]{2}:[0-9]{2}(\.[0-9]+)?([Zz]|[+-][0-9]{2}:[0-9]{2})$`. For `INHERIT`, exactly empty string. |
| `routing.budget_limit` | string; required | Minimum length 1. |
| `routing.fallback` | string; required | Enum `BLOCKED`, `APPROVED_DEFAULT`. |
| `routing.fallback_approval_ref` | string; required | If fallback is `APPROVED_DEFAULT`, minimum length 1; otherwise exactly empty string. |

## Conditional rules and authorization

- `parity.applicable=false` requires a nonempty `reason`, empty `exemplar`, and empty `members` and `touchpoints`; `true` requires nonempty exemplar and at least one member and touchpoint.
- `routing.selection=AUTHORIZED_TEMPORARY` is valid only for `MAIN_LEAD` or `HEAVY_CODER`, and requires nonempty approval reference plus valid nonempty expiration timestamp matching the stated format/pattern. Otherwise `expires_at` must be empty. Per settled portability policy, role/model/effort choices are proposed from Captain-permitted available choices and require Captain approval before launch; no fixed provider catalog, settings, or runtime selection is specified.
- `routing.fallback=APPROVED_DEFAULT` requires a nonempty fallback approval reference; `BLOCKED` requires it empty. Recheck authorization, availability, expiry, and fallback validity at dispatch, resume, and before accepting completion. Unknown capability/authorization is `BLOCKED`; never silently switch or spend.
- The source has no additional numeric bounds, closed-object rule, or constraints on unspecified strings unless explicitly stated above.

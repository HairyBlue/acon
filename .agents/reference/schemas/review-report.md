# ReviewReport

Readable normative field contract for code and security review reports. This document specifies shape and acceptance rules; it is not an executable validator or machine-schema appendix.

**Source parity:** paired with `review-report.yaml`, adapted from upstream `agents/code-reviewer.md` and `agents/security-auditor.md`, revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`. Preserve local attribution and full MIT notice at [crew reference](../crew/README.md#provenance-and-mit-notice). Model identity is evidence, not a selection instruction; never include credentials.

## Envelope

| Property | Normative value |
|---|---|
| Title / kind | `ReviewReport`; object |
| Required top-level fields | `envelope`, `review`, `findings`, `summary` |
| Additional fields | No restriction is asserted by the source contract. |

## Field and constraint parity

| Field / path | Type; requiredness | Constraints and semantics |
|---|---|---|
| `envelope` | object; required | Requires all five listed members. |
| `envelope.schema_id` | string; required within envelope | Exactly `review-report`. |
| `envelope.version` | string; required within envelope | Exactly `1.0`. |
| `envelope.generated_by` | string; required within envelope | No further constraint specified. |
| `envelope.timestamp` | string; required within envelope | No format constraint specified. |
| `envelope.task_id` | string; required within envelope | No pattern or length constraint specified. |
| `review` | object; required | Requires all eleven listed members. |
| `review.reviewer_type` | string; required within review | Enum `CODE`, `SECURITY`. |
| `review.reviewer_model` | string; required within review | Actual reviewer model identity evidence; not a selection instruction. Do not include credentials. No minimum length specified. |
| `review.reviewer_choice_ref` | string; required within review | Minimum length 1; task-local reference to actual authorized reviewer choice; no credentials. |
| `review.writer_choice_ref` | string; required within review | Minimum length 1; task-local reference to actual writer choice; no credentials. |
| `review.authorization_ref` | string; required within review | Minimum length 1; reference to current Captain authorization for reviewer selection. |
| `review.availability_checked_at` | string; required within review | Minimum length 1; timestamp/evidence reference for checking reviewer-choice availability before accepting review. |
| `review.context_ref` | string; required within review | Minimum length 1; task-local evidence that reviewer context is separate from writer session. |
| `review.correlation_warning` | string; required within review | Enum `CORRELATED_REVIEW`, `INDEPENDENT_REVIEW`. Report correlation from actual identity evidence; schema shape cannot establish independence. |
| `review.verdict` | string; required within review | Enum `PASS`, `FAIL`. |
| `review.cycles_completed` | integer; required within review | No minimum or maximum specified by source. |
| `review.escalated` | boolean; required within review | No further constraint specified. |
| `findings` | array; required | No item-count bounds specified. Each item requires all seven listed members. |
| `findings[].file` | string; required per finding | No further constraint specified. |
| `findings[].line` | integer; required per finding | No minimum or maximum specified. |
| `findings[].severity` | string; required per finding | Enum `CRITICAL`, `HIGH`, `MEDIUM`, `LOW`. |
| `findings[].category` | string; required per finding | No further constraint specified. |
| `findings[].evidence` | string; required per finding | No further constraint specified. |
| `findings[].suggested_fix` | string; required per finding | No further constraint specified. |
| `findings[].resolved` | boolean; required per finding | No further constraint specified. |
| `summary` | object; required | Requires all six listed members. |
| `summary.total_findings`, `.critical_count`, `.high_count`, `.medium_count`, `.low_count` | integer; required within summary | No numeric bounds or cross-field equality constraints specified by source. |
| `summary.blocking` | boolean; required within summary | No further constraint specified. |

## Review identity and acceptance rules

- Preserve reviewer type, actual reviewer model identity, reviewer/writer choice references, Captain authorization reference, availability evidence, and separate reviewer-context evidence. No credentials belong in report fields.
- A writer context is never an independent reviewer context. G8 code review and G9 security review are separate read-only review duties; each requires an independent reviewer context and actual identity/authorization/availability evidence. If reviewer and writer model identity is shared, mark `CORRELATED_REVIEW`; otherwise report identity-based `INDEPENDENT_REVIEW`. The enum alone does not prove independence.
- Recheck reviewer authorization and availability before accepting the review. Unknown required identity, authorization, availability, or isolation is `BLOCKED`, not a passing review. Captain-approved reviewer routing is required; do not silently switch choices or incur unapproved spend.
- The source schema sets no bounds on cycles, line numbers, finding counts, or summary counts and defines no cross-field arithmetic validation; do not invent such constraints here.

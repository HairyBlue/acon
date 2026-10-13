# DecisionSheet (`acon/decision-sheet/v1`)

Canonical human-readable contract for ACON Decision Gates evaluation sheets. This document specifies content; it is not an executable schema. Gate sheets evaluate existing governance and do not override Captain authority or relax established requirements.

## Root fields

| Field | Type | Required | Constraint / meaning |
|---|---|---:|---|
| `schema` | string | no | Constant `acon/decision-sheet/v1`; default is `acon/decision-sheet/v1`. |
| `gate` | string | yes | Exactly one of the seven gate IDs listed below. |
| `mode` | string | no | `advisory` or `enforce`; defaults to `advisory`. |
| `evaluator` | string | yes | Exactly `scout`, `worker`, `reviewer`, `oracle`, `evidence-auditor`, or `control-plane`. |
| `stateRef` | string | yes | Verifiable summary, reference, or digest of the evaluated input state. |
| `answers` | object | yes | Map from declared gate question IDs to answer records. Additional question-ID properties are permitted; each value follows the answer-record contract. |
| `result` | object | no | Derived result from the gate's deterministic Outcome Rules lookup. |

### Gate identifiers

`grill-trigger`, `plan-first`, `task-shape`, `anti-slop`, `skill-route`, `bearings-triage`, `deliverable-audit`.

## Answer record (`answers.<question-id>`)

Every answer record requires `evidence`.

| Field | Type | Required | Constraint / meaning |
|---|---|---:|---|
| `p` | number or map | no | A number is between 0.0 and 1.0 inclusive and represents probability (the source description specifies float multiples of 0.1). Alternatively, a map from arbitrary keys to numbers, each between 0.0 and 1.0 inclusive, represents a choice-probability distribution. |
| `choice` | string | no | Selected option identifier for choice questions. |
| `score` | integer | no | Selected level index for score questions; zero-based. |
| `evidence` | string | yes | Verbatim quote from the input state, at most 120 characters. The literal `NONE` is permitted only when a scalar `p` is at most 0.2. |

The source defines no additional cross-field requiredness among `p`, `choice`, and `score`. The `NONE` exception is conditional on a numeric `p` value; absent or distribution-valued `p` does not satisfy that condition.

## Result object (`result`)

| Field | Type | Required | Constraint / meaning |
|---|---|---:|---|
| `status` | string | yes | Exactly `OK`, `UNCERTAIN`, or `INVALID`. |
| `outcome` | string | yes | Deterministic outcome symbol derived from the gate lookup table. |
| `relaxing` | boolean | yes | True when outcome loosens or bypasses a governance requirement; such outcomes are always advisory. |
| `binding` | boolean | yes | True only when mode is `enforce` and the outcome tightens fleet governance. |

The result object itself is optional in the source contract. No additional result constraints are specified. The default mode is advisory; gate outcomes may only tighten governance and never supersede Captain authority.
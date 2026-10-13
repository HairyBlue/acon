# ShipDiff contract

Readable normative specification corresponding to `ship-diff.yaml`. This Markdown contract is not an executable validator. Keep field names and values exact. Source metadata: title `ShipDiff`; purpose: implementation specialist task completion summaries; no schema ID or revision is declared. Provenance: assertion-evidence ideas adapted from Fleet `skills/orchestration-verification/SKILL.md`, revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`; local MIT notice is [portable fleet](../crew/README.md#provenance-and-mit-notice).

## Top-level parity

| Field | Required | Type / constraints |
|---|---:|---|
| `task_id` | Yes | string |
| `status` | Yes | string; exactly `COMPLETED`, `FAILED`, or `PARTIAL` |
| `files_created` | Yes | array of strings |
| `files_modified` | Yes | array of strings |
| `files_deleted` | Yes | array of strings |
| `verification` | Yes | object, fields below |
| `diff_stat` | Yes | object, fields below |
| `notes` | No | string |
| `assertion_evidence` | Yes | array of assertion-evidence objects; minimum 1; exactly one record per dispatched requirement revision (semantic rule) |

Top-level value is an object. No additional-property restriction or other top-level bounds are specified.

## Nested fields and constraints

| Object / field | Required in object | Type / constraints |
|---|---:|---|
| `verification` object | — | object |
| `verification.command` | Yes | string |
| `verification.exit_code` | Yes | integer |
| `verification.summary` | Yes | string |
| `diff_stat` object | — | object |
| `diff_stat.insertions` | Yes | integer |
| `diff_stat.deletions` | Yes | integer |
| `diff_stat.files_changed` | Yes | integer |
| `assertion_evidence[]` object | — | object |
| `assertion_evidence[].requirement_id` | Yes | string matching `^REQ-[0-9]{3}$` |
| `assertion_evidence[].revision` | Yes | integer, minimum 1 |
| `assertion_evidence[].status` | Yes | string; exactly `PROVEN`, `UNPROVEN`, or `FAILED` |
| `assertion_evidence[].evidence_refs` | Yes | array of evidence-reference objects; minimum conditional below |
| `assertion_evidence[].observed_state` | Yes | string, minimum length 1; revision/hash or explicit working-diff identifier, not generic success claim |
| `assertion_evidence[].reason` | Yes | string |
| `assertion_evidence[].invalidated_by` | Yes | string; empty until invalidation, otherwise names correction/revision |
| `evidence_refs[]` object | — | object |
| `evidence_refs[].kind` | Yes | string; exactly `TEST`, `RUNTIME_OBSERVATION`, `STATIC_CHECK`, or `CAPTAIN_CONFIRMATION` |
| `evidence_refs[].artifact` | Yes | string, minimum length 1; durable artifact path/reference; existence and relevance need review |
| `evidence_refs[].locator` | Yes | string, minimum length 1; relevant named test, output, or observation and its scope |
| `evidence_refs[].command` | Yes | string |
| `evidence_refs[].exit_code` | Yes | integer or null; conditional relation below |

No bounds are given for ordinary strings, general arrays, or integer values beyond those shown. Objects have no additional-property restriction stated by the source.

## Conditional rules (normative)

1. For an evidence reference, when `command` is present and equals the empty string, `exit_code` must be null. Otherwise `exit_code` must be an integer. The command field is required, so these cases partition its permitted values.
2. A `PROVEN` assertion requires at least one `evidence_ref` and `invalidated_by` exactly empty string.
3. An `UNPROVEN` assertion requires `reason` length at least 1.
4. A `FAILED` assertion requires at least one `evidence_ref`; evidence must show a contrary observation and semantic relevance needs review.
5. Each dispatched requirement/revision has exactly one record. Evidence must refer to that exact assertion and current observed state. Review checks artifact existence, semantic relevance, currency of observed state, and complete parity coverage. These are cross-record/state semantics, not guaranteed by object shape.

## Evidence validity, correction, and compaction

Legacy reports lacking `assertion_evidence` are incomplete. `COMPLETED` requires current `PROVEN` evidence for every dispatched requirement revision; missing proof is never success. Compiler success alone does not establish runtime behavior or parity. On corrections/state changes, retain IDs, increment changed assertions' revisions, mark affected records `UNPROVEN`, preserve old evidence as historical, and set `invalidated_by` to the correction/revision. Rerun affected parity/proof before redispatch. Unaffected proof survives only with explicit dependency rationale. During compaction reread assertion text, inventory, and evidence; counts-only summaries are insufficient.

## Source-to-contract parity inventory

The source top-level required list and all nine properties are represented in the top-level table. Nested `required` lists are fully itemized for verification, diff-stat, assertion records, and evidence references. All primitive types, status/kind enums, regex, `minItems: 1`, both `minLength: 1` rules, revision `minimum: 1`, nullable exit code, and every nested `allOf` condition are recorded above. Descriptions are retained for evidence semantics. `$schema`, title, purpose and source comments/provenance are documented as metadata/semantics, not fields. The schema imposes no other explicit maxima, patterns, or `additionalProperties` restrictions.

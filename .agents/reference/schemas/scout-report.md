# ScoutReport contract

Readable normative specification corresponding to `scout-report.yaml`. This Markdown contract is not an executable validator. Preserve every key exactly when producing a report. No schema ID or revision is declared by the source.

## Top-level parity

| Field | Required | Type / constraints |
|---|---:|---|
| `status` | Yes | string; exactly `SUCCESS`, `PARTIAL`, or `BLOCKED` |
| `objective` | Yes | string |
| `files_inspected` | Yes | array of strings |
| `inventory` | Yes | array of inventory objects; see below |
| `findings` | Yes | array of finding objects; see below |
| `broken_references` | No | array of broken-reference objects; see below. Omission is permitted; no minimum length specified. |
| `risks` | Yes | array of strings |
| `next_actions` | Yes | array of strings |

The top-level value is an object. No additional-property restriction, string bounds, patterns, or array cardinality limits are specified.

## Nested object parity

| Object / field | Required in object | Type / constraints |
|---|---:|---|
| `inventory[]` object | — | object; no additional-property restriction or array bound specified |
| `inventory[].path` | Yes | string |
| `inventory[].role` | Yes | string; exactly `SOURCE`, `CONFIG`, `TEST`, `ASSET`, or `DOC` |
| `inventory[].symbols` | Yes | array of strings |
| `findings[]` object | — | object; no additional-property restriction or array bound specified |
| `findings[].topic` | Yes | string |
| `findings[].observation` | Yes | string |
| `findings[].evidence` | Yes | string |
| `broken_references[]` object | — | object; no additional-property restriction or array bound specified |
| `broken_references[].source_file` | Yes | string |
| `broken_references[].target_reference` | Yes | string |
| `broken_references[].issue` | Yes | string |

## Evidence and interpretation

Report findings with the evidence text required by the source field contract. Do not infer validation guarantees beyond these structural fields: the source specifies no evidence pattern, artifact-existence rule, citation length, or automatic invalidation semantics. Any stricter task-specific acceptance/evidence requirement remains applicable independently of this shape. Omitted optional `broken_references` means no claim about broken-reference inventory is structurally encoded; include an empty array when explicitly reporting none.

## Source-to-contract parity inventory

Every source declaration is represented above: top-level object; required list (`status`, `objective`, `files_inspected`, `inventory`, `findings`, `risks`, `next_actions`); `status` enum; each property and its primitive/array/item/object shape; nested required lists (`path`, `role`, `symbols`; `topic`, `observation`, `evidence`; `source_file`, `target_reference`, `issue`); and `role` enum. `$schema`, `title: ScoutReport`, and the description are source metadata, not report fields; title and purpose are identified here. No constraints have been added or removed.

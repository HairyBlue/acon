# Grill Interview

Readable contract specification corresponding to the former `grill-interview.yaml` (JSON Schema Draft 2020-12). This is a human-readable parity specification, not executable validation.

## Envelope

| Property | Type | Required | Constraints |
|---|---|---:|---|
| `round` | integer | Yes | No minimum or maximum is specified. |
| `frontier_status` | string | Yes | Exactly `ACTIVE` or `RESOLVED`. |
| `questions` | array of question objects | Yes | At least 1 and at most 3 items. |

## Question entries

Every item in `questions` is an object with these properties:

| Property | Type | Required | Constraints |
|---|---|---:|---|
| `id` | string | Yes | Must match `^Q[0-9]+$` (uppercase `Q` followed by one or more digits). |
| `title` | string | Yes | No additional constraint is specified. |
| `context` | string | Yes | No additional constraint is specified. |
| `options` | array of option objects | Yes | At least 2 and at most 4 items. |
| `recommended_option` | string | Yes | No enum or reference constraint is specified; it identifies the recommended option by convention. |
| `rationale` | string | No | No additional constraint is specified. |

## Option entries

Every item in a question's `options` is an object with these properties:

| Property | Type | Required | Constraints |
|---|---|---:|---|
| `key` | string | Yes | No additional constraint is specified. |
| `label` | string | Yes | No additional constraint is specified. |
| `trade_off` | string | Yes | No additional constraint is specified. |

## Parity notes

The contract requires the listed fields but does not declare any object closed to additional properties. It specifies no uniqueness constraints, cross-field conditions, numeric bounds for `round`, or requirement that `recommended_option` match an option key. Interview behavior (frontier rounds and explicit recommended choices) is described by the `grill-me` skill; no extra validation constraint is inferred here.

Mode: constitutional

## State
The evaluator receives the Captain's raw objective plus the `prompt-master` 9-dimension intent extraction summary.

## Mechanical Checks
| Check | Condition | Forced Status | Forced Outcome | Description |
| :--- | :--- | :--- | :--- | :--- |
| `EMPTY_STATE` | Input state is empty, whitespace-only, or missing | `OK` | `ASK` | Missing input context forces immediate front-loaded alignment |

## Completeness Signals

The evaluator counts how many of the following signals are **missing** from the Captain's message:

| Signal | Present if… |
| :--- | :--- |
| **Target scope** | Captain specifies files, modules, components, or pages to modify |
| **Technology/framework** | Captain names the language, framework, or library involved |
| **Acceptance criteria** | Captain describes what "done" looks like (behavior, output, appearance) |
| **Scope boundary** | Captain indicates what should NOT change, or limits the blast radius |

## Mandatory Triggers

The following conditions force `ASK` regardless of signal count:

- Captain's message is fewer than 20 words
- Captain uses "from scratch" / "build me" / "create a new" / "set up" phrasing (greenfield work)
- The task would touch `[HUMAN-CORE]` domains (monetary, auth, state machines)
- First message in a brand-new conversation/session (no prior context)

## Outcome Rules

Evaluated in strict first-match-wins order:

| Priority | Rule Name | Condition | Status | Outcome | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | `MECHANICAL_EMPTY` | Mechanical check `EMPTY_STATE` triggered | `OK` | `ASK` | Missing state forces upfront Captain consultation |
| 2 | `MANDATORY_TRIGGER` | Any mandatory trigger matched | `OK` | `ASK` | Hard-coded high-risk or low-context pattern; trigger `grill-me` |
| 3 | `SIGNALS_MISSING_2_PLUS` | 2–4 Missing signals | `OK` | `ASK` | Mandatory grill-me. Ask 1–3 targeted questions covering the missing signals |
| 4 | `SIGNALS_MISSING_1` | 1 Missing signal | `OK` | `CONTEXT` | Nearly complete — the Control Plane may infer the missing signal from codebase context. If inference confidence is low, escalate to `ASK` |
| 5 | `SIGNALS_COMPLETE` | 0 Missing signals | `OK` | `SKIP` | All 4 signals present — intent is clear. Proceed to prompt-master extraction then task shaping |

## Tight Order
1. `ASK` (tightest: halts execution to secure Captain alignment via `grill-me`)
2. `CONTEXT` (middle: allows inference attempt before deciding)
3. `SKIP` (loosest: allows autonomous flight to Phase II task shaping)

## On Uncertain
`ASK`

The default bias is toward asking, not toward skipping. When in doubt, ask.

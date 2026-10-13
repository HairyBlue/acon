---
name: grammars-and-constrained-sampling
description: Machine contracts, Token-0 anchoring, zero-preamble guidance, closed enums, and readable Markdown contract references.
---

# Machine Contracts & Grammar Envelopes (`grammars-and-constrained-sampling`)

> *"Do not ask an LLM to be concise in English. Constrain its structure to machine contracts."*

In multi-agent architectures, conversational token bloat drives context degradation, attention drift, and parser failures. Instructing an LLM with qualitative pleas ("be concise", "don't include filler") routinely fails. To achieve deterministic reliability, zero-overhead velocity, and reproducible execution, agent orchestration is governed by **The Machine Contract & Zero-Preamble Invariant**.

*(For the overarching 4-stage I/O & verification lifecycle—including input context slicing, dynamic sampling calibration, repetition penalties, and deterministic tool verification—see [`io-verification-control`](../io-verification-control/SKILL.md).)*

---

## The Machine Contract & Zero-Preamble Invariant

1. **First-Token Anchoring (Token-0):**  
   Never permit opening pleasantries (*"Sure!"*, *"Certainly!"*, *"Here is what I found"*). Where the harness supports first-token anchoring, anchor the prompt so the model's first generated token must be the structural opening of data or schema (`{`, `---`, or load-bearing markdown).

2. **Readable Contract Envelopes ([`.agents/reference/schemas/`](../../../reference/schemas/)):**
   Replace free-form status narratives and chat essays with structured reports guided by the canonical readable Markdown contracts. These documents specify normative fields and rules; they are not executable schemas or runtime validation.

3. **Closed Enum Constraints:**  
   Never solicit open-ended qualitative evaluations. Constrain status, severity, and decision fields to discrete, exhaustive sets (e.g. `[CRITICAL, HIGH, MEDIUM, LOW]`, `[SUCCESS, BLOCKED, FAILED]`). Closed enums eliminate subjective hallucinations and, where the harness supports constrained decoding, provide deterministic parsing.

4. **Tool-Bound Execution:**
   The assigned worker performs authorized code edits, file creations and system mutations only through verified mutation capability supplied by the active installed harness, within its exclusive file scope. Conversational code blocks are not an execution substitute. If required mutation capability is `UNAVAILABLE` or `UNKNOWN`, record `BLOCKED`; do not invent a tool or implement on the primary thread. Verify the resulting change with the task's explicit deterministic checks.

This verified-mutation wording is an ACON capability reconciliation informed by Fleet `docs/PHILOSOPHY.md`, revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`; see the [portable capability contract](../../../reference/crew/README.md#capability-discovery) and [local provenance and full MIT notice](../../../reference/crew/README.md#provenance-and-mit-notice). No source runtime is imported.

---

## Canonical Schemas (`.agents/reference/schemas/`)

Agent communications, task dispatches, and handoffs are guided by the eight canonical readable Markdown contract specifications in [`.agents/reference/schemas/`](../../../reference/schemas/):

| Markdown Contract | Consumer / Scope | Purpose & Normative Guidance |
| :--- | :--- | :--- |
| [**`scout-report.md`**](../../../reference/schemas/scout-report.md) | `Codebase Scout` (`SCOUT`) | Structured file inventories, findings, risks, and next actions. |
| [**`ship-diff.md`**](../../../reference/schemas/ship-diff.md) | Implementation Specialists (`SHIP`) | Exact file mutation manifest, diff stats, and verification test outputs. |
| [**`grill-interview.md`**](../../../reference/schemas/grill-interview.md) | Alignment & Sparring (`grill-me`) | 1–3 high-leverage questions with closed multiple-choice option enums. |
| [**`task-contract.md`**](../../../reference/schemas/task-contract.md) | Implementation Plans (`writing-plans`) | Atomic task definitions with $\le 3$ files, typed `Consumes`/`Produces`, and test checks. |
| [**`handoff-state.md`**](../../../reference/schemas/handoff-state.md) | Context Compaction (`handoff`) | Compact session state persistence (<500 tokens) for clean-slate resets. |
| [**`bearings-digest.md`**](../../../reference/schemas/bearings-digest.md) | Fleet Bearings ([`AGENTS.md §5`](../../../../AGENTS.md)) | 4-section status reporting: Captain's Call, Landed, Underway, Charted Next. |
| [**`decision-sheet.md`**](../../../reference/schemas/decision-sheet.md) | Decision gates | Gate outcomes, evidence and tighten-only rules. |
| [**`review-report.md`**](../../../reference/schemas/review-report.md) | Independent G8/G9 review | Findings, identities, context separation and correlation. |

---

## Before & After Prompting Examples

### 1. Eliminating Preambles & Conversational Drift

❌ **Weak Prompt (Conversational):**
```text
Please inspect the auth controllers and give me a concise summary of your findings. Don't be too wordy.
```
*Result:* Model generates 120 tokens of chit-chat (*"Sure! I'd be happy to help. After reviewing..."*) followed by an unstructured narrative.

✅ **Constrained Prompt (First-Token Anchored & Schema-Locked):**
```text
Audit auth session handlers in app/Http/. Do not emit conversational preambles or greetings.
First emitted character MUST be the opening triple-dash (---) of this structured report:
---
status: [SUCCESS | BLOCKED]
files_inspected: [list of paths]
findings: [{topic: str, observation: str, evidence: str}]
risks: [list of str]
```

### 2. Eliminating Qualitative Ambiguity with Closed Enums & Schema Locks

❌ **Weak Prompt (Qualitative & Unstructured):**
```text
Let me know if you think this migration is risky and what the status of the tests are.
```

✅ **Constrained Prompt (Enum-Locked & Schema-Bound):**
```text
Deliver migration assessment following these closed enums and structured report guidance:
---
risk_level: [LOW | MEDIUM | HIGH | CRITICAL]
test_status: [ALL_PASS | FAILING | UNVERIFIED]
blocking_issue: [NONE | SCHEMA_LOCK | DATA_LOSS_RISK]
```

### 3. Tool-Bound Execution vs. Speculative Markdown Dumps

❌ **Weak Prompt (Chat Code Dump):**
```text
Write a function that parses bearer tokens from HTTP authorization headers and show me the code.
```
*Result:* Model outputs conversational explanations and markdown fenced code blocks in chat that require human copy-pasting and risk unverified execution.

✅ **Constrained Prompt (Tool-Bound):**
```text
As the assigned worker, implement `extractBearerToken(header: string): string | null` in your authorized file `src/auth/token.ts`.
Execute edits only through verified mutation capability supplied by the active installed harness; code blocks in chat are not a substitute.
If the required capability is UNAVAILABLE or UNKNOWN, report BLOCKED; do not invent a tool or implement on the primary thread.
Verify immediately using `npm test -- src/auth/token.test.ts` and report its output and exit code.
```

---

## Related Skills & System Governance

- **[`io-verification-control`](../io-verification-control/SKILL.md):** Overarching 4-stage I/O and verification lifecycle (Input Control, Sampling Calibration, Output Contracts, and Ground Truth Verification).
- **[`ponytail`](../ponytail/SKILL.md):** Anti-overengineering review, minimal diffs, and 7-Rung Decision Ladder.
- **[`prompt-master`](../prompt-master/SKILL.md):** 9-dimension prompt calibration and task brief templates.
- **[`writing-plans`](../writing-plans/SKILL.md):** Implementation plans with atomic tasks and typed `Consumes`/`Produces` contracts.
- **[`.agents/rules/agent-control-plane.md`](../../../rules/agent-control-plane.md):** Constitution §6 (The Machine Contract & Zero-Preamble Invariant).


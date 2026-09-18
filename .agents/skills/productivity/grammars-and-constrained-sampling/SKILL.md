---
name: grammars-and-constrained-sampling
description: Principles for instructing LLMs with structural constraints, zero preamble, schema-locked envelopes, closed enums, and bounded token scope.
---

# Machine Contracts & Constrained Prompting (`grammars-and-constrained-sampling`)

> *"Do not ask an LLM to be concise in English. Constrain its structure."*

In multi-agent architectures, conversational token bloat is the primary driver of context degradation, attention drift, and parsing failures. Instructing an LLM with qualitative pleas ("be concise", "don't include filler") routinely fails. To achieve deterministic reliability and zero-overhead velocity, communication must be governed by structural prompt constraints.

---

## The 5 Behavioral Principles of Constrained Prompting

1. **First-Token Anchoring (Killing Preambles at Token 0):**  
   Never permit opening pleasantries (*"Sure!"*, *"Certainly!"*, *"Here is what I found"*). Anchor the prompt so the model's first generated token must be the structural opening of data or schema (`{`, `---`, or load-bearing markdown).
2. **Schema-Locked Envelopes (Replacing Essays with `.agents/schemas/`):**  
   Replace free-form status narratives and chat essays with strict machine-parseable YAML/JSON schemas. Dispatched subagents must return data strictly within designated schema envelopes in [`.agents/schemas/`](../../../schemas/).
3. **Closed Enum Choices (Eliminating Subjective Hallucination):**  
   Never solicit open-ended qualitative evaluations. Constrain status, severity, and decision fields to discrete, exhaustive sets (e.g. `[CRITICAL, HIGH, MEDIUM, LOW]`, `[SUCCESS, BLOCKED, FAILED]`).
4. **Bounded Output Scope (Strict Field Quotas, Max Tokens per Message):**  
   Impose explicit field budgets and token limits (e.g. max 3 bullet items, $\le 500$ tokens per state handoff). Unbounded fields inevitably degrade into narrative drift.
5. **Tool-Bound Execution (Mutations in Tools, Not Chat):**  
   Code edits, file creations, and system mutations must NEVER be emitted as conversational markdown code blocks. Force execution strictly through verified tool calls (`write_to_file`, `replace_file_content`).

---

## Canonical Schemas (`.agents/schemas/`)

All agent communications, task dispatches, and handoffs map directly to the 6 canonical YAML schemas in [`.agents/schemas/`](../../../schemas/):

| Schema File | Consumer / Scope | Purpose & Enforced Envelopes |
| :--- | :--- | :--- |
| [**`scout-report.yaml`**](../../../schemas/scout-report.yaml) | `Codebase Scout` (`SCOUT`) | Structured file inventories, findings, risks, and next actions. |
| [**`ship-diff.yaml`**](../../../schemas/ship-diff.yaml) | Implementation Specialists (`SHIP`) | Exact file mutation manifest, diff stats, and verification test outputs. |
| [**`grill-interview.yaml`**](../../../schemas/grill-interview.yaml) | Alignment & Sparring (`grill-me`) | 1–3 high-leverage questions with closed multiple-choice option enums. |
| [**`task-contract.yaml`**](../../../schemas/task-contract.yaml) | Implementation Plans (`writing-plans`) | Atomic task definitions with $\le 3$ files, typed `Consumes`/`Produces`, and test checks. |
| [**`handoff-state.yaml`**](../../../schemas/handoff-state.yaml) | Context Compaction (`handoff`) | Compact session state persistence (<500 tokens) for clean-slate resets. |
| [**`bearings-digest.yaml`**](../../../schemas/bearings-digest.yaml) | Fleet Bearings ([`AGENTS.md §5`](../../../../AGENTS.md)) | 4-section status reporting: Captain's Call, Landed, Underway, Charted Next. |

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
First emitted character MUST be the opening triple-dash (---) of this YAML envelope:
---
status: [SUCCESS | BLOCKED]
files_inspected: [list of paths]
findings: [{topic: str, observation: str, evidence: str}]
risks: [list of str]
```

### 2. Eliminating Qualitative Ambiguity with Closed Enums

❌ **Weak Prompt (Qualitative):**
```text
Let me know if you think this migration is risky and what the status of the tests are.
```

✅ **Constrained Prompt (Enum-Locked):**
```text
Deliver migration assessment strictly adhering to these enums:
risk_level: [LOW | MEDIUM | HIGH | CRITICAL]
test_status: [ALL_PASS | FAILING | UNVERIFIED]
blocking_issue: [NONE | SCHEMA_LOCK | DATA_LOSS_RISK]
```

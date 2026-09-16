---
name: grammars-and-constrained-sampling
description: Eliminates conversational token waste and formatting drift by enforcing formal machine grammars (YAML/JSON schemas, enums, regexes) and constrained token sampling across the multi-agent lifecycle.
---

# Grammars & Constrained Sampling (`grammars-and-constrained-sampling`)

> *"Do not ask an LLM to be concise in English. Force it to speak in grammars."*

In multi-agent systems, conversational token bloat is the leading cause of context degradation, latency spikes, and parsing failures. When agents exchange conversational filler (*"Sure! I'd be happy to help with that...", "Here is the summary of what I found...", "I hope this helps!"*), they consume valuable window capacity, induce attention drift, and force fragile regex parsing.

**Grammars and Constrained Sampling** replaces conversational drift with deterministic machine contracts. By restricting decoding logits at the token level and enforcing formal grammar schemas, agents communicate at maximum density, zero hallucinations, and 100% parseable reliability.

---

## 1. Overview & Core Concepts

### Grammars vs. Constrained Sampling

Understanding the distinction between syntax definitions and runtime execution is foundational:

```
┌────────────────────────────────────────────────────────┐
│ 1. Formal Grammar (The Syntactic Specification)        │
│    • JSON Schema / YAML Specification                  │
│    • Context-Free Grammars (GBNF / EBNF)               │
│    • Regular Expressions & Finite State Automata (FSA) │
└──────────────────────────┬─────────────────────────────┘
                           │ Compiles into
                           ▼
┌────────────────────────────────────────────────────────┐
│ 2. Constrained Sampling (The Runtime Masking Engine)   │
│    • Forward pass produces raw logits over vocabulary  │
│    • Masking layer zeros out (sets to -inf) all tokens │
│      that would violate the current state in grammar   │
│    • Softmax samples ONLY among valid legal tokens     │
└────────────────────────────────────────────────────────┘
```

| Dimension | Machine Grammar | Constrained Sampling |
| :--- | :--- | :--- |
| **Definition** | Declarative specification of valid syntax trees (CFG, JSON Schema, YAML schema, Regex). | Runtime decoding algorithm that clamps token logits to $-\infty$ for invalid next-tokens. |
| **Where it Lives** | In agent briefs, API schema configs, or grammar files (`.gbnf`, `.json`). | Inside the inference engine (vLLM `xgrammar`, llama.cpp sampler, Gemini/OpenAI API). |
| **Failure Mode** | LLM might ignore prompt instructions if not enforced at sampling time. | Mathematically impossible to produce invalid tokens; zero syntax errors. |
| **Primary Value** | Standardizes interface contracts (`Consumes` / `Produces`). | Guarantees 100% adherence, eliminates retry loops, and accelerates inference. |

### Why Constrained Sampling Cuts Token Cost by 60%–80%

1. **Elimination of Preamble & Chit-Chat:** Standard conversational prompts waste 50–150 tokens per turn on pleasantries (*"Certainly! I have inspected the files..."*). Constrained sampling forces the first generated token to immediately open the structural envelope (e.g. `{` or `version:`).
2. **Zero Parse-Retry Loops:** Unconstrained LLMs frequently drop closing brackets, emit invalid quotes, or slip into markdown prose midway through a JSON payload. Retrying failed parsing consumes thousands of remedial tokens. Constrained sampling achieves a 100% first-pass pass rate.
3. **Optimized Inference Velocity:** Engines equipped with grammar compilation (e.g. `xgrammar` in vLLM or GBNF in llama.cpp) prune the token search space before softmax, reducing kernel compute and accelerating time-to-first-token (TTFT) and throughput.
4. **Predictable Bounded Contexts:** Machine schemas enforce fixed field allocations, preventing open-ended essays and keeping inter-agent message payloads strictly under 500 tokens.

---

## 2. The Core Schemas (Machine Grammars)

ACON standardizes 6 canonical machine schemas across the multi-agent lifecycle. All specialist agents and control plane briefs MUST conform to these envelopes.

### Schema 1: `scout-report.yaml` (Codebase Scout)

Used by `Codebase Scout` subagents during Phase I / Phase II exploration. Eliminates conversational essays and yields deterministic path inventories.

```yaml
# Schema: scout-report.yaml
type: object
required: [status, objective, files_inspected, inventory, findings, risks, next_actions]
properties:
  status:
    type: string
    enum: [SUCCESS, PARTIAL, BLOCKED]
  objective:
    type: string
  files_inspected:
    type: array
    items: { type: string }
  inventory:
    type: array
    items:
      type: object
      required: [path, role, symbols]
      properties:
        path: { type: string }
        role: { type: string, enum: [SOURCE, CONFIG, TEST, ASSET, DOC] }
        symbols: { type: array, items: { type: string } }
  findings:
    type: array
    items:
      type: object
      required: [topic, observation, evidence]
      properties:
        topic: { type: string }
        observation: { type: string }
        evidence: { type: string }
  broken_references:
    type: array
    items:
      type: object
      required: [source_file, target_reference, issue]
      properties:
        source_file: { type: string }
        target_reference: { type: string }
        issue: { type: string }
  risks:
    type: array
    items: { type: string }
  next_actions:
    type: array
    items: { type: string }
```

#### Example Output:
```yaml
status: SUCCESS
objective: "Locate auth session handlers and evaluate migration impact"
files_inspected:
  - "app/Http/Middleware/Authenticate.php"
  - "config/session.php"
inventory:
  - path: "app/Http/Middleware/Authenticate.php"
    role: SOURCE
    symbols: ["redirectTo", "handle"]
  - path: "config/session.php"
    role: CONFIG
    symbols: ["driver", "lifetime", "encrypt"]
findings:
  - topic: "Session Encryption"
    observation: "Session payload encryption is enabled by default"
    evidence: "config/session.php line 42"
broken_references: []
risks:
  - "Changing driver invalidates all active Redis session tokens"
next_actions:
  - "Schedule maintenance window for Redis session rotation"
```

---

### Schema 2: `ship-diff.yaml` (Implementation Specialists)

Used by code implementation specialists (`Backend Specialist`, `Frontend UI Specialist`) upon task completion. Summarizes code mutations with zero filler.

```yaml
# Schema: ship-diff.yaml
type: object
required: [task_id, status, files_created, files_modified, files_deleted, verification, diff_stat]
properties:
  task_id:
    type: string
  status:
    type: string
    enum: [COMPLETED, FAILED, PARTIAL]
  files_created:
    type: array
    items: { type: string }
  files_modified:
    type: array
    items: { type: string }
  files_deleted:
    type: array
    items: { type: string }
  verification:
    type: object
    required: [command, exit_code, summary]
    properties:
      command: { type: string }
      exit_code: { type: integer }
      summary: { type: string }
  diff_stat:
    type: object
    required: [insertions, deletions, files_changed]
    properties:
      insertions: { type: integer }
      deletions: { type: integer }
      files_changed: { type: integer }
  notes:
    type: string
```

#### Example Output:
```yaml
task_id: "TASK-04"
status: COMPLETED
files_created:
  - "app/Services/BillingCalculator.php"
  - "tests/Unit/BillingCalculatorTest.php"
files_modified:
  - "app/Providers/AppServiceProvider.php"
files_deleted: []
verification:
  command: "vendor/bin/pest tests/Unit/BillingCalculatorTest.php"
  exit_code: 0
  summary: "6 tests passed, 18 assertions, 0 failures"
diff_stat:
  insertions: 84
  deletions: 2
  files_changed: 3
notes: "Pure function implementation adhering to Ponytail 7-Rung Ladder."
```

---

### Schema 3: `grill-interview.yaml` (`grill-me`)

Used by the Control Plane during Phase I Front-Loaded Alignment. Replaces unstructured conversational questions with machine-rendered decision rounds.

```yaml
# Schema: grill-interview.yaml
type: object
required: [round, frontier_status, questions]
properties:
  round:
    type: integer
  frontier_status:
    type: string
    enum: [ACTIVE, RESOLVED]
  questions:
    type: array
    minItems: 1
    maxItems: 3
    items:
      type: object
      required: [id, title, context, options, recommended_option]
      properties:
        id: { type: string, pattern: "^Q[0-9]+$" }
        title: { type: string }
        context: { type: string }
        options:
          type: array
          minItems: 2
          maxItems: 4
          items:
            type: object
            required: [key, label, trade_off]
            properties:
              key: { type: string }
              label: { type: string }
              trade_off: { type: string }
        recommended_option: { type: string }
        rationale: { type: string }
```

#### Example Output:
```yaml
round: 1
frontier_status: ACTIVE
questions:
  - id: "Q1"
    title: "Session Storage Backend"
    context: "System requires persistent session tracking across 4 stateless instances"
    options:
      - key: "REDIS"
        label: "Redis Cluster"
        trade_off: "Sub-millisecond access, requires Redis infrastructure"
      - key: "DATABASE"
        label: "PostgreSQL Session Table"
        trade_off: "Zero new infrastructure, increases DB write load"
    recommended_option: "REDIS"
    rationale: "Maintains zero DB overhead during traffic spikes"
```

---

### Schema 4: `task-contract.yaml` (`writing-plans`)

Used within implementation plans (`docs/plans/YYYY-MM-DD-<feature>.md`) to define atomic task boundaries with zero hand-waving.

```yaml
# Schema: task-contract.yaml
type: object
required: [task_id, title, eligibility, scope, consumes, produces, verification]
properties:
  task_id:
    type: string
    pattern: "^TASK-[0-9]{2}$"
  title:
    type: string
  eligibility:
    type: object
    required: [closed_loop, anti_gobble_file_count, domain_criticality]
    properties:
      closed_loop: { type: boolean }
      anti_gobble_file_count: { type: integer, maximum: 3 }
      domain_criticality: { type: string, enum: [AUTONOMOUS-SHIP, HUMAN-CORE / AI-TEST] }
  scope:
    type: object
    required: [create, modify, forbidden]
    properties:
      create: { type: array, items: { type: string } }
      modify: { type: array, items: { type: string } }
      forbidden: { type: array, items: { type: string } }
  consumes:
    type: array
    items:
      type: object
      required: [symbol, source_module]
      properties:
        symbol: { type: string }
        source_module: { type: string }
  produces:
    type: array
    items:
      type: object
      required: [symbol, type_signature]
      properties:
        symbol: { type: string }
        type_signature: { type: string }
  verification:
    type: object
    required: [command, expected_exit_code, verification_type]
    properties:
      command: { type: string }
      expected_exit_code: { type: integer, default: 0 }
      verification_type: { type: string, enum: [TDD_TEST_SUITE, TYPECHECK_OR_LINT, COMPILER_BUILD] }
```

---

### Schema 5: `handoff-state.yaml` (`handoff`)

Used when compacting sessions to external disk state (<500 tokens), enabling instant clean-slate agent restarts.

```yaml
# Schema: handoff-state.yaml
type: object
required: [session_id, timestamp, plan_file, baseline_status, modified_files, active_blockers, exact_next_step]
properties:
  session_id:
    type: string
  timestamp:
    type: string
  plan_file:
    type: string
  baseline_status:
    type: string
    enum: [CLEAN, DIRTY_UNTESTED, BROKEN]
  invariants_preserved:
    type: boolean
  completed_tasks:
    type: array
    items: { type: string }
  modified_files:
    type: array
    items: { type: string }
  active_blockers:
    type: array
    items: { type: string }
  exact_next_step:
    type: object
    required: [action, target_task, prompt_brief]
    properties:
      action: { type: string, enum: [DISPATCH_WORKER, AWAIT_CAPTAIN, RUN_TESTS] }
      target_task: { type: string }
      prompt_brief: { type: string }
```

#### Example Output:
```yaml
session_id: "e5b2fce6"
timestamp: "2026-09-16T16:30:00Z"
plan_file: "docs/plans/2026-09-16-grammars-and-constrained-sampling.md"
baseline_status: CLEAN
invariants_preserved: true
completed_tasks:
  - "TASK-01"
  - "TASK-02"
modified_files:
  - ".agents/skills/productivity/grammars-and-constrained-sampling/SKILL.md"
active_blockers: []
exact_next_step:
  action: DISPATCH_WORKER
  target_task: "TASK-03"
  prompt_brief: "Update AGENTS.md and .agents/rules/agent-control-plane.md with Grammars Invariant"
```

---

### Schema 6: `bearings-digest.yaml` (Fleet Bearings)

The structured grammar underpinning the canonical 4-section Fleet Bearings digest.

```yaml
# Schema: bearings-digest.yaml
type: object
required: [captains_call, recently_landed, underway, charted_next]
properties:
  captains_call:
    type: array
    items:
      type: object
      required: [item, type, action_needed]
      properties:
        item: { type: string }
        type: { type: string, enum: [DECISION, BLOCKER, APPROVAL, CREDENTIAL] }
        action_needed: { type: string }
  recently_landed:
    type: array
    items:
      type: object
      required: [task_id, description, status]
      properties:
        task_id: { type: string }
        description: { type: string }
        status: { type: string, enum: [MERGED, VERIFIED, PASSED] }
  underway:
    type: array
    items:
      type: object
      required: [specialist, task_id, current_action]
      properties:
        specialist: { type: string }
        task_id: { type: string }
        current_action: { type: string }
  charted_next:
    type: array
    items:
      type: object
      required: [task_id, description, blocked_by]
      properties:
        task_id: { type: string }
        description: { type: string }
        blocked_by: { type: array, items: { type: string } }
```

---

## 3. Constrained Sampling Directives (Enforcement Rules)

When invoking subagents or operating as a specialized worker, enforce these three non-negotiable sampling constraints:

### Directive 1: The Zero Conversational Preamble Invariant

Agents MUST NEVER emit introductory pleasantries, conversational acknowledgements, apologies, or meta-commentary.
- **Banned Openers:**
  - ❌ `"Sure, I can help with that!"`
  - ❌ `"Here is the information you requested:"`
  - ❌ `"Certainly! Let's examine the code..."`
  - ❌ `"Okay, I understand the plan..."`
- **Mandated Behavior:** The very first byte generated MUST be the opening symbol of the required grammar envelope (e.g. ````yaml`, `{`, or `# Plan:`).

### Directive 2: Token-Level Vocabulary Clamping & Banned Phrases

In model prompts and API system messages, enforce strict negative token constraints against conversational padding:

```markdown
[MANDATORY NEGATIVE CONSTRAINTS]
DO NOT EMIT:
- Conversational greetings or closings ("Hello", "Thanks", "Best regards")
- Fluff sign-offs ("Let me know if you need anything else", "Hope this helps")
- Explanations of tool calls before making them ("Now I will run grep...")
- Self-evident disclaimers ("As an AI...", "Note that this is simulated...")
```

### Directive 3: Enum & Regex Clamping

Ensure all decision outputs are restricted to closed enumerated sets. Never leave status flags, operation types, or severity levels open to free-form prose.
- **Status:** `[PASS, FAIL, BLOCKED, PENDING]`
- **Severity:** `[LOW, MEDIUM, HIGH, CRITICAL]`
- **Paths:** `^[a-zA-Z0-9_\-./]+$`

---

## 4. Harness Integration Guides

### 1. Agentic CLIs (`agy`, Claude Code)

In autonomous agent environments (Antigravity CLI, Claude Code), enforce grammars through structured tool declarations and MCP schemas.
- **Tool Schema Envelope:** Define tools with strict JSON Schema parameter validation. The CLI runtime automatically validates inputs before invocation.
- **Artifact Constraints:** When generating artifacts, explicitly anchor the artifact type and schema in the dispatch prompt:
  ```
  Output MUST be a single raw YAML envelope conforming to scout-report.yaml.
  No preceding markdown, no follow-up commentary.
  ```

### 2. Cloud APIs (Gemini & OpenAI)

#### Google Gemini API (`response_schema` / `response_mime_type`)
```python
from google import genai
from google.genai import types
from pydantic import BaseModel, Field
from typing import List, Literal

class ScoutReport(BaseModel):
    status: Literal["SUCCESS", "PARTIAL", "BLOCKED"]
    objective: str
    files_inspected: List[str]
    risks: List[str]
    next_actions: List[str]

client = genai.Client()
response = client.models.generate_content(
    model="gemini-2.5-pro",
    contents="Audit auth session handlers in app/",
    config=types.GenerateContentConfig(
        response_mime_type="application/json",
        response_schema=ScoutReport,
        temperature=0.0,
    ),
)
```

#### OpenAI API (`response_format` Strict JSON Schema)
```python
from openai import OpenAI

client = OpenAI()
response = client.chat.completions.create(
    model="gpt-5",
    messages=[{"role": "user", "content": "Audit auth session handlers"}],
    response_format={
        "type": "json_schema",
        "json_schema": {
            "name": "scout_report",
            "strict": True,
            "schema": ScoutReport.model_json_schema(),
        }
    },
    temperature=0.0,
)
```

### 3. Local Engines (vLLM, llama.cpp, Ollama)

#### vLLM with `xgrammar`
vLLM incorporates high-speed grammar compilation via `xgrammar`:
```bash
# Guided JSON via vLLM OpenAI-compatible endpoint
curl http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta-llama/Llama-3-70B-Instruct",
    "messages": [{"role": "user", "content": "Generate task contract"}],
    "guided_json": {
      "type": "object",
      "properties": {
        "task_id": {"type": "string"},
        "status": {"enum": ["COMPLETED", "FAILED"]}
      },
      "required": ["task_id", "status"]
    }
  }'
```

#### llama.cpp with `.gbnf` (Grammar-Based Sampling)
Compile a GBNF grammar file (`report.gbnf`):
```ebnf
root ::= "{" ws "\"status\":" ws status_val "," ws "\"files\":" ws file_list "}"
status_val ::= "\"SUCCESS\"" | "\"FAILED\""
file_list ::= "[" ws (string ("," ws string)*)? ws "]"
string ::= "\"" [a-zA-Z0-9_\-./]+ "\""
ws ::= [ \t\n\r]*
```
Run llama-cli:
```bash
llama-cli -m model.gguf --grammar-file report.gbnf -p "Audit repository"
```

#### Ollama (`format` Parameter)
```bash
curl http://localhost:11434/api/generate -d '{
  "model": "llama3",
  "prompt": "Summarize diff",
  "format": "json",
  "stream": false
}'
```

---

## 5. Pairing Matrix

| Paired Skill | Integration Mechanism | Enforced Grammar Contract |
| :--- | :--- | :--- |
| **[`prompt-master`](../prompt-master/SKILL.md)** | Subagent Brief Calibration | Enforces `scout-report.yaml` in Template M (Scout) and `ship-diff.yaml` in Template H (Ship). Embeds the Zero Preamble Invariant into generated briefs. |
| **[`grill-me`](../grill-me/SKILL.md)** | Frontier Interrogation | Enforces `grill-interview.yaml`. Constrains questions to 1–3 per round, with 2–4 strict multiple-choice enums and instant interactive CLI rendering. |
| **[`writing-plans`](../writing-plans/SKILL.md)** | Plan Decomposition | Enforces `task-contract.yaml`. Guarantees every planned task declares explicit `Consumes`, `Produces`, anti-gobble bounds ($\le 3$ files), and closed-loop verification commands. |
| **[`handoff`](../handoff/SKILL.md)** | Context Compaction | Enforces `handoff-state.yaml`. Compresses session state down to <500 tokens of structured YAML on disk, eliminating conversational carry-over. |
| **[`agent-control-plane`](../../rules/agent-control-plane.md)** | Constitution & Fleet Governance | Enforces `bearings-digest.yaml` and the universal Grammars Invariant across all worker dispatches. |

---

## 6. Verification Checklist

Before completing any task operating under this standard:
- [ ] Output opens immediately with the structured envelope (Zero conversational preamble).
- [ ] All required schema fields are present and typed correctly.
- [ ] All status indicators and categorizations use locked enums.
- [ ] File paths conform to the regex `^[a-zA-Z0-9_\-./]+$`.
- [ ] Total message payload is bounded (<500 tokens for state handoffs and diff summaries).

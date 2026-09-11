# ACON Cross-Harness Adapter & Execution Layer

> *"Talk to one agent. Ship with a crew."*

The **ACON Adapter Layer** provides a decoupled, modular execution bridge that isolates the **Agent Control Plane** (the central orchestrator and liaison to the user) from specific local CLI tools, direct API endpoints, and remote agent harnesses.

---

## 1. Architectural Overview

In traditional setups, agent assistants either lock themselves into a single vendor's CLI or run monolithic tool loops directly on the main command bridge. When the bridge performs long-running tool execution, incoming user steerings are forced into a blocking FIFO queue.

ACON enforces a strict **Zero-Execution & Zero-Archaeology Mandate** on the Control Plane:
1. **Control Plane Decoupling:** The primary assistant (First Mate) never executes code, tests, or multi-step discovery directly on the command bridge.
2. **Pluggable Execution Harnesses:** All concrete execution is routed to specialist execution harnesses (e.g., Antigravity CLI `agy`, Claude Code `claude`, or direct model APIs `api-runner.py`).
3. **Governance & Model Exclusion:** `acon.yaml` acts as the single declarative source of truth, enforcing security rules, model disallow-lists, and intent-based routing.
4. **The Ephemeral Bridge Pattern:** Tasks are written as immutable markdown briefs into `.agents/bridge/task_<uuid>.md`, executed by the selected adapter, and captured into `.agents/bridge/result_<uuid>.json`. Upon completion, ephemeral bridge files are automatically purged unless `--keep-bridge` is specified.
5. **Main-First Escalation Invariant:** Even when the cross-harness bridge is enabled (`bridge.enabled: true`), tasks that can be executed reliably on the main model MUST default to the main model configured in `acon.yaml`. External bridge models are engaged strictly by exception for high-complexity architecture, deep reasoning, or specialized domain requirements.

```
+-------------------------------------------------------------------------+
|                         Captain (Human User)                            |
+------------------------------------+------------------------------------+
                                     |
                                     v
+------------------------------------+------------------------------------+
|                   ACON Control Plane (First Mate)                      |
|       Intent Extraction  |  Task Shaping  |  Outcome Synthesis          |
+------------------------------------+------------------------------------+
                                     |
                          dispatches task brief
                                     |
                                     v
+------------------------------------+------------------------------------+
|                   Master Dispatcher (dispatch.sh)                       |
|   1. Parses acon.yaml                                                   |
|   2. Matches intent keyword patterns                                    |
|   3. Enforces models.exclude governance policy                          |
|   4. Allocates ephemeral bridge files (.agents/bridge/task_<uuid>.md)   |
+----+-------------------+-------------------+----------------------------+
     |                   |                   |
     v                   v                   v
+---------+         +---------+          +------------+
| agy.sh  |         |claude.sh|          |api-runner  |
| (AGY)   |         | (Claude)|          |  (Direct)  |
+----+----+         +----+----+          +-----+------+
     |                   |                     |
     +-------------------+---------------------+
                         |
                         v
+--------------------------------+----------------------------------------+
|                  Ephemeral Bridge Output Capture                        |
|        .agents/bridge/result_<uuid>.json (Auto-cleaned on exit)         |
+-------------------------------------------------------------------------+
```

---

## 2. Configuration Specification (`acon.yaml`)

The master configuration file lives at the repository root ([`acon.yaml`](../../acon.yaml)). It defines the cross-harness bridge settings, disallowed models, and dispatch routing rules. Note that the Control Plane is the permanent constitution of ACON and is never enabled/disabled; `bridge.enabled` strictly controls whether external cross-model adapters are used.

All model identifiers, reasoning efforts, exclusions, and dispatch patterns are declared strictly in [`acon.yaml`](../../acon.yaml), which serves as the single source of truth.

---

## 3. Supported Adapter Types & CLI Environment

### 3.1 Capability Archetypes & Model Governance

ACON decouples agent tasks from specific model names by operating on abstract capability archetypes, while [`acon.yaml`](../../acon.yaml) serves as the single declarative source of truth binding them to concrete model slugs:

- **Capability Archetypes:**
  - **Main Session / Control Plane:** Main Engine for unblocked command bridge operations, quick scans, triage, and universal fallback.
  - **Deep Reasoning & Architecture:** Deep Reasoning Model for system architecture, complex refactoring, ADR authoring, and security audits (`effort: auto` -> resolves to `high`).
  - **Core Coding & TDD:** Core Implementation Model for feature implementation, test-driven development, and mechanical formatting (`effort: auto` -> resolves to `high`).
  - **Web Research & Diagnostics:** Research Spike Model for read-only codebase archaeology, external doc research, and feasibility spikes (`effort: auto` -> resolves to `medium`).

- **Universal Exclusions (Strict Governance Policy):**
  - Excluded models are defined solely in `acon.yaml` under `models.exclude`.
  - The dispatch layer enforces this policy at invocation time and aborts immediately if an excluded model is requested.

- **Intelligent Reasoning Effort Policy (`effort: auto`):**
  - Reasoning effort defaults to `auto` across bridge configuration and dispatch rules.
  - Under `auto`, the harness adapter dynamically resolves each model to its optimal maximum supported effort:
    - Deep reasoning and core coding models (e.g., Claude Opus/Sonnet, Gemini) run at `high` effort for thorough chain-of-thought analysis and maximum fidelity.
    - Medium-capped models (such as `gpt-oss-120b`) automatically resolve to `medium` effort.
  - **Auto-Clamping Resilience:** If `high` effort is explicitly requested or passed to a medium-capped model (`gpt-oss-120b`), the adapter automatically clamps effort to `medium` and logs an informational notice, guaranteeing zero crashes and avoiding unnecessary fallbacks.
  - Can be explicitly overridden using `--effort` (`auto`, `low`, `medium`, `high`) when needed.

- **Automated Fallback & Resilience Cascade:**
  - The main engine configured in `acon.yaml` serves as the universal fallback across all dispatch rules.
  - If a primary worker model fails during execution (non-zero exit code), the dispatch runner automatically catches the failure and retries execution using the main engine.
  - Tasks only fail if both the primary model and the fallback engine fail.

- **Main-First Escalation Policy:**
  - Even when `bridge.enabled: true` and `prefer_main_first: true`, tasks that can be executed reliably by the main engine MUST default to the main model.
  - Routine coding, straightforward tests, simple scripts, and normal scans execute on the main engine, reserving heavy external models strictly for tasks that genuinely require deep reasoning, complex system architecture, or specialized domain capability.

### 3.2 Adapter Matrix

| Category | Adapter | Description | Use Case |
|---|---|---|---|
| **CLI Runtimes** | `agy.sh` | Antigravity CLI print-mode runner with structured JSON output & effort levels | Production coding, test suites, architecture, read-only scout spikes |
| **CLI Runtimes** | `claude.sh` | Claude Code CLI runner in non-interactive print mode | Deep reasoning, large architectural refactors |
| **Direct API** | `api-runner.py` | Zero-dependency Python runner targeting Anthropic / OpenAI | Fallback when CLI binaries are unavailable in container/CI |
| **IDE / Desktop** | Extensible | Headless bindings or IPC connections to IDE agents | Editor-integrated task execution (e.g. Cursor, VS Code) |
| **Sandboxes** | Extensible | Containerized execution runners (Docker, Podman, gVisor) | High-blast-radius execution or untrusted scripts |

---

## 4. How to Test Right Now

All adapter commands should be run from the repository root or `.agents/adapters/`.

### 1. Zero-Token Dry-Run Verification (`--dry-run`)

Test intent routing and verify policy enforcement without executing CLI harnesses or spending API tokens:

```bash
# Test research & scout intent routing
./.agents/adapters/dispatch.sh --dry-run --task "scout database models"
```
**Expected Output:**
```text
================================================================================
ACON Task Dispatch Plan (Dry Run)
================================================================================
Matched Rule   : research-scout
Pattern Match  : scout|research|audit|spike
Target Harness : agy
Target Model   : <target_model>
Fallback Model : <main_fallback_model>
Effort Level   : auto
Policy Check   : PASSED (Model is permitted by acon.yaml)
Adapter Script : .../.agents/adapters/agy.sh
Bridge Task    : .../.agents/bridge/task_<uuid>.md
Bridge Result  : .../.agents/bridge/result_<uuid>.json
--------------------------------------------------------------------------------
Task Content Preview:
scout database models
================================================================================
[INFO] Dry run complete. Execution halted before invoking adapter.
```

### 2. Verify Governance Model Exclusion Policy

Verify that requesting an excluded model triggers an immediate non-zero abort:

```bash
./.agents/adapters/dispatch.sh --dry-run --model <disallowed_model>
```
**Expected Output:**
```text
[ERROR] Governance Policy Violation: Model '<disallowed_model>' is explicitly excluded by policy in acon.yaml
[ERROR] Execution aborted immediately.
```

### 3. Live Task Execution

Execute a prompt directly using the resolved or overridden model:

```bash
# Dispatch an explanation task to an explicitly specified model
./.agents/adapters/dispatch.sh --task "Explain Python generators" --model <model_name>

# Dispatch from an existing markdown brief file
./.agents/adapters/dispatch.sh --file /path/to/brief.md

# Override target harness to direct API runner
./.agents/adapters/dispatch.sh --task "Summarize API security" --harness api --model <model_name>
```

### 4. Preserving Ephemeral Bridge Artifacts (`--keep-bridge`)

By default, bridge files (`task_<uuid>.md` and `result_<uuid>.json`) are automatically removed when the command finishes. To retain them for inspection, pass `--keep-bridge`:

```bash
./.agents/adapters/dispatch.sh --task "audit authentication flow" --keep-bridge
```

---

## 5. Guide for Humans & AI: Adding a New Adapter in 3 Steps

Adding support for a new CLI tool (e.g. `cursor`, `opencode`, `aider`) takes less than 2 minutes.

### Step 1: Create the Adapter Script

Create `.agents/adapters/<harness_name>.sh` adhering to ACON shell standards:
- Shebang `#!/usr/bin/env bash`
- Strict mode `set -euo pipefail` and `IFS=$'\n\t'`
- Accept `<prompt_file>` as `$1` (or `--file`) and `<model>` as `$2` (or `--model`)
- Direct diagnostics to `stderr` (`>&2`) and output to `stdout`

**Example: `.agents/adapters/opencode.sh`**
```bash
#!/usr/bin/env bash
# ==============================================================================
# Adapter: opencode.sh
# Description: OpenCode CLI execution harness adapter
# ==============================================================================
set -euo pipefail
IFS=$'\n\t'

PROMPT_FILE="${1:-}"
MODEL="${2:-}"

if [[ -z "${PROMPT_FILE}" || -z "${MODEL}" ]]; then
  echo "[ERROR] Usage: opencode.sh <prompt_file> <model>" >&2
  exit 1
fi

if ! command -v opencode >/dev/null 2>&1; then
  echo "[ERROR] 'opencode' CLI is not installed or not in PATH." >&2
  exit 127
fi

exec opencode --print --model "${MODEL}" --file "${PROMPT_FILE}"
```
Make the script executable:
```bash
chmod +x .agents/adapters/opencode.sh
```

### Step 2: Register Dispatch Rule in `acon.yaml`

Add a routing rule under `dispatch.rules` in `acon.yaml`:

```yaml
dispatch:
  rules:
    - name: "opencode-general"
      description: "Community model tasks routed to OpenCode"
      match: "opencode|community|deepseek"
      harness: "opencode"
      model: "deepseek-coder-v2"
      effort: "auto"
```

### Step 3: Verify with `--dry-run`

Test that intent matching and harness resolution correctly resolve your new adapter:

```bash
./.agents/adapters/dispatch.sh --dry-run --task "run deepseek code audit"
```

The dispatcher automatically checks permissions, checks exclusions in `acon.yaml`, and maps the harness name to `.agents/adapters/opencode.sh`.

---

## 6. Control Plane Integration

The Control Plane invokes adapters asynchronously using subagent delegation:

1. **Intent Extraction:** The Control Plane analyzes Captain intent using `prompt-master`.
2. **Task Shaping:** The Control Plane writes an airtight brief (`Template H` for Ship or `Template M` for Scout).
3. **Asynchronous Dispatch:** The Control Plane invokes `dispatch.sh` or delegates directly to a specialist subagent via `invoke_subagent`.
4. **Zero-Token Reactive Waiting:** The Control Plane immediately yields its turn, waiting reactively for execution completion without blocking loops.
5. **Central Synthesis:** The Control Plane verifies diffs, centralizes shared entry-point merges, and renders the 4-section **Fleet Bearings Digest**.

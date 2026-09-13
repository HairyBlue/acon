# ACON Cross-Harness Adapter & Execution Layer

> *"Talk to one agent. Ship with a crew."*

> [!WARNING]
> **Experimental Feature**: The `adapters/` layer (cross-harness bridge & session runner) is experimental. Use it at your own risk. The core, stable heart of ACON is `AGENTS.md` and `.agents/skills/`.

The **ACON Adapter Layer** provides a decoupled, modular execution bridge that isolates the **Agent Control Plane** (the central orchestrator and liaison to the user) from specific local CLI tools, direct API endpoints, and remote agent harnesses.

---

## 1. Architectural Overview

In traditional setups, agent assistants either lock themselves into a single vendor's CLI or run monolithic tool loops directly on the main command bridge. When the bridge performs long-running tool execution, incoming user steerings are forced into a blocking FIFO queue.

ACON enforces a strict **Zero-Execution & Zero-Archaeology Mandate** on the Control Plane:
1. **Control Plane Decoupling:** The primary assistant (First Mate) never executes code, tests, or multi-step discovery directly on the command bridge.
2. **Pluggable Execution Harnesses:** All concrete execution is routed to specialist execution harnesses (e.g., Antigravity CLI `agy`, Claude Code `claude`, OpenCode `opencode`, Aider `aider`, or Pi `pi`).
3. **Governance & Model Exclusion:** `acon.yaml` acts as the single declarative source of truth, enforcing security rules, model disallow-lists, and intent-based routing.
4. **The Ephemeral Bridge Pattern:** Tasks are written as immutable markdown briefs into `adapters/sessions/bridge/task_<bridge_id>.md`, executed by the selected adapter, and captured into `adapters/sessions/bridge/result_<bridge_id>.json`. Every execution is tagged with an explicit Bridge ID (`bridge_<timestamp>_<uuid>`). Upon completion, ephemeral bridge files are automatically purged unless `--keep-bridge` is specified.
5. **Main-First Escalation Invariant:** Even when the cross-harness bridge is enabled (`bridge.enabled: true`), tasks that can be executed reliably on the main model MUST default to the main model configured in `acon.yaml`. External bridge models are engaged strictly by exception for high-complexity architecture, deep reasoning, or specialized domain requirements.
6. **The Bridge Activation Gate:** Even when `bridge.enabled: true`, the default delegation tool is **ALWAYS native `invoke_subagent`** on the main engine. The Control Plane is strictly **FORBIDDEN** from invoking the external bridge (`dispatch.sh`) for everyday tasks (routine coding, standard tests, file inspections, general news/web lookups, git operations). The external bridge is engaged **STRICTLY BY EXCEPTION** only when at least one of three conditions is met: (1) explicit Captain command, (2) extreme architectural complexity requiring deep reasoning, or (3) cross-model comparative reviews.

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
|   4. Allocates ephemeral bridge files (adapters/sessions/bridge/)       |
+----+---------------------------------------------------+----------------+
     |                                                   |
     v                                                   v
+------------------------------------+          +----------------+
|         session-runner.sh          |          |   config-reader|
| - Synchronous: exec / run          |          |   (Fallback    |
| - Multi-Backend: herdr/tmux/native |          |    YAML engine)|
| - Harnesses: agy, claude, opencode,|          +----------------+
|              aider, pi             |
+-----------------+------------------+
                  |
                  v
+-------------------------------------------------------------------------+
|            Unified Runtime Directory (adapters/sessions/)               |
|  - bridge/ : result_<id>.json, task_<id>.md (Ephemeral bridge mailboxes)|
|  - cli/    : <session_id>/ (Interactive sessions, tracked logs & pipes) |
+-------------------------------------------------------------------------+
```

---

## 2. Configuration Specification (`acon.yaml`)

The master configuration file lives in the `adapters/` directory alongside the adapter scripts ([`acon.yaml`](acon.yaml)). It defines the cross-harness bridge settings, disallowed models, and dispatch routing rules. Note that the Control Plane is the permanent constitution of ACON and is never enabled/disabled; `bridge.enabled` strictly controls whether external cross-model adapters are used.

All model identifiers, reasoning efforts, exclusions, and dispatch patterns are declared strictly in [`acon.yaml`](acon.yaml), which serves as the single source of truth.

### 2.1 Prerequisites & Dual Config Reader Engine

The dispatch adapter features an automated dual config reader engine ensuring out-of-the-box compatibility across Unix, macOS, WSL, and Windows Git Bash:

- **Dual Config Reader Engine:**
  - **Native Engine (Unix / macOS / WSL):** Uses fast native `yq` and `jq` binaries when present for high-speed YAML parsing and JSON query evaluation.
  - **Automatic Python Fallback (`config-reader.py`):** If `yq` or `jq` are missing, the dispatcher automatically falls back to [`config-reader.py`](config-reader.py), providing equivalent YAML parsing and JSON query evaluation.
- **Windows (Git Bash) Compatibility:**
  - Works out of the box on Windows Git Bash with Python 3 and PyYAML (`pip install pyyaml`) — no `yq` or `jq` binaries required.
- **Explicit Python Reader Override (`ACON_FORCE_PYTHON_READER=1`):**
  - Set the environment variable `ACON_FORCE_PYTHON_READER=1` to explicitly force Python parsing on any platform (useful for CI consistency, deterministic testing, or debugging).

---

## 3. Supported Adapter Types & CLI Environment

### 3.1 Capability Archetypes & Model Governance

ACON decouples agent tasks from specific model names by operating on abstract capability archetypes, while [`acon.yaml`](acon.yaml) serves as the single declarative source of truth binding them to concrete model slugs:

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

- **The Bridge Activation Gate (`activation_gate: explicit_or_heavy_only`):**
  - Even when `bridge.enabled: true`, the default delegation tool is **ALWAYS native `invoke_subagent`** (running on the main model).
  - The Control Plane is strictly **FORBIDDEN** from invoking the external bridge (`dispatch.sh`) for everyday tasks (routine coding, standard tests, file inspections, general news/web lookups, git operations).
  - The external bridge (`dispatch.sh`) is engaged **STRICTLY BY EXCEPTION** only when at least one of these three conditions is met:
    1. *Explicit Captain Command:* The Captain explicitly asks to use an external model or the bridge (e.g., "use Claude", "run through Opus", "test on GPT", "use the bridge").
    2. *Extreme Architectural Complexity (Deep Reasoning Tier):* The objective involves foundational system rewrites, complex distributed schema migrations, or intractable concurrency bugs requiring deep reasoning effort that exceeds the main model.
    3. *Cross-Model Comparative Review:* The Captain asks for a second opinion or cross-model benchmark comparison.

### 3.2 Adapter Matrix

| Category | Adapter | Description | Use Case |
|---|---|---|---|
| **Unified Execution & Sessions** | `session-runner.sh` | Unified harness runner and multi-backend session manager (`herdr`, `tmux`, `native`) | Production coding, background agent execution, foreign project delegation, TDD |
| **Master Dispatcher** | `dispatch.sh` | Master intent router and governance policy gatekeeper reading `acon.yaml` | Declarative intent-based task dispatching & session activation |
| **Target Adoption** | `adopt.sh` | Portable one-command installer to adopt ACON conventions & skills into foreign repositories | Onboard foreign git repositories into ACON conventions |
| **Config Engine** | `config-reader.py` | Python YAML parser & query evaluator fallback for cross-platform compatibility | Standalone JSON evaluation when yq/jq are unavailable |

---

## 4. How to Test Right Now

All adapter commands should be run from the repository root or `adapters/`.

### 1. Zero-Token Dry-Run Verification (`--dry-run`)

Test intent routing and verify policy enforcement without executing CLI harnesses or spending API tokens:

```bash
# Test research & scout intent routing
./adapters/dispatch.sh --dry-run --task "deep-research database models"
```
**Expected Output:**
```text
================================================================================
ACON Task Dispatch Plan (Dry Run)
================================================================================
Bridge ID      : bridge_20260913_120500_a1b2c3d4
Matched Rule   : research-scout
Pattern Match  : deep-research|external-benchmark|oss-analysis
Target Harness : agy
Target Model   : <target_model>
Fallback Model : <main_fallback_model>
Effort Level   : auto
Policy Check   : PASSED (Model is permitted by acon.yaml)
Dispatch Mode  : Synchronous Execution (.../adapters/session-runner.sh exec)
Target Dir     : /path/to/project
Adapter Script : .../adapters/session-runner.sh
Bridge Task    : .../adapters/sessions/bridge/task_bridge_20260913_120500_a1b2c3d4.md
Bridge Result  : .../adapters/sessions/bridge/result_bridge_20260913_120500_a1b2c3d4.json
--------------------------------------------------------------------------------
Task Content Preview:
deep-research database models
================================================================================
[INFO] Dry run complete. Execution halted before invoking adapter.
```

### 2. Verify Governance Model Exclusion Policy

Verify that requesting an excluded model triggers an immediate non-zero abort:

```bash
./adapters/dispatch.sh --dry-run --model <disallowed_model>
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
./adapters/dispatch.sh --task "Explain Python generators" --model <model_name>

# Dispatch from an existing markdown brief file
./adapters/dispatch.sh --file /path/to/brief.md
```

### 4. Preserving Ephemeral Bridge Artifacts (`--keep-bridge`)

By default, bridge files (`task_bridge_<id>.md` and `result_bridge_<id>.json`) in `adapters/sessions/bridge/` are automatically removed when the command finishes, leaving the bridge mailbox clean. To retain them for inspection, pass `--keep-bridge`:

```bash
./adapters/dispatch.sh --task "audit authentication flow" --keep-bridge
```

---

## 5. Guide for Humans & AI: Adding a New Adapter in 3 Steps

Adding support for a new CLI tool (e.g. `cursor`, `opencode`, `aider`) takes less than 2 minutes.

### Step 1: Create the Adapter Script

Create `adapters/<harness_name>.sh` adhering to ACON shell standards:
- Shebang `#!/usr/bin/env bash`
- Strict mode `set -euo pipefail` and `IFS=$'\n\t'`
- Accept `<prompt_file>` as `$1` (or `--file`) and `<model>` as `$2` (or `--model`)
- Direct diagnostics to `stderr` (`>&2`) and output to `stdout`

**Example: `adapters/opencode.sh`**
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
chmod +x adapters/opencode.sh
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
./adapters/dispatch.sh --dry-run --task "run deepseek code audit"
```

The dispatcher automatically checks permissions, checks exclusions in `acon.yaml`, and maps the harness name to `adapters/opencode.sh`.

---

## 6. Control Plane Integration

The Control Plane invokes adapters asynchronously using subagent delegation:

1. **Intent Extraction:** The Control Plane analyzes Captain intent using `prompt-master`.
2. **Task Shaping:** The Control Plane writes an airtight brief (`Template H` for Ship or `Template M` for Scout).
3. **Asynchronous Dispatch:** The Control Plane invokes `dispatch.sh` or delegates directly to a specialist subagent via `invoke_subagent`.
4. **Zero-Token Reactive Waiting:** The Control Plane immediately yields its turn, waiting reactively for execution completion without blocking loops.
5. **Central Synthesis:** The Control Plane verifies diffs, centralizes shared entry-point merges, and renders the 4-section **Fleet Bearings Digest**.

---

## 7. Unified Session & Multiplexer Architecture (`session-runner.sh`)

> *"Spawn dedicated specialist workers in the background. Steer interactively. Monitor anytime via Herdr, TMUX, or native logs."*

The **Unified Session Runner** (`adapters/session-runner.sh`) provides an isolated, asynchronous execution bridge for CLI agent harnesses (`agy`, `claude`, `opencode`, `aider`, `pi`) across multiple multiplexers (`herdr`, `tmux`, `native`).

It enables the **First Mate (Control Plane)** and **Liaison Subagents** to delegate long-running tasks or foreign repository work to background processes without blocking the central command bridge, while ensuring full visibility in **Herdr's sidebar**, **TMUX windows**, or **native process logs**.

### 7.1 The Liaison Subagent Pattern

When an objective targets an external repository, foreign workspace, or long-running implementation task:
1. **Zero Bridge Execution:** The Control Plane never locks the main command bridge.
2. **Liaison Delegation:** The Control Plane dispatches a Liaison subagent, which invokes `session-runner.sh` (or `dispatch.sh --session`).
3. **Multiplexer & Sidebar Grouping:** In Herdr, a dedicated tab is spawned without focus (`--no-focus`), preventing pane splits and focus theft, grouped under the target workspace:
   ```text
   ▾ AGENTS GROUPED
     o portfolio · portfolio-auth (agy)
     o acon · scout-worker (claude)
   ```
   In TMUX, a background window is allocated (`tmux new-window -d`). In standalone environments, a native daemon tracks the PID.
4. **Interactive Steering & Logs:** The caller can monitor logs (`session-runner.sh log --clean`), check status (`session-runner.sh status`), or send steering inputs (`session-runner.sh send-input`). The human Captain can click the tab in Herdr's sidebar at any time to inspect or interact with the running agent directly.

---

### 7.2 Unified Session & Bridge Directory Layout

All runtime artifacts—both interactive/background CLI sessions and ephemeral bridge mailboxes—live strictly under `adapters/sessions/`:

```text
adapters/sessions/
├── bridge/                               # Ephemeral one-shot task mailboxes
│   ├── task_bridge_<id>.md               # Immutable task brief generated by dispatch.sh
│   └── result_bridge_<id>.json           # Structured JSON result captured from harness
└── cli/                                  # Headless & interactive CLI sessions
    └── <session_id>/
        ├── session.json                  # Metadata: session_id, harness, target_dir, pid, status, start_time
        ├── task.md                       # Packaged task brief or Portable Handoff Packet
        ├── cmd.sh                        # Executable command invoked by the runner
        ├── run.sh                        # Execution wrapper handling PID tracking, FIFO steering, and exit status
        ├── input.pipe                    # FIFO for sending asynchronous steering input
        ├── raw.log                       # Raw unbuffered stdout/stderr
        └── clean.log                     # Sanitized log with ANSI codes stripped
```

#### The Active Process Guard (Safety Invariant)
To prevent deleting sessions while they are still working:
1. **Never delete while working:** If `status == running` or `kill -0 "$PID"` succeeds, the session is protected and deletion is aborted.
2. **Cleanup on confirmed completion:** Bridge files are removed only after the process has fully exited and output is read into memory. CLI sessions are removed only when the process is confirmed terminated and deliverables are extracted.

#### Metadata Schema (`session.json`)
```json
{
  "session_id": "sess_20260913_120500_4210",
  "harness": "agy",
  "target_dir": "/home/hairyblue/my-stuff/portfolio",
  "status": "running",
  "start_time": "2026-09-13T04:05:00Z",
  "backend": "herdr",
  "herdr_tab_id": "w2:t3",
  "herdr_pane_id": "w2:pA",
  "herdr_workspace_id": "w2",
  "tab_label": "agy-portfolio",
  "pid": 27850,
  "exit_code": null,
  "end_time": null
}
```

---

### 7.3 The Portable Handoff Packager

When targeting a repository that lacks local `AGENTS.md` conventions, `session-runner.sh` automatically packages the prompt into a **Portable Handoff Packet** inside `task.md`.

This packet combines:
- **Context & Objective:** Clear goal extracted from the prompt.
- **Mandatory Boundary Scopes:** Explicit confinement to the target directory, forbidding traversal into parent or sibling repositories.
- **Engineering Governance (Ponytail Rules):** Enforcing the 7-Rung Decision Ladder (YAGNI, codebase reuse, standard library preference, zero unvetted dependencies, minimal working diffs).
- **Verification First Protocol:** Demanding local test execution and clean linting before task conclusion.
- **Structured Outcome Reporting:** Requiring a summary of changes, file modification inventory, and verification output.

---

### 7.4 Harness Support Matrix

| Harness | CLI Execution Command | Notes |
|---|---|---|
| **`agy`** | `agy -p "$(cat task.md)" --output-format json` | Supports `--model`, `--effort`, and extra arguments |
| **`claude`** | `claude -p "$(cat task.md)" --dangerously-skip-permissions` | Claude Code headless execution |
| **`opencode`** | `opencode run "$(cat task.md)"` | Community models via OpenCode runner |
| **`aider`** | `aider --message "$(cat task.md)" --yes --no-auto-commits` | Aider pairing agent with auto-commits disabled |
| **`pi`** | `pi -p "$(cat task.md)"` | Pi lightweight CLI harness |

---

### 7.5 Multi-Backend Multiplexer Support

`session-runner.sh` automatically detects the optimal execution backend according to strict priority:

1. **`herdr` Backend** (Priority 1):
   - Triggered when `$HERDR_ENV` is set and Herdr is running.
   - Uses `herdr tab create --cwd <target_dir> --label <label> --no-focus`.
   - The session cleanly appears under **"agents grouped"** in the Herdr sidebar (e.g. `o portfolio · portfolio-auth (agy)`).
   - Zero focus theft, zero pane split clutter.
2. **`tmux` Backend** (Priority 2):
   - Triggered when `$TMUX` is set and tmux is running.
   - Uses `tmux new-window -d -n <label> -c <target_dir>`.
   - Creates a dedicated background window without stealing active focus.
3. **`native` Backend** (Priority 3 / Default Fallback):
   - Active when neither Herdr nor TMUX is present, or when forced via `--backend native` / `--standalone`.
   - Spawns a background `nohup` daemon with robust PID tracking and FIFO pipe steering.
   - Zero dependencies on external terminal multiplexers.

### 7.6 macOS & Cross-Platform POSIX Portability

`session-runner.sh` and `dispatch.sh` are engineered to be 100% portable across Linux, macOS, WSL, and minimal Unix environments:

1. **Script Path Resolution:** Uses POSIX `$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)` rather than GNU-specific `readlink -f`.
2. **Zero GNU `sed -i` Dependencies:** Wrappers are rendered cleanly via direct heredoc expansion without relying on in-place regex substitutions that differ between GNU sed (Linux) and BSD sed (macOS).
3. **ANSI Code Sanitization:** Uses Python 3 regex filtering for universal cross-platform log sanitization, eliminating BSD sed escape syntax quirks.
4. **macOS Multiplexer Support:**
   - **`tmux` on macOS:** Supported out of the box via Homebrew (`brew install tmux`). Detects `$TMUX` automatically.
   - **`herdr` on macOS:** Supported natively via `$HERDR_ENV`.
   - **`native` Daemon on macOS:** Fully POSIX compliant (`nohup` + background PID tracking). Works on vanilla macOS without installing any external package or multiplexer.

---

### 7.7 Companion Adoption Tool (`adopt.sh`)

While `session-runner.sh` enables zero-terminal bridge operations on foreign repositories from within `acon`, [`adopt.sh`](adopt.sh) remains the companion tool to permanently adopt ACON into foreign repositories.

**Strict Lightweight Adoption Standard:**
`adopt.sh` transfers **ONLY**:
- `AGENTS.md` (synthesized Two-Tier constitution)
- `.agents/skills/` (full domain skill library dereferenced into concrete physical files)
- `.agents/rules/` (constitutional rules)

And strictly excludes `adapters/`, `adapters/sessions/`, and `acon.yaml`. Target repositories remain clean, pure consumers of ACON conventions and skills without runtime adapter bloat.

```bash
# Adopt ACON conventions into an external repository
./adapters/adopt.sh /home/user/my-project
```

---

### 7.8 CLI Command Reference

#### 1. `start`
Launches a new background agent session across Herdr, TMUX, or native daemon.
```bash
# Native daemon execution targeting an external project
./adapters/session-runner.sh start \
  --harness agy \
  --dir /home/hairyblue/my-stuff/portfolio \
  --label "portfolio-nav" \
  --prompt "Refactor mobile navigation menu"

# Force tmux background window
./adapters/session-runner.sh start \
  --backend tmux \
  --harness claude \
  --dir /path/to/project \
  --prompt "Audit authentication middleware"
```

#### 2. `exec` / `run`
Synchronously executes the harness CLI directly (used by `dispatch.sh`):
```bash
./adapters/session-runner.sh exec \
  --harness agy \
  --task-file adapters/sessions/bridge/task.md \
  --model gemini-3.8-flash \
  --effort auto
```

#### 3. `send-input`
Sends asynchronous steering input to the running agent via `input.pipe` and multiplexer IPC:
```bash
./adapters/session-runner.sh send-input \
  --session-id sess_20260913_120500_4210 \
  --input "Please also include unit tests for edge cases"
```

#### 4. `status`
Displays live status and process telemetry:
```bash
./adapters/session-runner.sh status --session-id sess_20260913_120500_4210

# Machine-readable JSON output
./adapters/session-runner.sh status --session-id sess_20260913_120500_4210 --json
```

#### 5. `log`
Inspects raw or ANSI-sanitized log streams:
```bash
# View last 50 lines of clean log (no ANSI escape codes)
./adapters/session-runner.sh log --session-id sess_20260913_120500_4210 --clean --tail 50

# Live tail streaming
./adapters/session-runner.sh log --session-id sess_20260913_120500_4210 --follow
```

#### 6. `stop`
Gracefully terminates the background agent (`SIGTERM` -> wait -> `SIGKILL`), closes Herdr tab or TMUX window, and automatically cleans up the session directory once confirmed terminated:
```bash
./adapters/session-runner.sh stop --session-id sess_20260913_120500_4210

# Pass --keep to preserve session logs and metadata for debugging
./adapters/session-runner.sh stop --session-id sess_20260913_120500_4210 --keep
```

#### 7. `clean`
Safely removes completed or stopped session directories. The Active Process Guard protects active running sessions from accidental deletion:
```bash
# Clean a specific completed session
./adapters/session-runner.sh clean --session-id sess_20260913_120500_4210

# Clean all completed/stopped sessions
./adapters/session-runner.sh clean --all
```

#### 8. `list`
Lists active and historical sessions:
```bash
./adapters/session-runner.sh list
```

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
./.agents/adapters/dispatch.sh --dry-run --task "deep-research database models"
```
**Expected Output:**
```text
================================================================================
ACON Task Dispatch Plan (Dry Run)
================================================================================
Matched Rule   : research-scout
Pattern Match  : deep-research|external-benchmark|oss-analysis
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
deep-research database models
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

---

## 7. Universal Machine-Wide Distro & Global Installation (`install-global.sh`)

ACON establishes a machine-wide agent distro across **any** AI CLI or editor environment on your system via a clean **Hub-and-Spoke Distro Architecture**.

```
                           +------------------------+
                           |   Master Hub (~/.acon) |
                           |  acon.yaml | skills/   |
                           |  rules/    | adapters/ |
                           +-----------+------------+
                                       |
        +------------------------------+------------------------------+
        |                              |                              |
        v                              v                              v
+------------------+          +------------------+          +------------------+
| Antigravity CLI  |          | Claude Code CLI  |          |    Cursor IDE    |
| ~/.gemini/config |          |     ~/.claude    |          |     ~/.cursor    |
| skills, rules,   |          | skills, rules,   |          |  skills, rules   |
| config, adapters |          |    CLAUDE.md     |          |                  |
+------------------+          +------------------+          +------------------+
                                       |
                                       v
                           +------------------------+
                           | Universal CLI (~/.local/bin/acon)        |
                           | acon status | acon sync | acon dispatch  |
                           +------------------------------------------+
```

### 7.1 Architecture: Hub-and-Spoke Distro

1. **Master Hub (`~/.acon/`):**
   - The single canonical source of truth on the user's host machine.
   - Contains dereferenced physical copies of `acon.yaml`, the full 114-skill catalog (`skills/`), constitutional rules (`rules/`), cross-harness runners (`adapters/`), and `AGENTS.md`.
   - Records the source repository in `~/.acon/.source_repo` for seamless background refreshes.

2. **Multi-CLI Spokes (Auto-Detection & Provisioning):**
   - The installer inspects the host and automatically provisions active agent environments:
     * **Antigravity CLI (`agy`):** Targets `~/.gemini/config/`. Provisions domain skill packages into `skills/` (preserving any pre-existing user or cloud provider skills), links/copies `rules/`, `acon.yaml`, and `adapters/`.
     * **Claude Code CLI (`claude`):** Targets `~/.claude/`. Provisions `skills/`, `rules/`, and mirrors `AGENTS.md` to `CLAUDE.md`.
     * **Cursor IDE (`cursor`):** Targets `~/.cursor/`. Provisions `skills/` and `rules/`.
     * **Custom Targets:** User-defined directories via `--target custom --target-dir <path>`.

3. **Universal Executable (`~/.local/bin/acon`):**
   - A lightweight command-line binary available globally in your PATH:
     * `acon status`: Displays a comprehensive machine-wide health dashboard showing hub status, active spokes, skill/rule counts, and symlink integrity.
     * `acon sync [REPO]`: Synchronizes Master Hub and all spokes against the latest upstream repository with a single command.
     * `acon dispatch [ARGS...]`: Invokes the cross-harness task dispatcher (`dispatch.sh`) globally from any directory.
     * `acon adopt [REPO]`: Deploys ACON into a target repository using `adopt.sh`.

### 7.2 Installer Options & CLI Flags

The global installer is located at `.agents/adapters/install-global.sh`:

```bash
./.agents/adapters/install-global.sh [OPTIONS]
```

| Flag | Description |
| :--- | :--- |
| `-d, --detect` | Auto-detect active AI CLIs on this host (default behavior). |
| `-a, --all` | Provision all supported CLIs (`agy`, `claude`, `cursor`). |
| `-t, --target <name>` | Provision specific CLI target: `agy`, `claude`, `cursor`, `custom` (repeatable). |
| `--target-dir <dir>` | Destination directory when using `--target custom`. |
| `-m, --mode <mode>` | Provisioning mode: `link` (default, spoke symlinks to hub) or `copy` (physical copies). |
| `-n, --dry-run` | Preview hub setup and spoke provisioning without altering filesystem. |
| `-f, --force` | Overwrite existing configurations or links without confirmation. |
| `--hub-dir <dir>` | Custom master hub path (default: `~/.acon`). |
| `--bin-dir <dir>` | Custom executable directory (default: `~/.local/bin`). |
| `-h, --help` | Show usage documentation and exit. |

### 7.3 Usage Examples

```bash
# Preview provisioning plan for all supported CLIs (Zero Risk)
./.agents/adapters/install-global.sh --dry-run --all

# Auto-detect and provision host CLIs (creates ~/.acon and ~/.local/bin/acon)
./.agents/adapters/install-global.sh --detect

# Provision specific targets
./.agents/adapters/install-global.sh --target agy --target cursor

# Pure physical copy mode (for environments where symlinks are restricted)
./.agents/adapters/install-global.sh --mode copy --all

# Check machine-wide health via universal CLI
acon status

# Refresh global skills from upstream repository
acon sync /path/to/acon-repo
```


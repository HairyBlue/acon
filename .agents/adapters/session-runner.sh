#!/usr/bin/env bash
# ==============================================================================
# ACON Unified Session Runner (session-runner.sh)
#
# Unified CLI execution harness adapter and multi-backend session manager.
# Supports:
#   - Harnesses: agy, claude, opencode, aider, pi
#   - Multiplexer Backends:
#       1. herdr (if $HERDR_ENV is set and herdr is running)
#       2. tmux  (if $TMUX is set and tmux is active)
#       3. native (headless daemon via nohup/PID tracking; zero dependencies)
#   - Central Declarative Governance:
#       Reads acon.yaml for default harnesses, models, intent rules, and exclusions
#   - Execution Modes:
#       1. start: launches background session with FIFO steering & logs
#       2. exec/run: synchronous harness execution (used by dispatch.sh)
#       3. send-input, status, log, stop, list: lifecycle controls
# ==============================================================================

set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ACON_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
CONFIG_READER="${SCRIPT_DIR}/config-reader.py"

# Resolve acon.yaml path
if [[ -f "${ACON_ROOT}/acon.yaml" ]]; then
  CONFIG_FILE="${ACON_ROOT}/acon.yaml"
elif [[ -f "${SCRIPT_DIR}/acon.yaml" ]]; then
  CONFIG_FILE="${SCRIPT_DIR}/acon.yaml"
elif [[ -n "${ACON_CONFIG:-}" && -f "${ACON_CONFIG}" ]]; then
  CONFIG_FILE="${ACON_CONFIG}"
else
  CONFIG_FILE="${ACON_ROOT}/acon.yaml"
fi

# Resolve Sessions Directory (Interactive/Background CLI sessions live under cli/)
if [[ -n "${ACON_SESSIONS_DIR:-}" ]]; then
  SESSIONS_BASE_DIR="${ACON_SESSIONS_DIR}"
elif [[ -d "${ACON_ROOT}/.agents" ]]; then
  SESSIONS_BASE_DIR="${ACON_ROOT}/.agents/sessions/cli"
else
  SESSIONS_BASE_DIR="${ACON_ROOT}/sessions/cli"
fi

# Resolve Session Directory with backward compatibility
resolve_session_dir() {
  local s_id="$1"
  if [[ -d "${SESSIONS_BASE_DIR}/${s_id}" ]]; then
    echo "${SESSIONS_BASE_DIR}/${s_id}"
  elif [[ -d "${ACON_ROOT}/.agents/sessions/${s_id}" ]]; then
    echo "${ACON_ROOT}/.agents/sessions/${s_id}"
  elif [[ -d "${ACON_ROOT}/sessions/${s_id}" ]]; then
    echo "${ACON_ROOT}/sessions/${s_id}"
  else
    echo "${SESSIONS_BASE_DIR}/${s_id}"
  fi
}

# Active Process Guard: Check if a session process is still running
is_session_alive() {
  local s_dir="$1"
  local pid=""
  if [[ -f "${s_dir}/pid" ]]; then
    pid="$(cat "${s_dir}/pid" 2>/dev/null | tr -d '[:space:]' || true)"
  fi
  if [[ -z "${pid}" && -f "${s_dir}/session.json" ]]; then
    pid="$(python3 -c "import json; d=json.load(open('${s_dir}/session.json')); print(d.get('pid',''))" 2>/dev/null || true)"
  fi

  if [[ -n "${pid}" && "${pid}" =~ ^[0-9]+$ ]]; then
    if kill -0 "${pid}" 2>/dev/null; then
      return 0 # Alive
    fi
  fi
  return 1 # Dead
}

# ANSI Colors for Terminal Output
if [[ -t 1 ]]; then
  RED=$'\033[0;31m'
  GREEN=$'\033[0;32m'
  YELLOW=$'\033[0;33m'
  BLUE=$'\033[0;34m'
  CYAN=$'\033[0;36m'
  BOLD=$'\033[1m'
  NC=$'\033[0m'
else
  RED=''
  GREEN=''
  YELLOW=''
  BLUE=''
  CYAN=''
  BOLD=''
  NC=''
fi

# ------------------------------------------------------------------------------
# Helper: Show Usage / Help
# ------------------------------------------------------------------------------
show_help() {
  cat <<EOF
${BOLD}ACON Unified Session Runner & Execution Layer${NC}

${BOLD}USAGE:${NC}
  $(basename "$0") <command> [OPTIONS]

${BOLD}COMMANDS:${NC}
  ${CYAN}start${NC}       Launch a background agent session (herdr, tmux, or native daemon)
  ${CYAN}exec${NC}        Execute a harness synchronously (used by dispatch.sh)
  ${CYAN}run${NC}         Alias for exec
  ${CYAN}send-input${NC}  Write steering input to a running agent session
  ${CYAN}status${NC}      Check current lifecycle status and metadata of a session
  ${CYAN}log${NC}         Inspect session execution logs (raw or ANSI-sanitized)
  ${CYAN}stop${NC}        Gracefully terminate and clean up a running session (use --keep to retain files)
  ${CYAN}clean${NC}       Safely remove completed or stopped session directories
  ${CYAN}list${NC}        List all active and past sessions

${BOLD}SUPPORTED HARNESSES:${NC}
  agy, claude, opencode, aider, pi

${BOLD}SUPPORTED BACKENDS:${NC}
  - ${BOLD}herdr${NC}  : Active when \$HERDR_ENV is set and herdr is running (sidebar grouped, --no-focus)
  - ${BOLD}tmux${NC}   : Active when \$TMUX is set and tmux is running (new background window)
  - ${BOLD}native${NC} : Default headless background daemon with PID tracking (zero dependencies)

${BOLD}START OPTIONS:${NC}
  -H, --harness <name>      Harness CLI to execute (default: resolved from acon.yaml, or agy)
  -d, --dir <path>          Target working directory for the agent (default: current directory)
  -s, --session-id <id>     Custom session identifier (default: sess_<timestamp>_<rand>)
  -p, --prompt <text>       Task prompt string
  -f, --task-file <path>    Path to markdown or text brief to execute
  -l, --label <text>        Multiplexer label (defaults to <harness>-<session-id>)
  -m, --model <model>       Model identifier (default: resolved from acon.yaml)
  -e, --effort <level>      Reasoning effort: auto, low, medium, high (default: auto)
  -b, --backend <name>      Force backend: herdr, tmux, native (default: auto-detected)
      --standalone          Alias for --backend native (force native background daemon)
  -- <extra-args...>        Forward remaining arguments directly to harness CLI

${BOLD}EXEC / RUN OPTIONS (SYNCHRONOUS):${NC}
  -H, --harness <name>      Harness CLI to execute (default: agy)
  -f, --task-file <path>    Path to markdown or text task brief (or positional \$1)
  -m, --model <model>       Model identifier (default: resolved from acon.yaml)
  -e, --effort <level>      Reasoning effort level
  -d, --dir <path>          Working directory (default: current directory)
  -- <extra-args...>        Forward arguments directly to harness

${BOLD}SEND-INPUT OPTIONS:${NC}
  -s, --session-id <id>     Target session ID (required)
  -i, --input <text>        Input string to send to the running agent (required)

${BOLD}STATUS OPTIONS:${NC}
  -s, --session-id <id>     Target session ID (required)
      --json                Output machine-readable JSON status

${BOLD}LOG OPTIONS:${NC}
  -s, --session-id <id>     Target session ID (required)
  -n, --tail <lines>        Display last N lines (default: all)
  -c, --clean               Sanitize ANSI color codes and cursor jump sequences
  -f, --follow              Stream live output in real time

${BOLD}STOP OPTIONS:${NC}
  -s, --session-id <id>     Target session ID (required)

${BOLD}EXAMPLES:${NC}
  # 1. Start a native background daemon session (no multiplexer required):
  $(basename "$0") start --harness agy --dir /home/user/portfolio --prompt "Refactor navigation"

  # 2. Start a session targeting tmux explicitly:
  $(basename "$0") start --backend tmux --harness claude -p "Audit security"

  # 3. Check session status:
  $(basename "$0") status --session-id sess_20260913_120500_4210

  # 4. View sanitized output logs:
  $(basename "$0") log --session-id sess_20260913_120500_4210 --clean --tail 50

  # 5. Steer the running agent via input pipe:
  $(basename "$0") send-input --session-id sess_20260913_120500_4210 --input "Check mobile responsive layout"

  # 6. Stop the session:
  $(basename "$0") stop --session-id sess_20260913_120500_4210

  # 7. Synchronous harness execution:
  $(basename "$0") exec --harness agy --task-file task.md --model gemini-3.8-flash
EOF
}

# ------------------------------------------------------------------------------
# Backend Detection Helpers
# ------------------------------------------------------------------------------
is_herdr_running() {
  if command -v herdr >/dev/null 2>&1; then
    if herdr status 2>/dev/null | grep -q "status: running"; then
      return 0
    fi
  fi
  return 1
}

is_tmux_running() {
  if command -v tmux >/dev/null 2>&1; then
    if [[ -n "${TMUX:-}" ]] && tmux info >/dev/null 2>&1; then
      return 0
    fi
  fi
  return 1
}

resolve_backend() {
  local requested="${1:-auto}"

  if [[ "${requested}" == "native" || "${requested}" == "standalone" ]]; then
    echo "native"
    return 0
  fi

  if [[ "${requested}" == "herdr" ]]; then
    if is_herdr_running; then
      echo "herdr"
      return 0
    else
      echo -e "${YELLOW}[WARNING]${NC} Requested backend 'herdr' but Herdr is not running. Falling back..." >&2
    fi
  fi

  if [[ "${requested}" == "tmux" ]]; then
    if is_tmux_running; then
      echo "tmux"
      return 0
    else
      echo -e "${YELLOW}[WARNING]${NC} Requested backend 'tmux' but TMUX is not active. Falling back..." >&2
    fi
  fi

  # Auto-detection by priority:
  # 1. If $HERDR_ENV is set and herdr is available
  if [[ -n "${HERDR_ENV:-}" ]] && is_herdr_running; then
    echo "herdr"
    return 0
  fi

  # 2. If $TMUX is set and tmux is available
  if [[ -n "${TMUX:-}" ]] && is_tmux_running; then
    echo "tmux"
    return 0
  fi

  # 3. Default: Native headless background daemon (zero dependencies)
  echo "native"
}

# ------------------------------------------------------------------------------
# Declarative Governance: Resolve from acon.yaml
# ------------------------------------------------------------------------------
resolve_acon_governance() {
  local prompt_text="$1"
  local in_harness="$2"
  local in_model="$3"
  local in_effort="$4"

  # Invoke Python helper to parse acon.yaml and resolve settings
  python3 -c "
import sys, json, os, re, subprocess

config_file = '${CONFIG_FILE}'
reader_py = '${CONFIG_READER}'
prompt = '''${prompt_text}'''
in_harness = '${in_harness}'
in_model = '${in_model}'
in_effort = '${in_effort}'

config_data = {}
if os.path.isfile(config_file):
    if os.path.isfile(reader_py):
        try:
            res = subprocess.run([sys.executable, reader_py, config_file], capture_output=True, text=True)
            if res.returncode == 0:
                config_data = json.loads(res.stdout)
        except Exception:
            pass
    if not config_data:
        try:
            import yaml
            with open(config_file, 'r') as f:
                config_data = yaml.safe_load(f) or {}
        except Exception:
            pass

bridge_cfg = config_data.get('bridge') or config_data.get('control_plane') or {}
default_harness = bridge_cfg.get('default_harness', 'agy')
main_model = bridge_cfg.get('main_model', 'gemini-3.8-flash')
default_effort = bridge_cfg.get('default_effort', 'auto')
excluded_models = config_data.get('models', {}).get('exclude', [])

matched_rule = None
rules = config_data.get('dispatch', {}).get('rules', [])
if prompt:
    for r in rules:
        pat = r.get('match', '')
        if pat:
            try:
                if re.search(pat, prompt, re.IGNORECASE):
                    matched_rule = r
                    break
            except Exception:
                pass

resolved_harness = in_harness
if not resolved_harness:
    if matched_rule and matched_rule.get('harness'):
        resolved_harness = matched_rule.get('harness')
    else:
        resolved_harness = default_harness

resolved_model = in_model
if not resolved_model:
    if matched_rule and matched_rule.get('model'):
        resolved_model = matched_rule.get('model')
    else:
        resolved_model = main_model

resolved_effort = in_effort
if not resolved_effort:
    if matched_rule and matched_rule.get('effort'):
        resolved_effort = matched_rule.get('effort')
    else:
        resolved_effort = default_effort

# Check exclusion policy
if resolved_model in excluded_models:
    sys.stderr.write(f'[ERROR] Governance Policy Violation: Model \'{resolved_model}\' is excluded by policy in acon.yaml\n')
    sys.exit(101)

# Effort resolution
if resolved_effort == 'auto' or not resolved_effort:
    if 'gpt-oss' in resolved_model:
        resolved_effort = 'medium'
    else:
        resolved_effort = 'high'
elif resolved_effort == 'high' and 'gpt-oss' in resolved_model:
    resolved_effort = 'medium'

# Model name adjustments
resolved_agy_model = resolved_model
if resolved_harness == 'agy' and resolved_model == 'claude-opus-4-6':
    resolved_agy_model = 'claude-opus-4-6-thinking'

result = {
    'harness': resolved_harness,
    'model': resolved_model,
    'agy_model': resolved_agy_model,
    'effort': resolved_effort,
    'matched_rule': matched_rule.get('name') if matched_rule else None
}
print(json.dumps(result))
"
}

# ------------------------------------------------------------------------------
# Helper: Generate Portable Handoff Packet (when target lacks AGENTS.md)
# ------------------------------------------------------------------------------
generate_portable_packet() {
  local target_dir="$1"
  local prompt_content="$2"
  local output_file="$3"

  cat <<EOF > "${output_file}"
# MISSION BRIEF: Autonomous Task Execution (Portable Handoff Packet)

> *This task packet establishes an explicit operational boundary and governance contract*
> *for foreign repositories lacking local AGENTS.md conventions.*

## 1. Context & Objective
${prompt_content}

## 2. Mandatory Boundary Scopes (Zero Collisions & Foreign Boundary Invariant)
- **Target Working Directory**: \`${target_dir}\`
- **Strict Boundary Invariant**: All file reads, edits, creations, and test runs MUST remain strictly within \`${target_dir}\`.
- **Foreign Isolation**: DO NOT inspect, traverse, or mutate files outside \`${target_dir}\` or in parent directories.
- **Dependency Guard**: DO NOT install unvetted global or system packages. Adhere strictly to existing dependencies declared in the repository.

## 3. Engineering & Anti-Overengineering Governance (Ponytail Rules)
- **7-Rung Decision Ladder**:
  1. **YAGNI**: Only build what was explicitly requested. Reject speculative abstractions.
  2. **Codebase Reuse**: Inspect and reuse existing utilities, components, and helper functions before authoring new ones.
  3. **Standard Library**: Prefer native language/runtime capabilities over adding new third-party packages.
  4. **Minimal Working Diff**: Deliver the smallest compliant solution with clean, readable diffs.
- **Craft & Preservation**: Preserve existing coding styles, naming conventions, and docstrings.

## 4. Verification First Protocol
- Run local project test suites, linters, or build commands before declaring task completion.
- If no automated tests exist, manually verify changes via command execution and document the verification steps.
- Ensure 0 unhandled errors, 0 lint regressions, and 0 syntax failures.

## 5. Outcome Reporting & Delivery
When finished, produce a structured markdown outcome report:
1. **Summary of Changes**: High-level explanation of what was implemented.
2. **Files Modified**: Explicit list of files modified, created, or deleted.
3. **Verification Performed**: Commands executed and their outcomes.
EOF
}

# ------------------------------------------------------------------------------
# Helper: Generate Standard Task Brief (when target has AGENTS.md)
# ------------------------------------------------------------------------------
generate_standard_brief() {
  local target_dir="$1"
  local prompt_content="$2"
  local output_file="$3"

  cat <<EOF > "${output_file}"
# MISSION BRIEF: Task Execution

## Objective
${prompt_content}

## Operating Governance
- **Target Directory**: \`${target_dir}\`
- **Local Standards**: Adhere strictly to local coding conventions, test commands, and boundaries defined in \`${target_dir}/AGENTS.md\` or \`CLAUDE.md\`.
EOF
}

# ------------------------------------------------------------------------------
# Helper: Strip ANSI Color Sequences
# ------------------------------------------------------------------------------
sanitize_log() {
  local src="$1"
  local dst="$2"
  if [[ -f "${src}" ]]; then
    python3 -c "
import re, sys
try:
    with open(sys.argv[1], 'r', errors='ignore') as f:
        content = f.read()
    clean = re.sub(r'\x1b(\[[0-9;]*[a-zA-Z]|\([B])|\r$', '', content)
    with open(sys.argv[2], 'w') as f:
        f.write(clean)
except Exception:
    pass
" "${src}" "${dst}" 2>/dev/null || cp "${src}" "${dst}"
  fi
}

# ==============================================================================
# COMMAND: START (Background Session Execution)
# ==============================================================================
cmd_start() {
  local harness=""
  local target_dir=""
  local session_id=""
  local prompt_text=""
  local task_file=""
  local tab_label=""
  local model=""
  local effort=""
  local requested_backend="auto"
  local extra_args=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -H|--harness)
        harness="$2"
        shift 2
        ;;
      -d|--dir)
        target_dir="$2"
        shift 2
        ;;
      -s|--session-id|--session)
        session_id="$2"
        shift 2
        ;;
      -p|--prompt)
        prompt_text="$2"
        shift 2
        ;;
      -f|--task-file|--file)
        task_file="$2"
        shift 2
        ;;
      -l|--label)
        tab_label="$2"
        shift 2
        ;;
      -m|--model)
        model="$2"
        shift 2
        ;;
      -e|--effort)
        effort="$2"
        shift 2
        ;;
      -b|--backend)
        requested_backend="$2"
        shift 2
        ;;
      --standalone)
        requested_backend="native"
        shift
        ;;
      --)
        shift
        extra_args=("$@")
        break
        ;;
      *)
        echo -e "${RED}[ERROR]${NC} Unknown start option: $1" >&2
        show_help
        exit 1
        ;;
    esac
  done

  # Validate target directory
  if [[ -z "${target_dir}" ]]; then
    target_dir="$(pwd)"
  fi
  if [[ ! -d "${target_dir}" ]]; then
    echo -e "${RED}[ERROR]${NC} Target directory does not exist: '${target_dir}'" >&2
    exit 1
  fi
  target_dir="$(cd "${target_dir}" && pwd -P)"

  # Resolve task prompt content
  local task_content=""
  if [[ -n "${task_file}" ]]; then
    if [[ ! -f "${task_file}" ]]; then
      echo -e "${RED}[ERROR]${NC} Task file not found: '${task_file}'" >&2
      exit 1
    fi
    task_content="$(cat "${task_file}")"
  elif [[ -n "${prompt_text}" ]]; then
    task_content="${prompt_text}"
  else
    echo -e "${RED}[ERROR]${NC} Either --prompt or --task-file must be specified." >&2
    exit 1
  fi

  # Resolve Governance & Intent matching from acon.yaml
  local gov_json
  set +e
  gov_json="$(resolve_acon_governance "${task_content}" "${harness}" "${model}" "${effort}")"
  local gov_rc=$?
  set -e

  if [[ ${gov_rc} -eq 101 ]]; then
    echo -e "${RED}[ERROR]${NC} Governance Policy Violation: Specified model is excluded in acon.yaml." >&2
    exit 1
  elif [[ ${gov_rc} -ne 0 || -z "${gov_json}" ]]; then
    echo -e "${YELLOW}[WARNING]${NC} Failed to resolve acon.yaml governance; falling back to defaults." >&2
    harness="${harness:-agy}"
    model="${model:-gemini-3.8-flash}"
    effort="${effort:-auto}"
  else
    harness="$(echo "${gov_json}" | python3 -c "import sys, json; print(json.load(sys.stdin).get('harness','agy'))")"
    model="$(echo "${gov_json}" | python3 -c "import sys, json; print(json.load(sys.stdin).get('model','gemini-3.8-flash'))")"
    effort="$(echo "${gov_json}" | python3 -c "import sys, json; print(json.load(sys.stdin).get('effort','auto'))")"
    local matched_rule
    matched_rule="$(echo "${gov_json}" | python3 -c "import sys, json; print(json.load(sys.stdin).get('matched_rule') or '')")"
    if [[ -n "${matched_rule}" ]]; then
      echo -e "${CYAN}[ACON]${NC} Matched acon.yaml rule: ${BOLD}${matched_rule}${NC} (harness=${harness}, model=${model}, effort=${effort})"
    fi
  fi

  # Validate harness CLI
  case "${harness}" in
    agy|claude|opencode|aider|pi) ;;
    *)
      echo -e "${YELLOW}[WARNING]${NC} Unrecognized harness '${harness}'. Proceeding with generic execution." >&2
      ;;
  esac

  # Generate session ID if not provided
  if [[ -z "${session_id}" ]]; then
    local ts
    ts="$(date +%Y%m%d_%H%M%S)"
    local rand="$((RANDOM % 9000 + 1000))"
    session_id="sess_${ts}_${rand}"
  fi

  local session_dir="${SESSIONS_BASE_DIR}/${session_id}"
  mkdir -p "${session_dir}"

  # Package task.md
  local task_md="${session_dir}/task.md"
  local has_local_agents=0
  if [[ -f "${target_dir}/AGENTS.md" || -f "${target_dir}/CLAUDE.md" ]]; then
    has_local_agents=1
  fi

  if [[ ${has_local_agents} -eq 0 ]]; then
    echo -e "${CYAN}[ACON]${NC} Target lacks AGENTS.md. Generating Portable Handoff Packet..."
    generate_portable_packet "${target_dir}" "${task_content}" "${task_md}"
  else
    echo -e "${CYAN}[ACON]${NC} Target contains local conventions. Generating Task Brief..."
    generate_standard_brief "${target_dir}" "${task_content}" "${task_md}"
  fi

  # Setup FIFO and Log files
  local input_pipe="${session_dir}/input.pipe"
  local raw_log="${session_dir}/raw.log"
  local clean_log="${session_dir}/clean.log"
  local pid_file="${session_dir}/pid"
  local session_json="${session_dir}/session.json"
  local run_sh="${session_dir}/run.sh"
  local cmd_sh="${session_dir}/cmd.sh"

  rm -f "${input_pipe}"
  mkfifo "${input_pipe}"
  touch "${raw_log}" "${clean_log}"

  # Map agy model adjustments
  local agy_model="${model}"
  if [[ "${agy_model}" == "claude-opus-4-6" ]]; then
    agy_model="claude-opus-4-6-thinking"
  fi

  local effort_args=()
  if [[ ! "${agy_model}" =~ ^claude- ]]; then
    if [[ -n "${effort}" && "${effort}" != "standard" && "${effort}" != "none" ]]; then
      effort_args+=(--effort "${effort}")
    fi
  fi

  # Generate cmd.sh based on harness contract
  {
    echo "#!/usr/bin/env bash"
    echo "set -uo pipefail"
    echo "cd \"${target_dir}\""

    case "${harness}" in
      agy)
        local eff_str="${effort_args[*]:-}"
        if [[ -n "${model}" ]]; then
          echo "exec agy -p \"\$(cat '${task_md}')\" --model '${agy_model}' ${eff_str} --output-format json \"\$@\""
        else
          echo "exec agy -p \"\$(cat '${task_md}')\" --output-format json \"\$@\""
        fi
        ;;
      claude)
        if [[ -n "${model}" ]]; then
          echo "exec claude -p \"\$(cat '${task_md}')\" --model '${model}' --dangerously-skip-permissions \"\$@\""
        else
          echo "exec claude -p \"\$(cat '${task_md}')\" --dangerously-skip-permissions \"\$@\""
        fi
        ;;
      opencode)
        if [[ -n "${model}" ]]; then
          echo "exec opencode run --model '${model}' \"\$(cat '${task_md}')\" \"\$@\""
        else
          echo "exec opencode run \"\$(cat '${task_md}')\" \"\$@\""
        fi
        ;;
      aider)
        if [[ -n "${model}" ]]; then
          echo "exec aider --model '${model}' --message \"\$(cat '${task_md}')\" --yes --no-auto-commits \"\$@\""
        else
          echo "exec aider --message \"\$(cat '${task_md}')\" --yes --no-auto-commits \"\$@\""
        fi
        ;;
      pi)
        if [[ -n "${model}" ]]; then
          echo "exec pi -p \"\$(cat '${task_md}')\" --model '${model}' \"\$@\""
        else
          echo "exec pi -p \"\$(cat '${task_md}')\" \"\$@\""
        fi
        ;;
      *)
        echo "exec ${harness} \"\$(cat '${task_md}')\" \"\$@\""
        ;;
    esac
  } > "${cmd_sh}"
  chmod +x "${cmd_sh}"

  local start_iso
  start_iso="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

  local formatted_extra=""
  if [[ ${#extra_args[@]} -gt 0 ]]; then
    for arg in "${extra_args[@]}"; do
      formatted_extra="${formatted_extra} $(printf '%q' "${arg}")"
    done
  fi

  # Create Execution Script Wrapper (fully POSIX/macOS portable without sed -i)
  cat <<RUN_EOF > "${run_sh}"
#!/usr/bin/env bash
set -uo pipefail

SESSION_DIR="${session_dir}"
TARGET_DIR="${target_dir}"
CMD_SH="${session_dir}/cmd.sh"
RAW_LOG="${session_dir}/raw.log"
CLEAN_LOG="${session_dir}/clean.log"
INPUT_PIPE="${session_dir}/input.pipe"
PID_FILE="${session_dir}/pid"
SESSION_JSON="${session_dir}/session.json"

cd "\${TARGET_DIR}"
echo "\$\$" > "\${PID_FILE}"

cleanup() {
  local exit_sig="\${1:-0}"
  python3 -c "
import re, sys
try:
    with open('\${RAW_LOG}', 'r', errors='ignore') as f:
        c = f.read()
    with open('\${CLEAN_LOG}', 'w') as f:
        f.write(re.sub(r'\x1b(\[[0-9;]*[a-zA-Z]|\([B])|\r$', '', c))
except Exception:
    pass
" 2>/dev/null || true

  if [[ -f "\${SESSION_JSON}" ]]; then
    python3 -c "
import json
try:
    with open('\${SESSION_JSON}', 'r') as f:
        data = json.load(f)
    data['status'] = 'stopped'
    data['end_time'] = '$(date -u +"%Y-%m-%dT%H:%M:%SZ")'
    with open('\${SESSION_JSON}', 'w') as f:
        json.dump(data, f, indent=2)
except Exception:
    pass
" 2>/dev/null || true
  fi
  exit "\${exit_sig}"
}

trap 'cleanup 143' TERM
trap 'cleanup 130' INT
trap 'cleanup 129' HUP

# Keep FIFO open for background reading
exec 3<>"\${INPUT_PIPE}"
exec <&3

# Update session.json status to running
python3 -c "
import json
try:
    with open('\${SESSION_JSON}', 'r') as f:
        data = json.load(f)
    data['status'] = 'running'
    data['pid'] = \$\$
    with open('\${SESSION_JSON}', 'w') as f:
        json.dump(data, f, indent=2)
except Exception:
    pass
" 2>/dev/null || true

# Execute cmd.sh with any extra arguments while logging
"\${CMD_SH}" ${formatted_extra} 2>&1 | tee -a "\${RAW_LOG}"
EXIT_CODE="\${PIPESTATUS[0]}"

# Post-execution sanitization
python3 -c "
import re, sys
try:
    with open('\${RAW_LOG}', 'r', errors='ignore') as f:
        c = f.read()
    with open('\${CLEAN_LOG}', 'w') as f:
        f.write(re.sub(r'\x1b(\[[0-9;]*[a-zA-Z]|\([B])|\r$', '', c))
except Exception:
    pass
" 2>/dev/null || true

FINAL_STATUS="completed"
if [[ \${EXIT_CODE} -ne 0 ]]; then
  FINAL_STATUS="failed"
fi

python3 -c "
import json
try:
    with open('\${SESSION_JSON}', 'r') as f:
        data = json.load(f)
    data['status'] = '\${FINAL_STATUS}'
    data['exit_code'] = \${EXIT_CODE}
    data['end_time'] = '$(date -u +"%Y-%m-%dT%H:%M:%SZ")'
    with open('\${SESSION_JSON}', 'w') as f:
        json.dump(data, f, indent=2)
except Exception:
    pass
" 2>/dev/null || true

exit "\${EXIT_CODE}"
RUN_EOF
  chmod +x "${run_sh}"

  # Resolve Backend (herdr -> tmux -> native)
  local backend
  backend="$(resolve_backend "${requested_backend}")"

  local herdr_tab_id=""
  local herdr_pane_id=""
  local herdr_workspace_id=""
  local tmux_window_id=""
  local assigned_label="${tab_label:-${harness}-${session_id}}"

  # Initial session.json
  cat <<JSON_EOF > "${session_json}"
{
  "session_id": "${session_id}",
  "harness": "${harness}",
  "model": "${model}",
  "effort": "${effort}",
  "target_dir": "${target_dir}",
  "status": "starting",
  "start_time": "${start_iso}",
  "backend": "${backend}",
  "herdr_tab_id": null,
  "herdr_pane_id": null,
  "herdr_workspace_id": null,
  "tmux_window_id": null,
  "tab_label": "${assigned_label}",
  "pid": null,
  "exit_code": null,
  "end_time": null
}
JSON_EOF

  # Dispatch to the chosen backend
  case "${backend}" in
    herdr)
      echo -e "${GREEN}[ACON]${NC} Herdr runtime active. Spawning non-focused Herdr tab..."
      local tab_json
      tab_json="$(herdr tab create --cwd "${target_dir}" --label "${assigned_label}" --no-focus 2>&1)" || true

      if [[ "${tab_json}" =~ pane_id ]]; then
        herdr_pane_id="$(echo "${tab_json}" | grep -o '"pane_id":"[^"]*"' | head -n1 | cut -d'"' -f4 || true)"
        herdr_tab_id="$(echo "${tab_json}" | grep -o '"tab_id":"[^"]*"' | head -n1 | cut -d'"' -f4 || true)"
        herdr_workspace_id="$(echo "${tab_json}" | grep -o '"workspace_id":"[^"]*"' | head -n1 | cut -d'"' -f4 || true)"

        # Update session.json with herdr metadata
        python3 -c "
import json
with open('${session_json}', 'r') as f:
    d = json.load(f)
d['herdr_tab_id'] = '${herdr_tab_id}'
d['herdr_pane_id'] = '${herdr_pane_id}'
d['herdr_workspace_id'] = '${herdr_workspace_id}'
with open('${session_json}', 'w') as f:
    json.dump(d, f, indent=2)
" 2>/dev/null || true

        sleep 0.3
        herdr pane run "${herdr_pane_id}" "bash '${run_sh}'" >/dev/null 2>&1
        echo -e "${GREEN}[ACON]${NC} Session launched in Herdr pane ${BOLD}${herdr_pane_id}${NC} (tab: ${BOLD}${assigned_label}${NC})"
      else
        echo -e "${YELLOW}[WARNING]${NC} Herdr tab creation failed. Falling back to native daemon." >&2
        backend="native"
      fi
      ;;

    tmux)
      echo -e "${GREEN}[ACON]${NC} TMUX runtime active. Spawning background tmux window..."
      local tw_out
      tw_out="$(tmux new-window -d -P -F "#{window_id}" -n "${assigned_label}" -c "${target_dir}" "bash '${run_sh}'" 2>&1)" || true

      if [[ "${tw_out}" =~ ^@ ]]; then
        tmux_window_id="${tw_out}"
        python3 -c "
import json
with open('${session_json}', 'r') as f:
    d = json.load(f)
d['tmux_window_id'] = '${tmux_window_id}'
with open('${session_json}', 'w') as f:
    json.dump(d, f, indent=2)
" 2>/dev/null || true
        echo -e "${GREEN}[ACON]${NC} Session launched in tmux window ${BOLD}${tmux_window_id}${NC} (name: ${BOLD}${assigned_label}${NC})"
      else
        echo -e "${YELLOW}[WARNING]${NC} tmux window creation failed (${tw_out}). Falling back to native daemon." >&2
        backend="native"
      fi
      ;;
  esac

  # Fallback or chosen Native Daemon
  if [[ "${backend}" == "native" ]]; then
    nohup bash "${run_sh}" >/dev/null 2>&1 &
    local bg_pid=$!
    echo "${bg_pid}" > "${pid_file}"
    python3 -c "
import json
with open('${session_json}', 'r') as f:
    d = json.load(f)
d['backend'] = 'native'
d['pid'] = ${bg_pid}
d['status'] = 'running'
with open('${session_json}', 'w') as f:
    json.dump(d, f, indent=2)
" 2>/dev/null || true
    echo -e "${GREEN}[ACON]${NC} Session launched in native headless daemon (PID: ${BOLD}${bg_pid}${NC})"
  fi

  # Output Summary Block
  echo -e "--------------------------------------------------------------------------------"
  echo -e "  ${BOLD}Session ID${NC} : ${CYAN}${session_id}${NC}"
  echo -e "  ${BOLD}Harness${NC}    : ${harness}"
  echo -e "  ${BOLD}Model${NC}      : ${model}"
  echo -e "  ${BOLD}Target Dir${NC} : ${target_dir}"
  echo -e "  ${BOLD}Backend${NC}   : ${backend}"
  echo -e "  ${BOLD}Task Packet${NC}: ${task_md}"
  echo -e "  ${BOLD}Log (Raw)${NC}  : ${raw_log}"
  echo -e "  ${BOLD}Log (Clean)${NC}: ${clean_log}"
  echo -e "--------------------------------------------------------------------------------"
  echo -e "To inspect logs:   ${BOLD}$(basename "$0") log --session-id ${session_id} --clean${NC}"
  echo -e "To check status:   ${BOLD}$(basename "$0") status --session-id ${session_id}${NC}"
  echo -e "To send steering:  ${BOLD}$(basename "$0") send-input --session-id ${session_id} --input \"<text>\"${NC}"
  echo -e "To stop session:   ${BOLD}$(basename "$0") stop --session-id ${session_id}${NC}"
}

# ==============================================================================
# COMMAND: EXEC / RUN (Synchronous Harness Execution for dispatch.sh)
# ==============================================================================
cmd_exec() {
  local harness="agy"
  local task_file=""
  local model=""
  local effort=""
  local target_dir=""
  local extra_args=()

  # Support positional argument: session-runner.sh exec <task_file> [model] [effort]
  if [[ $# -ge 1 && ! "$1" =~ ^- ]]; then
    task_file="$1"
    shift
    if [[ $# -ge 1 && ! "$1" =~ ^- ]]; then
      model="$1"
      shift
      if [[ $# -ge 1 && ! "$1" =~ ^- ]]; then
        effort="$1"
        shift
      fi
    fi
  fi

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -H|--harness)
        harness="$2"
        shift 2
        ;;
      -f|--task-file|--file)
        task_file="$2"
        shift 2
        ;;
      -m|--model)
        model="$2"
        shift 2
        ;;
      -e|--effort)
        effort="$2"
        shift 2
        ;;
      -d|--dir)
        target_dir="$2"
        shift 2
        ;;
      --)
        shift
        extra_args=("$@")
        break
        ;;
      *)
        # Positional task file fallback
        if [[ -z "${task_file}" && -f "$1" ]]; then
          task_file="$1"
          shift
        else
          echo -e "${RED}[ERROR]${NC} Unknown exec option: $1" >&2
          show_help
          exit 1
        fi
        ;;
    esac
  done

  if [[ -z "${task_file}" ]]; then
    echo -e "${RED}[ERROR]${NC} Option --task-file is required for exec." >&2
    exit 1
  fi

  if [[ ! -f "${task_file}" ]]; then
    echo -e "${RED}[ERROR]${NC} Task file not found: '${task_file}'" >&2
    exit 1
  fi

  if [[ -n "${target_dir}" && -d "${target_dir}" ]]; then
    cd "${target_dir}"
  fi

  # Resolve governance & exclusions from acon.yaml
  local task_content
  task_content="$(cat "${task_file}")"
  local gov_json
  set +e
  gov_json="$(resolve_acon_governance "${task_content}" "${harness}" "${model}" "${effort}")"
  local gov_rc=$?
  set -e

  if [[ ${gov_rc} -eq 101 ]]; then
    echo -e "${RED}[ERROR]${NC} Governance Policy Violation: Specified model is excluded in acon.yaml." >&2
    exit 1
  elif [[ ${gov_rc} -eq 0 && -n "${gov_json}" ]]; then
    harness="$(echo "${gov_json}" | python3 -c "import sys, json; print(json.load(sys.stdin).get('harness','agy'))")"
    model="$(echo "${gov_json}" | python3 -c "import sys, json; print(json.load(sys.stdin).get('model','gemini-3.8-flash'))")"
    effort="$(echo "${gov_json}" | python3 -c "import sys, json; print(json.load(sys.stdin).get('effort','auto'))")"
  fi

  # Validate CLI installation
  if ! command -v "${harness}" >/dev/null 2>&1; then
    echo -e "${RED}[ERROR]${NC} '${harness}' CLI is not installed or not in PATH." >&2
    exit 127
  fi

  # Map agy model adjustments
  local agy_model="${model}"
  if [[ "${agy_model}" == "claude-opus-4-6" ]]; then
    agy_model="claude-opus-4-6-thinking"
  fi

  local effort_args=()
  if [[ ! "${agy_model}" =~ ^claude- ]]; then
    if [[ -n "${effort}" && "${effort}" != "standard" && "${effort}" != "none" ]]; then
      effort_args+=(--effort "${effort}")
    fi
  fi

  case "${harness}" in
    agy)
      if [[ -n "${model}" ]]; then
        exec agy -p "$(cat "${task_file}")" --model "${agy_model}" "${effort_args[@]}" --output-format json "${extra_args[@]}"
      else
        exec agy -p "$(cat "${task_file}")" --output-format json "${extra_args[@]}"
      fi
      ;;
    claude)
      if [[ -n "${model}" ]]; then
        exec claude -p "$(cat "${task_file}")" --model "${model}" --dangerously-skip-permissions "${extra_args[@]}"
      else
        exec claude -p "$(cat "${task_file}")" --dangerously-skip-permissions "${extra_args[@]}"
      fi
      ;;
    opencode)
      if [[ -n "${model}" ]]; then
        exec opencode run --model "${model}" "$(cat "${task_file}")" "${extra_args[@]}"
      else
        exec opencode run "$(cat "${task_file}")" "${extra_args[@]}"
      fi
      ;;
    aider)
      if [[ -n "${model}" ]]; then
        exec aider --model "${model}" --message "$(cat "${task_file}")" --yes --no-auto-commits "${extra_args[@]}"
      else
        exec aider --message "$(cat "${task_file}")" --yes --no-auto-commits "${extra_args[@]}"
      fi
      ;;
    pi)
      if [[ -n "${model}" ]]; then
        exec pi -p "$(cat "${task_file}")" --model "${model}" "${extra_args[@]}"
      else
        exec pi -p "$(cat "${task_file}")" "${extra_args[@]}"
      fi
      ;;
    *)
      exec "${harness}" "$(cat "${task_file}")" "${extra_args[@]}"
      ;;
  esac
}

# ==============================================================================
# COMMAND: SEND-INPUT
# ==============================================================================
cmd_send_input() {
  local session_id=""
  local input_str=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--session-id|--session)
        session_id="$2"
        shift 2
        ;;
      -i|--input)
        input_str="$2"
        shift 2
        ;;
      *)
        echo -e "${RED}[ERROR]${NC} Unknown send-input option: $1" >&2
        show_help
        exit 1
        ;;
    esac
  done

  if [[ -z "${session_id}" || -z "${input_str}" ]]; then
    echo -e "${RED}[ERROR]${NC} Both --session-id and --input are required." >&2
    exit 1
  fi

  local session_dir="$(resolve_session_dir "${session_id}")"
  if [[ ! -d "${session_dir}" ]]; then
    echo -e "${RED}[ERROR]${NC} Session '${session_id}' does not exist in ${SESSIONS_BASE_DIR}" >&2
    exit 1
  fi

  local input_pipe="${session_dir}/input.pipe"
  local session_json="${session_dir}/session.json"

  if [[ ! -p "${input_pipe}" ]]; then
    echo -e "${RED}[ERROR]${NC} FIFO pipe not found for session: '${input_pipe}'" >&2
    exit 1
  fi

  local status="unknown"
  local herdr_pane_id=""
  local tmux_window_id=""
  local backend="native"

  if [[ -f "${session_json}" ]]; then
    status="$(python3 -c "import json; d=json.load(open('${session_json}')); print(d.get('status','unknown'))" 2>/dev/null || echo "unknown")"
    herdr_pane_id="$(python3 -c "import json; d=json.load(open('${session_json}')); print(d.get('herdr_pane_id',''))" 2>/dev/null || echo "")"
    tmux_window_id="$(python3 -c "import json; d=json.load(open('${session_json}')); print(d.get('tmux_window_id',''))" 2>/dev/null || echo "")"
    backend="$(python3 -c "import json; d=json.load(open('${session_json}')); print(d.get('backend','native'))" 2>/dev/null || echo "native")"
  fi

  if [[ "${status}" == "completed" || "${status}" == "failed" || "${status}" == "stopped" ]]; then
    echo -e "${YELLOW}[WARNING]${NC} Session '${session_id}' has already finished with status: ${status}" >&2
  fi

  echo -e "${CYAN}[ACON]${NC} Writing input to session '${session_id}'..."

  # Write to FIFO with timeout to avoid hanging
  if timeout 3 bash -c "echo \"${input_str}\" > \"${input_pipe}\""; then
    echo -e "${GREEN}[ACON]${NC} Input written to input pipe successfully."
  else
    echo -e "${YELLOW}[WARNING]${NC} FIFO write timed out (no reader attached)." >&2
  fi

  # Forward to multiplexers if applicable
  if [[ "${backend}" == "herdr" && -n "${herdr_pane_id}" ]] && is_herdr_running; then
    herdr pane run "${herdr_pane_id}" "${input_str}" >/dev/null 2>&1 || true
    echo -e "${GREEN}[ACON]${NC} Input forwarded to Herdr pane ${herdr_pane_id}."
  elif [[ "${backend}" == "tmux" && -n "${tmux_window_id}" ]] && is_tmux_running; then
    tmux send-keys -t "${tmux_window_id}" "${input_str}" C-m >/dev/null 2>&1 || true
    echo -e "${GREEN}[ACON]${NC} Input forwarded to tmux window ${tmux_window_id}."
  fi
}

# ==============================================================================
# COMMAND: STATUS
# ==============================================================================
cmd_status() {
  local session_id=""
  local as_json=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--session-id|--session)
        session_id="$2"
        shift 2
        ;;
      --json)
        as_json=1
        shift
        ;;
      *)
        echo -e "${RED}[ERROR]${NC} Unknown status option: $1" >&2
        show_help
        exit 1
        ;;
    esac
  done

  if [[ -z "${session_id}" ]]; then
    echo -e "${RED}[ERROR]${NC} Option --session-id is required." >&2
    exit 1
  fi

  local session_dir="$(resolve_session_dir "${session_id}")"
  local session_json="${session_dir}/session.json"
  local pid_file="${session_dir}/pid"

  if [[ ! -d "${session_dir}" || ! -f "${session_json}" ]]; then
    echo -e "${RED}[ERROR]${NC} Session '${session_id}' not found." >&2
    exit 1
  fi

  local pid=""
  if [[ -f "${pid_file}" ]]; then
    pid="$(cat "${pid_file}" 2>/dev/null | tr -d '[:space:]' || true)"
  fi

  # Dynamic liveness and status check
  python3 -c "
import json, os, subprocess, sys

with open('${session_json}', 'r') as f:
    data = json.load(f)

pid = data.get('pid') or '${pid}'
if pid and str(pid).isdigit():
    pid = int(pid)
    data['pid'] = pid
    try:
        os.kill(pid, 0)
        is_alive = True
    except OSError:
        is_alive = False
else:
    is_alive = False

backend = data.get('backend', 'native')
pane_id = data.get('herdr_pane_id')
tmux_window_id = data.get('tmux_window_id')

herdr_agent_status = None
if backend == 'herdr' and pane_id:
    try:
        res = subprocess.run(['herdr', 'pane', 'get', pane_id], capture_output=True, text=True, timeout=2)
        if res.returncode == 0:
            pane_data = json.loads(res.stdout)
            herdr_agent_status = pane_data.get('result', {}).get('pane', {}).get('agent_status')
            data['herdr_agent_status'] = herdr_agent_status
    except Exception:
        pass

# Synchronize status if marked running but process is gone
current_status = data.get('status', 'unknown')
if current_status in ('running', 'starting'):
    if not is_alive and (backend != 'herdr' or herdr_agent_status == 'done'):
        current_status = 'completed' if data.get('exit_code') == 0 else 'failed'
        data['status'] = current_status
        with open('${session_json}', 'w') as f:
            json.dump(data, f, indent=2)

if ${as_json} == 1:
    print(json.dumps(data, indent=2))
else:
    print('================================================================================')
    print(f'Session ID     : {data.get(\"session_id\")}')
    print(f'Harness        : {data.get(\"harness\")}')
    print(f'Model          : {data.get(\"model\", \"auto\")}')
    print(f'Status         : {data.get(\"status\")}')
    print(f'Target Dir     : {data.get(\"target_dir\")}')
    print(f'Backend        : {data.get(\"backend\")}')
    if data.get('herdr_tab_id'):
        print(f'Herdr Tab      : {data.get(\"herdr_tab_id\")} (Label: {data.get(\"tab_label\")})')
        print(f'Herdr Pane     : {data.get(\"herdr_pane_id\")}')
        if herdr_agent_status:
            print(f'Herdr Agent St : {herdr_agent_status}')
    if data.get('tmux_window_id'):
        print(f'Tmux Window    : {data.get(\"tmux_window_id\")}')
    if data.get('pid'):
        print(f'Process PID    : {data.get(\"pid\")} (Alive: {is_alive})')
    print(f'Start Time     : {data.get(\"start_time\")}')
    if data.get('end_time'):
        print(f'End Time       : {data.get(\"end_time\")}')
    if data.get('exit_code') is not None:
        print(f'Exit Code      : {data.get(\"exit_code\")}')
    print('================================================================================')
"
}

# ==============================================================================
# COMMAND: LOG
# ==============================================================================
cmd_log() {
  local session_id=""
  local tail_lines=""
  local clean=0
  local follow=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--session-id|--session)
        session_id="$2"
        shift 2
        ;;
      -n|--tail)
        tail_lines="$2"
        shift 2
        ;;
      -c|--clean)
        clean=1
        shift
        ;;
      -f|--follow)
        follow=1
        shift
        ;;
      *)
        echo -e "${RED}[ERROR]${NC} Unknown log option: $1" >&2
        show_help
        exit 1
        ;;
    esac
  done

  if [[ -z "${session_id}" ]]; then
    echo -e "${RED}[ERROR]${NC} Option --session-id is required." >&2
    exit 1
  fi

  local session_dir="$(resolve_session_dir "${session_id}")"
  local raw_log="${session_dir}/raw.log"
  local clean_log="${session_dir}/clean.log"

  if [[ ! -d "${session_dir}" ]]; then
    echo -e "${RED}[ERROR]${NC} Session '${session_id}' not found." >&2
    exit 1
  fi

  if [[ ! -f "${raw_log}" ]]; then
    echo -e "${RED}[ERROR]${NC} No log file found for session: '${session_id}'" >&2
    exit 1
  fi

  if [[ ${clean} -eq 1 ]]; then
    sanitize_log "${raw_log}" "${clean_log}"
  fi

  local target_file="${raw_log}"
  if [[ ${clean} -eq 1 ]]; then
    target_file="${clean_log}"
  fi

  local tail_args=()
  if [[ -n "${tail_lines}" ]]; then
    tail_args=(-n "${tail_lines}")
  fi

  if [[ ${follow} -eq 1 ]]; then
    tail -f "${tail_args[@]}" "${target_file}"
  else
    if [[ -n "${tail_lines}" ]]; then
      tail "${tail_args[@]}" "${target_file}"
    else
      cat "${target_file}"
    fi
  fi
}

# ==============================================================================
# COMMAND: STOP
# ==============================================================================
cmd_stop() {
  local session_id=""
  local keep_session=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--session-id|--session)
        session_id="$2"
        shift 2
        ;;
      -k|--keep)
        keep_session=1
        shift
        ;;
      *)
        echo -e "${RED}[ERROR]${NC} Unknown stop option: $1" >&2
        show_help
        exit 1
        ;;
    esac
  done

  if [[ -z "${session_id}" ]]; then
    echo -e "${RED}[ERROR]${NC} Option --session-id is required." >&2
    exit 1
  fi

  local session_dir="$(resolve_session_dir "${session_id}")"
  local session_json="${session_dir}/session.json"
  local pid_file="${session_dir}/pid"

  if [[ ! -d "${session_dir}" ]]; then
    echo -e "${RED}[ERROR]${NC} Session '${session_id}' not found." >&2
    exit 1
  fi

  local pid=""
  if [[ -f "${pid_file}" ]]; then
    pid="$(cat "${pid_file}" 2>/dev/null | tr -d '[:space:]' || true)"
  fi
  if [[ -z "${pid}" && -f "${session_json}" ]]; then
    pid="$(python3 -c "import json; d=json.load(open('${session_json}')); print(d.get('pid',''))" 2>/dev/null || true)"
  fi

  local herdr_tab_id=""
  local tmux_window_id=""
  if [[ -f "${session_json}" ]]; then
    herdr_tab_id="$(python3 -c "import json; d=json.load(open('${session_json}')); print(d.get('herdr_tab_id') or '')" 2>/dev/null || true)"
    tmux_window_id="$(python3 -c "import json; d=json.load(open('${session_json}')); print(d.get('tmux_window_id') or '')" 2>/dev/null || true)"
  fi

  echo -e "${YELLOW}[ACON]${NC} Stopping session '${session_id}'..."

  # Graceful process termination
  if [[ -n "${pid}" && "${pid}" =~ ^[0-9]+$ ]]; then
    if kill -0 "${pid}" 2>/dev/null; then
      for child in $(pgrep -P "${pid}" 2>/dev/null || true); do
        kill -TERM "${child}" 2>/dev/null || true
      done
      kill -TERM "${pid}" 2>/dev/null || true

      local waited=0
      while kill -0 "${pid}" 2>/dev/null && [[ ${waited} -lt 30 ]]; do
        sleep 0.1
        waited=$((waited + 1))
      done

      if kill -0 "${pid}" 2>/dev/null; then
        for child in $(pgrep -P "${pid}" 2>/dev/null || true); do
          kill -KILL "${child}" 2>/dev/null || true
        done
        kill -KILL "${pid}" 2>/dev/null || true
      fi
      echo -e "${GREEN}[ACON]${NC} Terminated process PID ${pid}."
    else
      echo -e "${CYAN}[ACON]${NC} Process PID ${pid} was already terminated."
    fi
  fi

  # Close Herdr tab if active
  if [[ -n "${herdr_tab_id}" && "${herdr_tab_id}" != "None" ]] && is_herdr_running; then
    herdr tab close "${herdr_tab_id}" >/dev/null 2>&1 || true
    echo -e "${GREEN}[ACON]${NC} Closed Herdr tab ${herdr_tab_id}."
  fi

  # Close tmux window if active
  if [[ -n "${tmux_window_id}" && "${tmux_window_id}" != "None" ]] && is_tmux_running; then
    tmux kill-window -t "${tmux_window_id}" >/dev/null 2>&1 || true
    echo -e "${GREEN}[ACON]${NC} Closed tmux window ${tmux_window_id}."
  fi

  # Update metadata
  if [[ -f "${session_json}" ]]; then
    python3 -c "
import json
with open('${session_json}', 'r') as f:
    d = json.load(f)
d['status'] = 'stopped'
d['end_time'] = '$(date -u +"%Y-%m-%dT%H:%M:%SZ")'
with open('${session_json}', 'w') as f:
    json.dump(d, f, indent=2)
" 2>/dev/null || true
  fi

  sanitize_log "${session_dir}/raw.log" "${session_dir}/clean.log" 2>/dev/null || true

  # Active Process Guard: Auto-Cleanup on Completion
  # Strict Invariant: Only remove if confirmed totally dead / terminated!
  if [[ ${keep_session} -eq 0 ]]; then
    if is_session_alive "${session_dir}"; then
      echo -e "${YELLOW}[WARNING]${NC} Session '${session_id}' process could not be confirmed dead. Session directory retained for safety: ${session_dir}" >&2
    else
      rm -rf "${session_dir}"
      echo -e "${GREEN}[ACON]${NC} Session '${session_id}' stopped and cleaned up."
    fi
  else
    echo -e "${GREEN}[ACON]${NC} Session '${session_id}' stopped (retained with --keep at ${session_dir})."
  fi
}

# ==============================================================================
# COMMAND: CLEAN
# ==============================================================================
cmd_clean() {
  local session_id=""
  local clean_all=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--session-id|--session)
        session_id="$2"
        shift 2
        ;;
      -a|--all)
        clean_all=1
        shift
        ;;
      -h|--help)
        cat <<EOF
Usage: $(basename "$0") clean [OPTIONS]

Safely clean up completed or stopped session directories.
Active running sessions are strictly protected by the Active Process Guard.

Options:
  -s, --session-id <id>   Clean up specific completed session directory
  -a, --all               Clean up all completed/stopped sessions in ${SESSIONS_BASE_DIR}
  -h, --help              Show this help message
EOF
        exit 0
        ;;
      *)
        echo -e "${RED}[ERROR]${NC} Unknown clean option: $1" >&2
        exit 1
        ;;
    esac
  done

  if [[ -n "${session_id}" ]]; then
    local session_dir="$(resolve_session_dir "${session_id}")"
    if [[ ! -d "${session_dir}" ]]; then
      echo -e "${RED}[ERROR]${NC} Session '${session_id}' not found." >&2
      exit 1
    fi

    # Active Process Guard: Never remove an active/running session!
    if is_session_alive "${session_dir}"; then
      echo -e "${RED}[ERROR]${NC} Cannot clean session '${session_id}': process is still running. Active sessions are protected." >&2
      exit 1
    fi

    rm -rf "${session_dir}"
    echo -e "${GREEN}[ACON]${NC} Cleaned up completed session directory: ${session_dir}"
    return 0
  fi

  if [[ ${clean_all} -eq 1 ]]; then
    local count=0
    if [[ -d "${SESSIONS_BASE_DIR}" ]]; then
      for s_dir in "${SESSIONS_BASE_DIR}"/*; do
        [[ -d "${s_dir}" ]] || continue
        local s_name="$(basename "${s_dir}")"
        [[ "${s_name}" == "cli" || "${s_name}" == "bridge" ]] && continue

        if is_session_alive "${s_dir}"; then
          echo -e "${YELLOW}[SKIP]${NC} Session '${s_name}' is still active; skipping."
        else
          rm -rf "${s_dir}"
          echo -e "${GREEN}[ACON]${NC} Cleaned up completed session '${s_name}'."
          count=$((count + 1))
        fi
      done
    fi
    echo -e "${GREEN}[ACON]${NC} Cleaned up ${count} completed session(s)."
    return 0
  fi

  echo -e "${RED}[ERROR]${NC} Either --session-id <id> or --all must be specified." >&2
  exit 1
}

# ==============================================================================
# COMMAND: LIST
# ==============================================================================
cmd_list() {
  local as_json=0
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --json)
        as_json=1
        shift
        ;;
      *)
        shift
        ;;
    esac
  done

  if [[ ! -d "${SESSIONS_BASE_DIR}" ]]; then
    if [[ ${as_json} -eq 1 ]]; then
      echo "[]"
    else
      echo "No sessions found."
    fi
    return 0
  fi

  python3 -c "
import os, json, glob

base_dir = '${SESSIONS_BASE_DIR}'
session_files = glob.glob(os.path.join(base_dir, '*', 'session.json'))
legacy_dir = '${ACON_ROOT}/.agents/sessions'
if os.path.isdir(legacy_dir):
    for sf in glob.glob(os.path.join(legacy_dir, '*', 'session.json')):
        p = os.path.basename(os.path.dirname(sf))
        if p not in ('cli', 'bridge') and sf not in session_files:
            session_files.append(sf)

sessions = []
for sf in session_files:
    try:
        with open(sf, 'r') as f:
            d = json.load(f)
            pid = d.get('pid')
            if pid and str(pid).isdigit():
                try:
                    os.kill(int(pid), 0)
                    d['alive'] = True
                except OSError:
                    d['alive'] = False
            else:
                d['alive'] = False
            sessions.append(d)
    except Exception:
        continue

sessions.sort(key=lambda x: x.get('start_time', ''), reverse=True)

if ${as_json} == 1:
    print(json.dumps(sessions, indent=2))
else:
    if not sessions:
        print('No sessions found.')
        exit(0)
    fmt = '{:<30} {:<10} {:<12} {:<10} {:<35}'
    print('=' * 105)
    print(fmt.format('SESSION ID', 'HARNESS', 'STATUS', 'BACKEND', 'TARGET DIR'))
    print('-' * 105)
    for s in sessions:
        sid = s.get('session_id', '')
        harness = s.get('harness', '')
        status = s.get('status', 'unknown')
        backend = s.get('backend', 'native')
        target = s.get('target_dir', '')
        if len(target) > 34:
            target = '...' + target[-31:]
        print(fmt.format(sid, harness, status, backend, target))
    print('=' * 105)
"
}

# ------------------------------------------------------------------------------
# Main Dispatcher
# ------------------------------------------------------------------------------
main() {
  if [[ $# -lt 1 ]]; then
    show_help
    exit 0
  fi

  local subcmd="$1"

  # Support positional invocation: session-runner.sh <task_file> [model] [effort]
  if [[ -f "${subcmd}" ]]; then
    cmd_exec "$@"
    return
  fi

  shift

  case "${subcmd}" in
    start)
      cmd_start "$@"
      ;;
    exec|run)
      cmd_exec "$@"
      ;;
    send-input)
      cmd_send_input "$@"
      ;;
    status)
      cmd_status "$@"
      ;;
    log)
      cmd_log "$@"
      ;;
    stop)
      cmd_stop "$@"
      ;;
    clean|rm)
      cmd_clean "$@"
      ;;
    list)
      cmd_list "$@"
      ;;
    -h|--help|help)
      show_help
      ;;
    *)
      echo -e "${RED}[ERROR]${NC} Unknown command: '${subcmd}'" >&2
      show_help
      exit 1
      ;;
  esac
}

main "$@"

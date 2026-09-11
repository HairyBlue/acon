#!/usr/bin/env bash
# ==============================================================================
# Master Dispatch Runner: dispatch.sh
# Description: Resolves tasks against acon.yaml rules, enforces model exclusion
#              policies, manages bridge workspaces, and routes to adapters.
# ==============================================================================
set -euo pipefail
IFS=$'\n\t'

# ------------------------------------------------------------------------------
# Directory & Path Resolution
# ------------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ACON_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
CONFIG_FILE="${ACON_ROOT}/acon.yaml"
BRIDGE_DIR="${ACON_ROOT}/.agents/bridge"

# CLI Options & Defaults
TASK_ARG=""
FILE_ARG=""
CLI_HARNESS=""
CLI_MODEL=""
CLI_EFFORT=""
DRY_RUN=0
KEEP_BRIDGE=0

BRIDGE_TASK_FILE=""
BRIDGE_RESULT_FILE=""
RAW_OUTPUT_TMP=""

# ------------------------------------------------------------------------------
# Usage & Help
# ------------------------------------------------------------------------------
usage() {
  cat <<'USAGE_EOF' >&2
Usage: dispatch.sh [OPTIONS]

Options:
  -t, --task "<desc>"     Task objective or prompt description
  -f, --file <brief.md>   Path to existing task brief markdown file
  -H, --harness <name>    Explicitly override target execution harness (e.g. agy, claude, api)
  -m, --model <model>     Explicitly override target model (e.g. model slug from acon.yaml)
  -e, --effort <level>    Explicitly override reasoning effort level (e.g. auto, low, medium, high)
  -n, --dry-run           Preview routing, rule matching, and policy checks without executing
  -k, --keep-bridge       Retain ephemeral task and result files in .agents/bridge/
  -c, --config <path>     Path to custom acon.yaml configuration file
  -h, --help              Show this help message and exit

Examples:
  # Dry-run intent routing
  ./dispatch.sh --dry-run --task "scout database models"

  # Execute implementation task with explicit model
  ./dispatch.sh --task "implement user authentication" --model custom-model

  # Execute task brief from file
  ./dispatch.sh --file .agents/bridge/brief.md --harness agy
USAGE_EOF
  exit 1
}

# ------------------------------------------------------------------------------
# Cleanup & Signal Trap
# ------------------------------------------------------------------------------
cleanup() {
  local exit_code=$?
  trap - EXIT INT TERM HUP

  if [[ -n "${RAW_OUTPUT_TMP:-}" && -f "${RAW_OUTPUT_TMP}" ]]; then
    rm -f "${RAW_OUTPUT_TMP}"
  fi

  if [[ "${KEEP_BRIDGE}" -eq 0 ]]; then
    if [[ -n "${BRIDGE_TASK_FILE:-}" && -f "${BRIDGE_TASK_FILE}" ]]; then
      rm -f "${BRIDGE_TASK_FILE}"
    fi
    if [[ -n "${BRIDGE_RESULT_FILE:-}" && -f "${BRIDGE_RESULT_FILE}" ]]; then
      rm -f "${BRIDGE_RESULT_FILE}"
    fi
  else
    if [[ -n "${BRIDGE_TASK_FILE:-}" && -f "${BRIDGE_TASK_FILE}" ]] || \
       [[ -n "${BRIDGE_RESULT_FILE:-}" && -f "${BRIDGE_RESULT_FILE}" ]]; then
      echo "[INFO] Ephemeral bridge files preserved:" >&2
      [[ -n "${BRIDGE_TASK_FILE:-}" && -f "${BRIDGE_TASK_FILE}" ]] && echo "[INFO]   Task:   ${BRIDGE_TASK_FILE}" >&2
      [[ -n "${BRIDGE_RESULT_FILE:-}" && -f "${BRIDGE_RESULT_FILE}" ]] && echo "[INFO]   Result: ${BRIDGE_RESULT_FILE}" >&2
    fi
  fi

  exit "${exit_code}"
}
trap cleanup EXIT INT TERM HUP

# ------------------------------------------------------------------------------
# Argument Parsing
# ------------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    -t|--task)
      TASK_ARG="${2:-}"
      shift 2
      ;;
    -f|--file)
      FILE_ARG="${2:-}"
      shift 2
      ;;
    -H|--harness)
      CLI_HARNESS="${2:-}"
      shift 2
      ;;
    -m|--model)
      CLI_MODEL="${2:-}"
      shift 2
      ;;
    -e|--effort)
      CLI_EFFORT="${2:-}"
      shift 2
      ;;
    -n|--dry-run)
      DRY_RUN=1
      shift
      ;;
    -k|--keep-bridge)
      KEEP_BRIDGE=1
      shift
      ;;
    -c|--config)
      CONFIG_FILE="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "[ERROR] Unknown option: $1" >&2
      usage
      ;;
  esac
done

# ------------------------------------------------------------------------------
# Validate Configuration File
# ------------------------------------------------------------------------------
if [[ ! -f "${CONFIG_FILE}" ]]; then
  echo "[ERROR] ACON configuration file not found at: ${CONFIG_FILE}" >&2
  exit 1
fi

# ------------------------------------------------------------------------------
# Read Task Content
# ------------------------------------------------------------------------------
TASK_TEXT=""
if [[ -n "${FILE_ARG}" ]]; then
  if [[ ! -f "${FILE_ARG}" ]]; then
    echo "[ERROR] Specified brief file not found: ${FILE_ARG}" >&2
    exit 1
  fi
  TASK_TEXT="$(cat "${FILE_ARG}")"
elif [[ -n "${TASK_ARG}" ]]; then
  TASK_TEXT="${TASK_ARG}"
fi

# ------------------------------------------------------------------------------
# Resolve Rules & Enforce Governance Policy via Python
# ------------------------------------------------------------------------------
RESOLVED_JSON="$(python3 - "${CONFIG_FILE}" "${TASK_TEXT}" "${CLI_HARNESS}" "${CLI_MODEL}" "${CLI_EFFORT}" << 'PYEOF'
import sys, os, re, json

config_path = sys.argv[1]
task_text = sys.argv[2]
cli_harness = sys.argv[3]
cli_model = sys.argv[4]
cli_effort = sys.argv[5] if len(sys.argv) > 5 else ""

try:
    import yaml
    with open(config_path, "r", encoding="utf-8") as f:
        cfg = yaml.safe_load(f) or {}
except Exception as e:
    sys.stderr.write(f"[ERROR] Failed to load configuration YAML: {e}\n")
    sys.exit(2)

bridge_cfg = cfg.get("bridge", cfg.get("control_plane", {}))
default_harness = bridge_cfg.get("default_harness", "agy")
default_effort = bridge_cfg.get("default_effort", "auto")
main_model = bridge_cfg.get("main_model", "")
models_cfg = cfg.get("models", {})
exclude_raw = models_cfg.get("exclude", [])
exclude_list = [str(m).strip() for m in exclude_raw]

def is_excluded(m):
    if not m:
        return False
    return any(m.strip().lower() == ex.lower() for ex in exclude_list)

# 1. Immediate policy check on explicit CLI model
if cli_model and is_excluded(cli_model):
    print(json.dumps({
        "status": "excluded",
        "model": cli_model,
        "reason": f"Model '{cli_model}' is explicitly excluded by policy in {os.path.basename(config_path)}"
    }))
    sys.exit(0)

# 2. Check if task text was provided
if not task_text:
    print(json.dumps({
        "status": "missing_task",
        "model": cli_model,
        "exclude_list": exclude_list
    }))
    sys.exit(0)

# 3. Match against dispatch rules
dispatch_section = cfg.get("dispatch", {})
rules = []
if isinstance(dispatch_section, list):
    rules = dispatch_section
elif isinstance(dispatch_section, dict):
    rules = dispatch_section.get("rules", [])

matched_rule = None
for r in rules:
    pattern = r.get("match", "")
    if pattern and re.search(pattern, task_text, re.IGNORECASE):
        matched_rule = r
        break

resolved_harness = cli_harness or (matched_rule.get("harness") if matched_rule else default_harness)
resolved_model = cli_model or (matched_rule.get("model") if matched_rule else main_model)
fallback_model = (matched_rule.get("fallback") if matched_rule else None) or main_model
effort = cli_effort or (matched_rule.get("effort") if matched_rule else None) or default_effort or "auto"
rule_name = matched_rule.get("name") if matched_rule else "default"
match_pattern = matched_rule.get("match") if matched_rule else None

# Check if fallback model is excluded
if fallback_model and is_excluded(fallback_model):
    fallback_model = None

# 4. Check if resolved model is excluded
if is_excluded(resolved_model):
    print(json.dumps({
        "status": "excluded",
        "model": resolved_model,
        "reason": f"Resolved model '{resolved_model}' is excluded by policy in {os.path.basename(config_path)}"
    }))
    sys.exit(0)

print(json.dumps({
    "status": "ok",
    "rule_name": rule_name,
    "match_pattern": match_pattern,
    "harness": resolved_harness,
    "model": resolved_model,
    "fallback": fallback_model,
    "effort": effort
}))
PYEOF
)"

STATUS="$(python3 -c "import sys, json; print(json.loads(sys.argv[1]).get('status', ''))" "${RESOLVED_JSON}")"

if [[ "${STATUS}" == "excluded" ]]; then
  EXCLUDED_MODEL="$(python3 -c "import sys, json; print(json.loads(sys.argv[1]).get('model', ''))" "${RESOLVED_JSON}")"
  EXCLUDED_REASON="$(python3 -c "import sys, json; print(json.loads(sys.argv[1]).get('reason', ''))" "${RESOLVED_JSON}")"
  echo "[ERROR] Governance Policy Violation: ${EXCLUDED_REASON}" >&2
  echo "[ERROR] Execution aborted immediately." >&2
  exit 1
fi

if [[ "${STATUS}" == "missing_task" ]]; then
  echo "[ERROR] Missing required argument: must provide --task \"<description>\" or --file <brief.md>." >&2
  usage
fi

RULE_NAME="$(python3 -c "import sys, json; print(json.loads(sys.argv[1]).get('rule_name', 'default'))" "${RESOLVED_JSON}")"
MATCH_PATTERN="$(python3 -c "import sys, json; print(json.loads(sys.argv[1]).get('match_pattern') or 'none') " "${RESOLVED_JSON}")"
RESOLVED_HARNESS="$(python3 -c "import sys, json; print(json.loads(sys.argv[1]).get('harness', 'agy'))" "${RESOLVED_JSON}")"
RESOLVED_MODEL="$(python3 -c "import sys, json; print(json.loads(sys.argv[1]).get('model', ''))" "${RESOLVED_JSON}")"
FALLBACK_MODEL="$(python3 -c "import sys, json; print(json.loads(sys.argv[1]).get('fallback') or 'none')" "${RESOLVED_JSON}")"
EFFORT_LEVEL="$(python3 -c "import sys, json; print(json.loads(sys.argv[1]).get('effort') or 'auto')" "${RESOLVED_JSON}")"

# ------------------------------------------------------------------------------
# Ephemeral Bridge File Setup
# ------------------------------------------------------------------------------
mkdir -p "${BRIDGE_DIR}"
TASK_UUID="$(python3 -c 'import uuid; print(uuid.uuid4())' 2>/dev/null || date +%s%N)"
BRIDGE_TASK_FILE="${BRIDGE_DIR}/task_${TASK_UUID}.md"
BRIDGE_RESULT_FILE="${BRIDGE_DIR}/result_${TASK_UUID}.json"

printf '%s\n' "${TASK_TEXT}" > "${BRIDGE_TASK_FILE}"

# ------------------------------------------------------------------------------
# Resolve Adapter Script
# ------------------------------------------------------------------------------
ADAPTER_SCRIPT=""
case "${RESOLVED_HARNESS}" in
  agy)
    ADAPTER_SCRIPT="${SCRIPT_DIR}/agy.sh"
    ;;
  claude|claude-code)
    ADAPTER_SCRIPT="${SCRIPT_DIR}/claude.sh"
    ;;
  api)
    ADAPTER_SCRIPT="${SCRIPT_DIR}/api-runner.py"
    ;;
  *)
    if [[ -f "${SCRIPT_DIR}/${RESOLVED_HARNESS}.sh" ]]; then
      ADAPTER_SCRIPT="${SCRIPT_DIR}/${RESOLVED_HARNESS}.sh"
    elif [[ -f "${SCRIPT_DIR}/${RESOLVED_HARNESS}" ]]; then
      ADAPTER_SCRIPT="${SCRIPT_DIR}/${RESOLVED_HARNESS}"
    else
      echo "[ERROR] Unsupported execution harness: '${RESOLVED_HARNESS}'. No adapter found in ${SCRIPT_DIR}." >&2
      exit 1
    fi
    ;;
esac

# ------------------------------------------------------------------------------
# Dry-Run Mode
# ------------------------------------------------------------------------------
if [[ "${DRY_RUN}" -eq 1 ]]; then
  cat <<REPORT_EOF
================================================================================
ACON Task Dispatch Plan (Dry Run)
================================================================================
Matched Rule   : ${RULE_NAME}
Pattern Match  : ${MATCH_PATTERN}
Target Harness : ${RESOLVED_HARNESS}
Target Model   : ${RESOLVED_MODEL}
Fallback Model : ${FALLBACK_MODEL}
Effort Level   : ${EFFORT_LEVEL}
Policy Check   : PASSED (Model '${RESOLVED_MODEL}' is permitted)
Adapter Script : ${ADAPTER_SCRIPT}
Bridge Task    : ${BRIDGE_TASK_FILE}
Bridge Result  : ${BRIDGE_RESULT_FILE}
--------------------------------------------------------------------------------
Task Content Preview:
$(head -n 5 "${BRIDGE_TASK_FILE}")
================================================================================
[INFO] Dry run complete. Execution halted before invoking adapter.
REPORT_EOF
  exit 0
fi

# ------------------------------------------------------------------------------
# Adapter Execution & Result Capture
# ------------------------------------------------------------------------------
if [[ ! -x "${ADAPTER_SCRIPT}" ]]; then
  chmod +x "${ADAPTER_SCRIPT}" || true
fi

TARGET_MODEL="${RESOLVED_MODEL}"
ACTUAL_MODEL="${TARGET_MODEL}"

echo "[INFO] Dispatching task via adapter: ${ADAPTER_SCRIPT} (harness=${RESOLVED_HARNESS}, model=${TARGET_MODEL}, effort=${EFFORT_LEVEL})" >&2

RAW_OUTPUT_TMP="$(mktemp "${BRIDGE_DIR}/raw_${TASK_UUID}.XXXXXX")"

# Pass effort level to environment
export EFFORT="${EFFORT_LEVEL}"
export ACON_EFFORT="${EFFORT_LEVEL}"

# Helper to execute adapter
execute_adapter() {
  local model_to_run="$1"
  if [[ "${RESOLVED_HARNESS}" == "agy" ]]; then
    "${ADAPTER_SCRIPT}" "${BRIDGE_TASK_FILE}" "${model_to_run}" "${EFFORT_LEVEL}" > "${RAW_OUTPUT_TMP}"
  else
    "${ADAPTER_SCRIPT}" "${BRIDGE_TASK_FILE}" "${model_to_run}" > "${RAW_OUTPUT_TMP}"
  fi
}

# Execute primary model
set +e
execute_adapter "${TARGET_MODEL}"
EXIT_CODE=$?
set -e

# Fallback retry logic
if [[ ${EXIT_CODE} -ne 0 ]]; then
  if [[ -n "${FALLBACK_MODEL}" && "${FALLBACK_MODEL}" != "none" && "${FALLBACK_MODEL}" != "${TARGET_MODEL}" ]]; then
    echo "[WARN] Primary model '${TARGET_MODEL}' failed with exit code ${EXIT_CODE}. Retrying with fallback model '${FALLBACK_MODEL}' on main..." >&2
    ACTUAL_MODEL="${FALLBACK_MODEL}"
    set +e
    execute_adapter "${FALLBACK_MODEL}"
    EXIT_CODE=$?
    set -e

    if [[ ${EXIT_CODE} -ne 0 ]]; then
      echo "[ERROR] Fallback model '${FALLBACK_MODEL}' also failed with exit code ${EXIT_CODE}." >&2
      exit "${EXIT_CODE}"
    fi
  else
    exit "${EXIT_CODE}"
  fi
fi

# Structure output into JSON result file
python3 - "${BRIDGE_RESULT_FILE}" "${TASK_UUID}" "${RESOLVED_HARNESS}" "${ACTUAL_MODEL}" "${RAW_OUTPUT_TMP}" << 'PYEOF'
import sys, os, json

result_file = sys.argv[1]
task_uuid = sys.argv[2]
harness = sys.argv[3]
model = sys.argv[4]
raw_file = sys.argv[5]

with open(raw_file, "r", encoding="utf-8", errors="replace") as f:
    raw_text = f.read()

try:
    parsed = json.loads(raw_text)
    if isinstance(parsed, dict):
        if "task_id" not in parsed:
            parsed["task_id"] = task_uuid
        if "harness" not in parsed:
            parsed["harness"] = harness
        if "model" not in parsed:
            parsed["model"] = model
        with open(result_file, "w", encoding="utf-8") as f:
            json.dump(parsed, f, indent=2)
    else:
        with open(result_file, "w", encoding="utf-8") as f:
            json.dump({
                "task_id": task_uuid,
                "harness": harness,
                "model": model,
                "result": parsed
            }, f, indent=2)
except Exception:
    with open(result_file, "w", encoding="utf-8") as f:
        json.dump({
            "task_id": task_uuid,
            "harness": harness,
            "model": model,
            "output": raw_text
        }, f, indent=2)
PYEOF

rm -f "${RAW_OUTPUT_TMP}"

# Emit output to stdout
cat "${BRIDGE_RESULT_FILE}"

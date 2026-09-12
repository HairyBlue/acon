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
CONFIG_READER="${SCRIPT_DIR}/config-reader.py"

# ------------------------------------------------------------------------------
# Platform Detection & Config Engine Resolution
# ------------------------------------------------------------------------------
case "$(uname -s)" in
    Linux|Darwin)
        PLATFORM="unix"
        ;;
    MINGW*|MSYS*|CYGWIN*)
        PLATFORM="windows"
        ;;
    *)
        PLATFORM="other"
        ;;
esac

USE_PYTHON_READER=0
PYTHON_BIN=""

if [[ "${ACON_FORCE_PYTHON_READER:-0}" == "1" ]]; then
    if command -v python3 &>/dev/null; then
        PYTHON_BIN="python3"
        USE_PYTHON_READER=1
    elif command -v python &>/dev/null; then
        PYTHON_BIN="python"
        USE_PYTHON_READER=1
    else
        echo "ERROR: Python 3 is required when ACON_FORCE_PYTHON_READER=1." >&2
        exit 1
    fi
elif [[ "${PLATFORM}" == "unix" ]] && command -v yq &>/dev/null && command -v jq &>/dev/null; then
    USE_PYTHON_READER=0
else
    if command -v python3 &>/dev/null; then
        PYTHON_BIN="python3"
        USE_PYTHON_READER=1
    elif command -v python &>/dev/null; then
        PYTHON_BIN="python"
        USE_PYTHON_READER=1
    elif command -v yq &>/dev/null && command -v jq &>/dev/null; then
        USE_PYTHON_READER=0
    else
        echo "ERROR: 'yq'/'jq' or 'python3' is required but not installed." >&2
        echo "  Install: https://github.com/mikefarah/yq (yq) or https://jqlang.github.io/jq/ (jq), or install Python 3." >&2
        exit 1
    fi
fi

# Compatibility wrapper for jq queries
if [[ "${USE_PYTHON_READER}" -eq 0 ]]; then
    acon_jq() {
        jq "$@"
    }
else
    acon_jq() {
        "${PYTHON_BIN}" "${CONFIG_READER}" --json-eval "$@"
    }
fi

# Configuration & Bridge Resolution (Repository Mode vs Global Hub Mode)
if [[ -f "${ACON_ROOT}/acon.yaml" ]]; then
  CONFIG_FILE="${ACON_ROOT}/acon.yaml"
elif [[ -f "${SCRIPT_DIR}/../acon.yaml" ]]; then
  ACON_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
  CONFIG_FILE="${ACON_ROOT}/acon.yaml"
elif [[ -n "${ACON_CONFIG:-}" && -f "${ACON_CONFIG}" ]]; then
  CONFIG_FILE="${ACON_CONFIG}"
  ACON_ROOT="$(cd "$(dirname "${CONFIG_FILE}")" && pwd)"
else
  CONFIG_FILE="${ACON_ROOT}/acon.yaml"
fi

if [[ -d "${ACON_ROOT}/.agents" ]]; then
  BRIDGE_DIR="${ACON_ROOT}/.agents/bridge"
else
  BRIDGE_DIR="${ACON_ROOT}/bridge"
fi

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
# Resolve Rules & Enforce Governance Policy
# ------------------------------------------------------------------------------
# 1. Parse configuration (using native yq or Python fallback reader)
# Convert YAML to JSON once for fast, standard querying
if [[ "${USE_PYTHON_READER}" -eq 0 ]]; then
  CONFIG_JSON="$(yq -o=json '.' "${CONFIG_FILE}")"
else
  CONFIG_JSON="$("${PYTHON_BIN}" "${CONFIG_READER}" "${CONFIG_FILE}")"
fi
BRIDGE_JSON="$(echo "${CONFIG_JSON}" | acon_jq -c '.bridge // .control_plane // {}')"
DEFAULT_HARNESS="$(echo "${BRIDGE_JSON}" | acon_jq -r '.default_harness // "agy"')"
DEFAULT_EFFORT="$(echo "${BRIDGE_JSON}" | acon_jq -r '.default_effort // "auto"')"
MAIN_MODEL="$(echo "${BRIDGE_JSON}" | acon_jq -r '.main_model // ""')"

EXCLUDE_JSON="$(echo "${CONFIG_JSON}" | acon_jq -c '.models.exclude // []')"

is_excluded() {
  local m="$1"
  [[ -z "${m}" ]] && return 1
  local match
  match="$(echo "${EXCLUDE_JSON}" | acon_jq -r --arg m "${m}" 'map(ascii_downcase) | index(($m | ascii_downcase)) // empty')"
  [[ -n "${match}" ]] && return 0
  return 1
}

# 2. Immediate policy check on explicit CLI model
if [[ -n "${CLI_MODEL}" ]] && is_excluded "${CLI_MODEL}"; then
  echo "[ERROR] Governance Policy Violation: Model '${CLI_MODEL}' is explicitly excluded by policy in $(basename "${CONFIG_FILE}")" >&2
  echo "[ERROR] Execution aborted immediately." >&2
  exit 1
fi

# 3. Check if task text was provided
if [[ -z "${TASK_TEXT}" ]]; then
  echo "[ERROR] Missing required argument: must provide --task \"<description>\" or --file <brief.md>." >&2
  usage
fi

# 4. Match against dispatch rules
RULES_JSON="$(echo "${CONFIG_JSON}" | acon_jq -c 'if .dispatch | type == "array" then .dispatch elif .dispatch | type == "object" then (.dispatch.rules // []) else [] end')"

RULE_NAME="default"
MATCH_PATTERN="none"
RESOLVED_HARNESS=""
RESOLVED_MODEL=""
FALLBACK_MODEL=""
EFFORT_LEVEL=""

NUM_RULES="$(echo "${RULES_JSON}" | acon_jq 'length')"
for (( i=0; i<NUM_RULES; i++ )); do
  RULE="$(echo "${RULES_JSON}" | acon_jq -c ".[$i]")"
  PATTERN="$(echo "${RULE}" | acon_jq -r '.match // ""')"
  if [[ -n "${PATTERN}" ]] && echo "${TASK_TEXT}" | grep -qiE "${PATTERN}"; then
    RULE_NAME="$(echo "${RULE}" | acon_jq -r '.name // "default"')"
    MATCH_PATTERN="${PATTERN}"
    RESOLVED_HARNESS="$(echo "${RULE}" | acon_jq -r '.harness // empty')"
    RESOLVED_MODEL="$(echo "${RULE}" | acon_jq -r '.model // empty')"
    FALLBACK_MODEL="$(echo "${RULE}" | acon_jq -r '.fallback // empty')"
    EFFORT_LEVEL="$(echo "${RULE}" | acon_jq -r '.effort // empty')"
    break
  fi
done

# Resolve missing properties using defaults
RESOLVED_HARNESS="${CLI_HARNESS:-${RESOLVED_HARNESS:-${DEFAULT_HARNESS}}}"
RESOLVED_MODEL="${CLI_MODEL:-${RESOLVED_MODEL:-${MAIN_MODEL}}}"
FALLBACK_MODEL="${FALLBACK_MODEL:-${MAIN_MODEL}}"
EFFORT_LEVEL="${CLI_EFFORT:-${EFFORT_LEVEL:-${DEFAULT_EFFORT}}}"
EFFORT_LEVEL="${EFFORT_LEVEL:-auto}"

# Check if fallback model is excluded
if is_excluded "${FALLBACK_MODEL}"; then
  FALLBACK_MODEL="none"
fi

# 5. Check if resolved model is excluded
if is_excluded "${RESOLVED_MODEL}"; then
  echo "[ERROR] Governance Policy Violation: Resolved model '${RESOLVED_MODEL}' is excluded by policy in $(basename "${CONFIG_FILE}")" >&2
  echo "[ERROR] Execution aborted immediately." >&2
  exit 1
fi

# ------------------------------------------------------------------------------
# Ephemeral Bridge File Setup
# ------------------------------------------------------------------------------
mkdir -p "${BRIDGE_DIR}"
TASK_UUID="$(uuidgen 2>/dev/null || cat /proc/sys/kernel/random/uuid 2>/dev/null || date +%s%N)"
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
if [[ "${USE_PYTHON_READER}" -eq 0 ]]; then
    if jq empty "${RAW_OUTPUT_TMP}" 2>/dev/null; then
        # Valid JSON — inject metadata
        if [[ "$(jq -r type "${RAW_OUTPUT_TMP}")" == "object" ]]; then
            jq --arg tid "$TASK_UUID" --arg h "$RESOLVED_HARNESS" --arg m "$ACTUAL_MODEL" \
                '. * {task_id: (.task_id // $tid), harness: (.harness // $h), model: (.model // $m)}' "${RAW_OUTPUT_TMP}" > "${BRIDGE_RESULT_FILE}"
        else
            jq --arg tid "$TASK_UUID" --arg h "$RESOLVED_HARNESS" --arg m "$ACTUAL_MODEL" \
                '{task_id: $tid, harness: $h, model: $m, result: .}' "${RAW_OUTPUT_TMP}" > "${BRIDGE_RESULT_FILE}"
        fi
    else
        # Raw text — wrap in JSON
        jq -n --arg tid "$TASK_UUID" --arg h "$RESOLVED_HARNESS" --arg m "$ACTUAL_MODEL" \
            --rawfile out "${RAW_OUTPUT_TMP}" \
            '{task_id: $tid, harness: $h, model: $m, output: $out}' > "${BRIDGE_RESULT_FILE}"
    fi
else
    "${PYTHON_BIN}" "${CONFIG_READER}" --wrap-result \
        --task-id "$TASK_UUID" --harness "$RESOLVED_HARNESS" --model "$ACTUAL_MODEL" \
        --raw-file "${RAW_OUTPUT_TMP}" > "${BRIDGE_RESULT_FILE}"
fi

rm -f "${RAW_OUTPUT_TMP}"

# Emit output to stdout
cat "${BRIDGE_RESULT_FILE}"

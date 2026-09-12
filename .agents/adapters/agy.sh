#!/usr/bin/env bash
# ==============================================================================
# Adapter: agy.sh
# Description: Antigravity CLI execution harness adapter for ACON
# ==============================================================================
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PROMPT_FILE=""
MODEL=""
EFFORT="${EFFORT:-}"

usage() {
  cat <<'USAGE_EOF' >&2
Usage: agy.sh <prompt_file> <model> [effort]
       agy.sh --file <prompt_file> --model <model> [--effort <effort>]

Arguments:
  <prompt_file>   Path to markdown or text file containing the task brief
  <model>         Target model identifier defined in acon.yaml
  [effort]        Optional reasoning effort (auto, low, medium, high)
USAGE_EOF
  exit 1
}

# Support both positional arguments ($1 $2 [$3]) and flagged options
if [[ $# -ge 2 && ! "$1" =~ ^- ]]; then
  PROMPT_FILE="$1"
  MODEL="$2"
  if [[ $# -ge 3 ]]; then
    EFFORT="$3"
  fi
else
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -f|--file|--prompt-file)
        PROMPT_FILE="${2:-}"
        shift 2
        ;;
      -m|--model)
        MODEL="${2:-}"
        shift 2
        ;;
      -e|--effort)
        EFFORT="${2:-}"
        shift 2
        ;;
      -h|--help)
        usage
        ;;
      *)
        echo "[ERROR] Unknown argument: $1" >&2
        usage
        ;;
    esac
  done
fi

if [[ -z "${PROMPT_FILE}" || -z "${MODEL}" ]]; then
  echo "[ERROR] Both prompt file and model must be specified." >&2
  usage
fi

if [[ ! -f "${PROMPT_FILE}" ]]; then
  echo "[ERROR] Prompt file not found: ${PROMPT_FILE}" >&2
  exit 1
fi

if ! command -v agy >/dev/null 2>&1; then
  echo "[ERROR] 'agy' CLI is not installed or not in PATH." >&2
  echo "[INFO]  To use this adapter, install Antigravity CLI." >&2
  exit 127
fi

# Resolve reasoning effort
RESOLVED_EFFORT=""
if [[ -z "${EFFORT}" || "${EFFORT}" == "auto" ]]; then
  if [[ "${MODEL}" =~ gpt-oss ]]; then
    RESOLVED_EFFORT="medium"
  else
    RESOLVED_EFFORT="high"
  fi
elif [[ "${EFFORT}" == "high" && "${MODEL}" =~ gpt-oss ]]; then
  echo "[INFO] Model '${MODEL}' max effort is medium; auto-clamping from high to medium" >&2
  RESOLVED_EFFORT="medium"
else
  RESOLVED_EFFORT="${EFFORT}"
fi

# Map acon.yaml model slugs to agy CLI model identifiers
AGY_MODEL="${MODEL}"
if [[ "${AGY_MODEL}" == "claude-opus-4-6" ]]; then
  AGY_MODEL="claude-opus-4-6-thinking"
fi

EFFORT_ARGS=()
# Claude models in agy have thinking built-in and reject the --effort CLI flag
if [[ ! "${AGY_MODEL}" =~ ^claude- ]]; then
  if [[ -n "${RESOLVED_EFFORT}" && "${RESOLVED_EFFORT}" != "standard" && "${RESOLVED_EFFORT}" != "none" ]]; then
    EFFORT_ARGS+=(--effort "${RESOLVED_EFFORT}")
  fi
fi

# Execute agy CLI in print mode with JSON output
exec agy -p "$(cat "${PROMPT_FILE}")" --model "${AGY_MODEL}" "${EFFORT_ARGS[@]}" --print-timeout "${PRINT_TIMEOUT:-10m0s}" --output-format json

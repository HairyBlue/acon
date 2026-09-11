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
  [effort]        Optional reasoning effort (low, medium, high)
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
  echo "[INFO]  To use this adapter, install Antigravity CLI or use api-runner.py fallback." >&2
  exit 127
fi

EFFORT_ARGS=()
if [[ -n "${EFFORT}" && "${EFFORT}" != "standard" && "${EFFORT}" != "none" ]]; then
  EFFORT_ARGS+=(--effort "${EFFORT}")
fi

# Execute agy CLI in print mode with JSON output
exec agy -p "$(cat "${PROMPT_FILE}")" --model "${MODEL}" "${EFFORT_ARGS[@]}" --output-format json

#!/usr/bin/env bash
# ==============================================================================
# Adapter: claude.sh
# Description: Claude Code CLI execution harness adapter for ACON
# ==============================================================================
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PROMPT_FILE=""
MODEL=""

usage() {
  cat <<'USAGE_EOF' >&2
Usage: claude.sh <prompt_file> <model>
       claude.sh --file <prompt_file> --model <model>

Arguments:
  <prompt_file>   Path to markdown or text file containing the task brief
  <model>         Target model identifier defined in acon.yaml
USAGE_EOF
  exit 1
}

# Support both positional arguments ($1 $2) and flagged options
if [[ $# -ge 2 && ! "$1" =~ ^- ]]; then
  PROMPT_FILE="$1"
  MODEL="$2"
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

if ! command -v claude >/dev/null 2>&1; then
  echo "[ERROR] 'claude' CLI is not installed or not in PATH." >&2
  echo "[INFO]  To use Claude Code, install via: npm install -g @anthropic-ai/claude-code" >&2
  echo "[INFO]  Alternatively, use api-runner.py fallback with ANTHROPIC_API_KEY." >&2
  exit 127
fi

# Execute claude CLI in non-interactive print mode
exec claude -p "$(cat "${PROMPT_FILE}")" --model "${MODEL}"

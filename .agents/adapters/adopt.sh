#!/usr/bin/env bash
# ==============================================================================
# ACON Repository Adoption & Synchronization: adopt.sh
# Description: Installs and updates ACON's Control Plane constitution, 114-skill
#              catalog, declarative model governance, rules, adapters, and IDE
#              configurations into any target repository.
#
# Non-Negotiable Invariants:
# 1. Universal Physical Copy Invariant (zero symlinks across all target assets)
# 2. Two-Tier AGENTS.md Merge Standard (preserves target repo rules verbatim)
# 3. Fail-Closed Verification Gate (symlink audit + dispatch dry-run)
# ==============================================================================
set -euo pipefail
IFS=$'\n\t'

# ------------------------------------------------------------------------------
# Directory & Path Resolution
# ------------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ACON_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# CLI Options & Defaults
TARGET_ARG=""
DRY_RUN=0
FORCE=0
SKIP_IDE=0
TEMP_DIR=""

# ------------------------------------------------------------------------------
# Cleanup & Signal Trap
# ------------------------------------------------------------------------------
cleanup() {
  local exit_code=$?
  trap - EXIT INT TERM HUP

  if [[ -n "${TEMP_DIR:-}" && -d "${TEMP_DIR}" ]]; then
    rm -rf "${TEMP_DIR}"
  fi

  exit "${exit_code}"
}
trap cleanup EXIT INT TERM HUP

# ------------------------------------------------------------------------------
# Usage & Help
# ------------------------------------------------------------------------------
usage() {
  local exit_code="${1:-1}"
  cat <<'USAGE_EOF' >&2
Usage: adopt.sh [OPTIONS] <TARGET_DIRECTORY>

Universal adoption, bootstrap, and synchronization suite for transferring
ACON's Control Plane constitution, 114-skill catalog, rules, adapters, and
configuration into any new or existing repository.

Arguments:
  <TARGET_DIRECTORY>     Path to target repository to adopt ACON into

Options:
  -n, --dry-run          Preview files to be transferred without making changes
  -f, --force            Overwrite configuration or re-synthesize AGENTS.md
  -s, --skip-ide         Deploy .agents/ only, skipping .cursor/ and .claude/
  -h, --help             Show this help message and exit

Invariants Enforced:
  • Universal Physical Copy Invariant: 0 symlinks in target repository
  • Two-Tier AGENTS.md: Tier 1 (Command Bridge) + Tier 2 (Workshop Manual)
  • Fail-Closed Gate: Automated symlink audit and dispatch dry-run check

Examples:
  # Adopt ACON into a target project
  ./.agents/adapters/adopt.sh /path/to/my-project

  # Preview adoption in dry-run mode
  ./.agents/adapters/adopt.sh --dry-run /path/to/my-project

  # Force update an already adopted project
  ./.agents/adapters/adopt.sh --force /path/to/my-project
USAGE_EOF
  exit "${exit_code}"
}

# ------------------------------------------------------------------------------
# Argument Parsing
# ------------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run)
      DRY_RUN=1
      shift
      ;;
    -f|--force)
      FORCE=1
      shift
      ;;
    -s|--skip-ide)
      SKIP_IDE=1
      shift
      ;;
    -h|--help)
      usage 0
      ;;
    -*)
      echo "[ERROR] Unknown option: $1" >&2
      usage
      ;;
    *)
      if [[ -z "${TARGET_ARG}" ]]; then
        TARGET_ARG="$1"
        shift
      else
        echo "[ERROR] Unexpected extra argument: $1" >&2
        usage
      fi
      ;;
  esac
done

if [[ -z "${TARGET_ARG}" ]]; then
  echo "[ERROR] Missing required argument: <TARGET_DIRECTORY>" >&2
  usage
fi

# ------------------------------------------------------------------------------
# Target Validation
# ------------------------------------------------------------------------------
if [[ ! -d "${TARGET_ARG}" ]]; then
  echo "[ERROR] Target directory does not exist or is not a directory: ${TARGET_ARG}" >&2
  exit 1
fi

TARGET="$(cd "${TARGET_ARG}" && pwd)"

if [[ "${TARGET}" == "${ACON_ROOT}" ]]; then
  echo "[ERROR] Cannot adopt ACON into the ACON source directory itself: ${TARGET}" >&2
  exit 1
fi

if [[ "${TARGET}" == "/" ]]; then
  echo "[ERROR] Target directory cannot be filesystem root (/)" >&2
  exit 1
fi

TEMP_DIR="$(mktemp -d -t acon-adopt-XXXXXX)"

echo "================================================================================"
echo "ACON Repository Adoption & Synchronization"
echo "================================================================================"
echo "Source Repository : ${ACON_ROOT}"
echo "Target Repository : ${TARGET}"
echo "Dry Run Mode      : $([[ ${DRY_RUN} -eq 1 ]] && echo "YES (preview only)" || echo "NO (live adoption)")"
echo "Deploy IDE Folders: $([[ ${SKIP_IDE} -eq 1 ]] && echo "SKIPPED" || echo "YES (.cursor, .claude)")"
echo "Force Overwrite   : $([[ ${FORCE} -eq 1 ]] && echo "YES" || echo "NO")"
echo "--------------------------------------------------------------------------------"

# ------------------------------------------------------------------------------
# Phase 1: Scout & Target Audit
# ------------------------------------------------------------------------------
echo "[PHASE 1] Auditing target repository..."

TARGET_HAS_AGENTS_MD=0
TARGET_HAS_CLAUDE_MD=0
TARGET_HAS_ACON_YAML=0
TARGET_ALREADY_ACON=0

if [[ -f "${TARGET}/AGENTS.md" || -L "${TARGET}/AGENTS.md" ]]; then
  TARGET_HAS_AGENTS_MD=1
  if grep -q "ACON Agent Control Plane Constitution" "${TARGET}/AGENTS.md" 2>/dev/null; then
    TARGET_ALREADY_ACON=1
  fi
fi

if [[ -f "${TARGET}/CLAUDE.md" || -L "${TARGET}/CLAUDE.md" ]]; then
  TARGET_HAS_CLAUDE_MD=1
fi

if [[ -f "${TARGET}/acon.yaml" ]]; then
  TARGET_HAS_ACON_YAML=1
fi

echo "  • Existing AGENTS.md : $([[ ${TARGET_HAS_AGENTS_MD} -eq 1 ]] && echo "Detected" || echo "Not found")"
echo "  • Existing CLAUDE.md : $([[ ${TARGET_HAS_CLAUDE_MD} -eq 1 ]] && echo "Detected" || echo "Not found")"
echo "  • Existing acon.yaml : $([[ ${TARGET_HAS_ACON_YAML} -eq 1 ]] && echo "Detected" || echo "Not found")"
echo "  • ACON Constitution  : $([[ ${TARGET_ALREADY_ACON} -eq 1 ]] && echo "Already present (updating)" || echo "Fresh adoption")"

# ------------------------------------------------------------------------------
# Phase 2: Two-Tier AGENTS.md Synthesis
# ------------------------------------------------------------------------------
echo "[PHASE 2] Synthesizing Two-Tier AGENTS.md..."

SOURCE_CONSTITUTION="${ACON_ROOT}/AGENTS.md"
SYNTHESIZED_AGENTS="${TEMP_DIR}/AGENTS.md"
WORKSHOP_CONTENT="${TEMP_DIR}/workshop.md"
touch "${WORKSHOP_CONTENT}"

if [[ ${TARGET_HAS_AGENTS_MD} -eq 1 ]]; then
  if [[ ${TARGET_ALREADY_ACON} -eq 1 ]]; then
    # Target already has ACON constitution. Extract existing Tier 2 workshop manual.
    if grep -q "## Local Workshop Manual:" "${TARGET}/AGENTS.md"; then
      awk '/## Local Workshop Manual:/{flag=1} flag' "${TARGET}/AGENTS.md" > "${WORKSHOP_CONTENT}"
    elif grep -q "=== foundation rules ===" "${TARGET}/AGENTS.md"; then
      awk '/=== foundation rules ===/{flag=1} flag' "${TARGET}/AGENTS.md" > "${WORKSHOP_CONTENT}"
    fi
  else
    # Existing non-ACON AGENTS.md: preserve entire file verbatim as Tier 2 Workshop Manual
    TARGET_PROJECT_NAME="$(basename "${TARGET}")"
    cat <<EOF > "${WORKSHOP_CONTENT}"
## Local Workshop Manual: ${TARGET_PROJECT_NAME} Guidelines

The guidelines below are preserved verbatim from this repository's original instructions.
Dispatched specialist subagents MUST inspect and adhere to these local conventions.

EOF
    cat "${TARGET}/AGENTS.md" >> "${WORKSHOP_CONTENT}"
  fi
elif [[ ${TARGET_HAS_CLAUDE_MD} -eq 1 && ! -L "${TARGET}/CLAUDE.md" ]]; then
  # Target has a physical CLAUDE.md but no AGENTS.md
  TARGET_PROJECT_NAME="$(basename "${TARGET}")"
  cat <<EOF > "${WORKSHOP_CONTENT}"
## Local Workshop Manual: ${TARGET_PROJECT_NAME} Guidelines

The guidelines below are preserved verbatim from this repository's original CLAUDE.md.
Dispatched specialist subagents MUST inspect and adhere to these local conventions.

EOF
  cat "${TARGET}/CLAUDE.md" >> "${WORKSHOP_CONTENT}"
fi

# Assemble Tier 1 (Command Bridge) + Tier 2 (Workshop Manual)
if [[ -s "${WORKSHOP_CONTENT}" ]]; then
  # Prepend Tier 1 constitution with local workshop manual link in section 3 if needed
  TARGET_PROJECT_NAME="$(basename "${TARGET}")"
  sed '/## 3. Command Bridge vs. Workshop Manuals/,/## 4. Mandatory Multi-Agent Delegation Rules/{
    /respecting the file boundary constraints established by the Control Plane\./ {
      a\
  - **Local Application Workshop Manual:** In this repository, the local Workshop Manual is defined directly below in the [Local Workshop Manual](#local-workshop-manual) section. Dispatched specialist subagents must strictly adhere to these local rules during execution.
    }
  }' "${SOURCE_CONSTITUTION}" > "${SYNTHESIZED_AGENTS}"

  cat <<'EOF' >> "${SYNTHESIZED_AGENTS}"

---

EOF
  cat "${WORKSHOP_CONTENT}" >> "${SYNTHESIZED_AGENTS}"
else
  # Fresh adoption without existing guidelines
  cp "${SOURCE_CONSTITUTION}" "${SYNTHESIZED_AGENTS}"
fi

if [[ ${DRY_RUN} -eq 0 ]]; then
  # Remove any pre-existing symlinks first to uphold Physical Copy Invariant
  rm -f "${TARGET}/AGENTS.md" "${TARGET}/CLAUDE.md"
  cp "${SYNTHESIZED_AGENTS}" "${TARGET}/AGENTS.md"
  cp "${SYNTHESIZED_AGENTS}" "${TARGET}/CLAUDE.md"
  echo "  ✓ Installed physical AGENTS.md and CLAUDE.md"
else
  echo "  [DRY RUN] Would install physical AGENTS.md and CLAUDE.md (${SYNTHESIZED_AGENTS})"
fi

# ------------------------------------------------------------------------------
# Phase 3: Pure Physical Copy Deployment (acon.yaml & .agents/)
# ------------------------------------------------------------------------------
echo "[PHASE 3] Deploying .agents/ and configuration (dereferencing all symlinks)..."

if [[ ${DRY_RUN} -eq 0 ]]; then
  # 1. acon.yaml
  if [[ ${TARGET_HAS_ACON_YAML} -eq 0 || ${FORCE} -eq 1 ]]; then
    rm -f "${TARGET}/acon.yaml"
    cp "${ACON_ROOT}/acon.yaml" "${TARGET}/acon.yaml"
    echo "  ✓ Installed physical acon.yaml"
  else
    echo "  ✓ Retained existing acon.yaml (use --force to overwrite)"
  fi

  # 2. .agents/ directory (rsync -avL dereferences all symlinks into real files)
  mkdir -p "${TARGET}/.agents"
  rsync -avL --delete \
    --exclude='bridge/task_*' \
    --exclude='bridge/result_*' \
    "${ACON_ROOT}/.agents/" "${TARGET}/.agents/"
  echo "  ✓ Deployed .agents/ directory with 0 symlinks"

  # Ensure adapters have execution permissions
  chmod +x "${TARGET}/.agents/adapters/"*.sh 2>/dev/null || true
  if [[ -f "${TARGET}/.agents/adapters/api-runner.py" ]]; then
    chmod +x "${TARGET}/.agents/adapters/api-runner.py"
  fi
  echo "  ✓ Verified adapter executable permissions"
else
  echo "  [DRY RUN] Would copy acon.yaml and rsync -avL .agents/"
fi

# ------------------------------------------------------------------------------
# Phase 4: IDE Folder Setup (.cursor/ & .claude/)
# ------------------------------------------------------------------------------
if [[ ${SKIP_IDE} -eq 0 ]]; then
  echo "[PHASE 4] Deploying IDE skill directories (.cursor/ & .claude/)..."
  if [[ ${DRY_RUN} -eq 0 ]]; then
    mkdir -p "${TARGET}/.cursor" "${TARGET}/.claude"
    # rsync -avL expands all symlinked skills and rules into concrete physical files
    rsync -avL --delete "${ACON_ROOT}/.cursor/" "${TARGET}/.cursor/"
    rsync -avL --delete "${ACON_ROOT}/.claude/" "${TARGET}/.claude/"
    echo "  ✓ Deployed physical .cursor/ directory"
    echo "  ✓ Deployed physical .claude/ directory"
  else
    echo "  [DRY RUN] Would deploy physical .cursor/ and .claude/ directories"
  fi
else
  echo "[PHASE 4] Skipping IDE folders (.cursor/, .claude/) as requested"
fi

# ------------------------------------------------------------------------------
# Phase 5: Verification Gate (Fail-Closed)
# ------------------------------------------------------------------------------
echo "[PHASE 5] Executing Verification Gate..."

if [[ ${DRY_RUN} -eq 0 ]]; then
  # 1. Invariant Check: Universal Physical Copy (Zero Symlinks)
  echo "  • Auditing symlinks in adopted directories..."

  # Check adopted directories specifically
  SYMLINKS_ACON=$(find "${TARGET}/.agents" \
    $([[ ${SKIP_IDE} -eq 0 ]] && echo "${TARGET}/.cursor ${TARGET}/.claude") \
    -type l 2>/dev/null || true)

  if [[ -n "${SYMLINKS_ACON}" ]]; then
    echo "[FAIL-CLOSED] Universal Physical Copy Invariant violated!" >&2
    echo "Found symlinks in adopted ACON directories:" >&2
    echo "${SYMLINKS_ACON}" >&2
    exit 1
  fi

  # Check root ACON files
  for root_file in AGENTS.md CLAUDE.md acon.yaml; do
    if [[ -L "${TARGET}/${root_file}" ]]; then
      echo "[FAIL-CLOSED] ${root_file} is a symlink! Must be a real physical file." >&2
      exit 1
    fi
  done

  # Check repository-wide excluding standard package manager & VCS internal directories
  SYMLINKS_REPO=$(find "${TARGET}" \
    -name .git -prune -o \
    -name node_modules -prune -o \
    -name vendor -prune -o \
    -name .venv -prune -o \
    -name .pnpm-store -prune -o \
    -type l -print 2>/dev/null || true)

  if [[ -n "${SYMLINKS_REPO}" ]]; then
    echo "[FAIL-CLOSED] Detected symlinks outside package manager caches in target repository:" >&2
    echo "${SYMLINKS_REPO}" >&2
    exit 1
  fi
  echo "  ✓ Invariant Verified: Zero symlinks found across all target assets"

  # 2. Invariant Check: Harness Dispatch Dry-Run
  echo "  • Verifying harness adapter dispatch runner..."
  if [[ -x "${TARGET}/.agents/adapters/dispatch.sh" ]]; then
    DISPATCH_OUTPUT=$("${TARGET}/.agents/adapters/dispatch.sh" --dry-run --task "verify" 2>&1)
    if [[ $? -ne 0 ]]; then
      echo "[FAIL-CLOSED] dispatch.sh verification failed:" >&2
      echo "${DISPATCH_OUTPUT}" >&2
      exit 1
    fi
    echo "  ✓ Dispatch Runner Verified: Dry-run check PASSED"
  else
    echo "[FAIL-CLOSED] ${TARGET}/.agents/adapters/dispatch.sh is missing or not executable" >&2
    exit 1
  fi

  # 3. Skill Catalog Count Check
  SKILL_COUNT=$(find "${TARGET}/.agents/skills" -name "SKILL.md" | wc -l | tr -d ' ')
  echo "  ✓ Catalog Verified: ${SKILL_COUNT} active skills installed"
else
  echo "  [DRY RUN] Verification Gate checks simulated."
fi

# ------------------------------------------------------------------------------
# Completion Digest
# ------------------------------------------------------------------------------
echo "================================================================================"
echo "⚓ ACON Adoption Complete: Target repository is shipshape!"
echo "================================================================================"
echo "Target Root      : ${TARGET}"
echo "Constitution     : ${TARGET}/AGENTS.md (Two-Tier Architecture)"
echo "CLAUDE Parity    : ${TARGET}/CLAUDE.md (Physical Copy)"
echo "Model Governance : ${TARGET}/acon.yaml"
echo "Catalog Location : ${TARGET}/.agents/skills/ (114 Skills)"
if [[ ${SKIP_IDE} -eq 0 ]]; then
  echo "IDE Integration  : ${TARGET}/.cursor/ and ${TARGET}/.claude/ (Physical Copies)"
fi
echo "Symlink Status   : 0 symlinks (Universal Physical Copy Invariant Satisfied)"
echo "Verification     : PASSED"
echo "================================================================================"

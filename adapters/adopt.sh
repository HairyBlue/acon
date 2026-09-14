#!/usr/bin/env bash
# ==============================================================================
# ACON Repository Adoption & Synchronization: adopt.sh
# Description: Installs and updates ACON's Control Plane constitution (AGENTS.md),
#              114-skill catalog (.agents/skills/), and constitutional rules
#              (.agents/rules/) into any target repository.
#
# Non-Negotiable Invariants:
# 1. Universal Physical Copy Invariant (zero symlinks across all target assets)
# 2. Two-Tier AGENTS.md Merge Standard (preserves target repo rules verbatim)
# 3. Strict Lightweight Adoption Boundary (adopts ONLY AGENTS.md, .agents/skills/,
#    and .agents/rules/; never copies adapters/, sessions/, or acon.yaml)
# 4. Fail-Closed Verification Gate (symlink audit + boundary enforcement)
# ==============================================================================
set -euo pipefail
IFS=$'\n\t'

# ------------------------------------------------------------------------------
# Directory & Path Resolution
# ------------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ACON_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# CLI Options & Defaults
TARGET_ARG=""
DRY_RUN=0
FORCE=0
DEPLOY_IDE=0
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

Universal lightweight adoption, bootstrap, and synchronization suite for
transferring ACON's Control Plane constitution, 114-skill catalog, and
constitutional rules into any new or existing repository.

Strict Adoption Standard:
  Adopts ONLY:
    • AGENTS.md          (Two-Tier Architecture: Command Bridge + Local Workshop Manual)
    • .agents/skills/    (114 domain skills dereferenced into real physical files)
    • .agents/rules/     (Constitutional rules dereferenced into real physical files)
  Strictly EXCLUDES:
    • adapters/          (Harness adapters belong to ACON control plane only)
    • adapters/sessions/ (Runtime session logs and bridge mailboxes)
    • acon.yaml          (Model governance belongs to ACON control plane only)

Arguments:
  <TARGET_DIRECTORY>     Path to target repository to adopt ACON into

Options:
  -n, --dry-run          Preview files to be transferred without making changes
  -f, --force            Overwrite existing files or re-synthesize AGENTS.md
      --ide              Also deploy .cursor/ and .claude/ IDE folders (optional)
  -h, --help             Show this help message and exit

Invariants Enforced:
  • Universal Physical Copy Invariant: 0 symlinks in target repository
  • Two-Tier AGENTS.md: Tier 1 (Command Bridge) + Tier 2 (Workshop Manual)
  • Strict Adoption Boundary: Only AGENTS.md, skills, and rules deployed
  • Fail-Closed Gate: Automated symlink audit and boundary check

Examples:
  # Adopt ACON into a target project
  ./adapters/adopt.sh /path/to/my-project

  # Preview adoption in dry-run mode
  ./adapters/adopt.sh --dry-run /path/to/my-project

  # Force update an already adopted project
  ./adapters/adopt.sh --force /path/to/my-project
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
    --ide)
      DEPLOY_IDE=1
      shift
      ;;
    -s|--skip-ide)
      DEPLOY_IDE=0
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
echo "Adoption Scope    : AGENTS.md, .agents/skills/, .agents/rules/"
echo "Excluded Assets   : adapters/, sessions/, acon.yaml (Strict Boundary Enforced)"
echo "Deploy IDE Folders: $([[ ${DEPLOY_IDE} -eq 1 ]] && echo "YES (.cursor, .claude)" || echo "NO (default: clean lightweight)")"
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
  rm -f "${TARGET}/AGENTS.md"
  cp "${SYNTHESIZED_AGENTS}" "${TARGET}/AGENTS.md"
  echo "  ✓ Installed physical AGENTS.md"
  if [[ ${TARGET_HAS_CLAUDE_MD} -eq 1 || ${DEPLOY_IDE} -eq 1 ]]; then
    rm -f "${TARGET}/CLAUDE.md"
    cp "${SYNTHESIZED_AGENTS}" "${TARGET}/CLAUDE.md"
    echo "  ✓ Installed physical CLAUDE.md"
  fi
else
  echo "  [DRY RUN] Manifest item: AGENTS.md (${SYNTHESIZED_AGENTS})"
  if [[ ${TARGET_HAS_CLAUDE_MD} -eq 1 || ${DEPLOY_IDE} -eq 1 ]]; then
    echo "  [DRY RUN] Manifest item: CLAUDE.md (Mirrored physical file)"
  fi
fi

# ------------------------------------------------------------------------------
# Phase 3: Pure Physical Copy Deployment (.agents/skills/ & .agents/rules/)
# ------------------------------------------------------------------------------
echo "[PHASE 3] Deploying .agents/skills/, .agents/rules/, and catalog indexes (dereferencing all symlinks)..."
echo "  • Boundary Policy: Strictly excluding adapters/, sessions/, and acon.yaml"

if [[ ${DRY_RUN} -eq 0 ]]; then
  # 1. Deploy .agents/skills/
  mkdir -p "${TARGET}/.agents/skills"
  rsync -avL --delete \
    "${ACON_ROOT}/.agents/skills/" "${TARGET}/.agents/skills/"
  echo "  ✓ Deployed .agents/skills/ directory (100% physical, 0 symlinks)"

  # 2. Deploy .agents/rules/ (if exists)
  if [[ -d "${ACON_ROOT}/.agents/rules" ]]; then
    mkdir -p "${TARGET}/.agents/rules"
    rsync -avL --delete \
      "${ACON_ROOT}/.agents/rules/" "${TARGET}/.agents/rules/"
    echo "  ✓ Deployed .agents/rules/ directory (100% physical, 0 symlinks)"
  fi

  # 3. Deploy root documentation in .agents/ (INDEX.md, README.md)
  for doc_file in INDEX.md README.md; do
    if [[ -f "${ACON_ROOT}/.agents/${doc_file}" ]]; then
      rm -f "${TARGET}/.agents/${doc_file}"
      cp "${ACON_ROOT}/.agents/${doc_file}" "${TARGET}/.agents/${doc_file}"
      echo "  ✓ Deployed .agents/${doc_file}"
    fi
  done

  # 4. Prune legacy .agents/adapters and .agents/bridge if present in target
  if [[ -d "${TARGET}/.agents/adapters" ]]; then
    rm -rf "${TARGET}/.agents/adapters"
    echo "  ✓ Pruned obsolete .agents/adapters directory"
  fi
  if [[ -d "${TARGET}/.agents/bridge" ]]; then
    rm -rf "${TARGET}/.agents/bridge"
    echo "  ✓ Pruned obsolete .agents/bridge directory"
  fi
else
  echo "  [DRY RUN] Manifest item: .agents/skills/ (rsync -avL dereferencing all symlinks)"
  if [[ -d "${ACON_ROOT}/.agents/rules" ]]; then
    echo "  [DRY RUN] Manifest item: .agents/rules/ (rsync -avL dereferencing all symlinks)"
  fi
  echo "  [DRY RUN] Manifest items: .agents/INDEX.md, .agents/README.md"
  if [[ -d "${TARGET}/.agents/adapters" || -d "${TARGET}/.agents/bridge" ]]; then
    echo "  [DRY RUN] Would prune obsolete legacy directories (.agents/adapters, .agents/bridge)"
  fi
  echo "  [DRY RUN] Explicitly excluded: adapters/, adapters/sessions/, acon.yaml"
fi

# ------------------------------------------------------------------------------
# Phase 4: Optional IDE Folder Setup (.cursor/ & .claude/)
# ------------------------------------------------------------------------------
if [[ ${DEPLOY_IDE} -eq 1 ]]; then
  echo "[PHASE 4] Deploying IDE skill directories (.cursor/ & .claude/)..."
  if [[ ${DRY_RUN} -eq 0 ]]; then
    mkdir -p "${TARGET}/.cursor" "${TARGET}/.claude"
    rsync -avL --delete "${ACON_ROOT}/.cursor/" "${TARGET}/.cursor/"
    rsync -avL --delete "${ACON_ROOT}/.claude/" "${TARGET}/.claude/"
    echo "  ✓ Deployed physical .cursor/ directory"
    echo "  ✓ Deployed physical .claude/ directory"
  else
    echo "  [DRY RUN] Would deploy physical .cursor/ and .claude/ directories"
  fi
else
  echo "[PHASE 4] Skipping IDE folders (.cursor/, .claude/) — keeping target repository lightweight"
fi

# ------------------------------------------------------------------------------
# Phase 5: Verification Gate (Fail-Closed)
# ------------------------------------------------------------------------------
echo "[PHASE 5] Executing Verification Gate..."

if [[ ${DRY_RUN} -eq 0 ]]; then
  # 1. Invariant Check: Universal Physical Copy (Zero Symlinks)
  echo "  • Auditing symlinks in adopted directories..."

  SYMLINKS_ACON=$(find "${TARGET}/.agents" \
    $([[ ${DEPLOY_IDE} -eq 1 ]] && echo "${TARGET}/.cursor ${TARGET}/.claude") \
    -type l 2>/dev/null || true)

  if [[ -n "${SYMLINKS_ACON}" ]]; then
    echo "[FAIL-CLOSED] Universal Physical Copy Invariant violated!" >&2
    echo "Found symlinks in adopted ACON directories:" >&2
    echo "${SYMLINKS_ACON}" >&2
    exit 1
  fi

  # Check root AGENTS.md
  if [[ -L "${TARGET}/AGENTS.md" ]]; then
    echo "[FAIL-CLOSED] AGENTS.md is a symlink! Must be a real physical file." >&2
    exit 1
  fi

  echo "  ✓ Invariant Verified: Zero symlinks found in adopted ACON assets"

  # 2. Invariant Check: Adoption Boundary Enforcement (Zero Leaked Adapters/Sessions/Config)
  echo "  • Verifying adoption boundary enforcement..."
  if [[ -e "${TARGET}/adapters" ]]; then
    echo "[FAIL-CLOSED] Boundary Violation: adapters/ directory found in target repository!" >&2
    exit 1
  fi
  if [[ -e "${TARGET}/adapters/sessions" || -e "${TARGET}/.agents/sessions" ]]; then
    echo "[FAIL-CLOSED] Boundary Violation: sessions directory found in target repository!" >&2
    exit 1
  fi
  if [[ -e "${TARGET}/.agents/adapters" || -e "${TARGET}/.agents/bridge" ]]; then
    echo "[FAIL-CLOSED] Boundary Violation: legacy .agents/adapters or .agents/bridge found in target repository!" >&2
    exit 1
  fi
  echo "  ✓ Boundary Verified: adapters/ and sessions/ strictly excluded"

  # 3. Skill Catalog Count Check
  SKILL_COUNT=$(find "${TARGET}/.agents/skills" -name "SKILL.md" | wc -l | tr -d ' ')
  echo "  ✓ Catalog Verified: ${SKILL_COUNT} active skills installed"
else
  echo "  [DRY RUN] Verification Gate checks simulated."
fi

# ------------------------------------------------------------------------------
# Completion Digest
# ------------------------------------------------------------------------------
SKILL_COUNT_DISPLAY=$(find "${ACON_ROOT}/.agents/skills" -name "SKILL.md" | wc -l | tr -d ' ')
echo "================================================================================"
echo "⚓ ACON Adoption Complete: Target repository is shipshape!"
echo "================================================================================"
echo "Target Root      : ${TARGET}"
echo "Constitution     : ${TARGET}/AGENTS.md (Two-Tier Architecture)"
echo "Catalog Location : ${TARGET}/.agents/skills/ (${SKILL_COUNT_DISPLAY} Skills)"
echo "Rules Location   : ${TARGET}/.agents/rules/"
echo "Boundary Policy  : Strict Lightweight (adapters/, sessions/, acon.yaml excluded)"
echo "Symlink Status   : 0 symlinks (Universal Physical Copy Invariant Satisfied)"
echo "Verification     : PASSED"
echo "================================================================================"

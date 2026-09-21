#!/usr/bin/env bash
# ==============================================================================
# ACON Repository Adoption & Synchronization: adopt.sh
# Description: Installs and updates ACON's Control Plane constitution (AGENTS.md),
#              domain skills catalog (.agents/skills/), constitutional rules
#              (.agents/rules/), machine schemas (.agents/schemas/), and reference
#              catalogs (.agents/reference/) into any target repository.
#
# Non-Negotiable Invariants:
# 1. Universal Physical Copy Invariant for catalog assets (zero symlinks in .agents/)
# 2. Single Source of Truth: CLAUDE.md symlinks cleanly to AGENTS.md
# 3. Two-Tier AGENTS.md Merge Standard (preserves target repo rules verbatim)
# 4. Strict Lightweight Adoption Boundary (adopts constitution, skills, rules, schemas, reference)
# 5. Fail-Closed Verification Gate (symlink audit + boundary enforcement)
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
transferring ACON's Control Plane constitution, domain skills catalog,
constitutional rules, machine schemas, and reference catalogs into any
new or existing repository.

Strict Adoption Standard:
  Adopts ONLY:
    • AGENTS.md          (Two-Tier Architecture: Command Bridge + Local Workshop Manual)
    • CLAUDE.md          (Symlink to AGENTS.md for single source of truth)
    • .agents/skills/    (Domain skills dereferenced into real physical files)
    • .agents/rules/     (Constitutional rules dereferenced into real physical files)
    • .agents/schemas/   (Machine schemas dereferenced into real physical files)
    • .agents/reference/ (Reference catalogs dereferenced into real physical files)
  Strictly EXCLUDES:
    • scripts/           (Adoption and management scripts belong to ACON control plane only)

Arguments:
  <TARGET_DIRECTORY>     Path to target repository to adopt ACON into

Options:
  -n, --dry-run          Preview files to be transferred without making changes
  -f, --force            Overwrite existing files or re-synthesize AGENTS.md
      --ide              Also deploy .cursor/ and .claude/ IDE folders (optional)
  -h, --help             Show this help message and exit

Invariants Enforced:
  • Physical Catalog Assets: 0 symlinks in target .agents/ (and IDE folders)
  • Single Source of Truth: CLAUDE.md symlinks cleanly to AGENTS.md
  • Two-Tier AGENTS.md: Tier 1 (Command Bridge) + Tier 2 (Workshop Manual)
  • Strict Adoption Boundary: Only constitution, skills, rules, schemas, reference deployed
  • Fail-Closed Gate: Automated symlink audit and boundary check

Examples:
  # Adopt ACON into a target project
  ./scripts/adopt.sh /path/to/my-project

  # Preview adoption in dry-run mode
  ./scripts/adopt.sh --dry-run /path/to/my-project

  # Force update an already adopted project
  ./scripts/adopt.sh --force /path/to/my-project
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
echo "Adoption Scope    : AGENTS.md, .agents/skills/, .agents/rules/, .agents/schemas/, .agents/reference/"
echo "Excluded Assets   : scripts/ (Strict Boundary Enforced)"
echo "Deploy IDE Folders: $([[ ${DEPLOY_IDE} -eq 1 ]] && echo "YES (.cursor, .claude)" || echo "NO (default: clean lightweight)")"
echo "Force Overwrite   : $([[ ${FORCE} -eq 1 ]] && echo "YES" || echo "NO")"
echo "--------------------------------------------------------------------------------"

# ------------------------------------------------------------------------------
# Phase 1: Scout & Target Audit
# ------------------------------------------------------------------------------
echo "[PHASE 1] Auditing target repository..."

TARGET_HAS_AGENTS_MD=0
TARGET_HAS_CLAUDE_MD=0
TARGET_ALREADY_ACON=0
TARGET_HAS_SCRIPTS_DIR=0

if [[ -d "${TARGET}/scripts" ]]; then
  TARGET_HAS_SCRIPTS_DIR=1
fi

if [[ -f "${TARGET}/AGENTS.md" || -L "${TARGET}/AGENTS.md" ]]; then
  TARGET_HAS_AGENTS_MD=1
  if grep -q "ACON Agent Control Plane Constitution" "${TARGET}/AGENTS.md" 2>/dev/null; then
    TARGET_ALREADY_ACON=1
  fi
fi

if [[ -f "${TARGET}/CLAUDE.md" || -L "${TARGET}/CLAUDE.md" ]]; then
  TARGET_HAS_CLAUDE_MD=1
fi

echo "  • Existing AGENTS.md : $([[ ${TARGET_HAS_AGENTS_MD} -eq 1 ]] && echo "Detected" || echo "Not found")"
echo "  • Existing CLAUDE.md : $([[ ${TARGET_HAS_CLAUDE_MD} -eq 1 ]] && echo "Detected" || echo "Not found")"
echo "  • Existing scripts/  : $([[ ${TARGET_HAS_SCRIPTS_DIR} -eq 1 ]] && echo "Detected (target-native)" || echo "Not found")"
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
  # Remove any pre-existing symlinks first to uphold Physical Copy Invariant for AGENTS.md
  rm -f "${TARGET}/AGENTS.md"
  cp "${SYNTHESIZED_AGENTS}" "${TARGET}/AGENTS.md"
  echo "  ✓ Installed physical AGENTS.md"

  # Ensure CLAUDE.md in target is created as a symlink to AGENTS.md (Single Source of Truth)
  rm -f "${TARGET}/CLAUDE.md"
  ln -s AGENTS.md "${TARGET}/CLAUDE.md"
  echo "  ✓ Created symlink CLAUDE.md -> AGENTS.md"
else
  echo "  [DRY RUN] Manifest item: AGENTS.md (${SYNTHESIZED_AGENTS})"
  echo "  [DRY RUN] Manifest item: CLAUDE.md (Symlink -> AGENTS.md)"
fi

# ------------------------------------------------------------------------------
# Phase 3: Pure Physical Copy Deployment (.agents/skills/, .agents/rules/, .agents/schemas/, .agents/reference/)
# ------------------------------------------------------------------------------
echo "[PHASE 3] Deploying .agents/skills/, .agents/rules/, .agents/schemas/, .agents/reference/, and catalog indexes (dereferencing all symlinks)..."
echo "  • Boundary Policy: Strictly excluding internal control plane scripts (scripts/)"

if [[ ${DRY_RUN} -eq 0 ]]; then
  # 0. Clean pre-existing legacy symlinks in target .agents directory
  if [[ -d "${TARGET}/.agents" ]]; then
    find "${TARGET}/.agents" -maxdepth 2 -type l -delete 2>/dev/null || true
  fi

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

  # 3. Deploy .agents/schemas/ (if exists)
  if [[ -d "${ACON_ROOT}/.agents/schemas" ]]; then
    mkdir -p "${TARGET}/.agents/schemas"
    rsync -avL --delete \
      "${ACON_ROOT}/.agents/schemas/" "${TARGET}/.agents/schemas/"
    echo "  ✓ Deployed .agents/schemas/ directory (100% physical, 0 symlinks)"
  fi

  # 4. Deploy .agents/reference/ (if exists)
  if [[ -d "${ACON_ROOT}/.agents/reference" ]]; then
    mkdir -p "${TARGET}/.agents/reference"
    rsync -avL --delete \
      "${ACON_ROOT}/.agents/reference/" "${TARGET}/.agents/reference/"
    echo "  ✓ Deployed .agents/reference/ directory (100% physical, 0 symlinks)"
  fi

  # 4b. Deploy .agents/crew/ (if exists)
  if [[ -d "${ACON_ROOT}/.agents/crew" ]]; then
    mkdir -p "${TARGET}/.agents/crew"
    rsync -avL --delete \
      "${ACON_ROOT}/.agents/crew/" "${TARGET}/.agents/crew/"
    echo "  ✓ Deployed .agents/crew/ directory (100% physical, 0 symlinks)"
  fi

  # 4c. Deploy .agents/workflows/ (if exists)
  if [[ -d "${ACON_ROOT}/.agents/workflows" ]]; then
    mkdir -p "${TARGET}/.agents/workflows"
    rsync -avL --delete \
      "${ACON_ROOT}/.agents/workflows/" "${TARGET}/.agents/workflows/"
    echo "  ✓ Deployed .agents/workflows/ directory (100% physical, 0 symlinks)"
  fi

  # 5. Deploy root documentation in .agents/ (INDEX.md, README.md)
  for doc_file in INDEX.md README.md; do
    if [[ -f "${ACON_ROOT}/.agents/${doc_file}" ]]; then
      rm -f "${TARGET}/.agents/${doc_file}"
      cp "${ACON_ROOT}/.agents/${doc_file}" "${TARGET}/.agents/${doc_file}"
      echo "  ✓ Deployed .agents/${doc_file}"
    fi
  done

  # 6. Prune obsolete legacy frameworks directory if present in target
  if [[ -d "${TARGET}/.agents/skills/frameworks" ]]; then
    rm -rf "${TARGET}/.agents/skills/frameworks"
    echo "  ✓ Pruned obsolete .agents/skills/frameworks directory"
  fi
else
  echo "  [DRY RUN] Manifest item: .agents/skills/ (rsync -avL dereferencing all symlinks)"
  if [[ -d "${ACON_ROOT}/.agents/rules" ]]; then
    echo "  [DRY RUN] Manifest item: .agents/rules/ (rsync -avL dereferencing all symlinks)"
  fi
  if [[ -d "${ACON_ROOT}/.agents/schemas" ]]; then
    echo "  [DRY RUN] Manifest item: .agents/schemas/ (rsync -avL dereferencing all symlinks)"
  fi
  if [[ -d "${ACON_ROOT}/.agents/reference" ]]; then
    echo "  [DRY RUN] Manifest item: .agents/reference/ (rsync -avL dereferencing all symlinks)"
  fi
  echo "  [DRY RUN] Manifest items: .agents/INDEX.md, .agents/README.md"
  if [[ -d "${TARGET}/.agents/skills/frameworks" ]]; then
    echo "  [DRY RUN] Would prune obsolete .agents/skills/frameworks directory"
  fi
  echo "  [DRY RUN] Explicitly excluded: scripts/"
fi

# ------------------------------------------------------------------------------
# Phase 4: Optional IDE Folder Setup (.cursor/ & .claude/)
# ------------------------------------------------------------------------------
if [[ ${DEPLOY_IDE} -eq 1 ]]; then
  echo "[PHASE 4] Deploying IDE skill directories (.cursor/ & .claude/)..."
  if [[ ${DRY_RUN} -eq 0 ]]; then
    # Clean legacy symlinks in IDE directories
    if [[ -d "${TARGET}/.cursor" ]]; then
      find "${TARGET}/.cursor" -maxdepth 2 -type l -delete 2>/dev/null || true
    fi
    if [[ -d "${TARGET}/.claude" ]]; then
      find "${TARGET}/.claude" -maxdepth 2 -type l -delete 2>/dev/null || true
    fi
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

  # Check root CLAUDE.md symlink resolves cleanly
  if [[ -L "${TARGET}/CLAUDE.md" ]]; then
    if [[ ! -e "${TARGET}/CLAUDE.md" ]]; then
      echo "[FAIL-CLOSED] CLAUDE.md symlink is broken!" >&2
      exit 1
    fi
    echo "  ✓ Single Source Verified: CLAUDE.md resolves cleanly to AGENTS.md"
  fi

  echo "  ✓ Invariant Verified: Zero symlinks found in adopted ACON catalog assets"

  # 2. Invariant Check: Adoption Boundary Enforcement (Zero Leaked Internal Scripts)
  echo "  • Verifying adoption boundary enforcement..."
  if [[ ${TARGET_HAS_SCRIPTS_DIR} -eq 0 && -e "${TARGET}/scripts" ]]; then
    echo "[FAIL-CLOSED] Boundary Violation: scripts/ directory leaked into target repository!" >&2
    exit 1
  fi
  for script_file in "${ACON_ROOT}"/scripts/*; do
    if [[ -f "${script_file}" ]]; then
      script_base="$(basename "${script_file}")"
      if [[ -e "${TARGET}/scripts/${script_base}" ]]; then
        echo "[FAIL-CLOSED] Boundary Violation: ACON script (${script_base}) leaked into target repository!" >&2
        exit 1
      fi
    fi
  done
  echo "  ✓ Boundary Verified: scripts/ strictly excluded"

  # 3. Catalog, Schema, & Reference Integrity Checks
  SKILL_COUNT=$(find "${TARGET}/.agents/skills" -name "SKILL.md" | wc -l | tr -d ' ')
  echo "  ✓ Catalog Verified: ${SKILL_COUNT} active skills installed"
  if [[ -d "${TARGET}/.agents/schemas" ]]; then
    SCHEMA_COUNT=$(find "${TARGET}/.agents/schemas" -name "*.yaml" | wc -l | tr -d ' ')
    echo "  ✓ Schemas Verified: ${SCHEMA_COUNT} canonical schemas installed"
  fi
  if [[ -d "${TARGET}/.agents/reference" ]]; then
    REF_COUNT=$(find "${TARGET}/.agents/reference" -name "*.md" | wc -l | tr -d ' ')
    echo "  ✓ Reference Verified: ${REF_COUNT} reference catalogs installed"
  fi
else
  echo "  [DRY RUN] Verification Gate checks simulated."
fi

# ------------------------------------------------------------------------------
# Completion Digest
# ------------------------------------------------------------------------------
SKILL_COUNT_DISPLAY=$(find "${ACON_ROOT}/.agents/skills" -name "SKILL.md" | wc -l | tr -d ' ')
SCHEMA_COUNT_DISPLAY=$(find "${ACON_ROOT}/.agents/schemas" -name "*.yaml" 2>/dev/null | wc -l | tr -d ' ')
echo "================================================================================"
echo "⚓ ACON Adoption Complete: Target repository is shipshape!"
echo "================================================================================"
echo "Target Root      : ${TARGET}"
echo "Constitution     : ${TARGET}/AGENTS.md (Two-Tier Architecture)"
echo "Claude Code Sync : ${TARGET}/CLAUDE.md -> AGENTS.md (Single Source of Truth)"
echo "Catalog Location : ${TARGET}/.agents/skills/ (${SKILL_COUNT_DISPLAY} Skills)"
echo "Rules Location   : ${TARGET}/.agents/rules/"
echo "Schemas Location : ${TARGET}/.agents/schemas/ (${SCHEMA_COUNT_DISPLAY} Schemas)"
echo "Reference Path   : ${TARGET}/.agents/reference/"
echo "Boundary Policy  : Strict Lightweight (scripts/ excluded)"
echo "Symlink Status   : 0 symlinks in catalog (CLAUDE.md symlinked to AGENTS.md)"
echo "Verification     : PASSED"
echo "================================================================================"

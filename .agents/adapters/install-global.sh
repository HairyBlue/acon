#!/usr/bin/env bash
# ==============================================================================
# ACON Universal Global Installer: install-global.sh
# Description: Establishes ACON as a machine-wide agent distro across ANY AI CLI
#              (Antigravity 'agy', Claude Code 'claude', Cursor, and future CLIs).
#
# Architecture: Universal Hub-and-Spoke Distro
# 1. Master Hub (~/.acon/):
#    Canonical home containing acon.yaml, skills/, rules/, and adapters/
# 2. Spokes (Multi-CLI Auto-Detection & Provisioning):
#    - Antigravity CLI : ~/.gemini/config/ (skills, rules, acon.yaml, adapters)
#    - Claude Code CLI : ~/.claude/        (skills, rules, CLAUDE.md)
#    - Cursor IDE      : ~/.cursor/        (skills, rules)
#    - Custom Targets  : User-defined directory
# 3. Universal Binary (~/.local/bin/acon):
#    Lightweight CLI for 'status', 'sync', 'dispatch', and 'adopt'
# ==============================================================================
set -euo pipefail
IFS=$'\n\t'

# Directory & Path Resolution
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ACON_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# CLI Options & Defaults
HUB_DIR="${ACON_HUB_DIR:-${HOME}/.acon}"
BIN_DIR="${ACON_BIN_DIR:-${HOME}/.local/bin}"
MODE="link" # link (symlinks from spokes to hub) or copy (physical copies)
DRY_RUN=0
FORCE=0
RUN_ALL=0
RUN_DETECT=0
TARGETS=()
CUSTOM_TARGET_DIR=""

# ------------------------------------------------------------------------------
# Usage & Help
# ------------------------------------------------------------------------------
usage() {
  local exit_code="${1:-1}"
  cat <<'USAGE_EOF' >&2
Usage: install-global.sh [OPTIONS]

Universal global installer establishing ACON as a machine-wide agent distro
across any AI CLI (Antigravity 'agy', Claude Code 'claude', Cursor, and custom).

Options:
  -d, --detect           Auto-detect active CLIs on this machine (default behavior)
  -a, --all              Provision all supported AI CLIs (agy, claude, cursor)
  -t, --target <name>    Provision specific target: agy, claude, cursor, custom
                         (can be specified multiple times)
      --target-dir <dir> Target directory when using --target custom
  -m, --mode <mode>      Provisioning mode: 'link' (default, spoke symlinks to hub)
                         or 'copy' (pure physical file copies)
  -n, --dry-run          Preview hub setup and spoke provisioning without modifying files
  -f, --force            Overwrite existing configurations/links without confirmation
      --hub-dir <dir>    Custom master hub directory (default: ~/.acon)
      --bin-dir <dir>    Custom binary installation directory (default: ~/.local/bin)
  -h, --help             Show this help message and exit

Architecture:
  • Master Hub (~/.acon):
    Canonical home for acon.yaml, skills/ (114 skills), rules/, and adapters/
  • Spokes:
    - Antigravity (agy) : ~/.gemini/config/ (skills, rules, acon.yaml, adapters)
    - Claude Code       : ~/.claude/        (skills, rules, CLAUDE.md)
    - Cursor IDE        : ~/.cursor/        (skills, rules)
  • Universal Executable (~/.local/bin/acon):
    - 'acon status'   : Check machine-wide installation health
    - 'acon sync'     : Refresh master hub & spokes from repo
    - 'acon dispatch' : Run cross-harness task dispatcher

Examples:
  # Auto-detect and provision active CLIs
  ./install-global.sh --detect

  # Preview provisioning plan for all supported CLIs
  ./install-global.sh --dry-run --all

  # Provision specific CLI targets
  ./install-global.sh --target agy --target claude

  # Provision using physical copies instead of symlinks
  ./install-global.sh --mode copy --all
USAGE_EOF
  exit "${exit_code}"
}

# ------------------------------------------------------------------------------
# Argument Parsing
# ------------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    -d|--detect)
      RUN_DETECT=1
      shift
      ;;
    -a|--all)
      RUN_ALL=1
      shift
      ;;
    -t|--target)
      if [[ -z "${2:-}" ]]; then
        echo "[ERROR] Missing argument for --target" >&2
        usage
      fi
      TARGETS+=("$2")
      shift 2
      ;;
    --target-dir)
      if [[ -z "${2:-}" ]]; then
        echo "[ERROR] Missing argument for --target-dir" >&2
        usage
      fi
      CUSTOM_TARGET_DIR="$2"
      shift 2
      ;;
    -m|--mode)
      if [[ -z "${2:-}" ]]; then
        echo "[ERROR] Missing argument for --mode" >&2
        usage
      fi
      if [[ "$2" != "link" && "$2" != "copy" ]]; then
        echo "[ERROR] Invalid --mode '$2'. Must be 'link' or 'copy'." >&2
        exit 1
      fi
      MODE="$2"
      shift 2
      ;;
    -n|--dry-run)
      DRY_RUN=1
      shift
      ;;
    -f|--force)
      FORCE=1
      shift
      ;;
    --hub-dir)
      if [[ -z "${2:-}" ]]; then
        echo "[ERROR] Missing argument for --hub-dir" >&2
        usage
      fi
      HUB_DIR="$2"
      shift 2
      ;;
    --bin-dir)
      if [[ -z "${2:-}" ]]; then
        echo "[ERROR] Missing argument for --bin-dir" >&2
        usage
      fi
      BIN_DIR="$2"
      shift 2
      ;;
    -h|--help)
      usage 0
      ;;
    *)
      echo "[ERROR] Unknown option: $1" >&2
      usage
      ;;
  esac
done

# ------------------------------------------------------------------------------
# Target Resolution & Auto-Detection
# ------------------------------------------------------------------------------
DETECTED_AGY=0
DETECTED_CLAUDE=0
DETECTED_CURSOR=0

# Detection probes
if command -v agy >/dev/null 2>&1 || [[ -d "${HOME}/.gemini" ]] || [[ -d "${HOME}/.gemini/config" ]]; then
  DETECTED_AGY=1
fi

if command -v claude >/dev/null 2>&1 || [[ -d "${HOME}/.claude" ]]; then
  DETECTED_CLAUDE=1
fi

if command -v cursor >/dev/null 2>&1 || [[ -d "${HOME}/.cursor" ]] || [[ -d "${HOME}/.cursor-server" ]] || [[ -d "${HOME}/.config/Cursor" ]]; then
  DETECTED_CURSOR=1
fi

# Determine active target list
if [[ ${RUN_ALL} -eq 1 ]]; then
  TARGETS=("agy" "claude" "cursor")
elif [[ ${#TARGETS[@]} -eq 0 || ${RUN_DETECT} -eq 1 ]]; then
  TARGETS=()
  if [[ ${DETECTED_AGY} -eq 1 ]]; then
    TARGETS+=("agy")
  fi
  if [[ ${DETECTED_CLAUDE} -eq 1 ]]; then
    TARGETS+=("claude")
  fi
  if [[ ${DETECTED_CURSOR} -eq 1 ]]; then
    TARGETS+=("cursor")
  fi

  # Fallback if no specific CLI environment was detected
  if [[ ${#TARGETS[@]} -eq 0 ]]; then
    TARGETS+=("agy")
  fi
fi

# Validate Custom Target
for t in "${TARGETS[@]}"; do
  if [[ "$t" == "custom" && -z "${CUSTOM_TARGET_DIR}" ]]; then
    echo "[ERROR] --target custom was requested but --target-dir was not specified." >&2
    exit 1
  fi
done

# Validate Source Repository
if [[ ! -f "${ACON_ROOT}/acon.yaml" || ! -d "${ACON_ROOT}/.agents/skills" ]]; then
  echo "[ERROR] Cannot locate valid ACON source files at ${ACON_ROOT}" >&2
  exit 1
fi

join_by() { local d=${1-} f=${2-}; if shift 2; then printf %s "$f" "${@/#/$d}"; else printf %s "$f"; fi; }
TARGETS_DISPLAY="$(join_by ", " "${TARGETS[@]}")"

echo "================================================================================"
echo "ACON Universal Machine-Wide Distro Installer"
echo "================================================================================"
echo "Source Repository : ${ACON_ROOT}"
echo "Master Hub Target : ${HUB_DIR}"
echo "Universal Binary  : ${BIN_DIR}/acon"
echo "Provisioning Mode : ${MODE} (spokes $([[ "${MODE}" == "link" ]] && echo "symlink to hub" || echo "physically copy from hub"))"
echo "Dry Run Mode      : $([[ ${DRY_RUN} -eq 1 ]] && echo "YES (preview only)" || echo "NO (live provisioning)")"
echo "Target Selection  : $([[ ${RUN_ALL} -eq 1 ]] && echo "ALL SUPPORTED" || ([[ ${RUN_DETECT} -eq 1 ]] && echo "AUTO-DETECT" || echo "EXPLICIT"))"
echo "Selected Spokes   : ${TARGETS_DISPLAY}"
echo "--------------------------------------------------------------------------------"
echo "Probed Environments on Host:"
echo "  • Antigravity CLI (agy) : $([[ ${DETECTED_AGY} -eq 1 ]] && echo "Detected ($(command -v agy 2>/dev/null || echo "~/.gemini/config present"))" || echo "Not detected")"
echo "  • Claude Code (claude)  : $([[ ${DETECTED_CLAUDE} -eq 1 ]] && echo "Detected ($(command -v claude 2>/dev/null || echo "~/.claude present"))" || echo "Not detected")"
echo "  • Cursor IDE (cursor)   : $([[ ${DETECTED_CURSOR} -eq 1 ]] && echo "Detected ($(command -v cursor 2>/dev/null || echo "~/.cursor present"))" || echo "Not detected")"
echo "--------------------------------------------------------------------------------"

# ------------------------------------------------------------------------------
# Phase 1: Master Hub Provisioning (~/.acon)
# ------------------------------------------------------------------------------
echo "[PHASE 1] Provisioning Master Hub (${HUB_DIR})..."

if [[ ${DRY_RUN} -eq 0 ]]; then
  mkdir -p "${HUB_DIR}/skills" "${HUB_DIR}/rules" "${HUB_DIR}/adapters"

  # Dereference copies to guarantee Master Hub is 100% self-contained
  rsync -avL --delete "${ACON_ROOT}/.agents/skills/" "${HUB_DIR}/skills/"
  rsync -avL --delete "${ACON_ROOT}/.agents/rules/" "${HUB_DIR}/rules/"
  rsync -avL --delete \
    --exclude='bridge/task_*' \
    --exclude='bridge/result_*' \
    "${ACON_ROOT}/.agents/adapters/" "${HUB_DIR}/adapters/"

  cp "${ACON_ROOT}/acon.yaml" "${HUB_DIR}/acon.yaml"
  if [[ -f "${ACON_ROOT}/AGENTS.md" ]]; then
    cp "${ACON_ROOT}/AGENTS.md" "${HUB_DIR}/AGENTS.md"
  fi

  chmod +x "${HUB_DIR}/adapters/"*.sh 2>/dev/null || true
  if [[ -f "${HUB_DIR}/adapters/api-runner.py" ]]; then
    chmod +x "${HUB_DIR}/adapters/api-runner.py"
  fi
  if [[ -f "${HUB_DIR}/adapters/acon" ]]; then
    chmod +x "${HUB_DIR}/adapters/acon"
  fi

  echo "${ACON_ROOT}" > "${HUB_DIR}/.source_repo"
  echo "  ✓ Master Hub installed at ${HUB_DIR}"
else
  echo "  [DRY RUN] Would create ${HUB_DIR} and copy skills/, rules/, adapters/, acon.yaml, AGENTS.md"
fi

# ------------------------------------------------------------------------------
# Phase 2: Spoke Provisioning
# ------------------------------------------------------------------------------
echo "[PHASE 2] Provisioning Multi-CLI Spokes..."

for target in "${TARGETS[@]}"; do
  case "${target}" in
    agy)
      SPOKE_DIR="${HOME}/.gemini/config"
      echo "  • Provisioning Spoke: Antigravity CLI (${SPOKE_DIR})..."
      if [[ ${DRY_RUN} -eq 0 ]]; then
        mkdir -p "${SPOKE_DIR}/skills"

        # Provision skill categories while preserving existing GCP/user skills
        for cat_path in "${HUB_DIR}/skills"/*; do
          if [[ -d "${cat_path}" ]]; then
            cat_name="$(basename "${cat_path}")"
            if [[ "${MODE}" == "link" ]]; then
              ln -sfn "${cat_path}" "${SPOKE_DIR}/skills/${cat_name}"
            else
              rsync -avL "${cat_path}/" "${SPOKE_DIR}/skills/${cat_name}/"
            fi
          fi
        done

        # Provision rules
        if [[ ! -d "${SPOKE_DIR}/rules" || -L "${SPOKE_DIR}/rules" ]]; then
          if [[ "${MODE}" == "link" ]]; then
            ln -sfn "${HUB_DIR}/rules" "${SPOKE_DIR}/rules"
          else
            mkdir -p "${SPOKE_DIR}/rules"
            rsync -avL "${HUB_DIR}/rules/" "${SPOKE_DIR}/rules/"
          fi
        else
          # Existing directory: provision individual rule files
          for rule_path in "${HUB_DIR}/rules"/*.md; do
            if [[ -f "${rule_path}" ]]; then
              rule_file="$(basename "${rule_path}")"
              if [[ "${MODE}" == "link" ]]; then
                ln -sfn "${rule_path}" "${SPOKE_DIR}/rules/${rule_file}"
              else
                cp "${rule_path}" "${SPOKE_DIR}/rules/${rule_file}"
              fi
            fi
          done
        fi

        # Provision acon.yaml
        if [[ "${MODE}" == "link" ]]; then
          ln -sfn "${HUB_DIR}/acon.yaml" "${SPOKE_DIR}/acon.yaml"
        else
          cp "${HUB_DIR}/acon.yaml" "${SPOKE_DIR}/acon.yaml"
        fi

        # Provision adapters
        if [[ "${MODE}" == "link" ]]; then
          ln -sfn "${HUB_DIR}/adapters" "${SPOKE_DIR}/adapters"
        else
          mkdir -p "${SPOKE_DIR}/adapters"
          rsync -avL "${HUB_DIR}/adapters/" "${SPOKE_DIR}/adapters/"
          chmod +x "${SPOKE_DIR}/adapters/"*.sh 2>/dev/null || true
        fi

        echo "    ✓ Antigravity Spoke provisioned (skills, rules, acon.yaml, adapters)"
      else
        echo "    [DRY RUN] Would provision ${SPOKE_DIR} (skills categories, rules, acon.yaml, adapters via ${MODE})"
      fi
      ;;

    claude)
      SPOKE_DIR="${HOME}/.claude"
      echo "  • Provisioning Spoke: Claude Code CLI (${SPOKE_DIR})..."
      if [[ ${DRY_RUN} -eq 0 ]]; then
        mkdir -p "${SPOKE_DIR}"

        # Provision skills
        if [[ ! -d "${SPOKE_DIR}/skills" || -L "${SPOKE_DIR}/skills" ]]; then
          if [[ "${MODE}" == "link" ]]; then
            ln -sfn "${HUB_DIR}/skills" "${SPOKE_DIR}/skills"
          else
            mkdir -p "${SPOKE_DIR}/skills"
            rsync -avL "${HUB_DIR}/skills/" "${SPOKE_DIR}/skills/"
          fi
        else
          for cat_path in "${HUB_DIR}/skills"/*; do
            if [[ -d "${cat_path}" ]]; then
              cat_name="$(basename "${cat_path}")"
              if [[ "${MODE}" == "link" ]]; then
                ln -sfn "${cat_path}" "${SPOKE_DIR}/skills/${cat_name}"
              else
                rsync -avL "${cat_path}/" "${SPOKE_DIR}/skills/${cat_name}/"
              fi
            fi
          done
        fi

        # Provision rules
        if [[ ! -d "${SPOKE_DIR}/rules" || -L "${SPOKE_DIR}/rules" ]]; then
          if [[ "${MODE}" == "link" ]]; then
            ln -sfn "${HUB_DIR}/rules" "${SPOKE_DIR}/rules"
          else
            mkdir -p "${SPOKE_DIR}/rules"
            rsync -avL "${HUB_DIR}/rules/" "${SPOKE_DIR}/rules/"
          fi
        else
          for rule_path in "${HUB_DIR}/rules"/*.md; do
            if [[ -f "${rule_path}" ]]; then
              rule_file="$(basename "${rule_path}")"
              if [[ "${MODE}" == "link" ]]; then
                ln -sfn "${rule_path}" "${SPOKE_DIR}/rules/${rule_file}"
              else
                cp "${rule_path}" "${SPOKE_DIR}/rules/${rule_file}"
              fi
            fi
          done
        fi

        # Provision CLAUDE.md
        if [[ -f "${HUB_DIR}/AGENTS.md" ]]; then
          if [[ "${MODE}" == "link" ]]; then
            ln -sfn "${HUB_DIR}/AGENTS.md" "${SPOKE_DIR}/CLAUDE.md"
          else
            cp "${HUB_DIR}/AGENTS.md" "${SPOKE_DIR}/CLAUDE.md"
          fi
        fi

        echo "    ✓ Claude Code Spoke provisioned (skills, rules, CLAUDE.md)"
      else
        echo "    [DRY RUN] Would provision ${SPOKE_DIR} (skills, rules, CLAUDE.md via ${MODE})"
      fi
      ;;

    cursor)
      SPOKE_DIR="${HOME}/.cursor"
      echo "  • Provisioning Spoke: Cursor IDE (${SPOKE_DIR})..."
      if [[ ${DRY_RUN} -eq 0 ]]; then
        mkdir -p "${SPOKE_DIR}"

        # Provision skills
        if [[ ! -d "${SPOKE_DIR}/skills" || -L "${SPOKE_DIR}/skills" ]]; then
          if [[ "${MODE}" == "link" ]]; then
            ln -sfn "${HUB_DIR}/skills" "${SPOKE_DIR}/skills"
          else
            mkdir -p "${SPOKE_DIR}/skills"
            rsync -avL "${HUB_DIR}/skills/" "${SPOKE_DIR}/skills/"
          fi
        else
          for cat_path in "${HUB_DIR}/skills"/*; do
            if [[ -d "${cat_path}" ]]; then
              cat_name="$(basename "${cat_path}")"
              if [[ "${MODE}" == "link" ]]; then
                ln -sfn "${cat_path}" "${SPOKE_DIR}/skills/${cat_name}"
              else
                rsync -avL "${cat_path}/" "${SPOKE_DIR}/skills/${cat_name}/"
              fi
            fi
          done
        fi

        # Provision rules
        if [[ ! -d "${SPOKE_DIR}/rules" || -L "${SPOKE_DIR}/rules" ]]; then
          if [[ "${MODE}" == "link" ]]; then
            ln -sfn "${HUB_DIR}/rules" "${SPOKE_DIR}/rules"
          else
            mkdir -p "${SPOKE_DIR}/rules"
            rsync -avL "${HUB_DIR}/rules/" "${SPOKE_DIR}/rules/"
          fi
        else
          for rule_path in "${HUB_DIR}/rules"/*.md; do
            if [[ -f "${rule_path}" ]]; then
              rule_file="$(basename "${rule_path}")"
              if [[ "${MODE}" == "link" ]]; then
                ln -sfn "${rule_path}" "${SPOKE_DIR}/rules/${rule_file}"
              else
                cp "${rule_path}" "${SPOKE_DIR}/rules/${rule_file}"
              fi
            fi
          done
        fi

        echo "    ✓ Cursor IDE Spoke provisioned (skills, rules)"
      else
        echo "    [DRY RUN] Would provision ${SPOKE_DIR} (skills, rules via ${MODE})"
      fi
      ;;

    custom)
      SPOKE_DIR="${CUSTOM_TARGET_DIR}"
      echo "  • Provisioning Spoke: Custom Directory (${SPOKE_DIR})..."
      if [[ ${DRY_RUN} -eq 0 ]]; then
        mkdir -p "${SPOKE_DIR}"
        if [[ "${MODE}" == "link" ]]; then
          ln -sfn "${HUB_DIR}/skills" "${SPOKE_DIR}/skills"
          ln -sfn "${HUB_DIR}/rules" "${SPOKE_DIR}/rules"
          ln -sfn "${HUB_DIR}/acon.yaml" "${SPOKE_DIR}/acon.yaml"
        else
          mkdir -p "${SPOKE_DIR}/skills" "${SPOKE_DIR}/rules"
          rsync -avL "${HUB_DIR}/skills/" "${SPOKE_DIR}/skills/"
          rsync -avL "${HUB_DIR}/rules/" "${SPOKE_DIR}/rules/"
          cp "${HUB_DIR}/acon.yaml" "${SPOKE_DIR}/acon.yaml"
        fi
        echo "    ✓ Custom Spoke provisioned at ${SPOKE_DIR}"
      else
        echo "    [DRY RUN] Would provision custom spoke at ${SPOKE_DIR}"
      fi
      ;;
  esac
done

# ------------------------------------------------------------------------------
# Phase 3: Universal Executable Installation (~/.local/bin/acon)
# ------------------------------------------------------------------------------
echo "[PHASE 3] Installing Universal Executable (${BIN_DIR}/acon)..."

if [[ ${DRY_RUN} -eq 0 ]]; then
  mkdir -p "${BIN_DIR}"
  cp "${ACON_ROOT}/.agents/adapters/acon" "${BIN_DIR}/acon"
  chmod +x "${BIN_DIR}/acon"
  echo "  ✓ Universal executable installed at ${BIN_DIR}/acon"

  if [[ ":${PATH}:" != *":${BIN_DIR}:"* ]]; then
    echo "  [NOTICE] ${BIN_DIR} is not in your current PATH."
    echo "  Add this to your ~/.bashrc or ~/.zshrc:"
    echo "    export PATH=\"${BIN_DIR}:\$PATH\""
  else
    echo "  ✓ ${BIN_DIR} verified present in PATH"
  fi
else
  echo "  [DRY RUN] Would install ${BIN_DIR}/acon with executable permissions"
fi

# ------------------------------------------------------------------------------
# Phase 4: Fail-Closed Verification Gate
# ------------------------------------------------------------------------------
echo "[PHASE 4] Executing Verification Gate..."

if [[ ${DRY_RUN} -eq 0 ]]; then
  # 1. Broken Symlinks Audit
  echo "  • Auditing symlinks across Master Hub and all provisioned spokes..."
  BROKEN_COUNT=0
  AUDIT_DIRS=("${HUB_DIR}")

  for t in "${TARGETS[@]}"; do
    case "$t" in
      agy) AUDIT_DIRS+=("${HOME}/.gemini/config") ;;
      claude) AUDIT_DIRS+=("${HOME}/.claude") ;;
      cursor) AUDIT_DIRS+=("${HOME}/.cursor") ;;
      custom) AUDIT_DIRS+=("${CUSTOM_TARGET_DIR}") ;;
    esac
  done

  for audit_dir in "${AUDIT_DIRS[@]}"; do
    if [[ -d "${audit_dir}" ]]; then
      while IFS= read -r link; do
        if [[ -L "${link}" && ! -e "${link}" ]]; then
          echo "[FAIL-CLOSED] Broken symlink detected: ${link} -> $(readlink "${link}")" >&2
          BROKEN_COUNT=$((BROKEN_COUNT + 1))
        fi
      done < <(find "${audit_dir}" -type l 2>/dev/null || true)
    fi
  done

  # Also check binary symlink if applicable
  if [[ -L "${BIN_DIR}/acon" && ! -e "${BIN_DIR}/acon" ]]; then
    echo "[FAIL-CLOSED] Broken binary symlink detected: ${BIN_DIR}/acon" >&2
    BROKEN_COUNT=$((BROKEN_COUNT + 1))
  fi

  if [[ ${BROKEN_COUNT} -gt 0 ]]; then
    echo "[FAIL-CLOSED] Detected ${BROKEN_COUNT} broken symlinks. Installation aborted." >&2
    exit 1
  fi
  echo "  ✓ Symlink Audit: 0 broken symlinks across all provisioned targets"

  # 2. Harness Dispatch Runner Check
  echo "  • Verifying harness adapter dispatch runner in Master Hub..."
  if [[ -x "${HUB_DIR}/adapters/dispatch.sh" ]]; then
    DISPATCH_OUTPUT=$("${HUB_DIR}/adapters/dispatch.sh" --dry-run --task "verify" 2>&1)
    if [[ $? -ne 0 ]]; then
      echo "[FAIL-CLOSED] Master Hub dispatch.sh verification failed:" >&2
      echo "${DISPATCH_OUTPUT}" >&2
      exit 1
    fi
    echo "  ✓ Dispatch Runner: Dry-run check PASSED"
  else
    echo "[FAIL-CLOSED] ${HUB_DIR}/adapters/dispatch.sh is missing or not executable" >&2
    exit 1
  fi

  # 3. Universal Binary Smoke Test
  echo "  • Testing universal binary execution..."
  if [[ -x "${BIN_DIR}/acon" ]]; then
    ACON_HELP_OUT=$("${BIN_DIR}/acon" --version 2>&1)
    echo "  ✓ Universal Binary Smoke Test: ${ACON_HELP_OUT}"
  else
    echo "[FAIL-CLOSED] ${BIN_DIR}/acon is missing or not executable" >&2
    exit 1
  fi

  # 4. Catalog Count Check
  SKILL_COUNT=$(find "${HUB_DIR}/skills" -name "SKILL.md" | wc -l | tr -d ' ')
  RULE_COUNT=$(find "${HUB_DIR}/rules" -name "*.md" | wc -l | tr -d ' ')
  echo "  ✓ Distro Verified: ${SKILL_COUNT} skills and ${RULE_COUNT} rules active"
else
  echo "  [DRY RUN] Verification Gate checks simulated."
fi

# ------------------------------------------------------------------------------
# Completion Digest
# ------------------------------------------------------------------------------
echo "================================================================================"
echo "⚓ ACON Universal Machine-Wide Distro: Shipshape!"
echo "================================================================================"
echo "Master Hub       : ${HUB_DIR}"
echo "Universal Binary : ${BIN_DIR}/acon"
echo "Spokes Provisioned: ${TARGETS_DISPLAY}"
echo "Provisioning Mode: ${MODE}"
echo "Verification     : $([[ ${DRY_RUN} -eq 1 ]] && echo "SIMULATED (Dry-Run)" || echo "PASSED (100% Healthy)")"
echo "--------------------------------------------------------------------------------"
echo "Quick Start Commands:"
echo "  acon status       # Inspect distro and CLI health"
echo "  acon sync         # Refresh distro skills from source repository"
echo "  acon dispatch     # Run cross-harness dispatcher globally"
echo "  acon adopt <dir>  # Adopt ACON into a target project"
echo "================================================================================"

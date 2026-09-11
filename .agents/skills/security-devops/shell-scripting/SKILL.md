---
name: shell-scripting
description: Production-grade defensive Bash scripting conventions, strict-mode standards, safe cleanup traps, idempotent operations, robust CLI argument parsing with getopts, and stream separation. Use when writing, refactoring, or auditing shell scripts, automation hooks, or DevOps tooling.
license: MIT
metadata:
  version: "1.0.0"
  category: "security-devops"
  languages: ["bash", "sh"]
---

# Defensive Shell Scripting Standards

Production-grade conventions and best practices for writing secure, resilient, idempotent, and maintainable Bash scripts across multi-agent environments and CI/CD automation.

---

## 1. Strict Mode Header

Every Bash script MUST start with a standardized strict-mode preamble. Silent failures and lax evaluation lead to cascading errors, partial deployments, and catastrophic data loss.

### The Canonical Header

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
```

### Breakdown & Rationale

| Directive | Purpose | Hazard Prevented |
|-----------|---------|------------------|
| `#!/usr/bin/env bash` | Portable shebang using user's environment Bash | Avoids hardcoding `/bin/bash` which may be outdated or absent (e.g. macOS Homebrew, BSD, NixOS). |
| `set -e` (errexit) | Immediately exits if any command returns a non-zero status | Prevents script from continuing after a failed command (e.g. `cd /missing/dir && rm -rf *`). |
| `set -u` (nounset) | Treats unset/unbound variables and parameters as errors | Prevents catastrophic expansions like `rm -rf "$UNSET_VAR/*"` evaluating to `rm -rf /*`. |
| `set -o pipefail` | Pipeline return code reflects the rightmost failing command | By default, Bash returns the status of the *last* command in a pipe. `false | true` passes under `set -e` unless `pipefail` is active. |
| `IFS=$'\n\t'` | Restricts Internal Field Separator to newlines and tabs | Prevents unexpected word splitting on spaces when iterating over file paths or command outputs. |

### Handling Permissible Non-Zero Exits

When a command is expected to fail or return a non-zero exit code (e.g. `grep` finding zero matches), explicitly safeguard it:

```bash
# Allow non-zero return without triggering 'set -e'
grep "pattern" "$file" || true

# Or capture the exit code safely
if grep -q "pattern" "$file"; then
  echo "Found pattern" >&2
fi

# Checking diff status safely
diff -u file_a file_b >/dev/null 2>&1 || diff_status=$?
```

---

## 2. Defensive Variable & Path Quoting

Unquoted expansions are the primary vector for subtle bugs, globbing bugs, and command injection vulnerabilities in shell scripts.

### The Universal Rule: Always Double-Quote

```bash
# BAD: Word splitting and globbing hazards
rm -rf $TARGET_DIR/cache
cp -r $SOURCE $DEST
for file in $(ls $DIR); do ... done

# GOOD: Strict quoting on every parameter and substitution
rm -rf "${TARGET_DIR}/cache"
cp -r "${SOURCE}" "${DEST}"
```

### Quoting Patterns Reference

```bash
# 1. Scalar variables
"$var"
"${file_path}"

# 2. Arrays: Preserve whitespace within each element
"${my_array[@]}"

# 3. Positional arguments: Preserves individual arguments with whitespace
"$@"

# 4. Command substitutions
"$(command -v tool)"
"$(mktemp)"

# 5. Parameter fallbacks and assertions
"${CONFIG_PATH:-/etc/default/app.conf}"   # Fallback default if unset
"${DB_PASSWORD:?DB_PASSWORD must be set}" # Exits with error message if unset/empty
```

> [!CAUTION]
> **Never use `"$*"` or `${array[*]}`** unless you explicitly intend to join all elements into a single scalar string delimited by the first character of `IFS`. Always prefer `"$@"` and `"${array[@]}"`.

---

## 3. Guaranteed Cleanup & Signal Traps

Scripts that allocate temporary directories, start background processes, or acquire file locks MUST register an exit trap. Traps guarantee cleanup executes regardless of whether the script terminates normally, errors out (`set -e`), or receives an interrupt signal (`SIGINT`, `SIGTERM`).

### Complete Cleanup Trap Pattern

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# 1. Declare tracked resources
TMP_DIR=""
LOCK_FILE=""

# 2. Define the cleanup handler
cleanup() {
  local exit_code=$?
  trap - EXIT INT TERM HUP  # Prevent recursion

  # Clean up temporary directory
  if [[ -n "${TMP_DIR:-}" && -d "${TMP_DIR}" ]]; then
    rm -rf "${TMP_DIR}"
  fi

  # Release lock file
  if [[ -n "${LOCK_FILE:-}" && -f "${LOCK_FILE}" ]]; then
    rm -f "${LOCK_FILE}"
  fi

  # Terminate any remaining background jobs spawned by this script
  local running_jobs
  running_jobs="$(jobs -p)"
  if [[ -n "${running_jobs}" ]]; then
    # shellcheck disable=SC2086
    kill ${running_jobs} 2>/dev/null || true
  fi

  exit "${exit_code}"
}

# 3. Register the trap immediately before allocating resources
trap cleanup EXIT INT TERM HUP

# 4. Allocate resources safely
TMP_DIR="$(mktemp -d -t agent-task-XXXXXX)"
LOCK_FILE="/tmp/agent-task.lock"
touch "${LOCK_FILE}"
```

---

## 4. Idempotency & Re-Run Safety

Production scripts must be safe to execute multiple times against the same environment without accumulating state, producing duplicate records, or crashing.

### Key Idempotency Patterns

#### 1. Safe Directory Creation
```bash
# Always use -p to avoid errors if the directory already exists
mkdir -p "${TARGET_DIR}/logs"
```

#### 2. Command & Tool Pre-Flight Checks
```bash
require_cmd() {
  local cmd="$1"
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "Error: Required command '${cmd}' is not installed or not in PATH." >&2
    exit 1
  fi
}

require_cmd "git"
require_cmd "jq"
```

#### 3. Conditional File Creation & Symlinking
```bash
# Non-destructive file creation
if [[ ! -f "${CONFIG_FILE}" ]]; then
  cp "${CONFIG_TEMPLATE}" "${CONFIG_FILE}"
fi

# Idempotent symlink creation (-s: symbolic, -f: overwrite destination, -n: no-dereference directory)
ln -sfn "${SOURCE_PATH}" "${LINK_PATH}"
```

#### 4. Atomic File Writes
Avoid writing directly to destination files where partial writes from failures could corrupt configuration:

```bash
write_atomic() {
  local content="$1"
  local dest_file="$2"
  local tmp_file

  tmp_file="$(mktemp "${dest_file}.tmp.XXXXXX")"
  echo "${content}" > "${tmp_file}"
  chmod 0644 "${tmp_file}"
  mv -f "${tmp_file}" "${dest_file}"
}
```

---

## 5. Standardized CLI Option Parsing (`getopts`)

Avoid fragile manual argument shifting (`$1`, `$2`, `shift`). Use `getopts` for standardized, POSIX-compliant flag parsing with built-in validation.

### Standard `getopts` Implementation

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Defaults
VERBOSE=0
DRY_RUN=0
TARGET_ENV="staging"
OUTPUT_FILE=""

usage() {
  cat <<'USAGE_EOF' >&2
Usage: $(basename "$0") [OPTIONS] -o <file>

Options:
  -e <env>      Target environment (development, staging, production). Default: staging
  -o <file>     Output file path (required)
  -v            Enable verbose output
  -n            Dry run mode
  -h            Show this help message and exit

Examples:
  $(basename "$0") -e production -o /tmp/report.json
  $(basename "$0") -v -n -o output.log
USAGE_EOF
  exit 1
}

# Parse options
while getopts ":e:o:vnh" opt; do
  case "${opt}" in
    e)
      TARGET_ENV="${OPTARG}"
      ;;
    o)
      OUTPUT_FILE="${OPTARG}"
      ;;
    v)
      VERBOSE=1
      ;;
    n)
      DRY_RUN=1
      ;;
    h)
      usage
      ;;
    \?)
      echo "Error: Invalid option -${OPTARG}" >&2
      usage
      ;;
    :)
      echo "Error: Option -${OPTARG} requires an argument." >&2
      usage
      ;;
  esac
done
shift $((OPTIND - 1))

# Validation
if [[ -z "${OUTPUT_FILE}" ]]; then
  echo "Error: Missing required option -o <file>." >&2
  usage
fi
```

---

## 6. Stream Separation (Stdout vs. Stderr)

Respect the Unix Philosophy: **Standard Output (`stdout`) is strictly for data output and pipe consumption. Standard Error (`stderr`) is strictly for diagnostics, progress indicators, warnings, and error messages.**

### Stream Discipline Rules

1. Never emit status logs or progress messages to `stdout`. Doing so breaks downstream consumers (`jq`, `awk`, shell pipes).
2. Direct all diagnostic logs to `stderr` using `>&2` or `>&2 echo "..."`.
3. Use structured logging helpers.

```bash
# Structured Logging Helpers
log_info() {
  echo "[INFO]  $(date +'%Y-%m-%dT%H:%M:%S%z') - $*" >&2
}

log_warn() {
  echo "[WARN]  $(date +'%Y-%m-%dT%H:%M:%S%z') - $*" >&2
}

log_error() {
  echo "[ERROR] $(date +'%Y-%m-%dT%H:%M:%S%z') - $*" >&2
}

fatal() {
  log_error "$*"
  exit 1
}
```

### Pipeable Example

```bash
# Correct: Diagnostics go to stderr, clean JSON goes to stdout
fetch_data() {
  log_info "Connecting to upstream API..."
  local payload
  payload='{"status": "active", "code": 200}'
  
  # Only machine payload is written to stdout
  printf '%s\n' "${payload}"
}

# Consumer can reliably pipe output without stderr noise
fetch_data | jq -r '.status'
```

---

## 7. Script Security & Hygiene Checklist

Before committing any shell script or automation hook, verify:

- [ ] **Shebang**: `#!/usr/bin/env bash` is on line 1.
- [ ] **Strict Mode**: `set -euo pipefail` and `IFS=$'\n\t'` are configured.
- [ ] **Variable Quoting**: All parameter expansions and subshells are enclosed in double quotes (`"$var"`, `"$@"`).
- [ ] **Cleanup Trap**: A `trap cleanup EXIT INT TERM HUP` function is implemented if temporary files, child jobs, or locks are created.
- [ ] **Idempotent I/O**: Directories use `mkdir -p`; file modifications do not corrupt state if rerun.
- [ ] **CLI Flags**: Options are parsed using `getopts` with validation and usage help.
- [ ] **Stream Separation**: Logs and errors route to `>&2`; only pipeable machine output routes to `stdout`.
- [ ] **Linter Verification**: Script passes `shellcheck` with zero warnings:
  ```bash
  shellcheck -s bash path/to/script.sh
  ```
- [ ] **Executable Bit**: The script has execution permissions set (`chmod +x path/to/script.sh`).

---

## 8. Complete Production Script Boilerplate

```bash
#!/usr/bin/env bash
# ==============================================================================
# Script: template.sh
# Description: Production-ready defensive Bash script template
# ==============================================================================
set -euo pipefail
IFS=$'\n\t'

# ------------------------------------------------------------------------------
# Global Variables & Defaults
# ------------------------------------------------------------------------------
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

VERBOSE=0
DRY_RUN=0
TARGET_PATH=""
TMP_DIR=""

# ------------------------------------------------------------------------------
# Logging & Stream Helpers
# ------------------------------------------------------------------------------
log_info() {
  echo "[INFO]  $(date +'%Y-%m-%d %H:%M:%S') - $*" >&2
}

log_warn() {
  echo "[WARN]  $(date +'%Y-%m-%d %H:%M:%S') - $*" >&2
}

log_error() {
  echo "[ERROR] $(date +'%Y-%m-%d %H:%M:%S') - $*" >&2
}

fatal() {
  log_error "$*"
  exit 1
}

# ------------------------------------------------------------------------------
# Cleanup & Signal Handling
# ------------------------------------------------------------------------------
cleanup() {
  local exit_code=$?
  trap - EXIT INT TERM HUP

  if [[ -n "${TMP_DIR:-}" && -d "${TMP_DIR}" ]]; then
    rm -rf "${TMP_DIR}"
  fi

  local running_jobs
  running_jobs="$(jobs -p)"
  if [[ -n "${running_jobs}" ]]; then
    # shellcheck disable=SC2086
    kill ${running_jobs} 2>/dev/null || true
  fi

  exit "${exit_code}"
}
trap cleanup EXIT INT TERM HUP

# ------------------------------------------------------------------------------
# CLI & Usage
# ------------------------------------------------------------------------------
usage() {
  cat <<'USAGE_EOF' >&2
Usage: ${SCRIPT_NAME} [OPTIONS] -t <path>

Options:
  -t <path>     Target path (required)
  -v            Enable verbose output
  -n            Dry run mode (no destructive changes)
  -h            Show this help message and exit
USAGE_EOF
  exit 1
}

parse_args() {
  while getopts ":t:vnh" opt; do
    case "${opt}" in
      t) TARGET_PATH="${OPTARG}" ;;
      v) VERBOSE=1 ;;
      n) DRY_RUN=1 ;;
      h) usage ;;
      \?) fatal "Invalid option: -${OPTARG}. Run with -h for usage." ;;
      :) fatal "Option -${OPTARG} requires an argument." ;;
    esac
  done
  shift $((OPTIND - 1))

  if [[ -z "${TARGET_PATH}" ]]; then
    fatal "Missing required option: -t <path>"
  fi
}

# ------------------------------------------------------------------------------
# Main Logic
# ------------------------------------------------------------------------------
main() {
  parse_args "$@"

  TMP_DIR="$(mktemp -d -t "${SCRIPT_NAME}.XXXXXX")"
  log_info "Initialized temporary workspace at ${TMP_DIR}"

  if [[ "${DRY_RUN}" -eq 1 ]]; then
    log_info "Running in DRY RUN mode. No changes will be applied."
  fi

  # Perform idempotent work
  log_info "Processing target: ${TARGET_PATH}"

  # Emitting output data to stdout
  printf '{"status":"completed","target":"%s"}\n' "${TARGET_PATH}"
}

main "$@"
```

---
name: git-worktrees
description: Enterprise Git worktree orchestration patterns for concurrent multi-agent isolation, parallel feature branches, safe lifecycle management, and clean dependency bootstrapping. Use when spawning isolated agent workspaces, running parallel tasks, switching branches without stashing, or isolating worktree environments.
license: MIT
metadata:
  version: "1.0.0"
  category: "security-devops"
  topics: ["git", "worktrees", "multi-agent", "isolation"]
---

# Git Worktrees Orchestration & Isolation

Production patterns for managing isolated Git worktrees in multi-agent environments, autonomous subagent fleets, and high-velocity development workflows.

---

## 1. Overview & Architectural Motivation

In high-concurrency multi-agent architectures, multiple specialist subagents often work on different tasks simultaneously. Using a single working directory with `git checkout` or `git stash` creates severe race conditions:
- Agents overwrite uncommitted changes from parallel workers.
- Tool caches, compilers, and lockfiles collide.
- Branch switches interrupt in-flight test suites and file watchers.

Git worktrees solve this by allowing multiple working directories attached to the same repository. Each worktree possesses:
1. An isolated working tree (files on disk).
2. An independent `HEAD` and staging area (`index`).
3. Shared repository object database (`.git/objects`) and ref storage, with zero cloning overhead.

```text
┌────────────────────────────────────────────────────────┐
│               Central Repository (.git/)               │
│             Shared Objects, Commits, Refs              │
└────────────┬─────────────────────────────┬─────────────┘
             │                             │
    ┌────────▼────────┐           ┌────────▼────────┐
    │  Main Worktree  │           │ Agent Worktree  │
    │  Branch: main   │           │ Branch: feat/x  │
    └─────────────────┘           └─────────────────┘
```

---

## 2. Multi-Agent Worktree Topology

### Standardized Directory Convention

All dynamically spawned worktrees must reside in a dedicated, standardized directory at the project root:

```text
my-project/
├── .git/
├── .gitignore
├── .worktrees/                     # Dedicated worktree root
│   ├── feat-auth-service/          # Subagent 1 isolated workspace
│   ├── fix-billing-race/           # Subagent 2 isolated workspace
│   └── scout-performance-spike/    # Subagent 3 isolated workspace
├── src/
└── package.json
```

### Mandate: `.gitignore` Enforcement

Every repository utilizing worktrees MUST add `.worktrees/` to its `.gitignore`:

```gitignore
# Git Worktrees for concurrent agents and local isolation
.worktrees/
```

> [!IMPORTANT]
> Never commit worktree directories into version control. Failing to ignore `.worktrees/` can lead to recursive staging, index corruption, and credential leakage.

---

## 3. Complete Worktree Lifecycle

The worktree lifecycle consists of four discrete phases: **Spawn**, **Bootstrap**, **Operate**, and **Teardown**.

```text
[ 1. SPAWN ]   git worktree add -b <branch> .worktrees/<branch> <base>
     │
     ▼
[ 2. BOOTSTRAP ] Copy .env, link node_modules/vendor, pre-flight checks
     │
     ▼
[ 3. OPERATE ]   Subagent runs tests, modifies files, creates commits
     │
     ▼
[ 4. TEARDOWN ]  Verify clean status, git worktree remove, git worktree prune
```

---

### Phase 1: Spawn

To spawn a new isolated worktree from a base reference (e.g. `main` or `HEAD`):

#### 1. Creating a New Feature Branch
```bash
# Syntax: git worktree add -b <new-branch> <path> <base-ref>
git worktree add -b feat/user-auth .worktrees/feat-user-auth main
```

#### 2. Checking Out an Existing Branch
```bash
# If branch already exists locally or remotely
git worktree add .worktrees/bugfix-123 bugfix-123
```

#### 3. Creating a Detached Read-Only Scout Worktree
For exploratory spikes or code audits that will not generate permanent commits:
```bash
# Detached HEAD: No branch creation required
git worktree add --detach .worktrees/scout-audit-spike HEAD
```

---

### Phase 2: Bootstrap (Configuration & Dependencies)

A freshly created worktree contains clean tracked files, but lacks ignored files such as `.env`, package directories (`node_modules`, `vendor`), and build artifacts.

#### 1. Safe Environment File Sync
Copy uncommitted environment files non-destructively:

```bash
WORKTREE_DIR=".worktrees/feat-user-auth"

# Copy development environment config if present in main worktree
if [[ -f .env ]]; then
  cp .env "${WORKTREE_DIR}/.env"
fi

if [[ -f .env.local ]]; then
  cp .env.local "${WORKTREE_DIR}/.env.local"
fi
```

#### 2. Dependency Strategy: Symlink vs. Fresh Install

| Dependency Type | Recommended Strategy | Command / Recipe | Rationale |
|-----------------|----------------------|------------------|-----------|
| **Node.js (pnpm)** | Native Store Link | `pnpm install` inside worktree | `pnpm` uses a hardlink content-addressable store. Near-zero disk overhead and instant setup. |
| **Node.js (npm/yarn)** | Symlink `node_modules` | `ln -sfn "$(pwd)/node_modules" "${WORKTREE_DIR}/node_modules"` | Avoids downloading hundreds of megabytes if dependencies did not change. |
| **PHP / Composer** | Symlink or `composer install` | `ln -sfn "$(pwd)/vendor" "${WORKTREE_DIR}/vendor"` | Fast symlink for quick edits; run `composer install` if `composer.json` is modified. |
| **Python** | Isolated Virtualenv | `python3 -m venv "${WORKTREE_DIR}/.venv"` | Prevents package pollution across different feature branches. |

```bash
# Example: Fast Node.js bootstrap with symlink fallback
bootstrap_worktree() {
  local wt_path="$1"

  # 1. Environment files
  [[ -f .env ]] && cp .env "${wt_path}/.env"

  # 2. Node modules symlink (if package.json matches base)
  if [[ -d node_modules && ! -d "${wt_path}/node_modules" ]]; then
    ln -sfn "$(pwd)/node_modules" "${wt_path}/node_modules"
  fi

  echo "Worktree bootstrapped at ${wt_path}" >&2
}
```

---

### Phase 3: Active Operation & Boundary Isolation

Once bootstrapped, the specialist subagent executes tasks strictly inside the assigned worktree directory:

1. **Working Directory Boundary**: All commands (`pytest`, `npm test`, linters, file edits) must run with working directory set to `.worktrees/<branch>`.
2. **Git Commit Boundary**: Commits created inside the worktree record directly onto the isolated branch without affecting the root repository's current branch or index.

---

### Phase 4: Teardown & Clean Removal

Never leave stale worktrees behind. Once work is merged, reviewed, or abandoned, execute teardown:

#### 1. Safety Check: Verify Uncommitted Work
Before removal, verify there are no uncommitted or untracked changes that would be lost:

```bash
WT_DIR=".worktrees/feat-user-auth"

if [[ -d "${WT_DIR}" ]]; then
  # Check for uncommitted tracked or untracked files
  if [[ -n "$(git -C "${WT_DIR}" status --porcelain)" ]]; then
    echo "Error: Worktree has uncommitted changes! Aborting teardown." >&2
    git -C "${WT_DIR}" status --short >&2
    exit 1
  fi
fi
```

#### 2. Clean Removal Command
```bash
# Safely remove the worktree and its administrative metadata
git worktree remove .worktrees/feat-user-auth

# Clean up stale administrative files if any exist
git worktree prune
```

#### 3. Branch Cleanup (If Merged)
```bash
# Delete local branch if merged
git branch -d feat/user-auth
```

---

## 4. Concurrent Subagent Isolation Rules

When dispatching parallel subagents in an orchestrator (such as ACON Control Plane), enforce the following non-negotiable rules:

### Rule 1: The "Single Active Branch" Invariant
Git strictly enforces that **a branch can only be checked out in one worktree at any given time**. Attempting to check out an already checked-out branch results in:

```text
fatal: 'feat/auth' is already checked out at '/path/to/.worktrees/agent-1'
```

- Each subagent MUST have a unique branch name (e.g. `feat/auth-service`, `scout/db-perf`).
- If an agent needs to inspect an existing branch without modifying it, use a **detached HEAD**:
  ```bash
  git worktree add --detach .worktrees/inspect-auth feat/auth
  ```

### Rule 2: Zero Worktree Overlap
No two subagents may share the same `.worktrees/<directory>`. Each agent receives its own dedicated worktree directory.

### Rule 3: Orchestrator Synthesis Pattern
Subagents do not merge into `main` directly. Instead:
1. Subagent finishes work and commits to `feat/<task>` in its worktree.
2. Subagent notifies parent Control Plane via structured completion report.
3. Control Plane verifies test pass and tears down the worktree.
4. Control Plane performs merge or presents diff to the user.

---

## 5. Safety Checks & Troubleshooting Playbook

### Diagnostic Commands

```bash
# List all active worktrees with branch and HEAD commit
git worktree list

# Machine-readable format
git worktree list --porcelain
```

### Common Errors & Solutions

#### Error 1: "fatal: 'branch' is already checked out at..."
**Cause**: The requested branch is already checked out in another worktree or the main working tree.  
**Resolution**:
1. Run `git worktree list` to find where the branch is checked out.
2. If the previous worktree directory was deleted manually without `git worktree remove`, Git's metadata is stale. Run:
   ```bash
   git worktree prune
   ```
3. If the worktree is still needed elsewhere, spawn with a new branch:
   ```bash
   git worktree add -b feat/my-feature-v2 .worktrees/feat-v2 origin/main
   ```

#### Error 2: "fatal: '.worktrees/xyz' is dirty; use --force to override"
**Cause**: Uncommitted changes exist inside the worktree directory.  
**Resolution**:
- **Never use `--force` blindly.** Inspect the uncommitted changes:
  ```bash
  git -C .worktrees/xyz status
  git -C .worktrees/xyz diff
  ```
- If the changes are valuable, commit or stash them.
- If and only if the changes are disposable scratch files, remove them or use `git worktree remove --force .worktrees/xyz`.

#### Error 3: Worktree Locked
**Cause**: An administrative lock was placed on the worktree to prevent accidental pruning (e.g. on network drives or removable storage).  
**Resolution**:
```bash
# Check lock status
git worktree list

# Unlock the worktree
git worktree unlock .worktrees/my-worktree
```

---

## 6. Automation Helper Scripts

Include these standardized scripts in your project or agent tooling:

### `spawn-worktree.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ $# -lt 1 ]]; then
  echo "Usage: $(basename "$0") <branch-name> [base-ref]" >&2
  exit 1
fi

BRANCH="$1"
BASE_REF="${2:-HEAD}"
DIR_NAME="${BRANCH//\//-}" # Replace slashes with dashes for directory name
WT_PATH=".worktrees/${DIR_NAME}"

# Ensure .worktrees is in .gitignore
if ! grep -qs '^\.worktrees/' .gitignore; then
  echo ".worktrees/" >> .gitignore
  echo "[INFO] Added .worktrees/ to .gitignore" >&2
fi

mkdir -p .worktrees

if [[ -d "${WT_PATH}" ]]; then
  echo "[ERROR] Directory ${WT_PATH} already exists." >&2
  exit 1
fi

# Add worktree
echo "[INFO] Spawning worktree for '${BRANCH}' from '${BASE_REF}'..." >&2
git worktree add -b "${BRANCH}" "${WT_PATH}" "${BASE_REF}"

# Bootstrap .env if present
if [[ -f .env && ! -f "${WT_PATH}/.env" ]]; then
  cp .env "${WT_PATH}/.env"
  echo "[INFO] Copied .env to ${WT_PATH}" >&2
fi

# Symlink node_modules if present
if [[ -d node_modules && ! -e "${WT_PATH}/node_modules" ]]; then
  ln -sfn "$(pwd)/node_modules" "${WT_PATH}/node_modules"
  echo "[INFO] Symlinked node_modules to ${WT_PATH}" >&2
fi

echo "[SUCCESS] Worktree ready at: ${WT_PATH}" >&2
printf '%s\n' "${WT_PATH}"
```

### `teardown-worktree.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [[ $# -lt 1 ]]; then
  echo "Usage: $(basename "$0") <worktree-path-or-branch>" >&2
  exit 1
fi

TARGET="$1"

# Resolve path
if [[ -d "${TARGET}" ]]; then
  WT_PATH="${TARGET}"
else
  DIR_NAME="${TARGET//\//-}"
  WT_PATH=".worktrees/${DIR_NAME}"
fi

if [[ ! -d "${WT_PATH}" ]]; then
  echo "[WARN] Worktree path ${WT_PATH} does not exist. Pruning metadata..." >&2
  git worktree prune
  exit 0
fi

# Check status
if [[ -n "$(git -C "${WT_PATH}" status --porcelain)" ]]; then
  echo "[ERROR] Cannot teardown: ${WT_PATH} has uncommitted changes!" >&2
  git -C "${WT_PATH}" status --short >&2
  exit 1
fi

echo "[INFO] Removing worktree at ${WT_PATH}..." >&2
git worktree remove "${WT_PATH}"
git worktree prune
echo "[SUCCESS] Worktree ${WT_PATH} removed." >&2
```

---

## 7. Worktree Hygiene Checklist

Before spawning or after destroying worktrees, verify:

- [ ] **`.gitignore`**: `.worktrees/` is present in `.gitignore`.
- [ ] **Branch Uniqueness**: Each active worktree tracks a unique branch or is in detached HEAD mode.
- [ ] **Dependency Bootstrap**: `.env`, `node_modules`, or `vendor` links are established before running tests or build tools.
- [ ] **Working Directory Setting**: Agent execution commands set `cwd` to the specific worktree path.
- [ ] **Cleanliness Verification**: `git status --porcelain` is checked before teardown.
- [ ] **Prune Execution**: `git worktree prune` is executed after worktree removal to prevent metadata drift.

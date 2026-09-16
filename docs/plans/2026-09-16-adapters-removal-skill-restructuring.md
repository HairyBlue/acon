# Plan: Adapters Removal & Skill Directory Restructuring

**Status:** Completed (Skill restructuring deferred per Captain direction)  
**Date:** 2026-09-16  
**Author:** Antigravity Control Plane (First Mate)  
**Tracking Issue / Context:** User request to remove `adapters/` (preserving only `adopt.sh` relocated to `scripts/adopt.sh`), migrate nested sub-skills (`design/impeccable`, `design/interface-design`, `frameworks/laravel-projects/filament`, `frameworks/laravel-projects/laravel`) into standardized `references/` directories, and synchronize all affected skills, rules, and documentation.

> **Captain Direction Update (2026-09-16):**  
> The Captain explicitly steered: **Do NOT transfer skills to references**. Skip all skill restructuring under `design/` and `frameworks/`. Strictly focus on:
> 1. Moving `adopt.sh` to `scripts/adopt.sh`.
> 2. Removing the `adapters/` directory entirely.
> 3. Updating all affected references across scripts, skills, governance rules, and documentation.
> Consequently, Phase 2 and Phase 3 are formally deferred, while Phases 1, 4, and 5 have been executed and verified.

---

## 1. Executive Summary & Architectural Decisions

1. **Retain & Relocate `adopt.sh`:**
   - Created root `scripts/` directory.
   - Moved `adapters/adopt.sh` to `scripts/adopt.sh` with executable permissions (`chmod +x`).
   - Updated `adopt.sh` internal header, help messages, boundary check exclusions (`scripts/`, `adapters/`, `acon.yaml`), and fail-closed gates.
   - Completely removed the remaining `adapters/` directory (`acon.yaml`, `config-reader.py`, `dispatch.sh`, `session-runner.sh`, `README.md`, and test sessions).
   - Removed `adapters/sessions/` from `.gitignore`.
2. **Skill Directory Hierarchy Restructuring (DEFERRED per Captain direction):**
   - *Deferred:* `design/impeccable` and `design/interface-design` remain as active standalone skills.
   - *Deferred:* `frameworks/laravel-projects/filament` and `frameworks/laravel-projects/laravel` remain in their original hierarchy.
3. **Purged Bridge & Re-Anchored Constitution to Native Subagents:**
   - In `AGENTS.md` and `.agents/rules/agent-control-plane.md`, removed deprecated Cross-Harness Bridge sections (`acon.yaml`, `dispatch.sh`) and Cross-Project Session Protocol (`session-runner.sh`).
   - Re-anchored the constitution purely on native subagent orchestration (`invoke_subagent`) and `scripts/adopt.sh` for external repository adoption.
   - Synchronized `README.md`, `.agents/INDEX.md`, and `.agents/skills/productivity/adopt-acon/SKILL.md`.

---

## 2. Work Breakdown & Execution Phases

### Phase 1: Script Relocation & Adapters Removal (`SHIP`)
- [x] **Task 1.1: Relocate `adopt.sh` to `scripts/adopt.sh`**
  - Create directory `scripts/`.
  - Move `adapters/adopt.sh` to `scripts/adopt.sh`.
  - Update script usage banner, comments, and boundary checks (disallow transferring `scripts/` to target repos, audit target for 0 symlinks, ensure `test ! -e "$TARGET/scripts"` and `test ! -e "$TARGET/adapters"`).
  - Verify syntax with `bash -n scripts/adopt.sh` and test with `bash scripts/adopt.sh --help`.
- [x] **Task 1.2: Remove `adapters/` directory and update `.gitignore`**
  - Delete `adapters/` tree (`rm -rf adapters/`).
  - Update `.gitignore` to remove `adapters/sessions/`.

### Phase 2: Restructure `design/` Suite (`SHIP`) — [DEFERRED per Captain direction]
- [-] **Task 2.1: Relocate `impeccable` to `references/impeccable`** *(Deferred)*
- [-] **Task 2.2: Relocate `interface-design` to `references/interface-design`** *(Deferred)*
- [-] **Task 2.3: Update `design/SKILL.md` and `design/README.md`** *(Deferred)*

### Phase 3: Restructure `frameworks/laravel-projects` Suite (`SHIP`) — [DEFERRED per Captain direction]
- [-] **Task 3.1: Relocate `filament` & `laravel` to `references/`** *(Deferred)*
- [-] **Task 3.2: Update `frameworks/laravel-projects/SKILL.md`** *(Deferred)*

### Phase 4: Synchronize Governance, Adoption Skill & Root Documentation (`SHIP`)
- [x] **Task 4.1: Update `AGENTS.md` and `.agents/rules/agent-control-plane.md`**
  - Replace `./adapters/adopt.sh` with `./scripts/adopt.sh`.
  - Remove deprecated Cross-Harness Bridge sections (`acon.yaml`, `dispatch.sh`, `session-runner.sh`) and Cross-Project Session Protocol, re-anchoring on native `invoke_subagent`.
  - Ensure `.agents/rules/agent-control-plane.md` is updated identically.
- [x] **Task 4.2: Update `productivity/adopt-acon/SKILL.md`**
  - Change all `./adapters/adopt.sh` commands and references to `./scripts/adopt.sh`.
  - Update architecture diagrams and verification checklist to verify `test ! -e "$TARGET/scripts"` and `test ! -e "$TARGET/adapters"`.
- [x] **Task 4.3: Update `README.md` and `.agents/INDEX.md`**
  - Remove bridge documentation from `README.md`; show `scripts/adopt.sh` in the directory tree.
  - Update `.agents/INDEX.md` to remove lookup entries for `acon.yaml` and `adapters/`, and update adoption reference to `scripts/adopt.sh`.

### Phase 5: Verification & Anti-Slop Audit (`SCOUT / VERIFY`)
- [x] **Task 5.1: Integrity & Broken Link Audit**
  - Verify `bash -n scripts/adopt.sh` passes without errors.
  - Verify `./scripts/adopt.sh --help` returns clean exit 0.
  - Confirm `adapters/` directory no longer exists on disk.
  - Run `grep -rn "adapters/"` across `AGENTS.md`, `.agents/`, `README.md`, `scripts/` to confirm zero unwanted stale references remain.
  - Confirm `.agents/rules/agent-control-plane.md` matches `AGENTS.md`.

---

## 3. Worker Dispatch Strategy & Boundaries

In compliance with the ACON Constitution:
- Work was partitioned into non-overlapping file scopes across specialist workers.
- Zero git collisions: verified single-source truth across all files.
- Control plane synthesizes final shared entry points and presents the Bearings digest.

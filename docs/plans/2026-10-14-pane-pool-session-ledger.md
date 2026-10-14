# Implementation Plan: Pane Pool and Session Ledger

- **Plan File:** `docs/plans/2026-10-14-pane-pool-session-ledger.md`
- **Author:** Captain-authorized planning worker
- **Date:** 2026-10-14
- **Status:** Implementation complete (4/4 tasks); G7/G8/G9 APPROVE; optional runtime validation pending and untested
- **Target Branch:** Existing branch; no branch operation authorized

## 1. Context & Objective

Replace the existing hard four-crew-pane-per-tab cap with the approved host-neutral pool policy: orchestrator pinned left, eight EMPTY slots in a two-column × four-row right grid initially, then two balanced new slots per growth step only within an upfront Captain-approved mission ceiling and host-attested readability/resource limits. Count across all tabs. Empty PTYs, live CLI processes, and assigned work are distinct; no capacity evasion or silent close/recycle of active user processes.

Use a minimal local gitignored JSON session ledger with exactly this hierarchy: `workspace_name` → `agents[]` → the `ORCHESTRATOR` entry → `fleets[]` → fleet `agents[]`. Each agent record has only `session_id`, extensible `cli`, `type`/role, and structured `resume_cmd` (`executable` plus `argv`). `fleets` appears only on the ORCHESTRATOR record. No workspace-root field unless later evidence proves it essential; prefer validating the active project and ledger location plus the recorded CLI session's actual workspace against the manually started ORCHESTRATOR workspace.

A human manually opens/resumes the ORCHESTRATOR after terminal closure. ACON never launches it from JSON, adds no daemon/launcher, and does not restart every workspace. The manually started ORCHESTRATOR reads the small local ledger, reconciles recorded owned live contexts first, and resumes only its recorded fleet under current Captain approvals and verified capabilities. Unknown/missing conversation or session identity stays pending and is reported; it is never silently recreated.

## 2. Decisions, Safety & Host Evidence

- **Ledger is data only:** Pane/resource/task/message rules remain in current ACON rules and current mission. Current Captain/harness evidence—not JSON—authorizes launch/resume. Do not add task, route, authorization, capability-history, process, owner, revision, workspace-root, or registry fields. No standalone schema file, executable validator, generic launcher/adapter, daemon, dependency, `.acon/settings.json`, or committed live IDs.
- **Validated resume:** Never shell-evaluate or execute stored `resume_cmd.argv` verbatim. Verify `executable` is the currently Captain-approved CLI and validate every argument against its documented, verified resume-only interface. Reject unknown flags and trust/approval-bypass flags (including `--approve`). Reconstruct a resume invocation using only verified resume options and the recorded agent's actual `session_id`. Recheck current Captain approval, CLI/model choice, scope and installed-harness capabilities. If identity/workspace is ambiguous, the CLI lacks verified exact-session resume, or the conversation cannot be proven to exist, leave pending and report. Never invoke create-if-absent behavior.
- **Pi evidence correction:** For installed Pi 1.2.0, `--resume` opens a selector; it is not a session-ID selector. `--session-id` creates a session if absent. Whether `--session` creates when absent is unestablished. None authorizes automatic resume. Other CLI resume semantics (including AGY/Codex) are `UNKNOWN` until separately approved discovery and verified evidence. Do not put guessed flags in the example or plan implementation.
- **Atomic file safety:** Only the manually active ORCHESTRATOR writes the local ledger. Confirm the ledger is at the active project location, `workspace_name` matches that workspace, and recorded actual sessions belong to the same manually started workspace. Reject a symlink ledger or sibling temp path (including dangling symlinks) before reading/writing. Write a validated small document to exact sibling temp path `.acon/sessions.json.tmp`, atomically rename it over `.acon/sessions.json`; on any failure preserve existing contents and pause/report. No lock, revision, or recovery subsystem. Ignore both exact paths idempotently.
- **Host claims:** Scout reports Herdr 0.8.2 protocol 20 and Pi 1.2.0 split/resize/layout/focus/wait/events/prompt/read interfaces as documented `AVAILABLE`. Balanced layout, pinning, event reliability, session-ID readback, workspace isolation, fresh context, and recovery remain `UNKNOWN` until smoke-tested. Documented interfaces are not observed behavior. The article `https://dotzlaw.com/insights/claude-code-13-herdr-parallel-agent-sessions/` is inspiration, not API evidence.
- **Launch and smoke boundaries:** Existing launch authorization barrier, skill G5/full skill embedding, workspace/worktree isolation, fresh independent reviewers, G8/G9, and Captain Git authority remain binding. Manual ORCHESTRATOR start does not authorize fleet launches. A later non-destructive smoke begins with empty layout only; model calls, resume and peer communication require separate bounded approvals. Never assume eight paid instances.
- **Ponytail:** Minimum diff; reuse existing ACON rules; 0 dependencies; prose safety is not represented as extra JSON fields. No runtime guarantee claimed.

## 3. Baseline & Preconditions

- Source snapshot inspected: `c733bbc8358b431f20db134f56b519ded0f45081`; initial `git status --short` was empty and targeted source diff was empty. Recheck before implementation and stop if baseline differs.
- **Captain authorization record (2026-10-14):** Captain `GO` approves this written simplified plan and selection of the same Pi GPT6Luna, high effort for sequential implementation and independent review roles. Planned identities: implementation worker fresh `wC:pN`; independent read-only reviewers fresh `wC:pH` and `wC:pJ`; planning worker `wC:pM`; all Pi GPT6Luna/high. This records the Captain's approved plan/model/role selection; actual dispatch still required the native/peer launch barrier and task-local authorization/capability preflight, which the assigned roles completed. Implementation and review evidence is recorded below.
- Relevant sources read: `AGENTS.md`, `.agents/rules/agent-control-plane.md`, `.agents/reference/crew/README.md`, `.gitignore`, `scripts/adopt.sh`, `.agents/skills/productivity/adopt-acon/SKILL.md`, handoff/task contracts, bounded catalogs and test inventory.
- Verified adoption insertion seam: `scripts/adopt.sh` parses options, validates/canonicalizes `TARGET`, rejects source root and `/`, then creates `TEMP_DIR`; `.gitignore` has no existing adoption mutation. Add fail-closed ignore handling after target path safety checks and before temp staging or any target writes. `[[ -L path ]]` catches existing and dangling symlinks. Preserve `CLAUDE.md -> AGENTS.md` and two-tier workshop flow.
- At the plan baseline, the shared crew reference and root/mirror contained the four-live-pane cap. Tasks 1–4 have since been implemented and accepted; Task 1 and Task 2 reports record the policy edits. Actual host layout/resource behavior remains untested and unknown.
- Planning itself performed no tests, adoption, source edits, host operations, pane/model changes, dependency/settings changes or Git mutations. The separately assigned implementation workers performed the changes and checks summarized under each task.
- Captain approved the plan and sequential roles. Implementation is now reported complete and reviewed; runtime pool use still requires a numeric mission ceiling and budget/time ceiling plus separately authorized host operations.

## 4. Implementation Tasks

Tasks are sequential; overlapping files are never assigned concurrently. Each task writes at most three files and has exact verification. These are future tasks, not work authorized in this planning stage.

### - [x] Task 1: Add minimal session-ledger contract to shared crew reference `[AUTONOMOUS-SHIP]`

- **Eligibility:** Documentation-only checks; one file; non-critical policy.
- **Goal:** Put the minimal JSON example and safety rules in the already-adopted shared fleet README; create no new schema asset.
- **File:** Modify `.agents/reference/crew/README.md` only, inserting `## Manual orchestrator session ledger` after `## Host-neutral orchestration` and before the current `A task/session message identifies...` paragraph.
- **Consumes:** Existing crew launch authorization barrier and host-neutral capability contract in the same README.
- **Produces:** A small example and prose defining manual startup, validation, safe resume, atomic writes and ledger/adoption boundaries. The prose is not JSON fields or an executable schema.
- **Exact insertion:**

````markdown
## Manual orchestrator session ledger

The user manually opens/resumes the ORCHESTRATOR after terminal closure. ACON never launches it from JSON, does not provide a daemon/launcher, and does not auto-start every workspace. After manual startup, it reads the local `<active-project>/.acon/sessions.json`, reconciles recorded owned live contexts first, and considers resuming only missing sessions in its recorded fleets. Current Captain authorization and verified installed-harness capabilities—not JSON—authorize any resume. Unknown/missing conversation or session identity stays pending and is reported; never create a replacement silently.

The ledger is gitignored local data with this minimal shape. Example values are inert placeholders, not commands or permission:

```json
{
  "workspace_name": "active-project-name",
  "agents": [
    {
      "session_id": "actual-orchestrator-session-id",
      "cli": "extensible-cli-identifier",
      "type": "ORCHESTRATOR",
      "resume_cmd": {
        "executable": "verified-cli-executable",
        "argv": ["inert-placeholder-only"]
      },
      "fleets": [
        {
          "agents": [
            {
              "session_id": "actual-fleet-session-id",
              "cli": "another-extensible-cli-identifier",
              "type": "WORKER",
              "resume_cmd": {
                "executable": "verified-cli-executable",
                "argv": ["inert-placeholder-only"]
              }
            }
          ]
        }
      ]
    }
  ]
}
```

The root contains only `workspace_name` and `agents`; an ORCHESTRATOR record has `session_id`, extensible `cli`, `type`/role, structured `resume_cmd` (`executable`, `argv`), and its `fleets` array. Fleet records contain `agents`; each fleet agent has only `session_id`, `cli`, `type`, and `resume_cmd`. No other fields are permitted in this example shape. Do not add workspace root, task/resource/process tables, routes, permissions, capability history, owner/revision/lock state, or a second schema/catalog. The ledger is not consent and cannot override current ACON rules or current-mission assignments/routes.

Before use, validate JSON types and required hierarchy, unique actual session IDs, active project/ledger location, `workspace_name` against the current manually opened project, and each recorded CLI session's actual workspace against the ORCHESTRATOR workspace. Reject symlink ledger/temp paths, including dangling symlinks. Never store secrets/credentials or commit/adopt actual session IDs.

Never shell-evaluate `resume_cmd` or execute its saved `argv` verbatim. Verify the executable is the current Captain-approved CLI; check each argument against that CLI version's documented, verified resume-only interface; reject unknown flags and approval/trust-bypass flags such as `--approve`. Reconstruct a resume invocation from verified resume-only options and the recorded actual session identity. Recheck current Captain authorization and capabilities. Pause/report if identity/workspace is ambiguous, session/conversation existence is unknown, or the CLI cannot resume that exact existing session. Never use create-if-absent behavior.

Pi 1.2.0 `--resume` opens a selector; it does not select a session ID. `--session-id` creates a session if absent; absent-ID behavior for `--session` is unestablished. These are not automatic-resume guarantees. AGY/Codex resume behavior remains `UNKNOWN` absent separately approved discovery. Do not infer CLI support from this document, screenshots, or articles.

For the one manually active ORCHESTRATOR writer, write validated data to the exact sibling temporary path `.acon/sessions.json.tmp`, then atomically rename it over `.acon/sessions.json`. Both exact paths are ignored. Reject symlinks before reading or writing; on malformed data, wrong workspace, uncertain ownership, unsafe command arguments, or any write/rename failure, preserve existing bytes and pause/report. No lock/revision framework is introduced.

Pane layout and resources, mission ceiling, task ownership/scopes, current authorization, peer communication routes/topics, completion evidence, workspace/worktree isolation, and reviewer lineage remain governed by existing ACON rules and the active mission; they are not ledger fields. The existing launch barrier, skill preflight, independent G8/G9 and Captain Git authority remain binding. Documented host interfaces and tested host behavior must be reported separately.
````

- **Verification:** Run `git diff --check -- .agents/reference/crew/README.md`. Use Python standard-library checks to extract/parse the JSON block, assert exact root keys `workspace_name, agents`, exact ORCHESTRATOR keys `session_id, cli, type, resume_cmd, fleets`, exact fleet keys `agents`, exact fleet-agent keys `session_id, cli, type, resume_cmd`, and assert no extra JSON safety/authorization fields. Check the prose contains the symlink, `argv` reconstruction, Pi selector, manual-start, pending-on-unknown, and atomic-write safeguards. Exit 0. This verifies the example/prose only, not runtime behavior.
- **Accepted completion:** G7 ACCEPTED. Evidence: `/tmp/pane-pool-task1-report.gbZIE2.md`; contract assertions, JSON hierarchy/prose checks, and `git diff --check -- .agents/reference/crew/README.md` all exited 0. Task 1 changed only the shared crew README; no runtime ledger or host behavior was exercised.

### - [x] Task 2: Update both constitution mirrors `[AUTONOMOUS-SHIP]`

- **Eligibility:** Documentation-only; two files; deterministic mirror check.
- **Goal:** Replace the existing four-pane cap with the approved mission-wide pool policy and explicitly bound manual orchestrator ledger access.
- **Files:** Modify `AGENTS.md` and `.agents/rules/agent-control-plane.md`; these are identical at baseline. Do not edit `CLAUDE.md` symlink.
- **Consumes:** Existing Rule 4 host-neutral orchestration and pane-cap sentence; Task 1 shared README contract.
- **Produces:** Matching replacement policy in root and mirror; no runtime code.
- **Exact edits:** In both files replace the unique sentence `Apply a maximum of four live crew panes per tab, excluding the orchestrator; opening tabs or relabeling panes does not evade the cap.` with:

```markdown
Use the Captain-authorized mission-wide pane-pool ceiling and layout, counting crew slots across all tabs; tabs/labels do not evade it. Start with the orchestrator pinned left and eight EMPTY slots in a two-column × four-row right grid. Grow only by two balanced slots within the upfront Captain-approved mission ceiling and host-attested readability/resource limits; otherwise queue and pause. Empty PTYs, live CLI processes, and assigned tasks are distinct. Never guess focus/ownership, steal foreign panes, or silently close/recycle active user processes. See the manual orchestrator session-ledger policy in [portable fleet reference](.agents/reference/crew/README.md#manual-orchestrator-session-ledger).
```

Append after the sentence ending `Assigned workers execute their authorized bounded scopes; primary-only restrictions do not transfer to them.`:

```markdown
The user manually opens/resumes the ORCHESTRATOR; ACON never launches it from JSON. Once manually started, it may read/write only its local `.acon/sessions.json` orchestration state as specified in the portable fleet reference; this is not permission for primary project inspection/edit/build/test, and the ledger is never authorization.
```

Keep all unrelated policy and current completion/approval rules unchanged.
- **Verification:** `cmp -s AGENTS.md .agents/rules/agent-control-plane.md`; `git diff --check -- AGENTS.md .agents/rules/agent-control-plane.md`; `rg -n 'maximum of four live crew panes per tab|eight EMPTY slots|manually opens/resumes|manual-orchestrator-session-ledger' AGENTS.md .agents/rules/agent-control-plane.md`. Expected exit 0.
- **Accepted completion:** G7 ACCEPTED. Evidence: `/tmp/pane-pool-task2-correction-report.E2uwZR.md`; corrected snapshot assertions, mirror `cmp -s`, and `git diff --check` exited 0. Root and physical mirror changed only within Task 2 scope; no host behavior was tested.

### - [x] Task 3: Ignore only ledger and atomic temp paths `[AUTONOMOUS-SHIP]`

- **Eligibility:** Single-file config; deterministic exact-line assertions.
- **File:** Modify `.gitignore` only.
- **Consumes:** Existing local session/worktree ignore entries; Task 1 exact runtime paths.
- **Produces:** Two exact root-anchored ignore patterns, without ignoring `.acon/` broadly.
- **Exact append:**

```gitignore
# Local manually managed orchestrator ledger and atomic-write temp
/.acon/sessions.json
/.acon/sessions.json.tmp
```

Preserve every existing byte/entry. Adoption is responsible for appending these exact patterns idempotently to a target `.gitignore`, not replacing local contents.
- **Verification:** `git diff --check -- .gitignore`; assert both new patterns and existing `.agents/sessions/`, `.worktrees/`, `scratch/` occur exactly once. Expected exit 0.
- **Accepted completion:** G7 ACCEPTED. Evidence: `/tmp/pane-pool-task3-report.jKJJxI.md`; exact original-byte preservation, required ignore/check-ignore assertions, and `git diff --check -- .gitignore` exited 0. Only `.gitignore` was changed by Task 3.

### - [x] Task 4: Preserve adoption ignores and reject unsafe ignore symlinks `[AUTONOMOUS-SHIP]`

- **Eligibility:** Three files; temporary-fixture regression; non-critical adoption plumbing.
- **Goal:** Add the two exact ignore lines without clobbering local ignores; fail before any target mutation if target `.gitignore` is a live or dangling symlink; document adoption boundary; prove preservation, idempotence, symlink refusal/no outside writes, and no source-live-state leak.
- **Files:** Modify `scripts/adopt.sh`; modify `.agents/skills/productivity/adopt-acon/SKILL.md`; create `tests/adopt-acon-session-ledger.sh`.
- **Consumes:** Verified existing script seam: after target canonicalization and rejection of source root/`/`, but before `TEMP_DIR` creation, current code has not yet modified target. Existing adoption copies AGENTS/.agents and never copies `.gitignore` or `.acon/`.
- **Produces:** Fail-closed inline ignore handling at that seam; adoption skill policy; bounded Bash fixture. Do not invent helper functions or alter unrelated adoption flow.
- **Exact inline script block:** Insert after the existing target `/` rejection and before `TEMP_DIR="$(mktemp...)`:

```bash
IGNORE_FILE="${TARGET}/.gitignore"
if [[ -L "${IGNORE_FILE}" ]]; then
  echo "[ERROR] Refusing symlink target .gitignore: ${IGNORE_FILE}" >&2
  exit 1
fi
if [[ -e "${IGNORE_FILE}" && ! -f "${IGNORE_FILE}" ]]; then
  echo "[ERROR] Target .gitignore exists but is not a regular file: ${IGNORE_FILE}" >&2
  exit 1
fi
if [[ ${DRY_RUN} -eq 0 ]]; then
  [[ -e "${IGNORE_FILE}" ]] || : > "${IGNORE_FILE}"
  for pattern in '/.acon/sessions.json' '/.acon/sessions.json.tmp'; do
    if ! grep -Fqx -- "${pattern}" "${IGNORE_FILE}"; then
      if [[ -s "${IGNORE_FILE}" && "$(tail -c 1 "${IGNORE_FILE}" | wc -l)" -eq 0 ]]; then
        printf '\n' >> "${IGNORE_FILE}"
      fi
      printf '%s\n' "${pattern}" >> "${IGNORE_FILE}"
    fi
  done
else
  echo "  [DRY RUN] Manifest item: preserve target .gitignore; ensure /.acon/sessions.json and /.acon/sessions.json.tmp are ignored"
fi
```

This checks `-L` before `-e`, so dangling symlinks fail closed. A missing ignore file is created only on non-dry-run adoption; existing regular-file contents are preserved and exact lines appended only if absent. Any append failure exits under existing `set -euo pipefail`. Do not follow, truncate, replace, or write outside the target via a symlink. Do not modify catalog counts, source/target copy boundaries, `CLAUDE.md` behavior, or `.agents` rsync logic.
- **Exact adoption-skill subsection:** Insert after `## 5. Automated Tooling: adopt.sh CLI Reference` and before `## 6. Adoption Checklist & Quality Invariants`:

```markdown
### Pane-pool policy and local session boundary

The user manually opens/resumes the ORCHESTRATOR; ACON never launches it from JSON. The portable session policy lives in the shared crew reference. Preserve target `.gitignore` contents and append only `/.acon/sessions.json` and `/.acon/sessions.json.tmp` when absent; reject a symlink `.gitignore` (including dangling links) before target writes. Repeated adoption must not duplicate either exact line. Never blanket-ignore `.acon/`, replace local ignores, or copy a source ledger, live session IDs, provider state, credentials, or internal scripts. The ledger is data, not consent. Existing Captain authorization, launch/skill preflight, task/message rules, workspace/worktree/reviewer isolation, compatibility paths, and G8/G9 remain binding. Documented host support is not smoke-tested behavior.
```

- **Complete bounded fixture:** Create `tests/adopt-acon-session-ledger.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
SOURCE="$TMP/source"
TARGET="$TMP/target"
mkdir -p "$SOURCE/scripts" "$SOURCE/.agents" "$SOURCE/.acon" "$TARGET"
cp "$REPO_ROOT/AGENTS.md" "$SOURCE/AGENTS.md"
cp "$REPO_ROOT/scripts/adopt.sh" "$SOURCE/scripts/adopt.sh"
cp -a "$REPO_ROOT/.agents/." "$SOURCE/.agents/"
printf 'PRIVATE-SESSION-SENTINEL\n' > "$SOURCE/.acon/sessions.json"
printf 'PRIVATE-TEMP-SENTINEL\n' > "$SOURCE/.acon/sessions.json.tmp"
printf 'Local target instruction.\n' > "$TARGET/AGENTS.md"
printf 'local-only-pattern\n.agents/sessions/\n.worktrees/\nscratch/\n' > "$TARGET/.gitignore"
mkdir -p "$TARGET/.agents"
printf 'local file\n' > "$TARGET/.agents/local-only.md"
bash "$SOURCE/scripts/adopt.sh" --force "$TARGET" >/dev/null
before="$(sha256sum "$TARGET/.gitignore" | cut -d' ' -f1)"
for pattern in 'local-only-pattern' '.agents/sessions/' '.worktrees/' 'scratch/' '/.acon/sessions.json' '/.acon/sessions.json.tmp'; do
  grep -Fqx "$pattern" "$TARGET/.gitignore"
  test "$(grep -Fxc "$pattern" "$TARGET/.gitignore")" -eq 1
done
grep -Fq 'Local target instruction.' "$TARGET/AGENTS.md"
test -f "$TARGET/.agents/local-only.md"
test ! -e "$TARGET/.acon/sessions.json"
test ! -e "$TARGET/.acon/sessions.json.tmp"
! grep -R -Fq 'PRIVATE-SESSION-SENTINEL' "$TARGET"
! grep -R -Fq 'PRIVATE-TEMP-SENTINEL' "$TARGET"
grep -Fq 'Pane-pool policy and local session boundary' "$TARGET/.agents/skills/productivity/adopt-acon/SKILL.md"
bash "$SOURCE/scripts/adopt.sh" --force "$TARGET" >/dev/null
test "$(sha256sum "$TARGET/.gitignore" | cut -d' ' -f1)" = "$before"

printf 'outside ignore sentinel\n' > "$TMP/outside-ignore"
mkdir -p "$TMP/symlink-target" "$TMP/dangling-target"
ln -s "$TMP/outside-ignore" "$TMP/symlink-target/.gitignore"
outside_before="$(sha256sum "$TMP/outside-ignore" | cut -d' ' -f1)"
if bash "$SOURCE/scripts/adopt.sh" --force "$TMP/symlink-target" >/dev/null 2>&1; then
  echo 'expected live .gitignore symlink refusal' >&2
  exit 1
fi
test "$(sha256sum "$TMP/outside-ignore" | cut -d' ' -f1)" = "$outside_before"
ln -s "$TMP/absent-ignore-target" "$TMP/dangling-target/.gitignore"
if bash "$SOURCE/scripts/adopt.sh" --force "$TMP/dangling-target" >/dev/null 2>&1; then
  echo 'expected dangling .gitignore symlink refusal' >&2
  exit 1
fi
test ! -e "$TMP/absent-ignore-target"
printf 'adoption fixture assertions passed\n'
```

- **TDD/verification:** Add fixture, run it against current source script and observe failure because the ignore lines are not yet appended. Implement only the precise changes above. Then run `bash tests/adopt-acon-session-ledger.sh` (exit 0; prints `adoption fixture assertions passed`), `bash -n scripts/adopt.sh tests/adopt-acon-session-ledger.sh`, and `git diff --check -- scripts/adopt.sh .agents/skills/productivity/adopt-acon/SKILL.md tests/adopt-acon-session-ledger.sh`. Fixture adopts only temporary copies; source sentinels are synthetic. It does not read the real live ledger or execute adoption against an actual repository. No feature/runtime tests are claimed.
- **Accepted completion:** G7 ACCEPTED. Evidence: `/tmp/adopt-task4-report.fQdsaM.md` and `/tmp/adopt-task4-executable-followup.5hVmHq.md`; fixture first failed as expected, then passed after implementation; Bash syntax and final diff checks exited 0. Fixture is executable (`755`) and content SHA-256 remained `9293695b6e76d3682afbd68564cceb5950c673f9ce228431ccf094892e6c7ad3` across mode correction. `shellcheck` was UNAVAILABLE (not installed); no installation was attempted.

### Independent review acceptance for Tasks 1–4

Captain reports G8 Code Review and G9 Security Review both `APPROVE` on the integrated implementation. Reviewers were fresh read-only contexts `wC:pH` and `wC:pJ`, independent from writer `wC:pN`; all used Pi GPT6Luna/high, therefore record `CORRELATED_REVIEW`. These approvals are accepted evidence per the Captain's current mission report; Task 4's earlier follow-up note that G8 clarification was still ongoing is superseded by this later approval. No review context was reused as writer.

## 5. Integration & Host Acceptance

**Implementation integration verification is complete:** Captain reports final fixture, Bash syntax, mirror, contract, ignore, diff, and scope checks all exited 0. The individual evidence paths and exit-code details are recorded above. The adoption fixture is executable and content-stable after mode correction. `shellcheck` remains UNAVAILABLE/not installed. These checks verify implementation contracts/adoption only; they do not prove runtime resume or host layout.

Later, separately approved non-destructive host smoke checks distinguish documentation from observed behavior: first create only empty layout; then separately authorize any model launch; separately test resume and peer communication. No automatic eight-process launch. Verify exact existing session identity and workspace against the manually started ORCHESTRATOR before any resume. For Pi, `--resume` opens a selector, `--session-id` creates when absent, and `--session` absent behavior is unknown; do not use these as automatic resume without exact verified semantics. Unknown/missing conversation stays pending. Reject stored approval/trust-bypass/unknown flags such as `--approve`; never shell-eval or use saved argv verbatim. Record documented interface capability separately from actual smoke result. Maintain current route approval, task scope, completion evidence, independent reviewer, workspace/worktree and G8/G9 rules.

## 6. Remaining Review & Captain Actions

- The four implementation tasks and G7/G8/G9 are accepted complete; optional runtime validation is pending and has not been performed. This is not global runtime acceptance.
- Runtime 8/10 layout behavior, resource/readability behavior, event reliability, exact-session resume/recovery, workspace isolation, fresh-context behavior, peer communication behavior, and other-CLI resume capabilities remain `UNKNOWN`/UNTESTED. No actual live `.acon/sessions.json` was created and no fleet was restored.
- Before actual pool use, Captain supplies the numeric mission ceiling and time/cost budget and separately authorizes host/model/resume/communication operations. No commit/push authorization was granted in this mission.
- Rollback is limited to reverting authorized source diffs while preserving target-local ignores/workshop rules and any local ledger. No Git mutation, destructive cleanup, pane closure, or runtime operation occurred in this progress update.

## 7. Planning Evidence

- Read-only snapshot: `c733bbc8358b431f20db134f56b519ded0f45081`; original working tree was clean. Current authorized write remains this plan file only.
- Re-verified `scripts/adopt.sh` target-validation seam: the target is canonicalized, source-root and filesystem-root targets are rejected, and `TEMP_DIR` is created immediately afterward. The proposed symlink guard is explicitly before temp staging and any target writes.
- Implementation and review evidence is recorded in the four task sections above. This plan-progress update changes only the plan; it did not run implementation tests, real adoption, host/pane/model operations, dependency/settings changes, or Git mutations. Optional runtime validation remains pending and untested.

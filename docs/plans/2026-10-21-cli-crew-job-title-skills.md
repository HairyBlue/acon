# Implementation Plan: CLI Crew Job Titles and Task-Scoped Skill Metadata

- **Plan File:** `docs/plans/2026-10-21-cli-crew-job-title-skills.md`
- **Author:** Planning Worker
- **Date:** 2026-10-21
- **Status:** Completed — documentation/adoption fixture only
- **Target Branch:** Existing branch; do not create a branch without separate approval

## 1. Context & Objective

Add optional descriptive `job_title` and task-scoped `skills.assigned` / `skills.loaded` metadata to the local CLI crew ledger while preserving broad `type`, actual unique session IDs, metadata-free old records, all current approval and safe-I/O boundaries, and pending treatment of uncertain session identities. Do not backfill guessed metadata. At the initial planning phase, this assignment was plan-only: no implementation, ledger migration, runtime validation, or live-ledger access. Later bounded implementation evidence and limits are recorded in §7.

The ledger remains observational data. Titles and skill names do not prove role, skill loading, capability, authorization, or consent; names do not install or activate skills. Full selected-skill embedding, fresh READY, writer/reviewer separation, Captain launch/spend/Git authority, private safe I/O, and current pending-history safeguards remain binding.

## 2. Authorized Investigation Findings

### Canonical ledger and policy

- `.agents/reference/crew/README.md:71-109` contains the inert ledger example; `:112-114` defines its exact allowlists and `:114-124` covers identity/workspace validation, untrusted data, resume-only arguments, safe I/O, and pending behavior. Current shape:
  - Root: `workspace_name`, `agents`.
  - ORCHESTRATOR record: required `session_id`, `cli`, `type`, `resume_cmd`, `fleets`; optional `pane_id`, `model`.
  - Fleet: `agents` only.
  - Fleet-agent record: required `session_id`, `cli`, `type`, `resume_cmd`; optional `pane_id`, `model`.
  - `resume_cmd`: required `executable`, `argv`; optional `copy_cmd`, `backup_argv`.
- `.agents/reference/crew/README.md:61-68,130-142` covers roster lifecycle, brief refresh, skill preflight, reviewer separation, and supplementary crew-side skill fallback. In particular, its current fallback permits resolving/applying relevant additional skills within existing bounds; it does not expand permissions or replace dispatch-time embedding obligations.
- The inspected summary text at `AGENTS.md:19,25`, `.agents/rules/agent-control-plane.md:19,25`, and `README.md:120-124` does not define a conflicting ledger field allowlist. Keep those files unchanged; duplicating optional metadata promotion there is unnecessary. `.agents/skills/productivity/adopt-acon/SKILL.md:239` documents adoption/privacy boundaries and likewise needs no change.

### Adoption and validation touchpoints

- `scripts/adopt.sh:165-174` ensures only the two exact ignored ledger paths are added; it does not parse ledger records and needs no change.
- `tests/adopt-acon-session-ledger.sh:13-34,45-62` is the existing adoption/privacy fixture: it protects source sentinel non-leakage, target ledger preservation, exact ignore uniqueness, idempotency, dry-run, and symlink cases. It is not a ledger schema validator; only add assertions that adoption copied the canonical contract/examples.
- No runtime ledger schema validator was found by the authorized targeted searches in `scripts/` and `tests/`. Therefore test-only example/presence checks below must not be reported as runtime schema enforcement.

### Scope deviation (not authorized)

I used recursive workspace-wide Markdown/shell searches (including `README.md`, `*.md`, and `*.sh` patterns) that traversed beyond the named source roots, and read `docs/plans/2026-10-14-terminal-fleet-lifecycle.md`. That was outside scope and is not retroactively approved. I stopped those reads, removed reliance on that historical plan, and will not read any other file under `docs/plans`; only this permitted plan file is read back. The findings and future file scopes above rely on the authorized named source files/directories only.

## 3. Design Decisions

1. **Title:** `job_title` is optional on ORCHESTRATOR and fleet-agent records. When present it is a string with at least one non-whitespace character; preserve the authored value. `type` remains the broad role/persona. Title is descriptive only.
2. **Skills shape:** `skills` is optional on ORCHESTRATOR and fleet-agent records only. When present it is an object with optional `assigned` and `loaded` arrays; either can be empty and `{}` is valid. Each array is a set represented as a JSON array: unique, exact, case-sensitive canonical leaf skill IDs. `loaded` must be a subset of `assigned`. Missing metadata and legacy records remain valid.
3. **IDs:** Resolve IDs using `.agents/INDEX.md` to a leaf `SKILL.md`; resolve router/suite entries to the chosen child skill. Reject unknown/non-leaf IDs, paths, and duplicates. Craft references such as `craft/anti-ai-slop.md` are not skill IDs; keep them in the task brief/reference evidence, not the arrays. Do not duplicate the installed-skill catalog in the ledger.
4. **Unknown keys:** Reject unknown keys at all ledger object levels, including within `skills`, preserving the current exact-allowlist approach. Only add optional `job_title` and `skills` to the two agent record types; root, fleet, and `resume_cmd` allowlists do not change.
5. **Supplementary fallback:** Existing crew-side fallback stays available within existing task bounds. A supplementary skill actually selected within scope can be reconciled into `assigned` before recording it as `loaded`; this is metadata reconciliation, not new execution permission, and never excuses required initial full-skill preflight.
6. **Identity versus task freshness:** A verified idle/untasked session remains a known identity even with no task or empty metadata. Unknown/unverified session identity remains pending; no task assignment alone makes a verified identity pending. `loaded` is a last-observed claim, never standalone proof. Keep current task/context evidence external; add no task ID or authorization fields to the ledger.
7. **Lifecycle freshness:** On task/brief revision or changed selection, refresh `assigned` and clear/reconcile stale `loaded`. Before resume/reconnect or `/new`, establish the current task and context, refresh the bounded brief, and re-equip selected skills if their complete content is unavailable or cannot be established in that context. Compaction alone proves neither skill loss nor continued availability: retain prior read/provision evidence as historical, reassess current-context availability, and re-equip only when unavailable or uncertain. No hook or automation is added. Do not backfill historical titles/skills.

## 4. Engineering Constraints

- `[AUTONOMOUS-SHIP]` documentation/example and existing-fixture assertion changes only; no high-stakes business logic.
- Ponytail: minimum diff is two files, no dependency, validator framework, registry, hierarchy, head flag, nested teams, autonomous hiring, migration, or runtime service.
- Preserve strict privacy, safe-I/O, explicit uncertainty, current authorization, READY, independent review, and unique-identity safeguards.
- At the initial planning phase, this plan was the only authorized write; the later separately approved two-file implementation is tracked in §7. Further work still requires separate approval.

## 5. Proposed Implementation Tasks

### - [x] Task 1: Specify metadata in the canonical ledger reference `[AUTONOMOUS-SHIP]`

- **Scope:** Modify only `.agents/reference/crew/README.md`; current example/allowlist at lines 71-114 and relevant lifecycle at 61-68, 130-142.
- **Consumes:** Existing schema and lifecycle in §2; skill ID lookup in `.agents/INDEX.md`.
- **Produces:** Exact optionality, canonical semantics, freshness rules, and inert examples below.
- **Exact minimal old/new replacements for the canonical reference:**

Replace this exact existing allowlist prefix (the remainder of its paragraph, beginning `` `pane_id`, when present``, stays verbatim):

```markdown
The root contains only `workspace_name` and `agents`. An ORCHESTRATOR record has only `session_id`, extensible `cli`, `type`/role, optional `pane_id` and `model`, `resume_cmd`, and `fleets`; each fleet has only `agents`, and each fleet agent has only `session_id`, `cli`, `type`, optional `pane_id` and `model`, and `resume_cmd`. Existing records without `pane_id` or `model` remain valid.
```

with:

```markdown
The root contains only `workspace_name` and `agents`. An ORCHESTRATOR record has required `session_id`, extensible `cli`, `type`/role, `resume_cmd`, and `fleets`, plus optional `pane_id`, `model`, `job_title`, and `skills`; each fleet has only `agents`, and each fleet agent has required `session_id`, `cli`, `type`, and `resume_cmd`, plus optional `pane_id`, `model`, `job_title`, and `skills`. Existing records without `pane_id`, `model`, `job_title`, or `skills` remain valid. A `skills` object has only optional `assigned` and `loaded` arrays; each array contains unique canonical skill IDs and each `loaded` ID must also occur in `assigned`.
```

Replace the earlier first-run clause `initialize only the existing minimal schema through the exact sibling temp followed by atomic rename.` with `initialize the existing minimal schema (including only the optional `job_title` and `skills` fields on agent records as defined below) through the exact sibling temp followed by atomic rename.`

Replace the later first-run clause `construct only the existing minimal schema;` with `construct the existing minimal schema plus only the optional `job_title` and `skills` fields defined above;`.

Replace the later sentence `Preserve the existing schema, safe IO/no-follow and anchored-rename requirements, executable/argv validation, and pending/conversation safeguards; do not add commands, automation, schema fields, or runtime guarantees.` with `Preserve the existing schema allowlists, safe IO/no-follow and anchored-rename requirements, executable/argv validation, and pending/conversation safeguards; permit only the optional `job_title` and `skills` fields defined above, and do not add any other schema fields, commands, automation, or runtime guarantees.` Preserve all other wording in those surrounding paragraphs verbatim. The separate prohibition on task/capability/authorization/process/etc. fields and a second schema/catalog remains verbatim and in force.

- **Exact new metadata guidance insertion:** Insert the following paragraph immediately after the full existing schema/allowlist paragraph (after its unchanged `backup_argv` sentence) and before `Before use, validate JSON types...`:

```markdown
`job_title`, when present on an ORCHESTRATOR or fleet-agent record, is a string containing at least one non-whitespace character; preserve its authored value. It describes a specific assignment; `type` remains the broad role/persona. It is not identity, authorization, capability, or consent. `skills`, when present on those records, is an object containing only optional `assigned` and `loaded` arrays; `{}` and empty arrays are valid. Each array is a set represented as an array of unique, exact, case-sensitive canonical leaf skill IDs resolved through `.agents/INDEX.md`; resolve suite/router entries to a selected child `SKILL.md`, and reject paths, unknown/non-leaf IDs, duplicates, wrong types, and unknown keys. `loaded` must be a subset of `assigned`. Craft references such as `craft/anti-ai-slop.md` are not skills; keep them in task-brief/reference evidence. Do not duplicate an installed-skill catalog in the ledger.

`assigned` is descriptive and grants no permission. Existing supplementary crew-side skill fallback remains available within current task bounds; after actually selecting a supplementary skill within those bounds, reconcile its canonical ID into `assigned` before recording it in `loaded`. This metadata reconciliation neither expands execution permission nor replaces applicable dispatch-time complete-skill embedding/preflight. `loaded` is a last-observed claim only; complete skill content must have external evidence of being read/provided in the applicable current task context. A title, `type`, READY receipt, or cached ledger value alone does not prove current loading.

A verified idle/untasked session remains a known session with no task or skill metadata; absence of an assignment alone does not make it pending. Unknown/unverified session identity remains pending. On task/brief revision or changed skill selection, refresh `assigned` and clear/reconcile `loaded`. Before resume/reconnect or `/new`, establish current task/context and refresh the bounded brief; re-equip selected skills if their complete content is absent or cannot be established in that context. Compaction alone proves neither retention nor loss: preserve prior read/provision evidence as historical, reassess current-context availability, and re-equip only if availability cannot be established. No hook or automation is implied. Never guess historical titles or skills.
```

- **Proposed accepted inert JSON examples:** Include all four in the canonical reference, labelled “metadata-free legacy”, “populated optional metadata”, “empty skill arrays”, and “empty skills object”. Every root `agents[]` entry is an ORCHESTRATOR record with `fleets`; any worker is nested under `fleets[].agents[]`. Each example uses distinct placeholder IDs for ORCHESTRATOR and worker. These are structural examples only, not commands or real IDs.

```json
{"workspace_name":"example-project","agents":[{"session_id":"placeholder-orchestrator-legacy","cli":"example-cli","type":"ORCHESTRATOR","resume_cmd":{"executable":"example-cli","argv":["--resume-existing","placeholder-orchestrator-legacy"]},"fleets":[]}]}
```

```json
{"workspace_name":"example-project","agents":[{"session_id":"placeholder-orchestrator-populated","cli":"example-cli","type":"ORCHESTRATOR","resume_cmd":{"executable":"example-cli","argv":["--resume-existing","placeholder-orchestrator-populated"]},"fleets":[{"agents":[{"session_id":"placeholder-worker-populated","cli":"example-cli","type":"WORKER","job_title":"Documentation worker","skills":{"assigned":["writing-plans"],"loaded":["writing-plans"]},"resume_cmd":{"executable":"example-cli","argv":["--resume-existing","placeholder-worker-populated"]}}]}]}]}
```

```json
{"workspace_name":"example-project","agents":[{"session_id":"placeholder-orchestrator-empty-arrays","cli":"example-cli","type":"ORCHESTRATOR","resume_cmd":{"executable":"example-cli","argv":["--resume-existing","placeholder-orchestrator-empty-arrays"]},"fleets":[{"agents":[{"session_id":"placeholder-worker-empty-arrays","cli":"example-cli","type":"WORKER","skills":{"assigned":[],"loaded":[]},"resume_cmd":{"executable":"example-cli","argv":["--resume-existing","placeholder-worker-empty-arrays"]}}]}]}]}
```

```json
{"workspace_name":"example-project","agents":[{"session_id":"placeholder-orchestrator-empty-object","cli":"example-cli","type":"ORCHESTRATOR","resume_cmd":{"executable":"example-cli","argv":["--resume-existing","placeholder-orchestrator-empty-object"]},"fleets":[{"agents":[{"session_id":"placeholder-worker-empty-object","cli":"example-cli","type":"WORKER","skills":{},"resume_cmd":{"executable":"example-cli","argv":["--resume-existing","placeholder-worker-empty-object"]}}]}]}]}
```

- **Rejected inert metadata examples and reasons:** Document these inline as invalid metadata examples, not as runnable ledger records: `{"job_title":7}` (wrong type); `{"job_title":"   "}` (blank); `{"skills":{"assigned":"ponytail"}}` (wrong array type); `{"skills":{"assigned":["ponytail","ponytail"]}}` (duplicate); `{"skills":{"assigned":[],"loaded":["ponytail"]}}` (loaded-not-assigned); `{"skills":{"assigned":["not-in-index"]}}` (unknown/non-leaf ID); `{"skills":{"assigned":[],"other":[]}}` (unknown nested key); `{"skills":{}}` at root/fleet level (wrong location). No real session/private values are to be used.
- **Verification:** `git diff --check -- .agents/reference/crew/README.md` (expected exit 0); manually check the documented exact allowlist and preservation of all old safe-I/O and pending clauses. Examples are documentation, not runtime validation.

### - [x] Task 2: Assert the copied policy/examples in the existing adoption fixture `[AUTONOMOUS-SHIP]`

- **Scope:** Modify only `tests/adopt-acon-session-ledger.sh`, after the existing adopted-skill assertion at line 37.
- **Consumes:** Task 1 text/examples and existing fixture protections at lines 13-34, 45-62.
- **Produces:** Add exactly these runnable future Bash assertions after `grep -Fq 'Pane-pool policy and local session boundary' "$TARGET/.agents/skills/productivity/adopt-acon/SKILL.md"`:

```bash
grep -Fq '`job_title`, when present on an ORCHESTRATOR or fleet-agent record, is a string' "$TARGET/.agents/reference/crew/README.md"
grep -Fq '`skills`, when present on those records, is an object containing only optional `assigned` and `loaded` arrays' "$TARGET/.agents/reference/crew/README.md"
grep -Fq '`{}` and empty arrays are valid.' "$TARGET/.agents/reference/crew/README.md"
grep -Fq '"fleets":[{"agents":[{"session_id":"placeholder-worker-populated"' "$TARGET/.agents/reference/crew/README.md"
grep -Fq '"skills":{"assigned":[],"loaded":[]}' "$TARGET/.agents/reference/crew/README.md"
grep -Fq '"skills":{}' "$TARGET/.agents/reference/crew/README.md"
grep -Fq '`loaded` must be a subset of `assigned`.' "$TARGET/.agents/reference/crew/README.md"
grep -Fq 'A verified idle/untasked session remains a known session' "$TARGET/.agents/reference/crew/README.md"
grep -Fq 'Compaction alone proves neither retention nor loss' "$TARGET/.agents/reference/crew/README.md"
grep -Fq 'Never guess historical titles or skills.' "$TARGET/.agents/reference/crew/README.md"
grep -Fq '{"skills":{"assigned":[],"loaded":["ponytail"]}}' "$TARGET/.agents/reference/crew/README.md"
grep -Fq 'An ORCHESTRATOR record has required `session_id`, extensible `cli`, `type`/role, `resume_cmd`, and `fleets`, plus optional `pane_id`, `model`, `job_title`, and `skills`' "$TARGET/.agents/reference/crew/README.md"
grep -Fq 'each fleet agent has required `session_id`, `cli`, `type`, and `resume_cmd`, plus optional `pane_id`, `model`, `job_title`, and `skills`' "$TARGET/.agents/reference/crew/README.md"
assert_absent() {
  if grep -Fq -- "$1" "$TARGET/.agents/reference/crew/README.md"; then
    printf 'unexpected superseded text found: %s\n' "$1" >&2
    exit 1
  fi
}
assert_absent 'An ORCHESTRATOR record has only `session_id`, extensible `cli`'
assert_absent 'each fleet agent has only `session_id`, `cli`, `type`, optional `pane_id` and `model`'
assert_absent 'Existing records without `pane_id` or `model` remain valid.'
assert_absent 'initialize only the existing minimal schema through the exact sibling temp followed by atomic rename.'
assert_absent 'construct only the existing minimal schema;'
assert_absent 'Preserve the existing schema, safe IO/no-follow and anchored-rename requirements'
grep -Fq 'initialize the existing minimal schema (including only the optional `job_title` and `skills` fields on agent records as defined below)' "$TARGET/.agents/reference/crew/README.md"
```

- **Verification:** `bash tests/adopt-acon-session-ledger.sh` (expected exit 0 and `adoption fixture assertions passed`); `git diff --check -- tests/adopt-acon-session-ledger.sh`.
- **Evidence limit:** These assertions check that adoption copied specified text and an invalid example. Combined with existing fixture assertions, they check adoption/privacy behavior only. They do not parse actual ledger data or implement/test runtime schema enforcement. Wrong-type, unknown-key, duplicate, and subset cases are documented contract examples, not runtime-tested cases.

## 6. Future Acceptance Checklist

- [ ] Exact allowlist: root remains `workspace_name, agents`; fleet remains `agents`; `resume_cmd` remains `executable, argv, copy_cmd?, backup_argv?`; only ORCHESTRATOR and fleet-agent records gain optional `job_title` and `skills` alongside existing fields.
- [ ] Positive documented full-ledger cases: metadata-free old ORCHESTRATOR; populated worker nested under root ORCHESTRATOR → `fleets[]` → `agents[]`; distinct placeholder session IDs; valid empty arrays and separately valid `skills:{}`. Existing optional `pane_id`/`model` absence remains valid.
- [ ] New-field contract rejects wrong title/skills types, whitespace-only title, unknown object keys, duplicate IDs, unknown/non-leaf IDs, loaded-not-assigned, and skills at root/fleet levels. This rejection is runtime behavior only if a future separately authorized parser is found/implemented; no such validator is claimed here.
- [ ] Craft references stay in brief/reference evidence, never arrays; no skill catalog duplication.
- [ ] Supplementary skill fallback reconciles metadata within existing bounds only; does not confer permission. Verified idle identity is not pending solely for lacking a task; unknown session identity remains pending.
- [ ] Task revision/change, `/new`, reconnect/resume, and compaction follow §3 freshness rules; compaction does not force unconditional reload, while dispatch-time full selected-skill preflight remains binding.
- [ ] Adoption fixture continues proving sentinel non-leakage, target ledger preservation, ignore uniqueness, idempotency, dry-run, and symlink protection; added assertions prove only copied documentation presence.
- [ ] No runtime behavior, live-ledger state, or independent review is claimed without separate evidence.

## 7. Rollback, Scope, and Verification Limits

No migration or backfill is planned. If an actual parser is discovered during an approved implementation, stop and seek scope/contract clarification before expanding these two files or claiming runtime acceptance behavior. Preserve historical uncertainty and old records.

**Scope deviation:** I performed recursive workspace-wide Markdown/shell searches outside the named roots and read `docs/plans/2026-10-14-terminal-fleet-lifecycle.md`; this was unauthorized and is not retroactively approved. Those reads stopped; I removed reliance on the historical plan and performed no further `docs/plans` reads except this plan readback. The plan's implementation scope is only `.agents/reference/crew/README.md` and the already-existing `tests/adopt-acon-session-ledger.sh`; no root/rule/README/adoption-skill edit is justified because inspected summaries contain no conflicting allowlist.

**Original planning-phase limits (historical):** During the initial plan-only phase, no shell commands, tests, builds, Git operations, or runtime validation were performed; implementation and independent review were not then authorized. The earlier scope deviation remains disclosed and was not retroactively approved. CodeGraph tools were unavailable; selected planning skills were `writing-plans`, `writing-for-agents`, and `ponytail`.

### Execution evidence and limits

- Final verification evidence reports `bash -n tests/adopt-acon-session-ledger.sh`, `bash tests/adopt-acon-session-ledger.sh` (`adoption fixture assertions passed`), scoped `git diff --check`, and an in-memory four-example hierarchy/canonical-ID check all passed (exit 0). The example check is documentation-only, not production validation.
- G8 code review: **PASS**; G9 security review: **PASS**. Both were separate read-only reviewer contexts and report `CORRELATED_REVIEW` (same model identity); neither establishes runtime behavior.
- Frozen raw two-path patch SHA-256: `d8209c5e45eba880befa14a35e717e5a0c5db435b4c356eb3c3c341ae074cf75`.
- No commit or push. No runtime validator, automatic skill activation, or historical metadata migration was added. ORCHESTRATOR separately recorded verified title/skill observations for only the two new current writer/reviewer records; this plan includes no actual session IDs, and its author did not read `.acon`.
- Completion is limited to the documentation and adoption-fixture changes and their reported checks/reviews. It is not runtime schema enforcement or proof of live skill loading. Git-index byte identity remains unproven per the evidence report.

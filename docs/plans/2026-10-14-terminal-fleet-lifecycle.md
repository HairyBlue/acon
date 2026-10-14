# Implementation Plan: Terminal Fleet Lifecycle and Safe Session Handoff

- **Plan File:** `docs/plans/2026-10-14-terminal-fleet-lifecycle.md`
- **Author:** Captain-authorized planning worker
- **Date:** 2026-10-14
- **Status:** In Progress — Captain approved this bounded G9 REQ-003 r2 correction and one additional G8 review cycle beyond the normal cap; implementation/review completion remains unchecked
- **Target Branch:** Existing branch; no branch operation authorized

## 1. Objective and constraints

Reconcile ACON's active surface-routing, role-intake and ledger-ownership instructions, and specify a safe terminal fleet lifecycle. Documentation changes only within Captain-approved bounded slices; the current proceed authorizes only the G9 REQ-003 r2 README/plan documentation correction and one additional G8 review cycle beyond the normal cap. No runtime implementation, schema fields, registry, daemon, adapter, dependency, guaranteed resume behavior, or runtime smoke-test claim.

Requirement IDs REQ-001–REQ-007 remain stable. REQ-001–REQ-007 were first recorded at revision `r1`; the Captain-approved G9 safety correction revises REQ-003 to `r2` without renumbering or erasing `r1`. Update affected task/proof mappings and preserve earlier decisions. Implementation and independent G8/G9 acceptance checkboxes remain unchecked.

### Revision history

- **r1 — original approved decisions:** REQ-001–REQ-007 and TASK-02–TASK-05 as originally recorded; retained as historical context.
- **r2 — REQ-003, Captain proceed:** G9 found a temp-path symlink check-to-use gap. Require exclusive no-follow temp creation using host-supported primitives; verify opened-file identity and binding to the expected workspace parent; write through the verified handle; reverify parent/temp association before rename and require the rename operation itself be bound to the verified parent directory objects/handles and expected temp entry, without re-resolving an untrusted path; fail closed and preserve existing bytes if a temp/parent is existing, changed, unsafe, or any primitive is unknown/unavailable. The rename clarification completes r2; it creates no new requirement. Captain also expressly approved one additional G8 review cycle beyond the normal cap. No runtime code, schema change, lock, registry, framework, dependency, or accepted runtime proof.

## 2. Requirement decisions

- **REQ-001 r1:** Terminal/agent-CLI orchestrators use separately opened, persona-equipped peer agents, never native subagents, even if peer mechanism fails. Desktop/IDE surfaces unable to open pane-plus-agent-CLI peers may use isolated native subagents only when every required capability is evidenced `AVAILABLE` and the exact assignment separately approved. Decide by actual surface/capabilities, not brand; unknown is `BLOCKED`.
- **REQ-002 r1:** When role is unknown, ask Normal Agent vs Orchestrator before role-dependent action. Existing verified role or approved handoff establishes role; do not ask assigned workers again. A standalone Normal Agent never spawns crew or assumes orchestration authority; it may perform its authorized bounded task or join by approved assignment. User manually opens/resumes the orchestrator.
- **REQ-003 r1 (historical):** Terminal orchestrator uses only local `.acon/sessions.json` and sibling `.acon/sessions.json.tmp`, named explicitly in `AGENTS.md`. On first run, safely initialize absent ledger from verified current orchestrator identity/workspace, using the existing minimal schema and temp/atomic rename. Reject symlinks; validate ledger and reconcile owned live conversations before crew launch/resume. Malformed/wrong-workspace/unknown-identity/permission/I/O failures pause and preserve bytes. Missing ledger has an initialization path, not circular permanent BLOCKED.
- **REQ-003 r2 (current):** Retain all r1 paths, schema, initialization, validation, reconciliation, and fail-closed requirements. Additionally, create the exact sibling temp exclusively with host-supported no-follow semantics; verify opened-file identity and binding to the expected workspace parent; write only through that verified handle (never reopen by untrusted path); verify parent/temp association before atomic rename, and bind the rename operation itself to the verified parent directory objects/handles and expected temp entry without untrusted-path re-resolution. Reject existing, changed, replaced, or unsafe temp/parent. Unknown/unavailable host primitives or any validation, creation, identity, parent-binding, write, or rename failure means BLOCKED/pause and preserve existing ledger bytes. No invented portable API or unsupported guarantee; no lock, registry, framework, or dependency.
- **REQ-004 r1:** Orchestrator owns ledger writes, except an explicitly appointed role may perform one exact bounded update under orchestrator authority while orchestrator suspends writes. Validate update and return ownership. Never concurrent writers or blanket crew permission. Prefer direct initialization; delegate bootstrap only if safe exact bootstrap is evidenced, otherwise pause/manual supported alternative.
- **REQ-005 r1:** Register each actual verified launch/join and actual role/model/pane association; update only after verified changes. Remove entry only on confirmed authorized retirement, not completion/disconnect/idle/timeout/missing pane. Unreachable identity remains pending and is never duplicated. Failed registration after launch freezes further launches and reports actual live process, without guessed rollback/kill. Preserve schema, exact ignore paths, safe resume-only validation; no claims about unknown exact-ID resume.
- **REQ-006 r1:** Existing normal agent adoption requires explicit Captain confirmation of identity/workspace, persona, available model/effort. Preserve session; no silent model/persona switch or writer-context reuse for independent review. Changes require supported control plus consent; otherwise pause/offer separately approved alternative, no restart guess.
- **REQ-007 r1:** Confirmed joining agent outside fleet geometry may move only its existing verified owned session to evenly distributed right-side fleet panes, keeping orchestrator alone pinned left. Respect approved mission-wide pane/live ceiling, host-attested geometry/readability/resources, ownership and non-focus behavior. No foreign moves, duplicate sessions, silent closure/recycle or layout destruction. Unsupported safe movement queues/pauses; update pane ID only after verified relocation.

All existing authorization, skill-preflight, scope, workspace/review isolation, independent G8/G9, primary project-execution and Captain Git-authority invariants remain binding.

## 3. Bounded touchpoint inventory and exclusions

| Path | Active conflicting seam to reconcile |
|---|---|
| `.agents/reference/crew/README.md` | Authorization barrier, host-neutral orchestration, manual ledger, sole physical writer, schema/resume rules |
| `AGENTS.md` | §1 role and child/peer route; §2 Phase III route; §4 bootstrap, persona dispatch and authorized roles; explicit ledger paths |
| `.agents/rules/agent-control-plane.md` | Same active clauses as AGENTS mirror |
| `.agents/skills/productivity/decision-gates/SKILL.md` | §2 child-or-peer lifecycle; §3 generic crew lifecycle and pane cap |
| `.agents/skills/productivity/grill-me/SKILL.md` | Existing peer/subagent scout permission and intake sequencing |
| `.agents/skills/productivity/prompt-master/SKILL.md` | Active dispatch guidance/pointers |
| `.agents/skills/productivity/prompt-master/references/platforms/coding-agents.md` | Platform routing recommendations |
| `.agents/skills/productivity/adopt-acon/SKILL.md` | “Pane-pool policy and local session boundary” manual-only ledger prose |

**Index disposition:** `.agents/INDEX.md` is explicitly excluded from writes. Its current “Agent Orchestration & Control Plane” row already points to `AGENTS.md`, the rule mirror and canonical portable fleet reference; the revised canonical contract remains reachable without an index edit. Evidence: `.agents/INDEX.md`, that row. No conditional or unassigned edits are permitted.

Other exclusions: `CLAUDE.md` is a symlink to AGENTS and is not separately edited; `.gitignore` already contains each exact ledger path once; scripts, tests, runtime ledger, settings, other plans, unrelated schemas/workflows, historical provenance inventories and generic role labels that grant no route are not changed. `scripts/adopt.sh` and `tests/adopt-acon-session-ledger.sh` are read-only seam/verification evidence. Adoption is not invoked.

## 4. Implementation tasks

Sequential slices, no overlapping workers, at most three files each. Documentation/static assertions do not establish runtime behavior. Every task consumes and produces explicit below; no slice is authorized until Captain sign-off.

### - [ ] TASK-02 — Canonical surface route and ledger lifecycle `[AUTONOMOUS-SHIP]`

- **Requirements:** REQ-001 r1, REQ-002 r1, REQ-003 r2 (r1 retained historically), REQ-004 r1, REQ-005 r1, REQ-006 r1, REQ-007 r1.
- **Files:** `.agents/reference/crew/README.md` only.
- **Consumes:** Existing authorization/capability/unsupported-mode rules and existing manual-ledger schema.
- **Produces:** Canonical route, role intake, first-run and all lifecycle ordering, without changing schema.
- **Exact edits:** In “Host-neutral orchestration”, replace/qualify generic child-or-peer allowance with:

```markdown
### Route by execution surface

Terminal/agent-CLI ORCHESTRATORS use separately opened, persona-equipped peer agents and never native subagents, including after peer failure. Desktop/IDE surfaces unable to open pane-plus-agent-CLI peers may use isolated native subagents only when every required delegation, context/workspace isolation, supervision, communication, completion-delivery and independent-review capability is evidenced AVAILABLE and the exact assignment is separately approved. Route by actual surface and task-local evidence, never brand. UNKNOWN is BLOCKED. Peer failure on a terminal route pauses; it does not authorize native fallback. All current authorization, skills, scope, workspace/review isolation, G8/G9, primary-execution and Captain Git invariants remain binding.

When acting role is unestablished, ask the Captain Normal Agent or ORCHESTRATOR before role-dependent action. Verified existing role or approved crew handoff establishes role; assigned workers are not asked again. A standalone Normal Agent never spawns crew or assumes orchestrator authority; it may perform its Captain-authorized bounded task or join by approved assignment. The user manually opens/resumes the ORCHESTRATOR; ledger data never launches it.
```

In “Manual orchestrator session ledger”, replace the existing sentence “Only the one manually active ORCHESTRATOR writes the ledger.” with this precise ownership rule:

```markdown
The manually active ORCHESTRATOR owns ledger writes. It may appoint one bounded crew role for one exact delegated update under ORCHESTRATOR authority only while suspending its own writes; validate the result, then return write ownership to the ORCHESTRATOR before any further write. No concurrent writers or blanket crew permission. Prefer direct safe bootstrap initialization; delegate ledger bootstrap only when the exact safe bootstrap is evidenced, otherwise pause and request the smallest supported manual alternative.
```

Add lifecycle text directly after the existing manual-ledger validation/write rules:

```markdown
The only ledger paths are local `.acon/sessions.json` and exact sibling `.acon/sessions.json.tmp`; `AGENTS.md` names both. Before any ledger read/write, reject symlinks (including dangling links) for both paths, validate existing JSON against the current minimal schema and active workspace, and reconcile actual owned live conversations. On first terminal orchestrator run with no ledger, verify the current orchestrator's actual identity and active workspace from supported runtime evidence; construct only the existing minimal schema; persist it using the race-resistant temp-write/rename procedure specified by REQ-003 r2. Never invent IDs. Wrong workspace, malformed data, unknown identity, permission/I/O failure or failed reconciliation pauses and preserves existing bytes. Missing ledger alone is not a permanent BLOCKED cycle.

Order: initialize/validate ledger; reconcile owned live conversations; confirm current assignment authorization, capabilities, role and workspace; launch/resume only if eligible; immediately register each actual verified launch/join using existing schema fields and verified session/CLI/type/model/pane associations; validate and persist; only then proceed to another launch. If launch occurred but registration/persistence fails, freeze further launches and report the real live process; never kill or rollback by guess. Update associations only after verified role/model/pane change. Keep unknown/unreachable identity pending; never duplicate/recreate. Remove roster entry only after confirmed authorized retirement/removal, never task completion, disconnect, idle, timeout or merely missing pane. Preserve exact ignore paths once each; no secrets/source live IDs.

A first-run normal agent is not silently adopted into a fleet: the Captain explicitly opts in and confirms actual identity/workspace, persona/role and available model/effort. Preserve its live session. No silent model/persona change or independent review in a writer context. Change only with evidenced supported control and consent; otherwise pause and offer separately approved alternative, never restart by guess.

For a confirmed joining agent outside fleet geometry, move only its existing verified owned session to evenly distributed right-side fleet panes, retaining the pinned ORCHESTRATOR alone on the left. Respect approved mission-wide pool/live ceiling and current host-attested readability/geometry/resources, pane ownership and non-focus behavior. No foreign move, duplicate, silent close/recycle or layout destruction. Unsupported safe move/geometry queues/pauses. Update pane locator only after verified relocation. Documentation is not runtime evidence; exact-ID resume remains UNKNOWN absent CLI/version proof.
```

Preserve all current schema key restrictions and resume-only safeguards. Existing schema inventory (from README): root `workspace_name, agents`; ORCHESTRATOR record `session_id, cli, type, pane_id?, model?, resume_cmd, fleets`; fleet record `agents`; fleet-agent record `session_id, cli, type, pane_id?, model?, resume_cmd`; `resume_cmd` `executable, argv, backup_argv?`. No new keys.
- **REQ-to-proof map:** REQ-001 route paragraph and terminal failure clause; REQ-002 role paragraph; REQ-003 r2 paths/first-run sequence, exclusive no-follow creation, verified handle/identity and parent binding, pre-rename association check, fail-closed preservation and BLOCKED behavior (plus retained r1 initialization/schema/reconciliation); REQ-004 replacement ownership paragraph; REQ-005 ordered registration, pending, retirement and failure clauses; REQ-006 normal-agent opt-in paragraph; REQ-007 verified relocation paragraph.
- **Static verification (expected exit 0):** `git diff --check -- .agents/reference/crew/README.md`. Then run the following Python 3 stdlib command after implementation; it checks exact normative text and absence of the superseded owner clause, and inventories unchanged schema keys from the actual canonical source:

```bash
python3 - <<'PY'
from pathlib import Path
p=Path('.agents/reference/crew/README.md'); s=p.read_text()
required=[
'Terminal/agent-CLI ORCHESTRATORS use separately opened, persona-equipped peer agents and never native subagents, including after peer failure.',
'Desktop/IDE surfaces unable to open pane-plus-agent-CLI peers may use isolated native subagents only when every required delegation, context/workspace isolation, supervision, communication, completion-delivery and independent-review capability is evidenced AVAILABLE and the exact assignment is separately approved.',
'When acting role is unestablished, ask the Captain Normal Agent or ORCHESTRATOR before role-dependent action.',
'The manually active ORCHESTRATOR owns ledger writes.',
'only while suspending its own writes; validate the result, then return write ownership to the ORCHESTRATOR before any further write. No concurrent writers',
'On first terminal orchestrator run with no ledger, verify the current orchestrator\'s actual identity and active workspace from supported runtime evidence;',
'immediately register each actual verified launch/join using existing schema fields',
'Keep unknown/unreachable identity pending; never duplicate/recreate.',
'Remove roster entry only after confirmed authorized retirement/removal',
'If launch occurred but registration/persistence fails, freeze further launches',
'A first-run normal agent is not silently adopted into a fleet: the Captain explicitly opts in',
'move only its existing verified owned session to evenly distributed right-side fleet panes',
'exact-ID resume remains UNKNOWN absent CLI/version proof.',
]
assert all(x in s for x in required), [x for x in required if x not in s]
assert 'Only the one manually active ORCHESTRATOR writes the ledger.' not in s
assert s.count('`.acon/sessions.json`') >= 1 and '`.acon/sessions.json.tmp`' in s
import json,re
blocks=re.findall(r'```json\n(.*?)\n```',s,re.S)
assert blocks, 'canonical JSON example missing'
obj=json.loads(blocks[0])
def exact_keys(value, required, optional=()):
 assert set(required) <= value.keys() <= set(required)|set(optional),(set(required),set(optional),value.keys())
exact_keys(obj,('workspace_name','agents'))
assert isinstance(obj['agents'],list) and len(obj['agents'])>=1
orch=obj['agents'][0]; exact_keys(orch,('session_id','cli','type','resume_cmd','fleets'),('pane_id','model'))
assert orch['type']=='ORCHESTRATOR' and isinstance(orch['fleets'],list)
exact_keys(orch['resume_cmd'],('executable','argv'),('backup_argv',))
for key in ('argv','backup_argv'):
 if key in orch['resume_cmd']: assert isinstance(orch['resume_cmd'][key],list) and all(isinstance(x,str) for x in orch['resume_cmd'][key])
for fleet in orch['fleets']:
 exact_keys(fleet,('agents',)); assert isinstance(fleet['agents'],list)
 for agent in fleet['agents']:
  exact_keys(agent,('session_id','cli','type','resume_cmd'),('pane_id','model'))
  exact_keys(agent['resume_cmd'],('executable','argv'),('backup_argv',))
  for key in ('argv','backup_argv'):
   if key in agent['resume_cmd']: assert isinstance(agent['resume_cmd'][key],list) and all(isinstance(x,str) for x in agent['resume_cmd'][key])
# G9 REQ-003 r2 static guardrails; these assert contract text only, not host/runtime guarantees.
for text in ('Create the temp exclusively with host-supported no-follow semantics','verify the opened file identity and its binding to the expected workspace parent','write through that verified handle without reopening the untrusted path','Before atomic rename, reverify the parent and temp association','require the rename operation itself to be host-supported and anchored/bound to the already verified parent directory objects or handles and expected temp entry, without re-resolving an untrusted path','Reject an existing, replaced, changed, or otherwise unsafe temp or parent','Require host-supported primitives for all these properties; if any required primitive or safe equivalent—including anchored rename semantics—is unknown or unavailable, pause as BLOCKED and preserve existing ledger bytes','Any validation, creation, identity, parent-binding, write, or rename failure preserves existing ledger bytes'):
 assert text in s,text
print('TASK-02 static normative-text, parsed example-schema, and REQ-003 r2 assertions passed; runtime behavior NOT tested')
PY
```

Expected stdout exactly `TASK-02 static normative-text, parsed example-schema, and REQ-003 r2 assertions passed; runtime behavior NOT tested`; exit 0. This parses the README's existing inert JSON example and checks required/optional keys recursively against its current hierarchy. It proves only static conformance of the documented example; it does not validate a live ledger, runtime parsing, initialization or atomic writes.

### - [ ] TASK-03 — Reconcile all constitution/mirror route and role clauses `[AUTONOMOUS-SHIP]`

- **Requirements:** REQ-001 r1, REQ-002 r1, REQ-003 r1, REQ-004 r1.
- **Files:** `AGENTS.md`, `.agents/rules/agent-control-plane.md` only; do not separately edit `CLAUDE.md` symlink.
- **Consumes:** TASK-02 canonical wording and current constitution/mirror.
- **Produces:** Matching edits throughout both files, not merely §1. Search and reconcile every active operative authorization for child, native, peer and “isolated child” routes in §1, §2 Phase III, §4 bootstrap, persona selection, skill handoff, tiered dispatch, independent review and Git/authority clauses. Retain historical/generic role labels only where they do not grant terminal native routes. Resolve blanket descriptions of every primary as orchestrator so Captain-selected Normal Agent role is allowed without granting crew authority.
- **Exact policy text:** Add to §1 and link canonical route; use this text to replace blanket-primary clauses wherever they actively establish the role: “Captain may establish the acting role as Normal Agent or ORCHESTRATOR. If role is unestablished, ask before role-dependent action; verified role or approved crew handoff establishes it. Normal Agent does not spawn crew or assume orchestration authority and may execute only its Captain-authorized bounded task or join by approved assignment. ORCHESTRATOR remains a control role and performs no project investigation, edits, builds/tests, or Git operations; its documented local ledger access is limited to `.acon/sessions.json` and `.acon/sessions.json.tmp` and confers no project permission. The user manually opens/resumes it.”

Replace active route grants in all listed sections with: “Terminal/agent-CLI ORCHESTRATORS use separately opened persona-equipped peers, never native subagents, including after peer failure. Desktop/IDE surfaces unable to open pane-plus-agent-CLI peers may use isolated native subagents only when every required capability is evidenced AVAILABLE and the exact assignment is separately approved. Route by actual surface/capability, never brand; UNKNOWN is BLOCKED.” Preserve all other approval, skills, isolation, scope, G8/G9 and Captain authority rules. Physical mirror must remain byte-identical.
- **REQ-to-proof map:** REQ-001 every active route clause; REQ-002 blanket-primary role grants plus role-intake and standalone Normal Agent clauses; REQ-003 both exact paths and manual-start statement; REQ-004 pointer to canonical sole-writer/appointed-handoff/no-concurrency rule.
- **Static verification (expected exit 0):** `cmp -s AGENTS.md .agents/rules/agent-control-plane.md`; `git diff --check -- AGENTS.md .agents/rules/agent-control-plane.md`; then:

```bash
python3 - <<'PY'
from pathlib import Path
files=['AGENTS.md','.agents/rules/agent-control-plane.md']
route='Terminal/agent-CLI ORCHESTRATORS use separately opened persona-equipped peers, never native subagents, including after peer failure.'
desktop='Desktop/IDE surfaces unable to open pane-plus-agent-CLI peers may use isolated native subagents only when every required capability is evidenced AVAILABLE and the exact assignment is separately approved.'
for f in files:
 s=Path(f).read_text()
 for text in (route,desktop,'Captain may establish the acting role as Normal Agent or ORCHESTRATOR.','If role is unestablished, ask before role-dependent action; verified role or approved crew handoff establishes it.','Normal Agent does not spawn crew or assume orchestration authority','ORCHESTRATOR remains a control role and performs no project investigation, edits, builds/tests, or Git operations;','The user manually opens/resumes it.','.acon/sessions.json','.acon/sessions.json.tmp','manual-orchestrator-session-ledger'):
  assert text in s, (f,text)
assert Path(files[0]).read_bytes()==Path(files[1]).read_bytes()
print('TASK-03 static route/role/ledger-pointer and mirror assertions passed; runtime behavior NOT tested')
PY
```

Expected stdout exactly `TASK-03 static route/role/ledger-pointer and mirror assertions passed; runtime behavior NOT tested`; exit 0. Additionally search every changed file for active permission phrases before dispatch: `grep -nEi 'child or peer|child-or-peer|isolated child|native subagent|primary agent|primary.*orchestrat' AGENTS.md .agents/rules/agent-control-plane.md`. Review each match in its full section; historical references may remain only if not granting a conflicting route/role. Static text/mirror checks do not prove harness enforcement.

### - [ ] TASK-04 — Reconcile decision gates and grill-me scouting/role procedure `[AUTONOMOUS-SHIP]`

- **Requirements:** REQ-001 r1, REQ-002 r1.
- **Files:** `.agents/skills/productivity/decision-gates/SKILL.md`, `.agents/skills/productivity/grill-me/SKILL.md` only.
- **Consumes:** TASK-02 canonical route; current gate and grill procedures.
- **Produces:** Revised lifecycle route and role-intake procedure, removing grill-me's existing permission for peer/subagent scouting on the terminal path.
- **Exact edits:** In decision-gates §2 and §3 replace operative generic child-or-peer route with the surface-specific route verbatim from TASK-02. In BOTH files insert this identical block at the crew-routing/intake section, replacing conflicting operative route text:

```markdown
Terminal/agent-CLI ORCHESTRATORS use separately opened persona-equipped peers, never native subagents, including after peer failure. Desktop/IDE surfaces unable to open pane-plus-agent-CLI peers may use isolated native subagents only when every required capability is evidenced AVAILABLE and the exact assignment is separately approved. Route by actual surface and task-local evidence, never brand; UNKNOWN is BLOCKED.

If role is unestablished, ask Normal Agent versus ORCHESTRATOR before role-dependent action. Verified role or approved handoff establishes it; do not ask assigned workers again. A Normal Agent never spawns crew or assumes orchestrator authority; it may perform its Captain-authorized bounded task or join by approved assignment.
```

In grill-me specifically replace its existing permissive clause, “It may assign a bounded, separately isolated child-or-peer scout only after the Captain approves permitted host/role choices and the relevant capability evidence is available; unknown capability is `BLOCKED`.” with the block above. Do not retain that fallback: terminal peer failure is not authority for native scouting. Preserve G1 alignment and Captain authority.
- **REQ-to-proof map:** REQ-001 exact route and absence of operative terminal-native fallback in both files; REQ-002 exact role question and worker exception; existing grill permission is explicitly replaced, not supplemented.
- **Static verification (expected exit 0):** `git diff --check -- .agents/skills/productivity/decision-gates/SKILL.md .agents/skills/productivity/grill-me/SKILL.md`; then:

```bash
python3 - <<'PY'
from pathlib import Path
files=['.agents/skills/productivity/decision-gates/SKILL.md','.agents/skills/productivity/grill-me/SKILL.md']
route='Terminal/agent-CLI ORCHESTRATORS use separately opened persona-equipped peers, never native subagents, including after peer failure.'
desktop='Desktop/IDE surfaces unable to open pane-plus-agent-CLI peers may use isolated native subagents only when every required capability is evidenced AVAILABLE and the exact assignment is separately approved.'
role='If role is unestablished, ask Normal Agent versus ORCHESTRATOR before role-dependent action.'
for f in files:
 s=Path(f).read_text()
 for text in (route,desktop,role,'Verified role or approved handoff establishes it; do not ask assigned workers again.','A Normal Agent never spawns crew or assumes orchestrator authority;'):
  assert text in s,(f,text)
g=Path(files[1]).read_text()
old='It may assign a bounded, separately isolated child-or-peer scout only after the Captain approves permitted host/role choices and the relevant capability evidence is available; unknown capability is `BLOCKED`.'
assert old not in g, 'old child-or-peer scouting allowance remains'
print('TASK-04 static exact route/role replacement assertions passed; runtime behavior NOT tested')
PY
```

Expected stdout exactly `TASK-04 static exact route/role replacement assertions passed; runtime behavior NOT tested`; exit 0. The obsolete-clause assertion matches the literal current source sentence replaced above; literal checks do not establish scouting/harness behavior.

### - [ ] TASK-05 — Align prompt/platform and adoption lifecycle pointers `[AUTONOMOUS-SHIP]`

- **Requirements:** REQ-001 r1, REQ-002 r1, REQ-003 r2 (r1 retained historically), REQ-004 r1, REQ-005 r1, REQ-006 r1, REQ-007 r1.
- **Files:** `.agents/skills/productivity/prompt-master/SKILL.md`, `.agents/skills/productivity/prompt-master/references/platforms/coding-agents.md`, `.agents/skills/productivity/adopt-acon/SKILL.md` only.
- **Consumes:** TASK-02 canonical wording; existing prompt platform guidance and adoption boundary.
- **Produces:** Platform pointers consistent with actual surface; adoption's existing manual-only ledger prose reconciled with exact bounded handoff exception, initialization and roster semantics.
- **Exact edits:** Add to prompt-master dispatch guidance and coding-agents platform section: “Resolve actual execution surface and task-local capabilities, not provider brand. Terminal/agent-CLI ORCHESTRATORS use separately opened persona-equipped peers only, never native subagents; desktop/IDE native-subagent fallback requires inability to open peers, all required capabilities AVAILABLE and separate assignment approval; unknown is BLOCKED. Establish Normal Agent versus ORCHESTRATOR before role-dependent action when unknown; approved handoff/existing verified role is sufficient.” Link the canonical README.

In adopt-acon “Pane-pool policy and local session boundary”, insert this exact route-and-role block (identical to TASK-04):

```markdown
Terminal/agent-CLI ORCHESTRATORS use separately opened persona-equipped peers, never native subagents, including after peer failure. Desktop/IDE surfaces unable to open pane-plus-agent-CLI peers may use isolated native subagents only when every required capability is evidenced AVAILABLE and the exact assignment is separately approved. Route by actual surface and task-local evidence, never brand; UNKNOWN is BLOCKED.

If role is unestablished, ask Normal Agent versus ORCHESTRATOR before role-dependent action. Verified role or approved handoff establishes it; do not ask assigned workers again. A Normal Agent never spawns crew or assumes orchestrator authority; it may perform its Captain-authorized bounded task or join by approved assignment.
```

Replace its manual-only lifecycle language with this exact paragraph, preserving the existing copy/secret/ignore safeguards:

```markdown
The manually active ORCHESTRATOR owns ledger writes. It may appoint one bounded crew role for one exact delegated update under ORCHESTRATOR authority only while suspending its own writes; validate the result, then return write ownership to the ORCHESTRATOR before any further write. No concurrent writers or blanket crew permission. Prefer direct safe bootstrap initialization; delegate ledger bootstrap only when the exact safe bootstrap is evidenced, otherwise pause and request the smallest supported manual alternative.

On first terminal orchestrator run with no ledger, verify actual current identity and workspace, then initialize the existing minimal schema through the canonical race-resistant temp-write/rename procedure in `.agents/reference/crew/README.md#manual-orchestrator-session-ledger`. Reject symlinks and preserve bytes on malformed/wrong-workspace/unknown-identity/permission/I/O failure; unknown or unavailable safe host primitives pause as BLOCKED. After each actual verified launch/join, register its existing identity and verified role/model/pane association before another launch; registration failure freezes further launches and reports the real live process without guessed rollback. Keep unreachable identity pending without duplication; remove entries only after confirmed authorized retirement/removal. A first-run existing normal agent joins only after explicit Captain opt-in confirming identity/workspace, persona and available model/effort; preserve its live session. For relocation, use the canonical verified-owned-session and right-side-pane rule; update pane ID only after verified movement. Preserve the no-copy/no-secrets boundary and exact ignore paths; never blanket-ignore `.acon/`.
```

Keep current clauses preventing source ledger/IDs/provider state/credentials/internal scripts from being copied, preserve exact two ignore patterns, and do not blanket-ignore `.acon/`.
- **REQ-to-proof map:** REQ-001/002 prompt and coding-agent route/role literals; REQ-003 r2 canonical race-resistant IO pointer and BLOCKED fallback in adoption; REQ-004 adoption replacement of manual-only ownership; REQ-005 register/freeze/pending/retire clauses; REQ-006 explicit Captain opt-in; REQ-007 link to canonical verified relocation contract.
- **Static verification (expected exit 0):** `git diff --check -- .agents/skills/productivity/prompt-master/SKILL.md .agents/skills/productivity/prompt-master/references/platforms/coding-agents.md .agents/skills/productivity/adopt-acon/SKILL.md`; then Python literal assertions:

```bash
python3 - <<'PY'
from pathlib import Path
files=['.agents/skills/productivity/prompt-master/SKILL.md','.agents/skills/productivity/prompt-master/references/platforms/coding-agents.md','.agents/skills/productivity/adopt-acon/SKILL.md']
for f in files:
 s=Path(f).read_text()
 for text in ('actual execution surface','not provider brand','never native subagents','all required capabilities AVAILABLE','Normal Agent versus ORCHESTRATOR'):
  assert text in s,(f,text)
route='Terminal/agent-CLI ORCHESTRATORS use separately opened persona-equipped peers, never native subagents, including after peer failure.'
desktop='Desktop/IDE surfaces unable to open pane-plus-agent-CLI peers may use isolated native subagents only when every required capability is evidenced AVAILABLE and the exact assignment is separately approved.'
role='If role is unestablished, ask Normal Agent versus ORCHESTRATOR before role-dependent action.'
a=Path(files[2]).read_text()
for text in (route,desktop,role,'Verified role or approved handoff establishes it; do not ask assigned workers again.'):
 assert text in a,text
a=Path(files[2]).read_text()
for text in ('The manually active ORCHESTRATOR owns ledger writes.','only while suspending its own writes','No concurrent writers','On first terminal orchestrator run with no ledger','After each actual verified launch/join, register its existing identity','registration failure freezes further launches','Keep unreachable identity pending without duplication','confirmed authorized retirement/removal','explicit Captain opt-in confirming identity/workspace, persona and available model/effort','canonical verified-owned-session and right-side-pane rule','canonical race-resistant temp-write/rename procedure in the [portable fleet reference]','host-supported no-follow/exclusive creation','pause as BLOCKED','source ledger/IDs/provider state/credentials/internal scripts from being copied','never blanket-ignore `.acon/`'):
 assert text in a,text
assert 'Only the one manually active ORCHESTRATOR writes the ledger.' not in a
assert 'The user manually opens/resumes the ORCHESTRATOR' in a
plan=Path('docs/plans/2026-10-14-terminal-fleet-lifecycle.md').read_text()
task5=plan[plan.index('### - [ ] TASK-05'):plan.index('## 5. Integration, acceptance and review\n\n- [x] Captain approves')]
assert '- **Requirements:** REQ-001 r1, REQ-002 r1, REQ-003 r2 (r1 retained historically), REQ-004 r1, REQ-005 r1, REQ-006 r1, REQ-007 r1.' in task5
assert 'REQ-003 r2 canonical race-resistant IO pointer and BLOCKED fallback in adoption' in task5
print('TASK-05 static lifecycle, pointer, and REQ-003 revision-mapping assertions passed; runtime behavior NOT tested')
PY
```

Expected stdout exactly `TASK-05 static lifecycle, pointer, and REQ-003 revision-mapping assertions passed; runtime behavior NOT tested`; exit 0. Also run `bash tests/adopt-acon-session-ledger.sh`; expected exit 0 and exact output `adoption fixture assertions passed`. This fixture uses temporary copies and proves existing adoption behavior only, not live ledger semantics or host/runtime behavior. Do not invoke adoption against a real target.

## 5. Integration, acceptance and review

- [x] Captain approves plan before any implementation — Captain proceeded with the approved bounded G9 REQ-003 r2 safety correction; this authorizes no runtime changes or Git mutation.
- [ ] Execute TASK-02 through TASK-05 sequentially; each task's exact static assertions and scoped `git diff --check` exit 0; TASK-03 mirror `cmp` exits 0; TASK-05 fixture exits 0. REQ-003 r2 assertion added to TASK-02 proof and canonical pointer/BLOCKED assertions added to TASK-05; these affected proofs require re-run after the safety correction.
- [ ] Static inventory confirms only approved slice files changed; exact ignore lines remain once each; no CLAUDE, script, test, setting, dependency, secret, live ledger, unrelated plan changed.
- [ ] G7, then G8 and G9 after implementation. Captain expressly authorized one additional G8 cycle beyond the normal cap for this correction. G8 and G9 use distinct independent read-only contexts, each separate from the writer; one reviewer context cannot satisfy both. Record actual writer and reviewer identities/context separation. If reviewer model identity matches writer or other reviewer, record `CORRELATED_REVIEW`; identical Luna model does not collapse reviewer roles. Sequential peer reviewer contexts are permitted under the approved one-live-CLI ceiling, with no overlapping live reviewer CLI. Unknown capability/approval/isolation blocks acceptance; no review acceptance is recorded here.
- [ ] Captain reviews diff; independent G8/G9 re-review accepts the corrected scope; any git mutation separately authorized. This plan authorizes none.

All checks above establish static documentation, mirror, schema-key inventory, or temporary fixture properties only. They do not prove instruction loading, peer/native harness enforcement, host no-follow/exclusive semantics, handle identity, parent binding, race resistance, live ledger creation/atomicity/reconciliation, registration, pane movement, or CLI exact-ID resume. G9's prior finding is pending independent re-review; no runtime proof is claimed.

## 6. Risk and recovery cases

| Case | Required behavior |
|---|---|
| Missing ledger | Verified actual orchestrator identity/workspace; existing schema; canonical exclusive no-follow verified-handle temp write and atomic rename; unknown/unavailable host primitive pauses as BLOCKED |
| Malformed/wrong-workspace/symlink/changed temp or parent/identity/IO failure | Reject, preserve bytes, pause/BLOCKED; never path-reopen an untrusted temp |
| Wrong/stale pane | Verify ownership and session; safe approved move only; update ID after proof; else queue |
| Launch registration failure | Freeze new launches, report actual process, no guessed kill/rollback |
| Unknown resume identity | Pending; never duplicate/recreate; unknown CLI semantics stay unknown |
| Existing normal agent | Captain explicitly opts in and confirms identity/workspace, role/persona and model/effort; preserve live session |
| Unknown role | Ask Normal Agent vs ORCHESTRATOR; do not repeat for established/assigned workers |
| Terminal peer failure/native tools | Remain peer-only; pause/block, never native fallback |
| Desktop/IDE no peer | Isolated native route only with all required capabilities AVAILABLE and exact approval; else BLOCKED |
| Geometry/resource uncertainty | Respect ceilings/evidence; no foreign/focus-changing movement, closure or layout destruction |

Rollback is limited to reverting approved documentation diffs while preserving unrelated state, historical plan evidence, exact ignore entries and any actual local ledger. No destructive/runtime operation.

## 7. Planning evidence

Initial `git status --short --untracked-files=all` was empty, `git diff --stat` empty and `git diff --check` exited 0. Target plan did not exist. Existing ignore paths each occur once. `CLAUDE.md` resolves to AGENTS. `scripts/adopt.sh` was inspected read-only, never invoked; existing adoption fixture was inspected only. No expensive tests or runtime smoke tests were run during planning.

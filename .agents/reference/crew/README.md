# Portable fleet reference

This is a documentation contract, not a runtime integration, compatibility certification or enforcement system. It defines behavior required from the active installed harness and task-bound Captain authorization. Reading these conventions does not demonstrate support for delegated execution. No adapter, installer, dependency, provider configuration or executable payload is supplied.

## Capability discovery

`HarnessCapability` records task-local discovery evidence. Its required columns are exactly the following; the table defines the record, not an observation of an execution host.

| execution_host_ref | delegation | isolated_contexts | workspace_isolation | review_isolation | read_only_review | supervision | communication | completion_delivery | concurrency | model_selection | discovery_evidence | checked_at |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Task-local host reference | Capability value | Capability value | Capability value | Capability value | Capability value | Capability value | Capability value | Capability value | Capability value | Capability value | Task-local observation reference | Observation timestamp |

Capability values are exactly `[AVAILABLE, UNAVAILABLE, UNKNOWN]`. `UNKNOWN` is not `AVAILABLE`. References identify evidence of the installed harness, not a global tool or provider prerequisite. `checked_at` records when that evidence was checked. A commissioned Scout inspects advertised capabilities and records observations within its assigned boundary; it does not install or probe new adapters or expose secrets. Implementation identities may be recorded in task-local discovery evidence, never promoted into global dispatch defaults.

The required behavior is to deliver a bounded task to an isolated crew session (child or peer), isolate its context and assigned workspace, permit scoped supervisor communication, and return terminal completion evidence distinct from receipt. Separate read-only review must be possible in a context other than the writer's. The installed harness chooses how these behaviors are supplied; this reference supplies no transport, wake guarantee or automatic scheduling/polling assumption.

SHIP requires delegation into isolated crew child or peer sessions, applicable workspace isolation, supervision, communication, terminal completion delivery, review isolation and read-only review. A pane, tab, process or separate conversation is not proof of isolation. Concurrent writers require workspace isolation preserving exclusive file ownership. Absence of concurrency alone permits sequential isolated roles when demonstrated by the installed harness. Model selection availability must support the proposed routing; discovering an unavailable choice does not grant permission to substitute another.

## Crew launch authorization barrier

**Universal rule:** Before any crew launch on any host, require Captain authorization for the exact bounded assignment. This applies equally to native child tools/subagents and peer CLI or pane sessions, whatever CLI, provider, or model is used—including lower-capability and frontier models. An application/build request is task intent, not consent to CLI/model discovery, spawning, or spend. Selecting or scoping a `Codebase Scout` at first intake is not permission to spawn; if approval is missing, the first response asks and waits. Model intelligence, CLI/provider/model choice, native child routes, and inherited/default choices confer no exemption from this barrier. Skills grant no launch permission.

Follow this order:

1. Verify applicable ACON instructions are available and loaded through documented harness reading/loading evidence. File presence alone does not prove automatic injection. If instruction availability/loading cannot be verified, report that precise gap and do not launch.
2. Extract intent and perform mandatory alignment (`prompt-master`/G1 and any required grill-me) without primary project exploration.
3. Confirm which CLI/subscription choices the Captain permits for discovery, unless a still-valid explicit approval already covers the same scope, time, and cost. Disclose any quota/time/cost implications before discovery or launch; ask and wait before unapproved discovery. Bounded read-only orchestration bootstrap remains permitted only within already granted permissions.
4. Perform bounded discovery only on Captain-approved CLI/subscription choices. Evidence must show each required task capability is `AVAILABLE` for the proposed route; a native child tool, installed CLI, model listing, or visible pane alone is not evidence of isolated agent execution, workspace/context isolation, communication, supervision, terminal completion, or required review isolation.
5. Propose the available role, host/tool, model choice, supported effort, bounded task/scope and deliverable, plus a quota/time/cost notice and any expiry. Then request explicit authorization for that assignment. Do not silently substitute a CLI, model, provider, or native/default route.
6. Track authorization plainly: `REQUIRED_AUTHORIZATION` means Captain authorization is needed; `WAITING_APPROVAL` means the proposal is awaiting the Captain. Neither state permits a launch. `AUTHORIZED` means the Captain explicitly approved that bounded assignment; recheck current availability and authorization at dispatch. Reuse a still-valid approval only within its recorded scope, time, and cost; do not re-ask unnecessarily. Missing authorization waits; it is not itself a capability `BLOCKED` state.
7. Only after authorization and capability checks, complete role preflight: resolve Gate G5 skills through the canonical index, fully read and inline each complete selected skill, append applicable existing mandatory skills, and verify scope/isolation. Then launch only the approved bounded role.

If an actual required capability or authorized choice is unavailable or unknown after approved bounded discovery, report one precise `BLOCKED` capability reason and the smallest supported alternative. Do not silently degrade to a native tool or inherited default, weaken isolation/review, launch another Scout to decide permission, or create a recursive permission loop. Explicitly authorized read-only scouting may inform a required plan before sign-off; an explicitly authorized planning role with its own bounded write scope may draft the plan before sign-off. Required plan sign-off gates implementation, not that bounded preparation.

These are normative ACON rules, not a claim that Markdown can intercept arbitrary CLI spawns or that every host automatically loads instructions. Model intelligence is not enforcement. Use only installed-harness launch/isolation controls evidenced by discovery; if the required execution or review contract cannot be demonstrated, do not launch or weaken acceptance. Examples such as AGY, Pi, or Codex have no special status and are choices only when approved and evidenced.

## Host-neutral orchestration

### Route by execution surface

Terminal/agent-CLI ORCHESTRATORS use separately opened, persona-equipped peer agents and never native subagents, including after peer failure. Desktop/IDE surfaces unable to open pane-plus-agent-CLI peers may use isolated native subagents only when every required delegation, context/workspace isolation, supervision, communication, completion-delivery and independent-review capability is evidenced AVAILABLE and the exact assignment is separately approved. Route by actual surface and task-local evidence, never brand. UNKNOWN is BLOCKED. Peer failure on a terminal route pauses; it does not authorize native fallback. All current authorization, skills, scope, workspace/review isolation, G8/G9, primary-execution and Captain Git invariants remain binding.

### Crew startup readiness

For ORCHESTRATOR-managed crew, startup readiness applies to each new launch, resume, or reconnect activation. It does not apply to an unmanaged Captain-established Normal Agent. Before project investigation, edits, builds/tests, Git operations, or task dispatch, the crew member loads applicable baseline governance and its persona, then sends a fresh `READY` receipt to the ORCHESTRATOR over an existing approved communication channel whose delivery is demonstrated. The startup request may provide baseline and scope-safety instructions and a freshness challenge/activation receipt, but no project task. The ORCHESTRATOR initiates that startup-only readiness request over the demonstrated approved channel, or uses an evidenced supported harness startup trigger; opening an interactive CLI alone does not trigger a reply. The ORCHESTRATOR verifies the reply against the actual harness/session identity and current activation, receives it over the approved channel, acknowledges the verified receipt, and only then sends the bounded project brief.

Use actual harness/session metadata to establish identity; IDs are opaque and must never be guessed or invented. A self-reported textual ID alone is not identity evidence. A stale READY, prior activation receipt, visible idle pane/title/process, or launch success alone is not proof. Ordinary terminal output counts only when the ORCHESTRATOR actually observes and correlates it through the approved channel; unobserved stdout claims do not. If the harness cannot demonstrate the channel, identity correlation, receipt, or bounded wait semantics, report `BLOCKED` with the concrete reason and smallest owner-approved next step—no native fallback or ORCHESTRATOR project execution.

Before launch, establish a bounded startup wait using supported harness semantics. If that wait expires without verified READY, block task dispatch, reconcile the existing crew identity, and preserve the session alive and registered; do not loop-poll, auto-retry, relaunch, or clean up. READY proves startup communication/persona readiness only—not task completion, future task-skill loading, capability availability, authorization, spend approval, or launch permission. Before project execution, separately verify the bounded task brief, selected task skills, and tool permissions. Existing terminal completion delivery, retained-crew lifecycle, approval/resource ceilings, role permissions, and independent G8/G9 review remain unchanged. This is documentation only: it adds no transport, push/wake guarantee, heartbeat, server, hook, script, dependency, or ledger field.

When acting role is unestablished, ask the Captain Normal Agent or ORCHESTRATOR before role-dependent action. Verified existing role or approved crew handoff establishes role; assigned workers are not asked again. A standalone Normal Agent never spawns crew or assumes orchestrator authority; it may perform its Captain-authorized bounded task or join by approved assignment. The user manually opens/resumes the ORCHESTRATOR; ledger data never launches it.

Distinguish **ORCHESTRATION CONTROL** from **PROJECT EXECUTION**. When acting as ORCHESTRATOR, the primary agent may perform bounded runtime bootstrap: inspect tools exposed by its active harness; establish OS and the currently active terminal/multiplexer from safe runtime evidence; inspect supported CLI help/version and authentication readiness without revealing credential values; discover models on Captain-approved CLIs; create/control approved isolated crew sessions or panes; send bounded briefs; and inspect lifecycle/completion evidence. This is host/harness discovery only, not project codebase exploration. The ORCHESTRATOR delegates project investigation (including read-only repository scouting), edits, builds/tests, and git operations to assigned workers through demonstrated capabilities. A Normal Agent may execute its Captain-authorized bounded task directly and never acquires crew authority from this exception. Assigned workers execute their authorized bounded scopes; ORCHESTRATOR-only execution restrictions do not transfer to them.

Bootstrap does not require a prior Scout or already-proven delegation. Check whether the current session is Herdr-managed using caller context/IDs before considering Herdr; Herdr installation alone is not evidence. Otherwise identify the actually active terminal/multiplexer through documented runtime hooks and bounded metadata. Windows, macOS, Linux, WezTerm, cmux and other hosts are possible, not prerequisites, a fixed command matrix, installation mandate, or compatibility guarantee. Never control another focused/external session merely because its CLI exists. Discover supported launch, agent execution, context/workspace/review isolation, communication, supervision, and completion capabilities before selecting a mechanism. Terminal display/pane support is not proof of agent execution or workspace/review isolation.

A Captain's explicit request for a named operation (for example, opening AGY in a pane and sending `hi`) authorizes only that operation and minimally necessary bounded bootstrap checks; it does not authorize unrelated CLI/model discovery, crew launches, or spend. Do not ask repeatedly for that same approval. Apply the [crew launch authorization barrier](#crew-launch-authorization-barrier) before any other discovery or launch. Discover models only on Captain-approved CLIs. The orchestrator CLI does not dictate the worker CLI: approved choices are equal candidates. Never silently switch or spend. Discovery cannot fabricate tools or certify support by installation alone.

## Manual orchestrator session ledger

The user manually opens/resumes the ORCHESTRATOR after terminal closure; establish the acting role before role-dependent work. ACON never launches it from JSON, provides a daemon/launcher, or auto-starts every workspace. Before any ledger read or write, reject symlinks (including dangling links) for `.acon/sessions.json` and `.acon/sessions.json.tmp`. Then safely read the local `<active-project>/.acon/sessions.json`; if absent, verify actual ORCHESTRATOR identity and active workspace and initialize only the existing minimal schema through the exact sibling temp followed by atomic rename. Validate existing or initialized data against the current schema and workspace, then reconcile owned live conversations before considering resumes or any launch. Current Captain authorization and verified installed-harness capabilities—not JSON—authorize every launch/resume. Unknown or missing session/conversation identity stays pending and is reported; never silently recreate it.

### Optional Captain-approved idle rosters

After the user requests a project, the ORCHESTRATOR aligns the goal and proposes an optional selected roster; it does not automatically launch every persona type. Approve each instance's canonical persona, discovered available CLI/model/effort, separate context, resource limits, and bounded startup-only scope under the [crew launch authorization barrier](#crew-launch-authorization-barrier). Ask/propose per-instance choices from actual approved-CLI discovery; persona, CLI, and model are independent, with no fixed provider hierarchy or catalog. Warming is opt-in and capability/resource-gated; CLI initialization or resume may consume resources/quota, so disclose startup quota/time/cost before approval. Each instance may use the same persona as another (for example, two Scouts); `type` identifies its selected role/persona, while session IDs remain unique. Record only actual verified initialized sessions; unknown or unpersisted identities stay pending.

Claim an instance is persona-equipped only after its canonical persona definition is verified read/loaded through supported harness preflight or complete brief injection; a `type` label or visible pane is not proof. Idle initialization is limited to separately approved startup work: no project inspection, edits, tests, or children, and no model work beyond that approved initialization. At warm-up or task dispatch, fully read/embed selected skills and applicable existing G5-mandatory skills; defer unselected task-specific skills until real work is scoped, and never omit a selected skill. Before continuing, recheck current approval, capability/availability, session identity/workspace, and verified role loading/resume support. Stored `type`/`model` values are observational, not proof of loading or authorization; continuation intent alone is not launch/spend consent. Reuse still-valid bounded approvals without ritual re-asking. Resume only missing conversations in the approved saved roster after reconciling live owned conversations and checking current approval, identity, workspace, and capabilities; keep live owned conversations and never duplicate them. Leave unsupported or uncertain members pending and unused members idle. Issue fresh bounded work contracts and required skills before project work.

The pane pool starts with eight EMPTY slots in a right-side two-column by four-row grid beside the pinned ORCHESTRATOR. Grow only by two balanced slots per step, under the upfront Captain-approved mission-wide live-pane ceiling and host-attested geometry/readability/resource limits. Count across all tabs; opening tabs or relabeling panes does not evade the ceiling. Empty PTYs, live CLI processes, and assigned work are distinct: an empty PTY is not a process or task, and occupied/live work is never silently closed or recycled. These host/layout/resource facts are not persisted in the ledger. CLI, model, and host choices remain neutral and must be separately approved and evidenced.

The ledger is gitignored local data with this minimal shape. Example values are inert placeholders, not commands or permission:

```json
{
  "workspace_name": "active-project-name",
  "agents": [
    {
      "session_id": "actual-orchestrator-session-id",
      "cli": "extensible-cli-identifier",
      "type": "ORCHESTRATOR",
      "pane_id": "verified-owned-pane-locator",
      "model": "verified-cli-native-model-identifier",
      "resume_cmd": {
        "executable": "verified-cli-executable",
        "argv": ["<verified-id-resume-option>", "<actual-session-id>"],
        "copy_cmd": "verified-cli-executable '<verified-id-resume-option>' '<actual-session-id>'",
        "backup_argv": ["<verified-file-resume-option>", "<same-conversation-file-path>"]
      },
      "fleets": [
        {
          "agents": [
            {
              "session_id": "actual-fleet-session-id",
              "cli": "extensible-id-resume-cli-identifier",
              "type": "WORKER",
              "pane_id": "verified-owned-pane-locator",
              "model": "verified-cli-native-model-identifier",
              "resume_cmd": {
                "executable": "verified-cli-executable",
                "argv": ["<verified-id-resume-option>", "<actual-session-id>"],
                "copy_cmd": "verified-cli-executable '<verified-id-resume-option>' '<actual-session-id>'"
              }
            }
          ]
        }
      ]
    }
  ]
}
```

The root contains only `workspace_name` and `agents`. An ORCHESTRATOR record has only `session_id`, extensible `cli`, `type`/role, optional `pane_id` and `model`, `resume_cmd`, and `fleets`; each fleet has only `agents`, and each fleet agent has only `session_id`, `cli`, `type`, optional `pane_id` and `model`, and `resume_cmd`. Existing records without `pane_id` or `model` remain valid. A `pane_id`, when present, is a nonempty opaque string recorded only when the actual owned pane/CLI association is verified; omit it when unsupported or unknown. It is a last-observed locator hint—not ownership proof, permission, stable cross-restart identity, or a portable-host guarantee. Before pane control, reconcile it against the current caller-owned runtime session/conversation and workspace; never blindly target stale, reused, foreign, or ambiguous references. Refresh it after successful creation, resume, or relocation. A `model`, when present, is a nonempty string containing the last verified actual CLI-native model identifier, provider-qualified when that CLI uses provider qualification; omit it when unknown. This is observational metadata, not a model catalog, availability proof, current consent, or instruction to auto-select or switch models. Reconcile it against the actual runtime at launch/resume; current Captain CLI/model authorization governs. A `resume_cmd` has required `executable` and `argv`, plus optional `copy_cmd` and `backup_argv`. Each present argv field is an array of strings using that same executable. `copy_cmd`, when present, is a nonempty string displaying only the primary invocation represented by `executable` and `argv`; it may be omitted, so existing records remain valid. `backup_argv` is backward-compatible and optional: records without it remain valid, and ID-only CLIs omit it. Include a backup only when the approved CLI demonstrably supports existing-conversation file-path resume. Do not add task, capability, authorization, process, resource, route, permission, owner, revision, workspace-root, or registry fields, or create a second schema/catalog. The ledger is data, not consent or a substitute for current ACON rules, active-mission assignments, routes, or approvals.

Before use, validate JSON types and required hierarchy, unique actual session IDs (role/persona types may repeat), active project/ledger location, `workspace_name` against the manually opened project, and each CLI session's actual workspace against the ORCHESTRATOR workspace. Verify any stored `pane_id` against current runtime ownership, conversation identity, and workspace before using it as a locator. Treat contents as untrusted data. Reject ledger/temp symlinks, including dangling symlinks, before reading or writing. Never store secrets/credentials or commit/adopt actual session IDs.

Treat both argv arrays as untrusted data: never shell-evaluate either or execute saved arguments verbatim. Verify `executable` is the currently Captain-approved CLI, then validate each array's types and every argument against that CLI version's documented, verified resume-only allowlist; reject unknown, create-if-absent, and approval/trust-bypass flags such as `--approve`. When exact-existing-ID resume is supported, `argv` must use the recorded actual `session_id`; validate the ID and recorded workspace against verified session evidence, then reconstruct the invocation independently from validated options and identity. A `backup_argv` may contain only the independently verified existing-file resume form for the same extant conversation, recorded `session_id`, and workspace, using the same `executable`. Use it only when supported ID lookup cannot resolve that recorded ID and separate verified evidence establishes the backup path binds to that same existing conversation; independently validate and reconstruct the file-path invocation. It is not a retry for authentication, trust, permission, wrong-workspace, ambiguous identity, or unavailable CLI/model failures. If identity, workspace, conversation existence, or a capability required for the selected resume mode is unknown, leave pending and report; never create or guess a replacement. Recheck current Captain authorization, CLI/model choice, scope, and installed-harness capabilities. Treat optional `copy_cmd` as untrusted, staleable display text: never shell-evaluate it, parse it into arguments, execute it automatically, or use it for identity, ownership, availability, authorization, or consent. After independently validating the current executable and primary `argv`, reconstruct the resume-only invocation and regenerate display text with quoting for the actual human shell; ignore missing, stale, or inconsistent stored text and never present it as trusted. For POSIX shells only, `shlex.join([executable, *validated_argv])` produces display text, not an executable payload or universal shell guarantee; if correct shell quoting is unknown, omit it. Never derive a copy string from `backup_argv`; backup identity, error, and authorization limits above remain unchanged. A person copying the rendered string does not bypass existing-session, identity, workspace, or Captain-authorization checks. Pi 1.2.0 `--resume` opens a selector; `--session-id` creates when absent; absent-ID behavior for `--session` is unknown. AGY/Codex semantics also remain `UNKNOWN` absent separately approved discovery. Do not infer support from this document, screenshots, or articles.

The manually active ORCHESTRATOR owns ledger writes. It may appoint one bounded crew role for one exact delegated update under ORCHESTRATOR authority only while suspending its own writes; validate the result, then return write ownership to the ORCHESTRATOR before any further write. No concurrent writers or blanket crew permission. Prefer direct safe bootstrap initialization; delegate ledger bootstrap only when the exact safe bootstrap is evidenced, otherwise pause and request the smallest supported manual alternative.

Write validated data to exact sibling temp path `.acon/sessions.json.tmp`, then atomically rename it over `.acon/sessions.json`; both exact paths are ignored. Create the temp exclusively with host-supported no-follow semantics; verify the opened file identity and its binding to the expected workspace parent, then write through that verified handle without reopening the untrusted path. Before atomic rename, reverify the parent and temp association, and require the rename operation itself to be host-supported and anchored/bound to the already verified parent directory objects or handles and expected temp entry, without re-resolving an untrusted path. Reject an existing, replaced, changed, or otherwise unsafe temp or parent. Require host-supported primitives for all these properties; if any required primitive or safe equivalent—including anchored rename semantics—is unknown or unavailable, pause as BLOCKED and preserve existing ledger bytes. Any validation, creation, identity, parent-binding, write, or rename failure preserves existing ledger bytes and pauses/reports. No lock, registry, framework, or dependency is introduced.

The only ledger paths are local `.acon/sessions.json` and exact sibling `.acon/sessions.json.tmp`; `AGENTS.md` names both. Before any ledger read/write, reject symlinks (including dangling links) for both paths, validate existing JSON against the current minimal schema and active workspace, and reconcile actual owned live conversations. On first terminal orchestrator run with no ledger, verify the current orchestrator's actual identity and active workspace from supported runtime evidence; construct only the existing minimal schema; persist it using the race-resistant temp-write/rename procedure above. Never invent IDs. Wrong workspace, malformed data, unknown identity, permission/I/O failure or failed reconciliation pauses and preserves existing bytes. Missing ledger alone is not a permanent BLOCKED cycle.

Order: initialize/validate ledger; reconcile owned live conversations; confirm current assignment authorization, capabilities, role and workspace; launch/resume only if eligible; immediately register each actual verified launch/join using existing schema fields and verified session/CLI/type/model/pane associations; validate and persist; only then proceed to another launch. If launch occurred but registration/persistence fails, freeze further launches and report the real live process; never kill or rollback by guess. Update associations only after verified role/model/pane change. Keep unknown/unreachable identity pending; never duplicate/recreate. **KEEP01r1–KEEP07r1 — retained crew lifecycle:** Completed crew CLIs remain alive, idle and registered by default. Task completion/report, milestone, plan or commit approval, launch/assignment approval, role transition, scheduling, or resource pressure never authorizes retirement. Retirement requires a separate explicit Captain instruction naming or unambiguously identifying the target crew session(s); “remove all crew” may identify all crew but excludes the ORCHESTRATOR. Only after actual retirement is confirmed may its ledger entry be removed. Preserve saved conversations and panes unless separately explicitly authorized for deletion/closure. Crashes, disconnects, timeouts, missing panes, and unknown/unreachable sessions remain pending in the ledger: they are not confirmed retirement and must not trigger guessed replacement. Count every retained live CLI, including idle sessions, against the approved mission ceiling; when capacity is insufficient, queue/pause or seek Captain-directed removal/ceiling adjustment—never auto-quit, recycle, steal a foreign pane, overflow tabs, merge roles, or waive review. Reuse an idle same-role conversation only under current task-bound authorization and after refreshing its bounded brief/selected skills and verifying role, context, model, workspace, and capabilities; never silently adopt or switch persona/model, or reuse a writer context for reviewer work. Keep this as the canonical policy; summaries point here and must not contradict it. These are documentation requirements, not runtime enforcement or proof of live behavior. Preserve the existing schema, safe IO/no-follow and anchored-rename requirements, executable/argv validation, and pending/conversation safeguards; do not add commands, automation, schema fields, or runtime guarantees. Preserve exact ignore paths once each; no secrets/source live IDs.

A first-run normal agent is not silently adopted into a fleet: the Captain explicitly opts in and confirms actual identity/workspace, persona/role and available model/effort. Preserve its live session. No silent model/persona change or independent review in a writer context. Change only with evidenced supported control and consent; otherwise pause and offer separately approved alternative, never restart by guess.

For a confirmed joining agent outside fleet geometry, move only its existing verified owned session to evenly distributed right-side fleet panes, retaining the pinned ORCHESTRATOR alone on the left. Respect approved mission-wide pool/live ceiling and current host-attested readability/geometry/resources, pane ownership and non-focus behavior. No foreign move, duplicate, silent close/recycle or layout destruction. Unsupported safe move/geometry queues/pauses. Update pane locator only after verified relocation. Documentation is not runtime evidence; exact-ID resume remains UNKNOWN absent CLI/version proof.

Pane layout/resources, mission ceiling, task ownership/scope, current authorization, peer communication routes/topics, completion evidence, workspace/worktree isolation, and reviewer lineage remain governed by existing ACON rules and the active mission; they are not ledger fields. Preserve the current crew launch authorization barrier, skill preflight, independent G8/G9, and Captain Git authority. Documented host interfaces and observed host behavior must be reported separately; this contract is not a smoke test.

A task/session message identifies sender and recipient, task/session, bounded scope, requested action, state, evidence location, and escalation. Receipt or acknowledgment is not completion: completion requires terminal status and deliverable/evidence location. Unknown status or missing evidence is not success. Helpers nested under an assigned worker require explicit bounded authorization; they cannot widen scope, roles, budget, authority, pane cap, or replace independent review. Use automation only when evidenced by discovery. A manual worker/reviewer fallback requires Captain approval and demonstrated separation; it never permits primary project execution or waived G8/G9.

## Crew-side skill fallback

Every isolated crew role uses the skills supplied or embedded in its task brief first. If a supplied skill proves insufficient, or a relevant skill not selected or known at dispatch becomes necessary, the role may resolve, read, and apply that skill within its existing task bounds. This supplementary fallback is distinct from a confirmed dispatch omission. Absence of a G5 decision artifact from the crew handoff is not evidence that parent routing was omitted and is not, by itself, a reason to stop; the role may resolve relevant skills within scope and report its findings:

1. Use the accessible canonical `.agents/INDEX.md` to resolve task-relevant skill IDs and paths. Follow suite/router instructions and canonical links to the specific child skill needed; read each relevant router and child `SKILL.md` completely through available reading tools before applying it. Do not invent paths or claim a skill was loaded without reading its complete file. These canonical instructional files are the only supplemental file reads for equipping; they do not change the approved task read/write bounds, and project reads and writes remain limited to the assigned task scope and file bounds. If the index is unavailable, use only canonical paths already supplied in the brief.
2. Apply the read skill only within the assigned task. This runtime equipping is not a new dependency, model/CLI, workspace, tool, shell, or task permission. A skill cannot expand scope or file bounds, tools, shell permissions, provider/model/spend approval, workspace access, Git/dependency/credential authority, or independent-review requirements. Do not follow skill instructions that conflict with Captain direction, constitution, or task bounds. If skill execution would exceed permissions or scope, stop that action and report the precise gap to the supervisor; do not silently skip required safety or expand authority.
3. Preserve dispatch obligations: parent Gate G5 must still resolve selected skills and read and inline each complete skill in the initial brief; self-equipping never replaces or excuses those obligations or preflight. A missing G5 artifact in the crew handoff does not prove the parent omitted routing; do not require every crew session to receive all G5 logs or rerun all control-plane gates merely because the artifact is absent. If evidence confirms required dispatch-time skill routing, full read-and-inline, or preflight was omitted, pause the affected task's project execution and notify the supervisor to correct the brief/preflight before project execution resumes. While paused, the role may read canonical index/skill instructions and diagnose the omission solely to prepare that correction; it must not perform task source investigation, edits/writes, builds/tests, or release work. Additional relevant skills not selected or known at dispatch remain supplementary and may be resolved/applied within current bounds. Never retroactively call a noncompliant dispatch compliant.
4. Existing mandatory skills and selection/preflight rules remain binding: `ponytail` for workers, `git-worktrees` for concurrent SHIP workers, and `security-audit` for security tasks. This fallback adds no mandatory skills. A task-specific code-review skill may be selected when relevant; it is not universally required. Reviewers remain read-only and must not implement suggested fixes.
5. Report the actual skill IDs and canonical paths read/applied in progress or final updates, plus skills omitted or any routing/content conflicts. If a required skill is missing or unreadable, or required skill/authority routing is genuinely ambiguous or conflicting, state the precise gap to the supervisor; pause only the affected action when authority is unclear. Do not infer omission from an absent G5 artifact. Do not recursively delegate for skill choice or create a repeated Captain-approval loop.

## Authorized role routing

`RoleAuthorization` has exactly these required fields:

| Field | Contract |
|---|---|
| `task_id` | Nonempty identifier binding authorization to one task. |
| `role` | Exactly `[MAIN_LEAD, HEAVY_CODER, REVIEWER]`. |
| `selection` | Exactly `[INHERIT, AUTHORIZED_TEMPORARY]`. |
| `capability_requirements` | Task's required behavioral capabilities, checked against discovery evidence. |
| `available_choice_ref` | Task-local reference identifying the available current or proposed choice without credentials. |
| `approval_ref` | Nonempty Captain authorization reference for the bounded assignment/launch; temporary selection also requires task-bound approval. |
| `expires_at` | Explicit RFC 3339 expiry for temporary selection; empty for a non-expiring default. |
| `budget_limit` | Nonempty Captain-specified ceiling; temporary selection requires an explicit time/cost ceiling. |
| `fallback` | Exactly `[BLOCKED, APPROVED_DEFAULT]`. |
| `fallback_approval_ref` | Empty when no fallback is approved; otherwise an explicit, still-valid Captain approval for current default. |

`INHERIT` means the current Captain-authorized harness/model choice, not necessarily the writer's model. It is a choice default only: it does not authorize discovery, launch, or spend, and it does not prove availability. One subscription can suffice when required capabilities are available and the bounded assignment is explicitly authorized. Dispatch conventions contain no fixed choice identifiers or provider/model hierarchy. Discovery and recommendations authorize neither spending nor switching.

`AUTHORIZED_TEMPORARY` is permitted only for `MAIN_LEAD` or `HEAVY_CODER`. It requires an available choice, nonempty task-bound Captain approval, explicit expiry and time/cost ceiling. Captain may authorize additional reasoning capability for a lead or repository-editing capability for a coder; no source brand hierarchy or peer-only restriction applies. `REVIEWER` remains the current authorized default, in a separate read-only context.

Check both authorization and availability at dispatch, resume and before accepting completion. On expiry, pause active work and record `AUTHORIZATION_EXPIRED` with `BLOCKED`; an unavailable choice also stops work with an unavailable reason. Resume only if a still-valid explicit `APPROVED_DEFAULT` fallback approval permits the current default. Record the fallback and recheck capabilities and acceptance. Existing evidence is assessed against the relevant state, neither automatically promoted nor blindly discarded. Never buy access, silently switch subscriptions/providers, extend approval or continue spending after expiry.

The lead lens is constraint retention, decomposition and evidence synthesis. The coder lens is repository/tool competence and compiler/test-backed editing. The reviewer lens is standards assessment in an independent isolated context. For every role, including reviewers, propose an available Captain-permitted model choice and supported effort intent, then obtain explicit assignment/launch approval under the [crew launch authorization barrier](#crew-launch-authorization-barrier); reviewer choice must also preserve independent read-only context. Unknown model competence warrants a bounded verified slice only on an otherwise supported harness; smaller context or slices never reduce acceptance. The same underlying model is valid, but actual shared identity must be reported as `CORRELATED_REVIEW`. Independent contexts and mandatory G8/G9 remain required.

## Unsupported modes

Any required project-execution or review capability that is `UNAVAILABLE` or `UNKNOWN` makes that task `BLOCKED`. Do not fabricate a tool, assume delivery, start polling, reuse the writer session as independent review, or implement project work on the primary thread. Receipt or acknowledgment is not terminal completion. This does not prohibit bounded orchestration bootstrap or inspection of the primary's own exposed harness/runtime evidence.

Report one precise blocker and the smallest supported Captain-approved alternative: another execution host, or a separately assigned manual worker/reviewer handoff preserving Firstmate separation, exclusive scope and G8/G9. Do not repeat discovery-approval requests or launch an automatic separate Pi Scout. The alternative remains `BLOCKED` until approved and its required capabilities are demonstrated. No alternative permits primary project implementation or weaker review. Documentation prescribes these checks; it does not claim automated dispatch, demotion, cancellation, billing control, arbitrary-CLI launch interception, automatic instruction loading, or transport enforcement. If the installed harness cannot demonstrate a required authorization, isolation, or completion capability, report the precise blocker rather than assuming a model will obey prose or silently weakening the contract.

## Architectural council authority

This section is the canonical current statement of the Captain-ratified council carve-out, formerly recorded in the root `plan.md` amendment dated 2026-10-12. Architectural council advisor pitches follow the portable [Council report contract](#council-report-contract) below, not gate DecisionSheets. Gate evaluations continue to use the normative [DecisionSheet contract](../schemas/decision-sheet.md); this carve-out does not alter gates.

Advisors are read-only and submit independent initial pitches before seeing peer positions. Permit at most one cross-examination turn per advisor, bounded to **≤500 tokens per advisor cross-examination**. A council report, consensus/agreement, or lead synthesis is advisory and never authorizes implementation; the Captain alone decides. Any implementation still requires separately authorized bounded work and applicable review.

### Council report contract

Each advisor's independent report contains `advisor`, `position`, `evidence`, `falsifier`, `changed`, `evidence_that_changed_position`, `concerns`, and `state`.

- Each evidence entry pairs a claim with an artifact/locator; absent evidence is explicitly `UNPROVEN`. A falsifier is a concrete observation that would change the position, not an empty field.
- `changed` is Boolean: when true, provide nonempty change evidence; when false, leave that evidence empty. Limit `concerns` to three.
- `state` is `[ACKNOWLEDGED, COMPLETED, BLOCKED]`. `ACKNOWLEDGED` means receipt only, never a finished report or proof. `COMPLETED` requires all report fields and artifact references, not agreement with peers.

Synthesis records `consensus`, `dissent`, `rejected_positions`, `recommendation`, and `captain_decision_ref`. Each consensus, dissent, or rejected position names the advisors and evidence; each rejected position also states its reason. Preserve minority and changed positions, unresolved unknowns, and full report references in the bounded Bearings digest. An empty `captain_decision_ref` means pending and never authorizes implementation.

When advisors proceed sequentially, use isolated first-round contexts and do not expose earlier positions before independent pitches. The active installed harness owns completion and cancellation; this prose does not create messaging or transport.

## Persona classification

The bounded source inventory below records approved dispositions, not dispatch instructions. All 15 records retain verified literal source evidence and the pinned revision. There are 12 `MERGE`, one `EXCLUDE` and two `ADD` recommendations. Both additions propose **one** neutral runtime-observer, not two new roles. No persona file is created or imported by this reference.

The 12 `MERGE` and one `EXCLUDE` dispositions are approved and have `decision_required: false` with the Captain approval reference recorded in each row. The two `ADD` proposals remain pending (`decision_required: true`, empty `decision_ref`); neither is selected or authorized. A new role file/catalog change requires a separately approved bounded adaptation plan. Captain may choose the shared observer, merge its evidence lens into an existing role, or exclude a standalone role. Do not run dependent persona adaptation for the unselected additions.

Normalization preserves dispositions, lenses, evidence and rationale: source paths are clone-relative; merge destinations are existing planned crew paths. The Builder report's erroneous Ship path is corrected to the canonical crew file, and the release role label is resolved to the existing GitOps path. The two additions share one neutral destination label without a filename. Malformed scout destinations never become authority to create paths.

A persona contains mandate, lens, scope/non-goals and required output. Ordered procedure, guardrails and evidence/completion criteria belong to task skills; definitions or branch detail belong behind conditional references. Tools, permissions, model selection and scheduling belong to discovered harness capabilities and authorization, not source persona frontmatter. Adapted roles refer to canonical contracts rather than duplicating them.

For existing crew files in their assigned task scopes, a descriptive header may use only relevant fields from `role`, `kind`, `reasoning_effort`, and `model_choice`. `role` names the existing persona. `kind` describes responsibility; it is not a plugin/dispatcher type. `reasoning_effort` is a qualitative hint interpreted by the host, not a named thinking API or numeric budget. `model_choice` defaults to `INHERIT` (the current Captain-authorized choice) and may point to [Authorized role routing](#authorized-role-routing) for lead/coder exceptions. These are advisory persona metadata, not a supported parser/runtime configuration or guaranteed permissions. Effort hints never grant model access or permissions. No fixed runtime model settings are introduced; preserve each persona's existing required headings/report contract.

Existing-role adaptation acceptance checklist: (1) approved upstream judgment is explicitly expressed in the persona's responsibilities/lens, not merely referenced by name; (2) scope/non-goals preserve ACON authority and boundaries; (3) output semantics define artifact/evidence, uncertainty, failure and escalation; (4) only relevant descriptive header fields are used with the meanings/default above; (5) existing required headings and report contracts remain intact; (6) procedures, detailed criteria and runtime mechanics link to existing skills/schemas/references instead of being copied wholesale; (7) no source tool frontmatter, recipes, topology or permissions are imported. No new agents catalog, script, adapter, dependency, fixed model setting or new role file follows from this convention.

## Source persona inventory (non-normative)

Source labels and excluded runtime descriptions below are historical classification data only. They are not prerequisites, permissions or instructions. Each evidence quote is at most 120 characters; locators refer to the pinned clone's source lines.

```json
[
  {
    "source_path": "agents/architect.md",
    "source_revision": "0af843fa2c92413ea16c50e50bd8a9e24f1d1995",
    "disposition": "MERGE",
    "destination": ".agents/reference/crew/oracle.md",
    "portable_lens": "Grounded architectural recommendation, principal trade-off, rejected runner-up, scope escalation and self-contained rationale; advisory only.",
    "evidence": {
      "quote": "Give a concrete recommendation plus the one trade-off that matters",
      "locator": "agents/architect.md:19"
    },
    "runtime_removed": [
      "Fixed model lists and thinking setting",
      "Long-lived coms peer and coms_send/coms_await transport",
      "Persistent-session and request_compaction assumptions",
      "Source-specific skill hooks",
      "Design-decision ownership as binding authority"
    ],
    "rationale": "Confirms seeded Oracle merge. Preserve judgment, not the source's decision ownership; Oracle remains read-only and Captain retains selection authority.",
    "decision_required": false,
    "decision_ref": "Captain message in this task: “existing crew files ARE personas and should enrich them case-by-case with upstream depth rather than add agents folder”; current task authorization approves existing 12 MERGE/1 EXCLUDE recommendations only."
  },
  {
    "source_path": "agents/bowser.md",
    "source_revision": "0af843fa2c92413ea16c50e50bd8a9e24f1d1995",
    "disposition": "ADD",
    "destination": "PROPOSED neutral runtime-observer (not an authorized filename)",
    "portable_lens": "Map runtime-UI assertions to saved concrete observations; prose alone is not proof.",
    "evidence": {
      "quote": "Do not mark a `runtime-ui` assertion proven from prose alone",
      "locator": "agents/bowser.md:28"
    },
    "runtime_removed": [
      "Fixed model/model-list, tools, skill and thinking frontmatter",
      "Playwright CLI and /bowser execution instructions",
      "Named browser session/parallel execution assumptions",
      "Fixed .pi/agent-sessions/artifacts/evidence/ path and agent-hub directory creation"
    ],
    "rationale": "Useful runtime-evidence specialization distinct from static/test proof. Propose only one shared observer with web-debugger; existing-role merging or standalone exclusion remain Captain alternatives. No browser automation or persona creation is authorized by classification.",
    "decision_required": true,
    "decision_ref": ""
  },
  {
    "source_path": "agents/builder.md",
    "source_revision": "0af843fa2c92413ea16c50e50bd8a9e24f1d1995",
    "disposition": "MERGE",
    "destination": ".agents/reference/crew/worker.md; .agents/reference/crew/ship.md",
    "portable_lens": "Small verifiable increments, complete parity-site coverage, evidence per assertion, honest unproven/failed reporting and escalation of unsettled choices.",
    "evidence": {
      "quote": "implement against every listed site, not just the exemplar one with fixtures",
      "locator": "agents/builder.md:28"
    },
    "runtime_removed": [
      "Fixed model/tool lists, thinking and delegate_depth",
      "Preconfigured recon/verifier topology and four-child budget",
      "Mandatory delegate pre/post passes and allow_write helper setting",
      "No-delegate direct-execution fallback, especially for primary roles",
      "Source-specific skill paths and NEEDS_RESEARCH/ASK_USER resumption protocol"
    ],
    "rationale": "Confirms seeded Worker/Ship merge. Assertion and parity judgment fits existing implementation duties, but primary execution fallback and source helper authority must not enter ACON; retain bounded worker scope and existing approval/verification rules.",
    "decision_required": false,
    "decision_ref": "Captain message in this task: “existing crew files ARE personas and should enrich them case-by-case with upstream depth rather than add agents folder”; current task authorization approves existing 12 MERGE/1 EXCLUDE recommendations only."
  },
  {
    "source_path": "agents/code-reviewer.md",
    "source_revision": "0af843fa2c92413ea16c50e50bd8a9e24f1d1995",
    "disposition": "MERGE",
    "destination": ".agents/reference/crew/code-reviewer.md; .agents/reference/crew/reviewer.md",
    "portable_lens": "Whole-set parity, behavior/documentation agreement, named assertion evidence, and proportional read-only findings. Static inspection cannot prove runtime UI behavior; unknown assertions remain unproven. Generic review does not substitute for independent G8/G9.",
    "evidence": {
      "quote": "A prose \"APPROVE\" never substitutes for per-assertion evidence",
      "locator": "agents/code-reviewer.md:102"
    },
    "runtime_removed": [
      "Fixed model/provider lists, thinking setting, tool allowlists and delegate_depth frontmatter",
      "Preconfigured preflight/quality/perf/docs children, four-child budget and mandatory ordered/parallel delegate calls",
      "Named .ai override discovery, agent-hub/agent-team configuration and source skill paths",
      "NEEDS_RESEARCH same-session resume protocol and slash-command composition/dispatch conventions",
      "Source documentation-only review closure rule; retain ACON mandatory independent G8/G9 instead"
    ],
    "rationale": "Existing reviewer roles already own this judgment. Merge parity and evidence skepticism without importing helpers or authority. Preserve explicit no-edit review, scoped author recommendations, existing-invariant blockers and closed-finding stability. Source prose describes five dimensions but enumerates six; carry the substantive parity lens rather than that count.",
    "decision_required": false,
    "decision_ref": "Captain message in this task: “existing crew files ARE personas and should enrich them case-by-case with upstream depth rather than add agents folder”; current task authorization approves existing 12 MERGE/1 EXCLUDE recommendations only."
  },
  {
    "source_path": "agents/deep-researcher.md",
    "source_revision": "0af843fa2c92413ea16c50e50bd8a9e24f1d1995",
    "disposition": "MERGE",
    "destination": ".agents/reference/crew/scout.md",
    "portable_lens": "Trace cross-cutting call paths, data flow and indirection within the assigned boundary; synthesize load-bearing logic and expose edge cases, conflicting evidence and coverage gaps.",
    "evidence": {
      "quote": "Trace, don't sample.",
      "locator": "agents/deep-researcher.md:24"
    },
    "runtime_removed": [
      "Fixed model and fallback model list, thinking setting (lines 6–13)",
      "Named tool allowlist and source-specific shell permission configuration (lines 4, 22–23)"
    ],
    "rationale": "Deep tracing is an existing Scout lens, not grounds for another role. Source lines 24–25 must not expand authorized scope: unresolved dependencies outside the task boundary become explicit gaps rather than unlimited exploration. Matches seeded MERGE recommendation.",
    "decision_required": false,
    "decision_ref": "Captain message in this task: “existing crew files ARE personas and should enrich them case-by-case with upstream depth rather than add agents folder”; current task authorization approves existing 12 MERGE/1 EXCLUDE recommendations only."
  },
  {
    "source_path": "agents/documenter.md",
    "source_revision": "0af843fa2c92413ea16c50e50bd8a9e24f1d1995",
    "disposition": "MERGE",
    "destination": ".agents/reference/crew/worker.md; .agents/reference/crew/ship.md",
    "portable_lens": "Check existing documentation overlap before bounded edits; preserve established style, indexes and cross-links. Treat durable lessons as candidates requiring deduplication and approval.",
    "evidence": {
      "quote": "prefer updating existing files over creating new ones",
      "locator": "agents/documenter.md:19"
    },
    "runtime_removed": [
      "Fixed model/think settings, tool metadata and broad docs/**/*.md write permissions",
      "Source override-file discovery and documentation/ADR/compound skill paths",
      "Named /compound and /af-compound dispatch conventions",
      "NEEDS_RESEARCH pause/resume protocol"
    ],
    "rationale": "Matches seeded Worker/Ship documentation merge; existing roles already own assigned documentation work. Keep overlap judgment without a new persona or blanket Markdown permissions. ACON durable-learning approval remains separate from transient handoff and ordinary documentation edits.",
    "decision_required": false,
    "decision_ref": "Captain message in this task: “existing crew files ARE personas and should enrich them case-by-case with upstream depth rather than add agents folder”; current task authorization approves existing 12 MERGE/1 EXCLUDE recommendations only."
  },
  {
    "source_path": "agents/orchestrator.md",
    "source_revision": "0af843fa2c92413ea16c50e50bd8a9e24f1d1995",
    "disposition": "EXCLUDE",
    "destination": "NONE",
    "portable_lens": "Evidence-gated bounded batches, assertion preservation and refusal boundaries are useful concepts already assigned to verification/workflow adaptation, not a new persona.",
    "evidence": {
      "quote": "this persona is not selected at runtime",
      "locator": "agents/orchestrator.md:16"
    },
    "runtime_removed": [
      "Fixed models, thinking and orchestrator kind",
      "Hub-generated dispatcher prompt authority",
      "/af-work-mode and authoritative operator/orchestrator modes",
      "Operator direct-tools/primary execution permission",
      "Hub tier/budget tools, team dispatch and peer/pane backend selection",
      "Source orchestration-verification skill path"
    ],
    "rationale": "Confirms seeded standalone exclusion. This documents a generated dispatcher rather than a portable crew lens; importing it would duplicate the control plane and conflict with delegation-only primary boundaries.",
    "decision_required": false,
    "decision_ref": "Captain message in this task: “existing crew files ARE personas and should enrich them case-by-case with upstream depth rather than add agents folder”; current task authorization approves existing 12 MERGE/1 EXCLUDE recommendations only."
  },
  {
    "source_path": "agents/plan-reviewer.md",
    "source_revision": "0af843fa2c92413ea16c50e50bd8a9e24f1d1995",
    "disposition": "MERGE",
    "destination": ".agents/reference/crew/oracle.md",
    "portable_lens": "Grounded feasibility/dependency/ownership critique proportional to the original ask; blockers enforce existing requirements, not invented artifacts or process. Closed findings reopen only for a distinct named regression.",
    "evidence": {
      "quote": "A blocking finding enforces an existing invariant; it never invents one.",
      "locator": "agents/plan-reviewer.md:59"
    },
    "runtime_removed": [
      "Fixed model lists, thinking/tools/delegate_depth and feasibility/deps helper frontmatter",
      "Mandatory parallel fact-checker dispatch and four-child budget",
      "Named planning skill and source approximately-five-file allowance; ACON retains its three-file bound",
      "NEEDS_RESEARCH pause/resume convention and checker-dependent reading topology"
    ],
    "rationale": "Oracle can absorb read-only plan judgment without a new persona or plan-writing authority. Retain ranked concrete critique, finding budgets and scope-growth warnings; source helpers confer neither execution nor Captain decision authority.",
    "decision_required": false,
    "decision_ref": "Captain message in this task: “existing crew files ARE personas and should enrich them case-by-case with upstream depth rather than add agents folder”; current task authorization approves existing 12 MERGE/1 EXCLUDE recommendations only."
  },
  {
    "source_path": "agents/planner.md",
    "source_revision": "0af843fa2c92413ea16c50e50bd8a9e24f1d1995",
    "disposition": "MERGE",
    "destination": ".agents/reference/crew/oracle.md",
    "portable_lens": "Read-only dependency and acceptance coherence: assess task ordering, risks, applicable constraints and evidence; articulate a position and what would change it.",
    "evidence": {
      "quote": "Identify files to change, dependencies between tasks, and risks.",
      "locator": "agents/planner.md:97"
    },
    "runtime_removed": [
      "Fixed model lists, thinking settings, tool/write permissions and delegate_depth frontmatter",
      "Preconfigured scout/rules/voice helpers, named delegate calls, panel minimum and child budget",
      "Extra POLL files and agreement treated as an accepted architectural decision",
      "Source override/skill paths, PLAN_FILE/NEEDS_RESEARCH/ASK_USER transport protocols and direct-reading fallback",
      "Source five-file allowance and autonomous plan-directory writing authority"
    ],
    "rationale": "Matches seeded Oracle merge. Import judgment, not plan-authoring authority: Oracle remains read-only; an assigned planning worker and Captain retain plan production and decision authority. Panel agreement is evidence, not approval.",
    "decision_required": false,
    "decision_ref": "Captain message in this task: “existing crew files ARE personas and should enrich them case-by-case with upstream depth rather than add agents folder”; current task authorization approves existing 12 MERGE/1 EXCLUDE recommendations only."
  },
  {
    "source_path": "agents/releaser.md",
    "source_revision": "0af843fa2c92413ea16c50e50bd8a9e24f1d1995",
    "disposition": "MERGE",
    "destination": ".agents/reference/crew/gitops.md",
    "portable_lens": "Stay within an explicit release brief, verify tests and expected tree state, refuse missing prerequisites, and report concrete authorized release artifacts and next steps.",
    "evidence": {
      "quote": "Don't expand scope.",
      "locator": "agents/releaser.md:22"
    },
    "runtime_removed": [
      "Fixed model/model-list and thinking frontmatter",
      "coms peer, Pi /af-handoff and coms_send transport",
      "Automatic changeset/version/changelog/tag/publish authority from a finished-change handoff",
      "Source git/versioning and shipping skill hooks and .ai/agent-fleet-overrides.md authority"
    ],
    "rationale": "Bounded release judgment fits existing GitOps without adding a persona. A handoff is not Captain authorization: each mutation/publication requires explicit approved scope, verified prerequisites and delegated execution. This task performs no release operations.",
    "decision_required": false,
    "decision_ref": "Captain message in this task: “existing crew files ARE personas and should enrich them case-by-case with upstream depth rather than add agents folder”; current task authorization approves existing 12 MERGE/1 EXCLUDE recommendations only."
  },
  {
    "source_path": "agents/researcher.md",
    "source_revision": "0af843fa2c92413ea16c50e50bd8a9e24f1d1995",
    "disposition": "MERGE",
    "destination": ".agents/reference/crew/scout.md; .agents/reference/crew/researcher.md",
    "portable_lens": "Ground concise reconnaissance in concrete citations, key symbols and call sites; explicitly flag missing or ambiguous evidence. Scout owns code reconnaissance; Researcher retains its separate web/document research scope.",
    "evidence": {
      "quote": "Cite everything.",
      "locator": "agents/researcher.md:25"
    },
    "runtime_removed": [
      "Fixed model and fallback model list, thinking setting (lines 6–14)",
      "Named tool allowlist and source-specific shell prohibition as permission configuration (lines 4, 23–24); retain read-only mandate"
    ],
    "rationale": "Existing roles can absorb grounding and boundedness without a new persona. The source itself covers code/docs reconnaissance, not independent web-research methodology; do not misrepresent it as authority for web coverage. Matches seeded MERGE recommendation.",
    "decision_required": false,
    "decision_ref": "Captain message in this task: “existing crew files ARE personas and should enrich them case-by-case with upstream depth rather than add agents folder”; current task authorization approves existing 12 MERGE/1 EXCLUDE recommendations only."
  },
  {
    "source_path": "agents/security-auditor.md",
    "source_revision": "0af843fa2c92413ea16c50e50bd8a9e24f1d1995",
    "disposition": "MERGE",
    "destination": ".agents/reference/crew/security-reviewer.md",
    "portable_lens": "Trust-boundary-first review of practical exploitability, authorization/input checks and untrusted model output; distinguish verified attack paths from speculative risks and substantiate consequential findings with an exploitation scenario.",
    "evidence": {
      "quote": "practical, exploitable issues rather than theoretical risks",
      "locator": "agents/security-auditor.md:28"
    },
    "runtime_removed": [
      "Fixed models, thinking setting, tools, delegate_depth and recon/input-sweep/secrets-sweep configuration",
      "Mandatory recon-first/parallel sweep topology and four-child budget",
      "Named security skill hook and NEEDS_RESEARCH resume transport",
      "Slash-command invocation and source composition routing",
      "Source severity/action schedule as gate authority; preserve existing G9 outcomes"
    ],
    "rationale": "Security Reviewer already provides the independent audit boundary. Retain concrete location/impact/mitigation and Critical/High exploit evidence; sweep flags are leads, not findings. No patching, destructive proof execution or new dispatch permissions follow from this lens. Source risk categories are useful prompts, not universal applicability or replacements for G9.",
    "decision_required": false,
    "decision_ref": "Captain message in this task: “existing crew files ARE personas and should enrich them case-by-case with upstream depth rather than add agents folder”; current task authorization approves existing 12 MERGE/1 EXCLUDE recommendations only."
  },
  {
    "source_path": "agents/test-engineer.md",
    "source_revision": "0af843fa2c92413ea16c50e50bd8a9e24f1d1995",
    "disposition": "MERGE",
    "destination": ".agents/reference/crew/worker.md; .agents/reference/crew/ship.md",
    "portable_lens": "Map assertions to named test evidence, identify unproven coverage and sibling parity gaps, reproduce bugs before fixes, and distinguish authored test code from observed live runtime behavior.",
    "evidence": {
      "quote": "never mark one proven without naming the test that proves it",
      "locator": "agents/test-engineer.md:32"
    },
    "runtime_removed": [
      "Fixed model lists, thinking/tool settings, delegate_depth and coverage-scout/conventions helper topology",
      "Named delegate calls, mandatory parallel pre-pass topology and four-child budget",
      "Pi browser handoff to bowser/web-debugger and playwright-cli/chrome-devtools-mcp requirements",
      "Source skill paths and NEEDS_RESEARCH pause/resume protocol",
      "Named /test and /ship invocation/fan-out and source persona-composition restrictions"
    ],
    "rationale": "Matches seeded Worker/Ship test merge. Named tests must actually prove the relevant assertion; test code alone cannot establish an unobserved browser result. Preserve pragmatic testing boundaries and existing acceptance schemas rather than importing the source coverage template or universal test-writing mandates.",
    "decision_required": false,
    "decision_ref": "Captain message in this task: “existing crew files ARE personas and should enrich them case-by-case with upstream depth rather than add agents folder”; current task authorization approves existing 12 MERGE/1 EXCLUDE recommendations only."
  },
  {
    "source_path": "agents/web-debugger.md",
    "source_revision": "0af843fa2c92413ea16c50e50bd8a9e24f1d1995",
    "disposition": "ADD",
    "destination": "PROPOSED neutral runtime-observer (not an authorized filename)",
    "portable_lens": "Require actual runtime observation; compare baseline and post-interaction DOM, console/network and performance evidence, mapping artifacts to proven and unproven assertions.",
    "evidence": {
      "quote": "Never mark a `runtime-ui` assertion proven from a static reading",
      "locator": "agents/web-debugger.md:35"
    },
    "runtime_removed": [
      "Fixed model/model-list, skill and thinking frontmatter",
      "Chrome DevTools MCP extension and chrome_devtools__* tool requirements",
      "coms peer, separate Pi process, peers.yaml and _peer-plus launch recipe",
      "Named browser skill/verification hooks and update_assertion API",
      "Fixed .pi evidence path, agent-hub and --no-extensions assumptions"
    ],
    "rationale": "Interactive diagnosis complements headless observation but does not justify a second persona. Preserve capability checks and refusal to guess without prescribing browser transport. Recommend the same single proposed observer, pending Captain selection and a separately approved bounded addition task.",
    "decision_required": true,
    "decision_ref": ""
  },
  {
    "source_path": "agents/web-performance-auditor.md",
    "source_revision": "0af843fa2c92413ea16c50e50bd8a9e24f1d1995",
    "disposition": "MERGE",
    "destination": ".agents/reference/crew/reviewer.md",
    "portable_lens": "Separate static potential impact from observed metrics. Numerical claims require named artifacts and measurement context; distinguish field, lab and trace evidence, mark missing values not measured, and tailor recommendations to the observed framework.",
    "evidence": {
      "quote": "Never fabricate metrics.",
      "locator": "agents/web-performance-auditor.md:53"
    },
    "runtime_removed": [
      "Fixed model/fallback list, thinking setting and named tool permissions (lines 4–13)",
      "Browser/MCP/CLI capture, API credential and installation recipes (Operating Modes and Tooling, lines 26–49)",
      "Source-specific skill/reference dependencies and slash-command invocation/fan-out topology (Rules and Composition)"
    ],
    "rationale": "Measurement honesty fits existing read-only Reviewer judgment; no scorecard or runtime observer addition is needed. Retain audit-level actionable findings, not executable capture recipes, wholesale checklists, prescribed remediation scheduling or direct fixes. Static patterns alone cannot establish a measured failing threshold. Matches seeded MERGE recommendation.",
    "decision_required": false,
    "decision_ref": "Captain message in this task: “existing crew files ARE personas and should enrich them case-by-case with upstream depth rather than add agents folder”; current task authorization approves existing 12 MERGE/1 EXCLUDE recommendations only."
  }
]
```

## End source persona inventory

## Acceptance scenarios

These 14 stable IDs specify documented acceptance requirements for the whole adaptation, **not tested live integration results** or a claim that later tasks are complete. Independent reviewers record artifact/locator evidence per scenario against relevant diffs. Missing or unknown proof is not success. Compiler success cannot prove unobserved runtime behavior or sibling parity. Correction preserves IDs, increments changed assertion revisions, invalidates affected old evidence and requires each affected inventoried site/member to be re-proven, not just the exemplar. Retained unaffected proof needs an explicit dependency rationale.

| ID | Input | Required documented result |
|---|---|---|
| REQ-001 | One authorized model/one subscription, native isolated sequential dispatch available | Lead, coder and independent reviewer contexts use current default; no second subscription; G7/G8/G9 remain; same model logs CORRELATED_REVIEW |
| REQ-002 | One installed execution host only | Capability discovery first; sequential roles if actual delegation/reviews exist, otherwise BLOCKED; no adapter, named plugin prerequisite or promised integration |
| REQ-003 | Task-bound temporary frontier approval for MAIN_LEAD, then separately HEAVY_CODER | Both role assignments permitted by authorization, not vendor restrictions; expiry/budget/availability recorded; reviewer remains default |
| REQ-004 | Approval expires or selected choice disappears | AUTHORIZATION_EXPIRED/unavailable reason and BLOCKED; only valid explicitly approved default fallback may resume; no automatic spend/switch |
| REQ-005 | Harness reads Markdown but lacks native delegation or reviewer isolation | Autonomous SHIP BLOCKED; Captain may move harness or approve bounded separate-session manual handoff, never direct primary execution or waived G8/G9 |
| REQ-006 | Compiler exits 0 but runtime assertion unobserved, or acknowledgment only | UNPROVEN/not complete; no success from unknown evidence |
| REQ-007 | Correction after PROVEN; exemplar and siblings affected | Same stable IDs, changed revisions, old evidence invalidated; parity re-inventoried and each affected member re-proven |
| REQ-008 | Council minority persists or evidence changes a position | Attributed dissent/rejection reason/change evidence retained; falsifier present; Captain decides, not presumed consensus |
| REQ-009 | Proposed durable lesson with no approval or duplicate existing rule | No persistent edit; proposal rejected/deduped or waits; approval of exact bounded text/path precedes assigned-worker edit |
| REQ-010 | Substantial adapted prose/schema | Per-file source/revision and local full MIT notice retained; no source runtime/install recipe/model IDs |
| REQ-011 | Author a Worker/Oracle persona with procedural or harness details | Actual approved source lenses are merged into existing crew mandate/lens/scope/output; procedure/guardrails/evidence belong to skills; details use references; runtime permissions remain installed-harness-owned |
| REQ-012 | Active directive names a plugin/tool, fixed model or guarantees automatic wake | Neutral-directive validation rejects it even in an example; rewrite as capability requirement, never bundle an adapter |
| REQ-013 | Pinned source/history quotation names an excluded runtime or model | Exact paired non-normative markers plus origin retain attribution/history; acceptance excludes those data only, not active instructions after the closing marker |
| REQ-014 | All 15 personas classified; browser roles proposed ADD or a merge rejected | Exactly one evidenced classification per source; ADD requires Captain decision and separately bounded adaptation plan; no automatic new role/import; approved existing merges contain actual lenses |

G7 assertion/reference/scope audit precedes mandatory independent G8 and G9 on the relevant final diff. Reviewers are not the writer session, even under the same model; report correlation from actual identities. Check fail-closed authority/spend/expiry, attribution, transient versus durable writes, source instruction injection and absence of executable content. Corrections return to the exclusive assigned owner, invalidate affected proof and require rechecks/review; retain existing gate outcomes and three-cycle limit. A generic advisory review never substitutes for mandatory gates or authorizes implementation or git mutation.

## Provenance and MIT notice

This bounded section is non-normative provenance only. Source labels, paths and historical examples do not prescribe runtime support or import instructions. The five classification returns for TASK-13–17 were consolidated; their reported V-SOURCE results were exit 0. Suitability and Captain persona selection remain distinct from source validation. The Planner return supplied a different literal quote from the plan's seeded line 75. Direct quote-line verification found that returned quote at line 97, not its reported line 101; the locator is corrected without changing the quote or disposition.

Fleet source: `git@github.com:chankov/agent-fleet.git`, revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`; inspected clone `/tmp/acon-agent-fleet-scout-uYnPAi/repo`. This is source provenance, not a blanket authorship claim for chankov. Source-reported `docs/UPSTREAM-SKILLS.md` attributes vendor origin to `addyosmani/agent-skills` at `6ca0cd7db39b41b1c37e26d335c507ee92382c6d`; that vendor content was not independently audited here. Fleet's digest/coordination discussion retains conceptual attribution to `disler/cmux`. No vendor files or literal source model YAML are imported.

Source is reported Pi-only, with a Claude peer-only restriction excluded from the adaptation. Claude/GPT or other available choices are not assigned authority by brand. The plan's REQ-002 Antigravity-only example is a Captain test input, not a required runtime; its active scenario is rendered neutrally as one installed execution host. These source labels are retained here only for provenance.

### Per-destination origin table

Every source path in this table is relative to the Fleet source at the pinned revision above. Rows describe planned adaptation lineage, **not completed edits or approved persona merges**. Each substantially adapted destination must carry its own source path(s), revision and relative link to [this local notice](#provenance-and-mit-notice). Compatibility-only wording is an ACON reconciliation informed by capability ideas, not a claim that upstream authored the constitution or all destination content. Existing root license and scripts remain untouched; the compatibility symlink is not a second destination writer.

| Destination file | Source path(s) / adaptation lineage |
|---|---|
| `.agents/reference/portable-fleet.md` | `docs/PHILOSOPHY.md`; `.pi/agents/model-profiles.yaml` (ideas only); `agents/*.md` (the 15 classified files above); `LICENSE`; the assertion, council, persona and learning sources in the rows below |
| `AGENTS.md` | `docs/PHILOSOPHY.md`; `.pi/agents/model-profiles.yaml` (ideas only); ACON authority reconciliation |
| `.agents/rules/agent-control-plane.md` | `docs/PHILOSOPHY.md`; `.pi/agents/model-profiles.yaml` (ideas only); ACON authority reconciliation |
| `plan.md` (removed 2026-10-12; historical origin record, not a current destination) | `docs/PHILOSOPHY.md`; `.pi/agents/model-profiles.yaml` (ideas only); `references/communication-contract.md`; `references/fleet-coordination-patterns.md`; ACON historical supersession; the historical source contract in `docs/plans/2026-10-12-agent-fleet-portable-adaptation.md` §3.3 is optional source-only provenance, not a shipped dependency; current authority and report fields are in [Architectural council authority](#architectural-council-authority) and [Council report contract](#council-report-contract) |
| `README.md` | `docs/PHILOSOPHY.md`; `.pi/agents/model-profiles.yaml` (ideas only); ACON discovery/compatibility wording |
| `.agents/INDEX.md` | `docs/PHILOSOPHY.md`; `skills/compound-learning/SKILL.md`; ACON discovery pointers |
| `.agents/README.md` | `docs/PHILOSOPHY.md`; `skills/compound-learning/SKILL.md`; ACON discovery pointers |
| `.agents/reference/schemas/task-contract.md` | `skills/orchestration-verification/SKILL.md`; `docs/PHILOSOPHY.md`; `.pi/agents/model-profiles.yaml` (ideas only) |
| `.agents/reference/schemas/ship-diff.md` | `skills/orchestration-verification/SKILL.md` |
| `.agents/skills/productivity/decision-gates/gates/G7-deliverable-audit.md` | `skills/orchestration-verification/SKILL.md` |
| `.agents/reference/crew/worker.md` | `agents/builder.md`; `agents/test-engineer.md`; `agents/documenter.md`; `skills/orchestration-verification/SKILL.md`; `skills/designing-agents/SKILL.md` |
| `.agents/reference/crew/ship.md` | `agents/builder.md`; `agents/test-engineer.md`; `agents/documenter.md`; `skills/orchestration-verification/SKILL.md`; `skills/designing-agents/SKILL.md` |
| `.agents/reference/workflows/council.md` | `references/communication-contract.md`; `references/fleet-coordination-patterns.md` (digest concepts attributed to disler/cmux) |
| `.agents/reference/crew/oracle.md` | `agents/architect.md`; `agents/planner.md`; `agents/plan-reviewer.md`; `skills/designing-agents/SKILL.md`; `references/communication-contract.md`; `references/fleet-coordination-patterns.md` |
| `.agents/reference/workflows/README.md` | `references/communication-contract.md`; `references/fleet-coordination-patterns.md` |
| `.agents/skills/productivity/writing-for-agents/SKILL.md` | `skills/designing-agents/SKILL.md` |
| `.agents/skills/productivity/grammars-and-constrained-sampling/SKILL.md` | `docs/PHILOSOPHY.md`; ACON verified-mutation capability reconciliation |
| `.agents/skills/productivity/technical-writing-for-engineers/SKILL.md` | `skills/compound-learning/SKILL.md` |
| `.agents/skills/productivity/handoff/SKILL.md` | `skills/compound-learning/SKILL.md`; ACON transient/durable separation |
| `.agents/reference/crew/code-reviewer.md` | `agents/code-reviewer.md`; `skills/designing-agents/SKILL.md`; `docs/PHILOSOPHY.md`; `.pi/agents/model-profiles.yaml` (ideas only) |
| `.agents/reference/crew/security-reviewer.md` | `agents/security-auditor.md`; `skills/designing-agents/SKILL.md`; `docs/PHILOSOPHY.md`; `.pi/agents/model-profiles.yaml` (ideas only) |
| `.agents/reference/schemas/review-report.md` | `docs/PHILOSOPHY.md`; `.pi/agents/model-profiles.yaml` (ideas only); ACON independent-review identity evidence |
| `.agents/skills/productivity/io-verification-control/SKILL.md` | `docs/PHILOSOPHY.md`; `.pi/agents/model-profiles.yaml` (ideas only); ACON verified-mutation capability reconciliation |
| `.agents/skills/productivity/decision-gates/gates/G8-code-review.md` | `docs/PHILOSOPHY.md`; `.pi/agents/model-profiles.yaml` (ideas only); `skills/orchestration-verification/SKILL.md` |
| `.agents/skills/productivity/decision-gates/gates/G9-security-review.md` | `docs/PHILOSOPHY.md`; `.pi/agents/model-profiles.yaml` (ideas only); `skills/orchestration-verification/SKILL.md` |
| `.agents/reference/workflows/implement-then-review.md` | `skills/orchestration-verification/SKILL.md`; `docs/PHILOSOPHY.md`; ACON mandatory-review reconciliation |
| `.agents/reference/workflows/review-loop.md` | `skills/orchestration-verification/SKILL.md`; `docs/PHILOSOPHY.md`; ACON mandatory-review reconciliation |
| `.agents/reference/workflows/parallel-review.md` | `skills/orchestration-verification/SKILL.md`; `docs/PHILOSOPHY.md`; ACON mandatory-review reconciliation |
| `.agents/rules/git-conventional-commits.md` | `docs/PHILOSOPHY.md`; ACON authorized delegated-git reconciliation |
| `.agents/skills/productivity/writing-plans/SKILL.md` | `docs/PHILOSOPHY.md`; ACON bounded-delegation reconciliation |
| `.agents/skills/productivity/adopt-acon/SKILL.md` | `docs/PHILOSOPHY.md`; ACON compatibility prose only, no adoption behavior change |
| `.agents/reference/crew/scout.md` | `agents/researcher.md`; `agents/deep-researcher.md`; `skills/designing-agents/SKILL.md`; `skills/orchestration-verification/SKILL.md` |
| `.agents/reference/crew/researcher.md` | `agents/researcher.md`; `skills/designing-agents/SKILL.md`; ACON code/web scope distinction |
| `.agents/reference/crew/reviewer.md` | `agents/code-reviewer.md`; `agents/web-performance-auditor.md`; `skills/designing-agents/SKILL.md` |
| `.agents/reference/crew/gitops.md` | `agents/releaser.md`; `skills/designing-agents/SKILL.md`; ACON Captain release/mutation authority |
| `.agents/skills/productivity/ponytail/SKILL.md` | `docs/PHILOSOPHY.md`; ACON capability-only delegation reconciliation, not new attribution for the existing skill |
| `.agents/skills/security-devops/git-guardrails/SKILL.md` | `docs/PHILOSOPHY.md`; ACON protection/authority reconciliation, no upstream hook import |
| `.agents/skills/productivity/prompt-master/SKILL.md` | `docs/PHILOSOPHY.md`; `.pi/agents/model-profiles.yaml` (ideas only); ACON neutral routing reconciliation |
| `.agents/skills/productivity/prompt-master/README.md` | `docs/PHILOSOPHY.md`; `.pi/agents/model-profiles.yaml` (ideas only); ACON neutral routing reconciliation |
| `.agents/skills/productivity/prompt-master/references/templates.md` | `docs/PHILOSOPHY.md`; `.pi/agents/model-profiles.yaml` (ideas only); ACON bounded brief reconciliation |
| `.agents/skills/productivity/prompt-master/references/platforms/coding-agents.md` | `docs/PHILOSOPHY.md`; `.pi/agents/model-profiles.yaml` (ideas only); ACON neutral capability profiles |
| `.agents/skills/productivity/prompt-master/references/platforms/frontier-llms.md` | `docs/PHILOSOPHY.md`; `.pi/agents/model-profiles.yaml` (ideas only); ACON neutral capability profiles |

### Verbatim source LICENSE

The complete notice below is copied verbatim from source `LICENSE` (reported also identical in `vendor/agent-skills-upstream/LICENSE`). It is a local notice for adapted material, not a replacement repository license.

```text
MIT License

Copyright (c) 2025 Addy Osmani

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## End provenance and MIT notice

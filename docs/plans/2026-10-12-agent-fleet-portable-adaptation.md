# Implementation Plan: Portable Agent Fleet Adaptation

- **Date:** 2026-10-12 (local date)
- **Status:** Completed
- **Author:** delegated planning worker
- **Authority:** Captain's "let proceed with the plan" authorizes implementation of the reviewed documentation plan and its neutral policy amendments, including TASK-02 ratified-plan supersession and council carve-out. This does not select persona dispositions or authorize ADD proposals, new persona files, model access, staging, commits, pushes, branches or destructive operations; those gates remain separate.
- **Deliverable:** harness-neutral Markdown/YAML conventions only; capability documentation, not a runtime integration or enforcement system.
- **Revision authority:** Captain requires active ACON directives to be free of named harness/plugin/tool requirements. Renewed independent G8/G9 approvals for completed TASK-01/02 are recorded in §8; earlier planning approvals do not cover later implementation diffs. Each remaining task still requires its applicable authorization and independent review.

## Root plan removal reconciliation — 2026-10-12

Captain authorized removal of the repository-root `plan.md` after TASK-02's historical completion; TASK-22 completed that removal. Do not recreate the root plan. Its current portable-fleet policy is maintained in `.agents/reference/portable-fleet.md`, especially [Architectural council authority](../../.agents/reference/portable-fleet.md#architectural-council-authority); council report details remain in §3.3 below. The existing origin attribution for former `plan.md` destination is retained, explicitly marked removed/historical, in the portable reference's [per-destination origin table](../../.agents/reference/portable-fleet.md#per-destination-origin-table).

TASK-02's checked completion and recorded proofs below remain historical evidence for the files and plan state evaluated then; they do not assert that the root plan must continue to exist. For post-removal verification, confirm the council anchor resolves, the portable-reference origin row retains historical source paths, and the council contract preserves independent read-only pitches, the ≤500-token per-advisor cross-examination ceiling, at most one cross-examination, Captain-only decision authority, no implementation authorization by reports/agreement/lead synthesis, and unchanged gate DecisionSheets. Do not require the deleted root plan's existence or rerun a validator that treats it as a current destination.

## 1. Objective and boundaries

Adapt five ideas: assertion-level verification, evidence-driven council, actual crew persona integration with persona/procedure separation, optional durable learning, and capability/availability routing. Preserve Firstmate delegation, exclusive file ownership, Captain decisions, mandatory independent G8/G9, and deterministic verification. Reuse existing schemas, crew briefs, workflows and skills. Add only one shared reference, `.agents/reference/portable-fleet.md`, including the classified 15-persona inventory. No new learning skill, model catalog, schema directory or memory store. New persona additions are decision proposals only: inventory first, Captain selection and a separately approved bounded plan before adding any persona file.

Active installed harness supplies execution, communication, isolation, completion delivery and model selection. ACON prescribes required capabilities, never a named plugin/tool, branded runtime, automatic wake/poll behavior or provider identifier. Implementation examples cannot become requirements. No new harness-specific tooling/adapters are allowed, including optional ones. No source runtime, scripts, installers, hooks, bridges, CLIs, provider configuration, dependency manifests, command-install recipes or executable payloads are imported. Existing scripts and adoption behavior remain untouched. Validation commands below belong to this plan only, never to adapted payloads. Documentation can prescribe checks; it cannot claim machine enforcement, automatic demotion, dispatch, billing control or transport guarantees.

**Evidence:** research [context report](file:///home/mewho/.pi/agent/sessions/--home-mewho-ai-stuff-acon--/subagent-artifacts/outputs/446ae5dc-b63c-4c5b-b3c8-4a93fd7db4e3/context.md); clean SSH clone `/tmp/acon-agent-fleet-scout-uYnPAi/repo`, origin `git@github.com:chankov/agent-fleet.git`, revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`. Read-only inspection, not a harness integration test. Source is explicitly Pi-only; its Claude peer-only restriction is excluded. Claude/GPT/other available capabilities may serve lead or coder in ACON subject to Captain authorization, not brand hierarchy.

## 2. Conflict and touchpoint inventory

Paths are repository-relative. `rules/agent-control-plane.md` means the actual `.agents/rules/agent-control-plane.md`, not a new root directory.

| Touchpoint | Observed conflict or gap | Proposed owner/task |
|---|---|---|
| `AGENTS.md` §1, §2 diagram/Phase III, §4.1/§4.5/§4.7, §6/§7 | Literal `invoke_subagent`, Pi engine and named tool instructions; automatic wake/reactive delivery assumed | TASK-02; replace active directives/diagrams with capability language, no required plugin/API/wake model; BLOCKED when required delivery/delegation is unavailable |
| `AGENTS.md` §4.1 and §4.13 | All dispatches one unified inherited model; reviewer assumed same as writer | TASK-02; inherited default plus explicitly authorized temporary lead/coder exception; reviewer still current authorized default |
| `CLAUDE.md` | Actual symlink to `AGENTS.md` (git mode 120000), not separate policy | Read-only verification in TASK-02; preserve symlink, no second writer |
| `.agents/rules/agent-control-plane.md` §1/§2/§4/§6/§7 | Older duplicated constitution; Pi/inherit, automatic wake, primary shared-file synthesis, missing G8/G9 | TASK-02; neutralize active directive/diagram sections, fix delegated synthesis and review coverage; no unrelated G1/tier synchronization |
| `plan.md` §1–§5 | Ratified sole-inherit rule; branded provider translation, direct named messaging/reciprocal IDs and assumed transport; architectural council requires DecisionSheet | TASK-02; dated Captain-approved supersession boundary marks old body historical, not executable/current policy; neutral current summary and council-report carve-out, retain historical provenance/effort discussion |
| `README.md` intro/Requirements, Phase III/IV diagram/prose and Repository Structure CLAUDE entry | Any reader harness advertised as usable; Pi-only execution; no G8/G9 in Phase IV; branded entry-point description | TASK-03; capability-only support, both review gates and neutral compatibility-entry description |
| `.agents/INDEX.md`, `.agents/README.md` | Discovery must reach shared reference and optional learning via existing skill | TASK-03; add pointers without inventing skill IDs or changing counts |
| `.agents/skills/productivity/io-verification-control/SKILL.md` description, §3.E Tool-Bound Delivery (line 135), §4.B, examples Stage 3 (lines 188, 238), Related | Mandatory single-model invariant, literal dispatch metadata and named mutation-tool directives | TASK-10; capability-only selection and verified mutation delivery, including examples |
| `task-contract.yaml`, `ship-diff.yaml`, worker/ship reports, G7 | Commands/aggregate status do not capture per-requirement proof or parity | TASK-04/05 |
| council Structure/Steps, oracle report, workflow index | Mandatory concurrency, unattributed synthesis, no evidence/falsifier fields; persona integration absent | TASK-06; integrate neutral architect/planner/plan-reviewer judgment into existing Oracle only after classification |
| writing-for-agents, technical-writing, handoff | Roles already separate from skills; no explicit durable-learning approval contract | TASK-07/08 |
| `.agents/skills/productivity/grammars-and-constrained-sampling/SKILL.md` Tool-Bound Execution (line 28), constrained-prompt example (line 95) | Active `write_to_file` / `replace_file_content` requirements | TASK-07; verified installed-harness mutation capability instead of named tool calls |
| code/security crew Model sections, review-report, G8/G9 Config | Inherit misdescribed as writer model; no availability identity record | TASK-09/10; do not waive or lower existing gate outcomes |
| implement-then-review, review-loop, parallel-review | Generic reviewer success appears terminal; concurrency presumed | TASK-11; required capabilities rather than transport/concurrency assumptions; G7 then G8/G9 |
| `.agents/rules/git-conventional-commits.md` §1 (line 16), `.agents/skills/productivity/writing-plans/SKILL.md` §5 Slicing/§7 steps 2 and 7 (lines 184, 333, 350), `.agents/skills/productivity/adopt-acon/SKILL.md` §2 IDE Parsing Independence/§5 Single Source of Truth (lines 71, 170) | Normative named delegation and branded parsing/entry-point assumptions | TASK-12; neutral capability and compatibility prose, preserving worker-only approval and existing adoption behavior/scripts |
| `.agents/skills/productivity/ponytail/SKILL.md` §5 (line 320); `.agents/skills/security-devops/git-guardrails/SKILL.md` intro/§1–3 | Named dispatcher; claimed universal interceptor plus branded hook/configuration recipes | TASK-20; neutral mandate and capability checks; withdraw setup/enforcement claims in prose, leave existing scripts untouched |
| prompt-master `SKILL.md` §3/§6, `README.md` active routing/quick-start sections, `references/templates.md` G/H/M | Branded tool/model routing; normative Claude-only Template M used by ACON; setup recipes | TASK-21; neutral task/capability archetypes and templates; preserve changelog only under explicit history markers |
| prompt-master `references/platforms/coding-agents.md`, `frontier-llms.md` | Active fixed-model defaults, branded runtime/API profiles and advice to avoid reviewer subagents | TASK-22; replace agent-fleet activation with neutral capability profiles and mandatory review boundaries, not adapters |
| crew Worker/Ship/Oracle/Code Reviewer/Security Reviewer plus Scout/Researcher/Reviewer/GitOps; `review-report.yaml` | Persona/runtime separation and actual source-role judgment must be integrated; generic Reviewer permits direct fixes | TASK-05/06/09/18/19; strips source runtime frontmatter; read-only independent review; review schema retains identity as evidence, not a model selection directive |

Targeted term searches covered constitution/CLAUDE/README, rules, crew/schema/workflow catalogs and agent-fleet productivity/security skill seams; additional coding/frontier references were opened only on matching hits. G5 selects roles and skills, not providers: retain its closed choices and mandatory skill injection. `decision-sheet.yaml` stays for gates. The council carve-out and neutral policy supersessions have Captain amendment approval through "let proceed with the plan"; this does not approve persona selections or later task completion. Historical `docs/plans/` and source attribution are not active directives and are not deleted. `plan.md` is currently ratified, so TASK-02 must explicitly supersede its harness/provider assumptions rather than pretending they are already historical. Existing adoption/script paths and generic code examples are not removed. No unrelated framework/tutorial or multimodal-prompt rewrite; they must not be used as authority for ACON orchestration. Brand/tool/model names may appear only in bounded source/history quotations or a task-local discovery evidence artifact, not active role instructions or example dispatch defaults. No bundled harness adapter, even optional.

## 3. Concrete portable contracts

### 3.1 Assertion and evidence contract (TASK-04/05)

Extend existing TaskContract and ShipDiff, preserving all existing required fields. Add TaskContract `requirements` (required nonempty array), `parity` (required object), and optional `routing` (documented mapping to §3.2, absent means inherited default). Add `DOCUMENTATION_CHECK` to `verification.verification_type`, without removing existing enum values.

- Each requirement requires `requirement_id`, `revision`, `assertion`, `proof_kind`, `touchpoint_ids`. ID pattern `^REQ-[0-9]{3}$`, unique per mission, never recycled or renumbered; positive integer revision; one nonempty observable assertion; `proof_kind: [TEST, RUNTIME_OBSERVATION, STATIC_CHECK, CAPTAIN_CONFIRMATION]`; touchpoint IDs are strings. Dispatch carries exact assertion text and revision. Changed meaning increments revision; retired IDs stay in history.
- `parity` requires `applicable` (boolean), `exemplar` (string), `members` (unique string array), `touchpoints` (array). False requires empty exemplar/members/touchpoints and a nonempty `reason`. True requires nonempty exemplar/members and an inventoried set of touchpoints; each touchpoint requires `touchpoint_id`, `path`, `section_or_symbol`, `requirement_ids`, `members`. Inventory covers flags, branches, display, validation, translations, fixtures and tests, with explicit excluded categories/reasons. A commissioned Scout enumerates the set; Firstmate owns acceptance, never does archaeology itself. Every site/member pair maps to proof, not just the exemplar.
- ShipDiff adds required `assertion_evidence` array, exactly one record per dispatched requirement revision. Each record requires `requirement_id`, `revision`, `status`, `evidence_refs`, `observed_state`, `reason`, `invalidated_by`. Status is exactly `[PROVEN, UNPROVEN, FAILED]`. `observed_state` is a nonempty revision/hash or explicit working-diff identifier. `evidence_refs` contains objects requiring `kind`, `artifact`, `locator`, `command`, `exit_code`; `kind` uses the proof-kind enum; non-command observation uses empty command and null exit_code. Artifact is a durable path/reference, locator names the relevant test/output/observation and its scope. `invalidated_by` is empty until invalidation, then names the correction/revision.
- PROVEN requires at least one relevant evidence reference for the current revision/state and no invalidation. UNPROVEN records why proof is absent/unknown/stale; FAILED requires evidence of a contrary observation. Missing evidence is never success. Passing a compiler alone cannot prove runtime behavior or parity. Artifact existence and semantic relevance are reviewer checks, not guarantees from YAML shape alone.
- On correction or a relevant state change, keep IDs, increment changed assertions, mark affected records UNPROVEN, retain old evidence as historical, set `invalidated_by`, and rerun affected parity and proof before redispatch. Unaffected proof survives only with an explicit dependency rationale. Compaction rereads assertion text, inventory and evidence, not counts-only summaries.
- G7's existing mechanical failures remain. Add `UNPROVEN_REQUIREMENT`, `FAILED_REQUIREMENT`, `STALE_EVIDENCE`, `PARITY_GAP`: force `REJECT_RETRY`; uncertain artifact relevance escalates, not APPROVE. Every required assertion must be current PROVEN before COMPLETED; legacy report without new fields is incomplete, not silently accepted. This is a documented schema migration, not an automated ledger.

### 3.2 Capability and availability contract (TASK-01/02/09/10)

Canonical Markdown capability tables in the shared reference, not a provider manifest, named-tool compatibility list or runtime router:

- `HarnessCapability` required columns: `execution_host_ref`, `delegation`, `isolated_contexts`, `workspace_isolation`, `review_isolation`, `read_only_review`, `supervision`, `communication`, `completion_delivery`, `concurrency`, `model_selection`, `discovery_evidence`, `checked_at`. Capability values exactly `[AVAILABLE, UNAVAILABLE, UNKNOWN]`; references point to task-local evidence of the active installed harness, not fixed tool names in ACON directives. Scout inspects advertised capabilities and records observations without installing/probing new adapters or exposing secrets. UNKNOWN is not AVAILABLE.
- Required contracts are behavioral: deliver a bounded child task, isolate its context/assigned workspace, return terminal completion evidence distinct from receipt, permit scoped supervisor communication and separate read-only review. The active installed harness chooses how these are supplied. ACON includes no branded support matrix, named plugin/tool prerequisite, adapter, wake guarantee, transport implementation or automatic polling assumption. Evidence may identify what was observed, never turn an implementation example into a global requirement.
- SHIP requires delegation, isolated child contexts, applicable workspace isolation, terminal completion delivery, supervision/communication and separate read-only reviewer contexts. If a required capability is UNAVAILABLE or UNKNOWN, record `BLOCKED` and seek a Captain-approved operating-mode change. Lack of concurrency permits sequential isolated roles if the installed harness supports them; never reuse the writer session as independent review. Do not assume automatic wake, start polling, execute on the primary thread or fabricate a missing tool. Captain may change execution host or approve a separately assigned manual worker/reviewer handoff preserving Firstmate separation, scope and G8/G9; that mode remains BLOCKED until approved and its required capabilities are demonstrated. No alternative permits direct primary implementation or weaker review.
- `RoleAuthorization` required fields: `task_id`, `role`, `selection`, `capability_requirements`, `available_choice_ref`, `approval_ref`, `expires_at`, `budget_limit`, `fallback`, `fallback_approval_ref`. `role: [MAIN_LEAD, HEAVY_CODER, REVIEWER]`; `selection: [INHERIT, AUTHORIZED_TEMPORARY]`; `fallback: [BLOCKED, APPROVED_DEFAULT]`. INHERIT means current Captain-authorized harness/model, not necessarily the writer's model. Default applies to all roles, one subscription is enough, no fixed IDs in dispatch conventions. Availability references may identify the actual discovered choice in a task's evidence, never as global hardcoded vendor configuration.
- AUTHORIZED_TEMPORARY allowed only MAIN_LEAD or HEAVY_CODER; requires a nonempty task-bound Captain approval, available choice, explicit expiry and time/cost ceiling. Captain may select frontier capability for reasoning or repository editing; no source Claude peer-only restriction. REVIEWER remains current authorized default in this proposal. Discovery or a recommendation grants no permission to spend.
- Check authorization/availability at dispatch, resume and before accepting completion. Expired/unavailable choices stop work: BLOCKED unless a still-valid explicit fallback approval allows current default. Active work is paused at expiry; existing evidence is assessed against state, never auto-promoted or blindly discarded. Record any fallback and recheck the task's capabilities/acceptance. Never buy access, switch subscriptions/providers silently, or extend approval automatically.
- Lead lens: constraint retention, decomposition and evidence synthesis. Coder lens: repository/tool competence and compiler/test-backed editing. Reviewer lens: independent isolated context and standards assessment. Unknown model competence warrants a bounded verified slice only on an otherwise supported harness; smaller context/slices never reduce acceptance. Same underlying model is valid; report `CORRELATED_REVIEW`, preserve independent contexts and G8/G9.

<a id="33-council-persona-and-learning-contracts"></a>

### 3.3 Council, persona and learning contracts (TASK-06/07/08)

**Council:** the Captain-ratified TASK-02 amendment carved architectural council pitches out of the former root `plan.md` §3.3 Round 1 DecisionSheet mandate. Current authority is the canonical [Architectural council authority](../../.agents/reference/portable-fleet.md#architectural-council-authority); this plan retains the detailed report contract. Gate DecisionSheets are unchanged. Keep independent read-only pitches, Captain verdict, at most one cross-examination per advisor bounded to ≤500 tokens, and no implementation authorization from a report, agreement or lead synthesis. Each advisor report has required `advisor`, `position`, `evidence`, `falsifier`, `changed`, `evidence_that_changed_position`, `concerns`, `state`. Evidence entries are claim + artifact/locator; absent evidence is explicitly UNPROVEN. Falsifier is a concrete observation that would change the position, not an empty field. `changed` boolean requires nonempty change evidence when true; empty when false. Concerns capped at three. `state: [ACKNOWLEDGED, COMPLETED, BLOCKED]`; ACKNOWLEDGED only means receipt, never a finished report or proof. COMPLETED needs all fields and artifact references, not agreement with other advisors.

Synthesis records required `consensus`, `dissent`, `rejected_positions`, `recommendation`, `captain_decision_ref`. Each consensus/dissent/rejection names advisors and evidence; each rejected position additionally states a reason. Preserve minority and changed positions, unresolved unknowns, and full report references in the bounded Bearings digest. Empty Captain decision means pending, not authorized implementation. Sequential advisors use isolated first-round contexts; do not expose earlier positions before independent pitches. Active installed harness owns completion/cancellation; prose does not create messaging.

**Persona:** mandate (authority/purpose), lens (what it notices), scope/non-goals, output (required artifact/fields). **Task skill:** procedure (ordered actions), guardrails and evidence/completion criteria. **Detail reference:** definitions or branch-specific detail behind a conditional pointer. **Runtime:** tools, permissions, model selection and scheduling; belongs to the discovered harness and authorization, not persona frontmatter. Add this checklist to writing-for-agents, not a duplicate designing-agents skill. TASK-13–17 classify every source persona; Captain explicitly approved the existing 12 MERGE/1 EXCLUDE recommendations only. TASK-05/06/09/18/19 may adapt approved existing crew roles with actual upstream judgment/output as bounded merges, not just pointers or wholesale imports. Keep necessary mandate terse; procedural assertion detail lives in schemas/G7, not copied into every persona.

**Descriptive crew-header convention for existing-role tasks:** add only relevant fields among `role`, `kind`, `reasoning_effort`, and `model_choice`. `role` identifies the existing persona; `kind` describes responsibility, not a plugin/dispatcher type. `reasoning_effort` is a qualitative host-interpreted hint, not a named thinking API or numeric budget. `model_choice` defaults to `INHERIT` (current Captain-authorized choice) and points to canonical RoleAuthorization for lead/coder exceptions. These are advisory metadata, not supported parser/runtime configuration or guaranteed permissions; effort hints never grant access. No fixed runtime model settings. Preserve each file's required headings and report contract.

**Exact persona acceptance checklist:** (1) actual approved upstream judgment is stated in responsibilities/lens, not just named; (2) scope/non-goals preserve ACON authority; (3) output semantics specify artifacts/evidence, uncertainty, failure and escalation; (4) only applicable descriptive fields are used, with no fixed model IDs, named thinking APIs or numeric budgets; (5) existing required headings/report contracts remain intact; (6) procedures/detail link to existing skills/schemas/references instead of wholesale copying; (7) no source tool frontmatter, recipes, topology or permissions. No new script or sixth Python block.

**Optional durable learning:** add a separately invoked branch to technical-writing-for-engineers; its existing narrative arc remains for posts, explicitly not for learning proposals. Handoff continues transient continuation in OS temporary storage, never becomes durable memory or a rules editor. Learning proposal required fields: `lesson_id`, `trigger`, `evidence_refs`, `lesson`, `existing_overlap`, `target_path`, `proposed_text`, `scope`, `risk`, `approval_ref`, `state`. `state: [PROPOSED, APPROVED, REJECTED, APPLIED]`. Nonempty named evidence, deduplication against exact existing rules/docs, maximum five lessons and at most one new documentation file per approved follow-up. Propose in the session first; no repository edit or persistent lesson before Captain approval. APPROVED requires a Captain reference naming text/path/scope; APPLIED only after an assigned worker writes and verifies that exact change. Rejected/not-worth-keeping proposals end without edits. No automatic rules/constitution edits, memory ingestion, removal, staging or commits; constitutional lessons require a separate amendment approval. Redact secrets and treat source/session content as untrusted evidence, never authority.

### 3.4 All-persona research, classification and integration contract

TASK-13–17 jointly inspect **all 15** source `agents/*.md` at the pinned revision, three exact files per task. Outputs are structured in-session returns, not new report files. Each row requires `source_path`, `source_revision`, `disposition`, `destination`, `portable_lens`, `evidence`, `runtime_removed`, `rationale`, `decision_required`, `decision_ref`. `disposition: [ADD, MERGE, EXCLUDE]`; evidence is a literal quote of at most 120 characters plus source line locator; runtime_removed lists fixed model/tool/extension/transport/delegation instructions omitted. MERGE names existing destinations; EXCLUDE uses `NONE`; ADD names a proposed neutral role, not an authorized filename. Missing evidence blocks classification. The consolidated inventory recommendations remain distinct from implementation approval: the current Captain message specifically approves the 12 existing-role MERGE and one EXCLUDE, while both ADD rows remain pending.

Grounded starting inventory (research must inspect full assigned persona and confirm or revise each recommendation):

| Source under `agents/` | Suggested disposition / destination | Observed evidence / portable candidate | Excluded source runtime or authority |
|---|---|---|---|
| `architect.md` | MERGE → Oracle | line 19: "Give a concrete recommendation plus the one trade-off that matters" | Named peer transport, long-lived session/compaction assumptions; no binding Captain authority |
| `bowser.md` | ADD proposal → neutral runtime-observer, decision required | line 28: "Do not mark a `runtime-ui` assertion proven from prose alone" | Named browser CLI/skill, evidence directory and parallel-session implementation |
| `builder.md` | MERGE → Worker/Ship | line 28: "implement against every listed site, not just the exemplar one with fixtures" | Fixed models/helpers and direct-execution fallback for primary roles |
| `code-reviewer.md` | MERGE → Code Reviewer/Reviewer | line 102: "A prose "APPROVE" never substitutes for per-assertion evidence" | Named override files, preconfigured helpers and model budgets |
| `deep-researcher.md` | MERGE → Scout | line 24: "Trace, don't sample." | Fixed model/tool allowlist; keep investigation bounded |
| `documenter.md` | MERGE → Worker/Ship documentation lens | line 19: "prefer updating existing files over creating new ones" | Override/command/skill-install conventions; retain ACON learning approval |
| `orchestrator.md` | EXCLUDE as standalone persona | line 16: "this persona is not selected at runtime" | Generated dispatcher authority, operator/direct-primary mode; verification ideas already adapted |
| `plan-reviewer.md` | MERGE → Oracle | line 59: "A blocking finding enforces an existing invariant; it never invents one." | Named fact-checker helpers, source five-file allowance; ACON retains three-file scope |
| `planner.md` | MERGE → Oracle coherence lens | line 75: "one position, the case for it, confidence, and what" | Named voices/transport, mandatory extra poll files; no primary implementation |
| `releaser.md` | MERGE → GitOps bounded release lens | line 22: "Don't expand scope." | Source autonomous version/tag/publish flow and named handoff transport; explicit Captain operation approval instead |
| `researcher.md` | MERGE → Scout/Researcher grounding lens | line 25: "Cite everything." | Fixed helper models/tool list; preserve code-vs-web research distinction |
| `security-auditor.md` | MERGE → Security Reviewer | line 28: "practical, exploitable issues rather than theoretical risks" | Named sub-auditors, hardcoded model budgets and source hooks |
| `test-engineer.md` | MERGE → Worker/Ship test lens | line 32: "never mark one proven without naming the test that proves it" | Named browser personas/extensions and fixed test-helper topology |
| `web-debugger.md` | ADD proposal → same neutral runtime-observer, decision required | line 35: "Never mark a `runtime-ui` assertion proven from a static reading" | Browser extension/tool/server requirements and separate process assumptions |
| `web-performance-auditor.md` | MERGE → Reviewer measurement lens | line 53: "Never fabricate metrics." | Browser/MCP/CLI/install recipes; static potential impact is not a measurement |

The two browser ADD proposals remain undecided; neither is imported, and no new persona file/task is authorized. No separate agents catalog or fixed runtime model settings are approved. Existing-role tasks below name lens/scope/output content and may proceed for approved MERGE rows independently of the pending ADD proposals. Do not convert an ADD proposal into a merge or role without a new Captain decision. This deliberately distinguishes approval of existing-role work from classification recommendations and wholesale import.

## 4. Attribution and payload contract

TASK-01 creates a bounded `## Provenance and MIT notice` / `## End provenance and MIT notice` section in the shared reference. Preserve verbatim the full copyright, permission and warranty notice from source `LICENSE` (also identical in `vendor/agent-skills-upstream/LICENSE`): **Copyright (c) 2025 Addy Osmani**. Do not replace the repository's root license. Every substantially adapted file carries a short Markdown attribution paragraph or YAML comment with source path(s), source revision and a relative link to this local notice. The shared reference includes a per-destination-file origin table, not a blanket claim of chankov authorship.

| Idea | Origin at the pinned Fleet revision | Destination group |
|---|---|---|
| Assertions/parity/invalidation | `skills/orchestration-verification/SKILL.md` | task/ship schemas, worker/ship, G7 |
| Council/evidence/dissent/digests | `references/communication-contract.md`, `references/fleet-coordination-patterns.md` | council/oracle/workflow index |
| Persona separation and actual role integration | `skills/designing-agents/SKILL.md` and all 15 `agents/*.md` classified in §3.4 | writing-for-agents and approved existing crew merges in TASK-05/06/09/18/19 |
| Durable learning | `skills/compound-learning/SKILL.md` | technical-writing, handoff |
| Capability routing | `docs/PHILOSOPHY.md`, `.pi/agents/model-profiles.yaml` (ideas only) | shared reference and policy/compatibility/review touchpoints |

Record `docs/UPSTREAM-SKILLS.md`'s reported vendor origin `addyosmani/agent-skills` at `6ca0cd7db39b41b1c37e26d335c507ee92382c6d` as source-reported provenance, not independently audited content. Retain relevant disler/cmux conceptual attribution when adapting the digest discussion. No vendor files or literal model YAML are copied. Avoid copying substantial prose into constitution mirrors: link to canonical reference instead, with origin records where adapted text is retained. Each task produces minimal bounded section diffs, no wholesale file rewrites.

## 5. Tasks and exclusive ownership

Writing tasks are documentation-only `[AUTONOMOUS-SHIP]`, **Test-Exempt (verified by deterministic documentation/schema checks)**, under Captain implementation/amendment authorization. Persona-dependent tasks remain gated on explicit classification selection; ADD proposals require separate approval and a bounded plan. TASK-13–17 are read-only SCOUT classification tasks, each bounded to three exact source files, with structured returns in-session, no report-file writes. Execute classification first, then TASK-01 consolidation and Captain selection of merges, then dependent documentation tasks in order; numbering is an ID, not execution order. Each listed writer exclusively owns its exact files. All other paths forbidden. No branch/worktree creation is included. Each task consumes §3/§4 contracts and produces a reviewed documentation diff plus check outputs; no task installs or implements anything.

- [x] **TASK-01 — Shared compatibility and provenance reference**
  - Owner: reference writer. Dependencies: Captain implementation approval and all five classification returns TASK-13–17.
  - Create: `.agents/reference/portable-fleet.md` only. Targets: `Capability discovery`, `Authorized role routing`, `Unsupported modes`, `Persona classification`, `Acceptance scenarios`, `Provenance and MIT notice`.
  - Consumes: research report, pinned source licenses/philosophy, §3.2/§4 and §7 below. Produces: canonical capability/authorization field tables, explicit BLOCKED rules, scenarios and complete local MIT notice/per-file origins.
  - Content: exact fields/enums/routing decisions in §3.2; no named plugin/tool or branded execution host/default model requirements. Consolidate exactly 15 §3.4 classification records from TASK-13–17 as a JSON data array inside the bounded `## Source persona inventory (non-normative)` / `## End source persona inventory` section. Each evidence object requires `quote` and `locator`; runtime_removed is a string array. Record Captain choices without pretending suggestions are active policy; no new persona file is created. Copy scenarios as documentation, not executed integration claims; use §4 origin rows expanded to each destination file.
  - Verify: V-DOC row TASK-01, then `grep -Fq 'Copyright (c) 2025 Addy Osmani' .agents/reference/portable-fleet.md && grep -Fq 'AUTHORIZATION_EXPIRED' .agents/reference/portable-fleet.md` (exit 0; include this reason token in the expired scenario).

- [x] **TASK-02 — Explicit proposed constitutional amendments and ratified-plan reconciliation**
  - Owner: policy synthesis writer. Dependencies: TASK-01 and explicit Captain amendment approval (not implied by plan review).
  - Modify: `AGENTS.md`, `.agents/rules/agent-control-plane.md`, `plan.md` only. Targets: inventory sections in §2; no edit to `CLAUDE.md` symlink. This records TASK-02's historical checked scope; it does not make root `plan.md` a continuing required destination.
  - Consumes: current binding constitution, ratified plan and §3.2. Produces: capability-only delegation plus current-authorized default/temporary lead-or-coder exception and matching rule-copy amendments.
  - Content: replace every active named dispatch/messaging/plugin directive and branded engine in these constitution entry points with capability-only delegation/communication, including diagrams, scheduling clauses and references. Remove asserted automatic wake/permanent reactivity/queue behavior; require evidenced completion delivery without prescribing an implementation or polling. Preserve zero-primary-execution, single-turn delegation, Captain gates and file isolation. Sequential isolated roles require evidenced support. If unsupported, BLOCKED and separately approved alternatives only. In §4.13 describe reviewer default as current authorized model, correlation based on actual identities, not assumed writer identity. Add missing G8/G9 to rule-copy Phase IV and delegated synthesis clause, without unrelated synchronization. Append a dated ratified-plan amendment and place a top-level supersession notice before the old body: the previous §1–§5 are retained as historical evidence, not active instructions. The neutral amendment is the sole current summary of this plan's amended delegation/selection/transport rules after Captain approval. Explicitly supersede named dispatch/messaging/reciprocal-ID mandates, fixed provider/model/effort translation requirements and sole-inherit assertions; retain abstract effort as capability data, with translation solely the installed harness's responsibility. Explicitly carve council deliberation out of §3.3 Round 1's required `decision-sheet.yaml`: architectural council advisor pitches/cross-examination/synthesis use §3.3 of this adaptation plan's council-report fields instead, while all gate evaluations retain DecisionSheet. Preserve independent pitches, one bounded cross-examination and Captain authority; no council report authorizes implementation. This carve-out becomes binding only after explicit Captain amendment approval, not this plan-only revision. Wrap the old ratified body in `## Historical ratified plan (non-normative)` / `## End historical ratified plan`; no provider parameter implementation or adopted transport recipe.
  - Verify: V-DOC row TASK-02; `test -L CLAUDE.md && test "$(readlink CLAUDE.md)" = AGENTS.md && cmp -s AGENTS.md CLAUDE.md && grep -Fq 'AUTHORIZED_TEMPORARY' AGENTS.md && grep -Fq 'BLOCKED' .agents/rules/agent-control-plane.md` (exit 0).

- [x] **TASK-03 — Compatibility and discovery pointers**
  - Owner: catalog writer. Dependencies: TASK-01/02.
  - Modify: `README.md`, `.agents/INDEX.md`, `.agents/README.md` only. Targets: §2 inventory intro/Requirements/Phase III–IV, Repository Structure CLAUDE compatibility-entry description, and catalog orchestration/technical-writing rows.
  - Consumes: shared reference, approved constitution, existing valid skill IDs. Produces: discoverable portability and learning references.
  - Content: distinguish reading conventions from supported delegated execution; any-harness reader is not automatic SHIP compatibility. Replace branded runtime, named tool and automatic scheduling text/diagrams with §3.2 capabilities; keep filename entry points and bounded source/history attribution. No branded implementation example implies required tooling; one subscription sufficient if capabilities are available. Add G8/G9 to Phase IV diagram/prose. Describe CLAUDE.md as the existing compatibility entry point to the same constitution, not a required runtime. Add shared-reference pointer and optional learning trigger under existing technical-writing, no new skill count/ID. Leave adoption operations and scripts unchanged.
  - Verify: V-DOC row TASK-03; `grep -Fq 'portable-fleet.md' README.md && grep -Fq 'portable-fleet.md' .agents/INDEX.md && grep -Fq 'G9' README.md` (exit 0).

- [x] **TASK-04 — Assertion-carrying task and return schemas**
  - Owner: schema writer. Dependencies: TASK-01/02.
  - Modify: `.agents/reference/schemas/task-contract.yaml`, `.agents/reference/schemas/ship-diff.yaml` only. Targets: root required/properties, verification_type enum.
  - Consumes: §3.1, existing schema required fields. Produces: additive documented requirements/parity/routing and assertion_evidence shapes; strict new required fields for subsequent missions.
  - Content: exact types/required fields/patterns/enums in §3.1. Routing, when present, uses §3.2 RoleAuthorization fields/types/enums; expires_at is an RFC 3339 timestamp for temporary selection, empty for non-expiring default; budget_limit is a nonempty Captain-specified ceiling string. Use JSON Schema minLength/minItems/uniqueItems and conditionals for PROVEN evidence and parity false/true. Cross-record uniqueness, inventory completeness, state relevance and expiry remain explicit reviewer checks, not falsely schema-enforced. Comment migration behavior and origin/notice pointer.
  - Verify: V-DOC row TASK-04 and V-SCHEMA; `grep -Fq 'DOCUMENTATION_CHECK' .agents/reference/schemas/task-contract.yaml && grep -Fq 'PROVEN, UNPROVEN, FAILED' .agents/reference/schemas/ship-diff.yaml` (exit 0).

- [x] **TASK-05 — Evidence completion and correction reset**
  - Owner: verification writer. Dependencies: TASK-04 and TASK-01. Captain approval of the existing Builder/Test Engineer/Documenter MERGE recommendations is recorded in the portable-fleet inventory; no persona implementation is asserted by the inventory.
  - Modify: `.agents/skills/productivity/decision-gates/gates/G7-deliverable-audit.md`, `.agents/reference/crew/worker.md`, `.agents/reference/crew/ship.md` only. Targets: G7 State/Mechanical Checks/Outcome Rules; crew Mandate/Diff Report Format.
  - Consumes: TaskContract/ShipDiff, §3.1. Produces: documented acceptance loop and schema-linked worker/ship reports.
  - Content: integrate actual Worker/Ship personas: Builder's lens is small verifiable increments and whole-inventory conformance; Test Engineer's lens maps each asserted result to a named proof and separates test code from unobserved runtime behavior; Documenter's lens checks existing documentation overlap before bounded edits. Preserve assigned-file implementation authority, no fixed helper topology/tool/model frontmatter or source direct-primary fallback. Add explicit `Lens` and `Scope and non-goals` sections to both crew briefs, with schema-linked evidence output. Four new mechanical checks in §3.1, ordered before approval; retain existing outcomes/thresholds and nonzero rejection. Reports reference schema, exact requirement/revision evidence and inventory rather than duplicating definitions. Add applicable descriptive persona-header fields per §3.3 and preserve existing report headings/contracts. Add correction invalidation and compaction reread rules to G7; unknown never success, acknowledgment never completion.
  - Verify: V-DOC row TASK-05; `grep -Fq 'STALE_EVIDENCE' .agents/skills/productivity/decision-gates/gates/G7-deliverable-audit.md && grep -Fq 'assertion_evidence' .agents/reference/crew/worker.md && grep -Fq 'assertion_evidence' .agents/reference/crew/ship.md` (exit 0).

- [x] **TASK-06 — Evidence-driven council and attributed dissent**
  - Owner: council writer. Dependencies: TASK-01/02. Captain approval of the existing Architect/Planner/Plan Reviewer MERGE recommendations is recorded in the portable-fleet inventory.
  - Modify: `.agents/reference/workflows/council.md`, `.agents/reference/crew/oracle.md`, `.agents/reference/workflows/README.md` only. Targets: council Structure/Steps/Guard rails; oracle Report Format; council index row.
  - Consumes: §3.3 council contract, discovered harness capability. Produces: complete advisor/synthesis field tables and council-specific Oracle output pointer.
  - Content: adapt actual Oracle judgment from Architect (recommendation plus trade-off and runner-up, no binding architecture authority), Planner (dependency/acceptance coherence, not primary execution or mandatory named voices) and Plan Reviewer (proportional findings grounded in existing requirements; no invented blockers or reopening closed findings absent a distinct regression). Add `Lens` and `Scope and non-goals` to Oracle; preserve its read-only mandate/general verdicts. Council branch uses exact fields/enum in §3.3. Integrate approved Architect recommendation/trade-off and runner-up lens, Planner dependency/acceptance coherence and Plan Reviewer proportional existing-invariant critique into Oracle responsibilities/output. Concurrent if supported, otherwise sequential isolated advisors; neither primary enactment nor weaker review. Receipt and full report are different states. Add relevant descriptive header fields per §3.3; preserve Oracle's current headings and report contract. Attribute minority/rejected positions/reasons and change evidence; decision remains Captain's.
  - Verify: V-DOC row TASK-06; `grep -Fq 'ACKNOWLEDGED, COMPLETED, BLOCKED' .agents/reference/workflows/council.md && grep -Fq 'falsifier' .agents/reference/workflows/council.md && grep -Fq 'rejected_positions' .agents/reference/workflows/council.md` (exit 0).

- [x] **TASK-07 — Persona/procedure distinction and neutral mutation delivery**
  - Owner: authoring writer. Dependencies: TASK-01.
  - Modify: `.agents/skills/productivity/writing-for-agents/SKILL.md`, `.agents/skills/productivity/grammars-and-constrained-sampling/SKILL.md` only. Targets: writing-for-agents new `Persona, procedure and runtime` reference beside Information hierarchy; grammars Tool-Bound Execution (line 28) and constrained-prompt example (line 95).
  - Consumes: existing context-pointer rules, §3.3 persona contract. Produces: four-layer checklist with conditional Worker/Oracle references.
  - Content: mandate/lens/scope/output versus procedure/guardrails/evidence versus detail references versus harness ownership. In grammars, replace named mutation-tool requirements and the example's named edit command with verified mutation capability supplied by the installed harness. Preserve tool-bound edits, assigned-worker authority, no conversational code substitute and explicit verification; unavailable required mutation capability is BLOCKED, not permission to invent a tool or execute on the primary thread. Do not add persona tools/model frontmatter or import source personas; do not weaken full-skill embedding mandate.
  - Verify: V-DOC row TASK-07; `grep -Fq 'Persona, procedure and runtime' .agents/skills/productivity/writing-for-agents/SKILL.md && grep -Fq 'lens' .agents/skills/productivity/writing-for-agents/SKILL.md` (exit 0).

- [x] **TASK-08 — Optional approved durable learning, separate from handoff**
  - Owner: learning writer. Dependencies: TASK-01/03.
  - Modify: `.agents/skills/productivity/technical-writing-for-engineers/SKILL.md`, `.agents/skills/productivity/handoff/SKILL.md` only. Targets: technical-writing invocation/Story Frame and new learning branch; handoff transient scope pointer.
  - Consumes: §3.3 learning contract, existing temporary handoff policy. Produces: proposal-only procedure and later authorized-worker application gate.
  - Content: exact required proposal fields/enums; evidence → dedupe → minimal text/path proposal → Captain approval → separately dispatched bounded edit/check. No saved lesson before approval, no new memory store; narrative arc only for narrative branch. Handoff points to learning only on explicit durable-learning request; preserve temporary path, redaction and schema.
  - Verify: V-DOC row TASK-08; `grep -Fq 'PROPOSED, APPROVED, REJECTED, APPLIED' .agents/skills/productivity/technical-writing-for-engineers/SKILL.md && grep -Fq 'approval_ref' .agents/skills/productivity/technical-writing-for-engineers/SKILL.md` (exit 0).

- [x] **TASK-09 — Review identity and availability without weakening independence**
  - Owner: review-contract writer. Dependencies: TASK-01/02/04. Captain approval of the existing Code Reviewer/Security Auditor MERGE recommendations is recorded in the portable-fleet inventory.
  - Modify: `.agents/reference/crew/code-reviewer.md`, `.agents/reference/crew/security-reviewer.md`, `.agents/reference/schemas/review-report.yaml` only. Targets: Model/Operating Rules and schema review properties.
  - Consumes: §3.2, existing review verdict/correlation schema. Produces: accurate reviewer selection/identity evidence.
  - Content: integrate actual Code Reviewer's lens of parity plus behavior/documentation agreement and Security Auditor's lens of concrete exploitability, evidence and missing boundary checks; add `Lens` and `Scope and non-goals` in both crew briefs. Strip all source model/tool/delegate metadata, mandatory helpers and vendor paths. Keep `reviewer_model` as existing schema identity evidence; express selection as abstract INHERIT/current authorized choice, never a required dispatch parameter or writer-model assumption. Add required review `reviewer_choice_ref`, `writer_choice_ref`, `authorization_ref`, `availability_checked_at`, `context_ref` strings; refs identify actual choices without credentials, context proves reviewer is not writer session. Preserve `[CODE, SECURITY]`, `[PASS, FAIL]`, `[CORRELATED_REVIEW, INDEPENDENT_REVIEW]`. Missing identity/availability or independent context is BLOCKED, not passing review. Integrate approved Code Reviewer parity/behavior-documentation agreement and Security Auditor practical-exploitability judgment into the existing role responsibilities/lenses; add applicable descriptive header fields per §3.3 and preserve all current required headings/report contracts. Same model warning stays mandatory; schema shape alone cannot prove independence.
  - Verify: V-DOC row TASK-09 and V-SCHEMA; `grep -Fq 'context_ref' .agents/reference/schemas/review-report.yaml && grep -Fq 'CORRELATED_REVIEW' .agents/reference/crew/code-reviewer.md && grep -Fq 'CORRELATED_REVIEW' .agents/reference/crew/security-reviewer.md` (exit 0).

- [x] **TASK-10 — Align inherited default and gate documentation**
  - Owner: gate writer. Dependencies: TASK-02/05/09.
  - Modify: `.agents/skills/productivity/io-verification-control/SKILL.md`, `.agents/skills/productivity/decision-gates/gates/G8-code-review.md`, `.agents/skills/productivity/decision-gates/gates/G9-security-review.md` only. Targets: io description/§3.E Tool-Bound Delivery (line 135)/§4.B/Related/default example captions and Stage 3 delivery examples (lines 188, 238); G8/G9 Input/Config.
  - Consumes: approved constitution and review/evidence schemas. Produces: consistent default/exception language and explicit capability preconditions for both gates.
  - Content: replace single-model/named dispatch metadata in normative text and examples with abstract INHERIT/current-authorized choice plus canonical temporary lead/coder pointer. Replace the named mutation-tool directive and Stage 3 examples with verified mutation capability supplied by the installed harness, preserving tool-bound assigned-worker edits and explicit checks; unavailable required capability is BLOCKED. Active installed harness selects model/effort; no fixed API parameter/model/plugin or scheduling assumption. Keep deterministic verification. G8/G9 receive current assertion evidence, inventory and actual reviewer identity/context. Missing delegation/reviewer capability is BLOCKED, no alternate weaker review. Preserve current outcome tables and 3-cycle controls (including existing G9 severity handling); runtime enforcement is not promised.
  - Verify: V-DOC row TASK-10; `grep -Fq 'BLOCKED' .agents/skills/productivity/decision-gates/gates/G8-code-review.md && grep -Fq 'BLOCKED' .agents/skills/productivity/decision-gates/gates/G9-security-review.md && grep -Fq 'AUTHORIZED_TEMPORARY' .agents/skills/productivity/io-verification-control/SKILL.md` (exit 0).

- [x] **TASK-11 — Workflow parity with mandatory review gates**
  - Owner: workflow writer. Dependencies: TASK-05/09/10.
  - Modify: `.agents/reference/workflows/implement-then-review.md`, `.agents/reference/workflows/review-loop.md`, `.agents/reference/workflows/parallel-review.md` only. Targets: Steps/Guard rails/Concurrency note.
  - Consumes: approved G7/G8/G9, shared capability rules. Produces: no generic-review terminal shortcut.
  - Content: generic reviewer PASS/PASS_WITH_NOTES is advisory to its focus, never substitutes for G8/G9 schema PASS or authorizes implementation/commit. After corrections invalidate affected assertion proof, rerun G7 and mandatory reviews on final diff. Concurrent focused review is optional; use separate sequential native reviewer sessions when supported, BLOCKED otherwise. Keep bounded loops and delegated edits.
  - Verify: V-DOC row TASK-11; `grep -Fq 'G8' .agents/reference/workflows/implement-then-review.md && grep -Fq 'G9' .agents/reference/workflows/review-loop.md && grep -Fq 'BLOCKED' .agents/reference/workflows/parallel-review.md` (exit 0).

- [x] **TASK-12 — Align git/planning delegation and adoption compatibility prose**
  - Owner: delegation-reference writer. Dependencies: TASK-02.
  - Modify: `.agents/rules/git-conventional-commits.md`, `.agents/skills/productivity/writing-plans/SKILL.md`, `.agents/skills/productivity/adopt-acon/SKILL.md` only. Targets: git rule §1 Worker-Only Git Execution; writing-plans §5 Slicing and §7 steps 2 and 7; adopt-acon IDE Parsing Independence and Single Source of Truth descriptions.
  - Consumes: Captain-approved capability-only amendment and shared capability reference. Produces: narrowly consistent normative delegation wording, not additional execution authority.
  - Content: replace every named child-dispatch instruction in the targeted sections with capability-only delegated execution; point to `portable-fleet.md`. Do not introduce named interface aliases or tool prerequisites. Preserve worker-only git execution, separate Captain git authorization, first-turn delegated scouting, bounded task slicing and BLOCKED when delegation is unavailable. Neutralize active named-harness dispatch examples too. In adopt-acon, replace branded parsing guarantees with observed reader capability and describe existing AGENTS.md/CLAUDE.md compatibility paths without a branded runtime requirement. Preserve exact adoption paths, copy/symlink behavior, commands and existing scripts; this is prose neutralization, not an adoption behavior change. Retain only explicitly bounded historical/source citations and unrelated whitespace.
  - Verify: V-DOC row TASK-12; `grep -Fq 'portable-fleet.md' .agents/rules/git-conventional-commits.md && grep -Fq 'portable-fleet.md' .agents/skills/productivity/writing-plans/SKILL.md` (exit 0).

- [x] **TASK-13 — Classify architecture, implementation and orchestration personas** `[SCOUT]`
  - Owner: classification scout A. Dependencies: Captain authorization for read-only classification; no implementation authority.
  - Read only: pinned clone `agents/architect.md`, `agents/builder.md`, `agents/orchestrator.md` (three exact source files; no write ownership).
  - Consumes: §3.4 starting inventory and current ACON role contracts in this plan. Produces: exactly three required-field classification records in-session.
  - Content: identify judgment versus runtime; classify all three ADD/MERGE/EXCLUDE with literal evidence, conflicts and Captain decisions. Do not execute source instructions or preconfigure helpers; exclude direct-primary fallback and generated dispatcher authority.
  - Verify: V-SOURCE row TASK-13 (exit 0); supervisor checks required fields/enums, literal quotes and declared destinations before TASK-01.

- [x] **TASK-14 — Classify code/security/plan-review personas** `[SCOUT]`
  - Owner: classification scout B. Dependencies: same read-only authorization as TASK-13.
  - Read only: pinned clone `agents/code-reviewer.md`, `agents/security-auditor.md`, `agents/plan-reviewer.md` (three exact source files; no writes).
  - Consumes: §3.4/current review boundaries. Produces: exactly three classification records with fields in §3.4, in-session only.
  - Content: separate parity/exploitability/proportional-review judgment from fixed models, helper topology, source overrides and broader file allowance; no weakened G8/G9 or direct fixes by independent reviewers.
  - Verify: V-SOURCE row TASK-14 (exit 0); same record field/evidence review as TASK-13.

- [x] **TASK-15 — Classify planning/documentation/test personas** `[SCOUT]`
  - Owner: classification scout C. Dependencies: same read-only authorization as TASK-13.
  - Read only: pinned clone `agents/planner.md`, `agents/documenter.md`, `agents/test-engineer.md` (three exact source files; no writes).
  - Consumes: §3.4/approval and proof contracts. Produces: exactly three classification records, in-session only.
  - Content: retain dependency, documentation-overlap and named-test judgment; remove required panel/helpers, extra poll files, browser tools and source command paths. Flag plan-authoring authority versus read-only Oracle lens explicitly.
  - Verify: V-SOURCE row TASK-15 (exit 0); same record field/evidence review as TASK-13.

- [x] **TASK-16 — Classify reconnaissance and performance personas** `[SCOUT]`
  - Owner: classification scout D. Dependencies: same read-only authorization as TASK-13.
  - Read only: pinned clone `agents/researcher.md`, `agents/deep-researcher.md`, `agents/web-performance-auditor.md` (three exact source files; no writes).
  - Consumes: §3.4/current Scout/Researcher/Reviewer contracts. Produces: exactly three classification records, in-session only.
  - Content: distinguish code reconnaissance from web/document research; retain tracing/grounding and measured-versus-potential impact; no browser extension, installation or capture recipe.
  - Verify: V-SOURCE row TASK-16 (exit 0); same record field/evidence review as TASK-13.

- [x] **TASK-17 — Classify browser evidence and release personas; surface additions** `[SCOUT]`
  - Owner: classification scout E. Dependencies: same read-only authorization as TASK-13.
  - Read only: pinned clone `agents/bowser.md`, `agents/web-debugger.md`, `agents/releaser.md` (three exact source files; no writes).
  - Consumes: §3.4/Firstmate/Captain boundaries. Produces: three classification records plus the explicit shared runtime-observer ADD decision, in-session only.
  - Content: compare neutral runtime-evidence lens versus existing crew coverage, not two automatic imports. Strip fixed browser transport/extensions/models and autonomous release flow; keep actual observation requirements and explicitly authorized release reporting.
  - Verify: V-SOURCE row TASK-17 (exit 0); ADD records must have decision_required true and no implementation/file creation authority.

- [x] **TASK-18 — Adapt actual Scout and Researcher personas**
  - Owner: investigation-persona writer. Dependencies: TASK-01/07 and Captain-approved Researcher/Deep Researcher MERGE classifications from TASK-16.
  - Modify: `.agents/reference/crew/scout.md`, `.agents/reference/crew/researcher.md` only. Targets: Mandate, new Lens/Scope and non-goals, Report Format.
  - Consumes: Researcher/Deep Researcher approved portable lenses and §3.1. Produces: two integrated existing personas, not a new source-role catalog.
  - Content: Scout traces cross-cutting paths and explicit parity inventory to the task boundary, cites path/line and distinguishes confirmed sites from gaps. Researcher retains web/document sources, adds evidence conflict/coverage caveats and never presents code reconnaissance as authoritative web research. Both output evidence locators, uncertainty, failure/gaps and escalation semantics; read-only, no source model/tool/helper runtime directives. Add applicable descriptive header fields per §3.3; preserve existing required headings, report contracts, length bounds and role distinction.
  - Verify: V-DOC row TASK-18; `grep -Fq '## Lens' .agents/reference/crew/scout.md && grep -Fq '## Lens' .agents/reference/crew/researcher.md` (exit 0).

- [x] **TASK-19 — Adapt actual Reviewer and GitOps personas**
  - Owner: reviewer-release persona writer. Dependencies: TASK-01/07/09 and Captain-approved Code Reviewer/Web Performance Auditor/Releaser MERGE recommendations from TASK-14/16/17.
  - Modify: `.agents/reference/crew/reviewer.md`, `.agents/reference/crew/gitops.md` only. Targets: Mandate, Lens/Scope and non-goals, Operating Rules/Report Format.
  - Consumes: approved source judgment, independent G8/G9 and Captain mutation authority. Produces: neutral integrated existing personas.
  - Content: Reviewer explicitly read-only: remove its ≤5-line direct-fix permission and Applied Fixes output; fixes go to assigned writer. Add parity/documentation agreement and performance lens: static findings are potential impact, numerical results require named measured artifacts; no fabricated scorecard. GitOps adds release readiness and concrete authorized artifact/state reporting only: no automatic changeset/version/tag/publish, fixed transport, CLI or model routing. Existing authorized-operation table and Captain approval remain; no git operation is authorized here. Add applicable descriptive header fields per §3.3; preserve existing required headings/report contracts and explicit failure/escalation output semantics.
  - Verify: V-DOC row TASK-19; `grep -Fq '## Lens' .agents/reference/crew/reviewer.md && grep -Fq '## Lens' .agents/reference/crew/gitops.md && ! grep -Fq 'Apply small, obvious fixes in-place' .agents/reference/crew/reviewer.md` (exit 0).

- [x] **TASK-20 — Neutralize dispatcher and hook recipes without changing scripts**
  - Owner: safety-documentation writer. Dependencies: TASK-01/02.
  - Modify: `.agents/skills/productivity/ponytail/SKILL.md`, `.agents/skills/security-devops/git-guardrails/SKILL.md` only. Targets: Ponytail §5; git-guardrails description/intro/§1–3.
  - Consumes: neutral delegation and Captain mutation policy. Produces: capability-only prose, no required dispatcher/interceptor or new tooling.
  - Content: Ponytail references bounded delegated workers without a named call. Git guardrails removes active hook installation/configuration/code recipes and unsupported universal enforcement claims, replacing them with authority checks and evidence of protections actually supplied by the installed harness. Existing bundled script is acknowledged as a legacy artifact, untouched/out of scope and not a required or recommended adapter; no execution/setup/import instructions. Missing required safety capability reports BLOCKED/operating-mode decision, never permission for autonomous git operations.
  - Verify: V-DOC row TASK-20; `grep -Fq 'portable-fleet.md' .agents/skills/productivity/ponytail/SKILL.md && grep -Fq 'BLOCKED' .agents/skills/security-devops/git-guardrails/SKILL.md` (exit 0).

- [x] **TASK-21 — Neutralize fleet prompt entry points and G/H/M templates**
  - Owner: prompt-entry writer. Dependencies: TASK-01/02/12.
  - Modify: `.agents/skills/productivity/prompt-master/SKILL.md`, `.agents/skills/productivity/prompt-master/README.md`, `.agents/skills/productivity/prompt-master/references/templates.md` only. Targets: agent/reasoning archetypes and profile pointers, active fleet routing/setup examples, Template G/H/M/index/anchors.
  - Consumes: neutral capabilities and task/evidence contracts. Produces: harness-neutral templates usable by all assigned roles.
  - Content: remove active fleet brand/model defaults and branded installation/session recipes. Remove branded activation wording in Template G's file-scope and Template H's bounded-agent descriptions and index rows. Rename Template M to `Bounded Agent Task Brief`, update in-file links/index; retain old fragment only as a compatibility anchor, not a runtime requirement. Session/context strategies are capability choices without named APIs. Require installed-harness evidence and Firstmate worker separation for ACON tasks; no advice skipping mandatory review. Preserve unrelated multimodal techniques; mark retained README release notes `## Historical source notes (non-normative)` with an explicit end marker. No new scripts/adapters.
  - Verify: V-DOC row TASK-21; `grep -Fq 'Bounded Agent Task Brief' .agents/skills/productivity/prompt-master/references/templates.md && grep -Fq 'portable-fleet.md' .agents/skills/productivity/prompt-master/SKILL.md` (exit 0).

- [x] **TASK-22 — Replace active coding/frontier routing with capability profiles**
  - Owner: capability-profile writer. Dependencies: TASK-01/02/21.
  - Modify: `.agents/skills/productivity/prompt-master/references/platforms/coding-agents.md`, `.agents/skills/productivity/prompt-master/references/platforms/frontier-llms.md` only. Targets: active agent/model routing headings, parameter/session guidance and fleet review shortcuts.
  - Consumes: §3.2 and updated prompt entry points. Produces: neutral role/capability profiles, not vendor adapters or hardcoded recommendation tables.
  - Content: retain task/context/scope/guardrail/evidence concepts; replace branded agent/model tiers and mandatory API syntax with current-authorized capability/availability/expiry/fallback. Parameter translation belongs to installed harness; no fixed IDs, guaranteed browser tooling or self-verification exception to G8/G9. Minimal source-history quotes, if retained, require bounded non-normative markers and origins; do not preserve old recommendations as active examples. No new provider-specific tooling, optional or required.
  - Verify: V-DOC row TASK-22; `grep -Fq 'portable-fleet.md' .agents/skills/productivity/prompt-master/references/platforms/coding-agents.md && grep -Fq 'portable-fleet.md' .agents/skills/productivity/prompt-master/references/platforms/frontier-llms.md` (exit 0).

## 6. Exact no-install deterministic verification

**Captain-approved narrow validation exception:** Captain explicitly directed: "keep them as validation". The five existing inline Python snippets below (§6 V-DOC, V-SOURCE, V-SCHEMA and §8 regression/plan audit) are executable local development/plan-verification commands only. They are not ACON runtime, imported persona/skill payloads, packaged scripts, harness adapters or dependency additions. No `.py` file is created; that fact alone would not authorize embedded executable content. This explicit exception permits retaining these validation snippets, not expanding executable scope. They must never be automatically run by an adopter or copied into adapted runtime/skill payloads. No implementation or constitutional amendment is authorized by this exception.

Available in inspected environment: `/usr/bin/python3`, standard Unix utilities, installed Python `yaml` and `jsonschema`. If missing in a later environment, stop/BLOCKED; no installation authorized. These commands are validation instructions only. Every command expects exit **0**; grep checks are required content, not proof of semantic adequacy. Independent review covers meaning and exclusions.

### V-DOC (run per task)

Execute the exact assignment for the task below immediately before the common command block. Paths are exclusive write scope; validation itself is read-only. Whitespace and import/link checks inspect additions for tracked files and complete contents for new/untracked files; retain `git diff --check`. Existing trailing whitespace and unrelated broken links are baseline debt, not permission for cleanup. Required-field/enum checks still inspect the complete resulting contract. YAML comments' notice links are covered by the required shared-reference existence and reviewer reference audit.

| Task | Exact assignment |
|---|---|
| TASK-01 | `FILES='.agents/reference/portable-fleet.md'` |
| TASK-02 | `FILES='AGENTS.md .agents/rules/agent-control-plane.md'` (historical checked assignment also included root `plan.md`; do not require it after the dated deletion reconciliation above) |
| TASK-03 | `FILES='README.md .agents/INDEX.md .agents/README.md'` |
| TASK-04 | `FILES='.agents/reference/schemas/task-contract.yaml .agents/reference/schemas/ship-diff.yaml'` |
| TASK-05 | `FILES='.agents/skills/productivity/decision-gates/gates/G7-deliverable-audit.md .agents/reference/crew/worker.md .agents/reference/crew/ship.md'` |
| TASK-06 | `FILES='.agents/reference/workflows/council.md .agents/reference/crew/oracle.md .agents/reference/workflows/README.md'` |
| TASK-07 | `FILES='.agents/skills/productivity/writing-for-agents/SKILL.md .agents/skills/productivity/grammars-and-constrained-sampling/SKILL.md'` |
| TASK-08 | `FILES='.agents/skills/productivity/technical-writing-for-engineers/SKILL.md .agents/skills/productivity/handoff/SKILL.md'` |
| TASK-09 | `FILES='.agents/reference/crew/code-reviewer.md .agents/reference/crew/security-reviewer.md .agents/reference/schemas/review-report.yaml'` |
| TASK-10 | `FILES='.agents/skills/productivity/io-verification-control/SKILL.md .agents/skills/productivity/decision-gates/gates/G8-code-review.md .agents/skills/productivity/decision-gates/gates/G9-security-review.md'` |
| TASK-11 | `FILES='.agents/reference/workflows/implement-then-review.md .agents/reference/workflows/review-loop.md .agents/reference/workflows/parallel-review.md'` |
| TASK-12 | `FILES='.agents/rules/git-conventional-commits.md .agents/skills/productivity/writing-plans/SKILL.md .agents/skills/productivity/adopt-acon/SKILL.md'` |
| TASK-18 | `FILES='.agents/reference/crew/scout.md .agents/reference/crew/researcher.md'` |
| TASK-19 | `FILES='.agents/reference/crew/reviewer.md .agents/reference/crew/gitops.md'` |
| TASK-20 | `FILES='.agents/skills/productivity/ponytail/SKILL.md .agents/skills/security-devops/git-guardrails/SKILL.md'` |
| TASK-21 | `FILES='.agents/skills/productivity/prompt-master/SKILL.md .agents/skills/productivity/prompt-master/README.md .agents/skills/productivity/prompt-master/references/templates.md'` |
| TASK-22 | `FILES='.agents/skills/productivity/prompt-master/references/platforms/coding-agents.md .agents/skills/productivity/prompt-master/references/platforms/frontier-llms.md'` |

```bash
python3 - $FILES <<'PY'
from pathlib import Path
import json, re, subprocess, sys

def active_content(text):
    pairs = (
        ('Provenance and MIT notice', 'provenance and MIT notice'),
        ('Source persona inventory (non-normative)', 'source persona inventory'),
        ('Historical source notes (non-normative)', 'historical source notes'),
        ('Historical ratified plan (non-normative)', 'historical ratified plan'),
    )
    for opening, closing in pairs:
        start, end = '## ' + opening, '## End ' + closing
        starts = list(re.finditer('^' + re.escape(start) + '$', text, re.M))
        ends = list(re.finditer('^' + re.escape(end) + '$', text, re.M))
        assert len(starts) == len(ends) <= 1, opening
        if starts:
            assert ends[0].start() > starts[0].start(), opening
            text = text[:starts[0].start()] + text[ends[0].end():]
    return text

forbidden_active = re.compile(
    r'pi-subagents|invoke_subagent|manage_subagents|send_message|contact_supervisor|write_to_file|replace_file_content|'
    r'coms_send|coms_await|agent-hub|PreToolUse|delegate_depth|Model: inherit|'
    r'Claude Code|Codex CLI|Antigravity(?: IDE| CLI)?|\bAGY\b|Windsurf|\bCline\b|'
    r'(?:gpt|claude|gemini)[ -][0-9]|Opus [0-9]|Sol/Terra/Luna|'
    r'(?:runtime|harness) (?:automatically )?wakes|automatically wakes', re.I)
files = sys.argv[1:]
assert 1 <= len(files) <= 3
assert Path('.agents/reference/portable-fleet.md').is_file()
for name in files:
    p = Path(name)
    assert p.is_file() and p.suffix in {'.md', '.yaml'}, name
    tracked = subprocess.run(['git', 'ls-files', '--error-unmatch', name], capture_output=True).returncode == 0
    diff = subprocess.check_output(['git', 'diff', '--unified=0', '--', name], text=True) if tracked else p.read_text()
    added = '\n'.join(line[1:] for line in diff.splitlines() if line.startswith('+') and not line.startswith('+++')) if tracked else diff
    assert all(line.rstrip() == line for line in added.splitlines()), name
    for target in re.findall(r'(?<!!)\[[^\]]+\]\(([^\s)]+)\)', added):
        if '://' in target or target.startswith('#'):
            continue
        assert (p.parent / target.split('#')[0]).exists(), (name, target)
    assert not re.search(r'(?im)^\s*(?:```(?:bash|sh|shell|python|javascript|typescript)|(?:curl|wget)\s|(?:npm|pnpm|pip|uv)\s+(?:install|add)|import\s|require\()', added), name
    active = active_content(p.read_text())
    assert not forbidden_active.search(active), (name, 'active harness/model directive')
    assert not re.search(r'(?i)(append-prompt:|--apply|\.pi/agent-sessions|bin/af-)', active), name
    assert not re.search(r'(?i)\b(?:TODO|TBD)\b', added), name
    contracts = {
        '.agents/reference/portable-fleet.md': (
            'HarnessCapability', 'execution_host_ref', 'delegation', 'isolated_contexts',
            'workspace_isolation', 'review_isolation', 'read_only_review', 'supervision',
            'communication', 'completion_delivery', 'concurrency', 'model_selection',
            'discovery_evidence', 'checked_at',
            'AVAILABLE, UNAVAILABLE, UNKNOWN', 'RoleAuthorization', 'task_id', 'role', 'selection',
            'capability_requirements', 'available_choice_ref', 'approval_ref', 'expires_at',
            'budget_limit', 'fallback', 'fallback_approval_ref', 'MAIN_LEAD, HEAVY_CODER, REVIEWER',
            'INHERIT, AUTHORIZED_TEMPORARY', 'BLOCKED, APPROVED_DEFAULT'),
        '.agents/reference/workflows/council.md': (
            'advisor', 'position', 'evidence', 'falsifier', 'changed',
            'evidence_that_changed_position', 'concerns', 'state',
            'ACKNOWLEDGED, COMPLETED, BLOCKED', 'consensus', 'dissent',
            'rejected_positions', 'recommendation', 'captain_decision_ref'),
        '.agents/skills/productivity/writing-for-agents/SKILL.md': (
            'mandate', 'lens', 'scope', 'output', 'procedure', 'guardrails', 'evidence', 'runtime'),
        '.agents/skills/productivity/technical-writing-for-engineers/SKILL.md': (
            'lesson_id', 'trigger', 'evidence_refs', 'lesson', 'existing_overlap', 'target_path',
            'proposed_text', 'scope', 'risk', 'approval_ref', 'state',
            'PROPOSED, APPROVED, REJECTED, APPLIED'),
    }
    for token in contracts.get(name, ()):
        assert token.casefold() in active.casefold(), (name, token)
    if p.parent.name == 'crew':
        assert '## Lens' in active and '## Scope and non-goals' in active, name
    if name == '.agents/reference/portable-fleet.md':
        inventory = p.read_text().split('## Source persona inventory (non-normative)', 1)[1].split('## End source persona inventory', 1)[0]
        records = json.loads(re.search(r'```json\n(.*?)\n```', inventory, re.S).group(1))
        expected = {'architect', 'bowser', 'builder', 'code-reviewer', 'deep-researcher', 'documenter', 'orchestrator', 'plan-reviewer', 'planner', 'releaser', 'researcher', 'security-auditor', 'test-engineer', 'web-debugger', 'web-performance-auditor'}
        assert len(records) == 15 and {Path(row['source_path']).stem for row in records} == expected
        required = {'source_path', 'source_revision', 'disposition', 'destination', 'portable_lens', 'evidence', 'runtime_removed', 'rationale', 'decision_required', 'decision_ref'}
        for row in records:
            assert required <= row.keys() and row['disposition'] in {'ADD', 'MERGE', 'EXCLUDE'}
            assert row['source_revision'] == '0af843fa2c92413ea16c50e50bd8a9e24f1d1995'
            assert 1 <= len(row['evidence']['quote']) <= 120 and row['evidence']['locator']
            assert row['disposition'] != 'ADD' or row['decision_required'] is True
subprocess.run(['git', 'diff', '--check', '--', *files], check=True)
print('V-DOC PASS:', ', '.join(files))
PY
```

Whitespace/import checks apply to additions or complete new contents. The neutral-directive check additionally scans complete active contents of every owned file, excluding only exact paired source/provenance/history sections. Existing adoption scripts and deliberately out-of-scope historical plans are not scanned as active role directives and are not claimed removed. No executable command blocks may be newly inserted into adapted payloads; JSON/YAML remain data. Historical/source quotes cannot be used as operational instructions. This scanner is an aid, not a security enforcement claim.

### V-SOURCE (TASK-13–17, three exact read paths per task)

Use the task's exact assignment before the common block. The command validates pinned source identity and this plan's bounded evidence quotes; it does not execute source personas or decide their suitability. Research returns still require independent judgment and supervisor review of all §3.4 fields. No report files are written.

| Task | Exact assignment |
|---|---|
| TASK-13 | `READS='architect.md builder.md orchestrator.md'` |
| TASK-14 | `READS='code-reviewer.md security-auditor.md plan-reviewer.md'` |
| TASK-15 | `READS='planner.md documenter.md test-engineer.md'` |
| TASK-16 | `READS='researcher.md deep-researcher.md web-performance-auditor.md'` |
| TASK-17 | `READS='bowser.md web-debugger.md releaser.md'` |

```bash
python3 - $READS <<'PY'
from pathlib import Path
import re, subprocess, sys
root = Path('/tmp/acon-agent-fleet-scout-uYnPAi/repo')
assert subprocess.check_output(['git', '-C', str(root), 'rev-parse', 'HEAD'], text=True).strip() == '0af843fa2c92413ea16c50e50bd8a9e24f1d1995'
names = sys.argv[1:]
assert len(names) == 3 and len(set(names)) == 3
text = Path('docs/plans/2026-10-12-agent-fleet-portable-adaptation.md').read_text()
rows = re.findall(r'^\| `([^`]+\.md)` \| (ADD|MERGE|EXCLUDE).*?line (\d+): "(.*?)" \|', text, re.M)
lookup = {name: (line, quote) for name, disposition, line, quote in rows}
for name in names:
    assert name in lookup and Path(name).name == name
    source = (root / 'agents' / name).read_text().splitlines()
    line, quote = lookup[name]
    assert 1 <= len(quote) <= 120 and quote in source[int(line)-1], name
print('V-SOURCE PASS:', ', '.join(names))
PY
```

### V-SCHEMA (after TASK-04 and again TASK-09)

```bash
python3 - <<'PY'
from pathlib import Path
import yaml
from jsonschema import Draft202012Validator
root = Path('.agents/reference/schemas')
for name in ('task-contract.yaml', 'ship-diff.yaml', 'review-report.yaml'):
    s = yaml.safe_load((root / name).read_text())
    Draft202012Validator.check_schema(s)
    if name == 'task-contract.yaml':
        assert {'requirements', 'parity'} <= set(s['required'])
        assert 'DOCUMENTATION_CHECK' in s['properties']['verification']['properties']['verification_type']['enum']
        fields = s['properties']['requirements']['items']['required']
        assert {'requirement_id', 'revision', 'assertion', 'proof_kind', 'touchpoint_ids'} <= set(fields)
    elif name == 'ship-diff.yaml':
        assert 'assertion_evidence' in s['required']
        record = s['properties']['assertion_evidence']['items']
        assert record['properties']['status']['enum'] == ['PROVEN', 'UNPROVEN', 'FAILED']
        assert {'requirement_id', 'revision', 'status', 'evidence_refs', 'observed_state', 'reason', 'invalidated_by'} <= set(record['required'])
        sample = dict(requirement_id='REQ-001', revision=1, status='UNPROVEN', evidence_refs=[], observed_state='working-diff-1', reason='not observed', invalidated_by='')
        validator = Draft202012Validator(record)
        validator.validate(sample)
        for mutation in (dict(sample, status='SUCCESS'), dict(sample, status='PROVEN'), {k:v for k,v in sample.items() if k != 'requirement_id'}):
            assert list(validator.iter_errors(mutation)), mutation
    elif 'context_ref' in s['properties']['review']['properties']:
        assert {'reviewer_choice_ref', 'writer_choice_ref', 'authorization_ref', 'availability_checked_at', 'context_ref'} <= set(s['properties']['review']['required'])
        assert s['properties']['review']['properties']['verdict']['enum'] == ['PASS', 'FAIL']
print('V-SCHEMA PASS: schemas valid; required fields and evidence enums checked')
PY
```

The V-DOC token tables check each prose contract's required field names and closed enums; V-SCHEMA checks schema structure. These are necessary syntax/reference checks, not semantic proof. TASK-04 validates existing review schema unchanged; TASK-09 must additionally run `grep -Fq 'context_ref' .agents/reference/schemas/review-report.yaml` as listed. Schema sample checks do not substitute for the manual scenarios below. No test/fixture/validator file is created.

## 7. Acceptance scenarios and review gates

Copy these rows into the shared reference and inspect against all relevant diffs. Record reviewer evidence per scenario using stable IDs; do not claim live harness results from prose checks.

| ID | Input | Required documented result |
|---|---|---|
| REQ-001 | One authorized model/one subscription, native isolated sequential dispatch available | Lead, coder and independent reviewer contexts use current default; no second subscription; G7/G8/G9 remain; same model logs CORRELATED_REVIEW |
| REQ-002 | One installed execution host only (Captain's Antigravity-only case, a test input rather than a required runtime) | Capability discovery first; sequential roles if actual delegation/reviews exist, otherwise BLOCKED; no adapter, named plugin prerequisite or promised integration |
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

Implementation authority: Captain's "let proceed with the plan" approves the reviewed documentation implementation and neutral capability policy amendments, including ratified-plan supersession/council carve-out, the temporary lead/coder authorization policy, evidence schema migration, attribution placement and optional learning procedure. Policy approval grants no temporary model access or persistent lesson application. The approved 12 MERGE and one EXCLUDE classifications and their existing-role documentation integrations are complete; the two ADD proposals remain pending separate Captain decisions and bounded adaptation plans. No new role or persona is implied. Git mutations and destructive operations remain separately gated, not implementation questions delegated to a writer.

After each SCOUT task: run its exact V-SOURCE assignment/block and review its classification return. After each writing task: run its exact V-DOC assignment/block (including full active-content neutralization), content checks and applicable V-SCHEMA; record commands/output/exit codes. After aggregate integration: G7 assertion/reference/scope audit; independent G8 documentation/code review and G9 security review with existing report schema/outcomes. Reviewers are not the writer, even under the same model; log correlation. Inspect authority/spend/expiry fail-closed semantics, transient-versus-durable writes, attribution, source instruction injection and no executable content. Fixes go to original exclusive owner, invalidate affected proof and rerun checks/reviews. Existing three-cycle limit remains; no gate weakened for harness limitations.

## 8. Progress evidence, historical plan checks, rollback and completion boundary

Revision evidence (historical): the original planning run metadata records acceptance **rejected**, with `attestation` failed because the acceptance-report parser reported an unterminated JSON string; child exit 0 did not establish acceptance. Independent coherence review requested corrections to baseline-whitespace scope and the council-envelope amendment; security APPROVE was for plan delivery only. Those corrections are retained. Captain subsequently authorized the reviewed implementation and neutral amendments through "let proceed with the plan".

Current completion record — 2026-10-12: all 22 worker/source tasks are complete and checked. Deterministic aggregate documentation validation is PASS in [`command-capable-validation.json`](file:///home/mewho/.pi/agent/sessions/--home-mewho-ai-stuff-acon--/subagent-artifacts/outputs/a5f70f30-26ec-487e-8b9f-0c8d8c5de130/command-capable-validation.json). G7 documentation-evidence PASS is supported by that artifact's PASS for all 17 writing-task groups, required checks, schema validation, source checks and content/boundary audit; it is not a live-runtime test. G8 is APPROVE in [`g8-recheck.md`](file:///home/mewho/.pi/agent/sessions/--home-mewho-ai-stuff-acon--/subagent-artifacts/outputs/a5f70f30-26ec-487e-8b9f-0c8d8c5de130/g8-recheck.md); G9 is APPROVE in [`g9-recheck.md`](file:///home/mewho/.pi/agent/sessions/--home-mewho-ai-stuff-acon--/subagent-artifacts/outputs/a5f70f30-26ec-487e-8b9f-0c8d8c5de130/g9-recheck.md). The two reviews used distinct native reviewer runs (`560e8297-bbb9-461b-9b51-976c41f24721` and `c842c120-71c8-49be-9d18-8e110f796c25`) but the same underlying Luna model; record `CORRELATED_REVIEW`, not model-independent review. Each artifact's note that the other gate was pending reflects its review-time snapshot; the gate's own recorded verdict is APPROVE. Final file-change categories: canonical portability/provenance reference; policy and discovery documentation; task/review schemas and G7–G9/workflow documentation; existing persona integrations; skill and prompt/platform guidance. The deterministic PASS and reviews establish documentation integration only—not live harness compatibility. TASK-22 root-plan removal was separately authorized and completed; the historical origin row is retained, and the deleted root plan must not be restored.

Historical verification references for TASK-13–17, TASK-01 and TASK-02 remain useful evidence for their completed scopes only: classification returns `task-13.md` through `task-17.md` record V-SOURCE PASS at revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`; TASK-01 and TASK-02 each have prior independent G8/G9 approval references (`8754c7c3-f2aa-476e-994b-300f23a79a2a` and `31d3f908-a464-4967-aa1f-7a3cc2f05cfc`). They do not cover later task diffs or the current aggregate. The existing `CLAUDE.md` symlink remains unchanged. Source checks establish pinned HEAD and literal quotes, not runtime compatibility or persona selection. The 12 MERGE and one EXCLUDE dispositions are approved as recorded in the inventory; the two ADD rows remain pending.

### Historical planning checks (not post-implementation acceptance)

The two command blocks below are preserved verbatim as historical planning checks under the approved validation-only exception. Their In Review/zero-checked/plan-only clean-tree assertions describe the original planning state and are **not applicable after implementation**. Do not run them as implementation acceptance or demand a clean tracked tree; use each task's §6 checks and start-state delta evidence instead. The historical whitespace regression also asserts baseline-specific conditions.

At planning time these commands were intended to run from the repository root with expected exit 0. The first exercised V-DOC's whitespace-selection code against dirty tracked baselines and in-memory clean/dirty additions/new-file contents (no fixture files or git mutations):

```bash
python3 - <<'PY'
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import patch
import subprocess, textwrap
text = Path('docs/plans/2026-10-12-agent-fleet-portable-adaptation.md').read_text()
source = textwrap.dedent('    tracked = ' + text.split('    tracked = ', 1)[1].split('    for target', 1)[0])
for name in ('AGENTS.md', '.agents/rules/agent-control-plane.md', '.agents/skills/productivity/technical-writing-for-engineers/SKILL.md'):
    p = Path(name)
    assert any(line.rstrip() != line for line in p.read_text().splitlines()), name
    exec(source, dict(p=p, name=name, subprocess=subprocess))
for tracked, content, should_pass in (
    (True, '+++ b/file.md\n+clean addition\n', True),
    (True, '+++ b/file.md\n+dirty addition \n', False),
    (False, 'clean new content\n', True),
    (False, 'dirty new content \n', False),
):
    p = SimpleNamespace(read_text=lambda: content)
    with patch.object(subprocess, 'run', return_value=SimpleNamespace(returncode=0 if tracked else 1)), patch.object(subprocess, 'check_output', return_value=content):
        passed = True
        try:
            exec(source, dict(p=p, name='in-memory-case.md', subprocess=subprocess))
        except AssertionError:
            passed = False
        assert passed == should_pass, (tracked, should_pass)
print('WHITESPACE REGRESSION PASS: 3 dirty baselines accepted; 4 clean/dirty addition/new-content cases checked')
import ast, re
first = re.findall(chr(96)*3 + 'bash\n(.*?)\n' + chr(96)*3, text, re.S)[0]
body = first.split("<<'PY'\n", 1)[1].rsplit('\nPY', 1)[0]
tree = ast.parse(body)
nodes = [node for node in tree.body if isinstance(node, ast.FunctionDef) and node.name == 'active_content' or isinstance(node, ast.Assign) and any(isinstance(target, ast.Name) and target.id == 'forbidden_active' for target in node.targets)]
namespace = {'re': re}
exec(compile(ast.Module(body=nodes, type_ignores=[]), 'neutral-check', 'exec'), namespace)
clean, banned = namespace['active_content'], namespace['forbidden_active']
for sample, should_pass in (
    ('Delegate only through evidenced capabilities.', True),
    ('Use pi-subagents for dispatch.', False),
    ('Execute edits through write_to_file.', False),
    ('Delivery: tool-bound only via replace_file_content.', False),
    ('Default model: gpt-6-example.', False),
    ('The harness automatically wakes the primary.', False),
    ('## Historical source notes (non-normative)\nUse pi-subagents.\n## End historical source notes\nDelegate by capability.', True),
    ('## Source persona inventory (non-normative)\nExcluded agent-hub.\n## End source persona inventory', True),
    ('## Historical source notes (non-normative)\nUse pi-subagents.', False),
    ('## Historical source notes (non-normative)\nOld tool.\n## End historical source notes\nUse invoke_subagent.', False),
    ('Quoted marker: ## Historical source notes (non-normative)\nUse invoke_subagent.', False),
):
    passed = True
    try:
        passed = banned.search(clean(sample)) is None
    except AssertionError:
        passed = False
    assert passed == should_pass, (sample, should_pass)
print('NEUTRAL REGRESSION PASS: 11 active-vs-history/source cases checked')
PY
```

Historical planning context only: the plan was the sole new file at that stage. `git diff --check` alone ignored the untracked plan, so the following Python check verified its whitespace and exact untracked-file boundary. `.agents/reference/portable-fleet.md` was then a named proposed path. These assumptions no longer describe the implementation baseline.

```bash
git diff --check
python3 - <<'PY'
from pathlib import Path
import re, subprocess
p = Path('docs/plans/2026-10-12-agent-fleet-portable-adaptation.md')
t = p.read_text()
assert '**Status:** In Review' in t
assert not re.search(r'^- \[x\]', t, re.M)
tasks = re.findall(r'^- \[ \] \*\*(TASK-\d{2})', t, re.M)
assert tasks == ['TASK-%02d' % i for i in range(1, 23)]
rows = re.findall(r"\| TASK-\d{2} \| `FILES='([^']+)'`", t)
assert len(rows) == 17
owned = [r.split() for r in rows]
assert all(1 <= len(group) <= 3 for group in owned)
flat = [name for group in owned for name in group]
assert len(flat) == len(set(flat)), 'overlapping ownership'
for name in flat:
    assert name == '.agents/reference/portable-fleet.md' or Path(name).is_file(), name
for target in re.findall(r'(?<!!)\[[^\]]+\]\(([^\s)]+)\)', t):
    if target.startswith('file://'):
        assert Path(target[7:]).is_file(), target
    elif '://' not in target and not target.startswith('#'):
        assert (p.parent / target.split('#')[0]).exists(), target
for token in ('PROVEN, UNPROVEN, FAILED', 'AVAILABLE, UNAVAILABLE, UNKNOWN', 'MAIN_LEAD, HEAVY_CODER, REVIEWER', 'INHERIT, AUTHORIZED_TEMPORARY', 'BLOCKED, APPROVED_DEFAULT', 'ACKNOWLEDGED, COMPLETED, BLOCKED', 'PROPOSED, APPROVED, REJECTED, APPLIED', 'requirement_id', 'invalidated_by', 'falsifier', 'approval_ref', 'expires_at', 'fallback_approval_ref', 'completion_delivery'):
    assert token in t, token
assert len(re.findall(r'^\| REQ-\d{3} \|', t, re.M)) == 14
research = re.findall(r"\| TASK-(?:13|14|15|16|17) \| `READS='([^']+)'`", t)
assert len(research) == 5 and all(len(row.split()) == 3 for row in research)
source_names = [name for row in research for name in row.split()]
root = Path('/tmp/acon-agent-fleet-scout-uYnPAi/repo/agents')
assert len(set(source_names)) == 15 and set(source_names) == {p.name for p in root.glob('*.md')}
seeds = re.findall(r'^\| `([^`]+\.md)` \| (ADD|MERGE|EXCLUDE).*?line (\d+): "(.*?)" \|', t, re.M)
assert len(seeds) == 15
for name, disposition, line, quote in seeds:
    assert 1 <= len(quote) <= 120 and quote in (root / name).read_text().splitlines()[int(line)-1], name
assert not re.search(r'^\s*(?:curl|wget|npm install|pip install|git clone|git add|git commit|git push|git checkout|git switch)\s', t, re.M)
assert not re.search(r'^\s*```(?:typescript|javascript|sh|shell)\b', t, re.M)
assert not any(line.rstrip() != line for line in t.splitlines()), 'trailing whitespace'
assert not subprocess.check_output(['git', 'diff', '--cached', '--name-only'], text=True).strip(), 'staged files'
assert not subprocess.check_output(['git', 'diff', '--name-only'], text=True).strip(), 'tracked edits in plan-only task'
assert subprocess.check_output(['git', 'ls-files', '--others', '--exclude-standard'], text=True).splitlines() == [str(p)], 'unexpected untracked files'
print('PLAN PASS: 22 tasks (17 disjoint writers + 5 three-file scouts), 14 scenarios, 15 grounded persona seeds; plan-only unstaged diff')
PY
git status --short
git diff --cached --name-only
```

Rollback: implementation/amendment approval is now recorded and TASK-01/02 policy/reference changes exist. Preserve this reviewed baseline. During documentation work, keep task diffs and prior text in review artifacts; a delegated owner proposes minimal reverse edits to touched sections after Captain approval, reruns validation/G8/G9 and restores original required fields/wording only when downstream documents remain consistent. No deletion/reset/clean/checkout commands, history mutation or automatic revert. New references can be marked inactive pending a separately authorized removal; do not remove files autonomously. No data migration, runtime deployment or adoption change to roll back.

**Completion boundary.** All 22 tasks are checked, including source classification tasks TASK-13–17; those completed classifications do not resolve the separate two new-role ADD proposals. Preserve the 12 approved MERGE / one EXCLUDE / two pending ADD dispositions; existing-role documentation integrations are complete, and no new role is implied. The root `plan.md` removal was separately authorized and completed; do not recreate it. The aggregate checks and G8/G9 approvals cover documentation integration only, not live harness compatibility. Legacy scripts remain untouched; no runtime, script, adapter, dependency or subscription grant was added. The five inline validators remain local-only validation commands under the existing exception. No commit, push, staging, branch operation, or other git mutation was performed or authorized.

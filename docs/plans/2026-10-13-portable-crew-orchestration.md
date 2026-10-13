# Implementation Plan: Portable Crew Orchestration

- **Plan file:** `docs/plans/2026-10-13-portable-crew-orchestration.md`
- **Date:** 2026-10-13
- **Author:** task-bound Captain-authorized GPT 6 Luna planning specialist
- **Status:** Completed (static repository acceptance passed; not live host certification)
- **Target:** Documentation contracts only; no runtime, adapter, CLI configuration, provider catalog, `.acon/settings.json`, dependencies, CLI probes, or settings changes
- **Authorization:** Captain approved implementation and retirement of exactly the eight canonical schema YAML files, but only after replacements, scoped references, semantic parity, and independent pre-retirement review pass. No other deletion is authorized. Git staging/history/remote operations remain unauthorized.

## 1. Objective and settled decisions

Make crew orchestration host-neutral: the primary orchestrator never executes; separately assigned isolated child or peer sessions may perform bounded work. Preserve existing contract semantics and provenance while replacing exactly eight canonical YAML schema documents with readable Markdown tables and rules. There is no machine-schema appendix and no claim that Markdown is executable validation.

Settled requirements: discovery-first; ask Captain which CLIs/subscriptions are allowed, then verify supported authentication, model listing, launch, isolation, communication, and terminal completion without exposing secrets. No probe or discovery launch until Captain authorizes the choices and quota/time/cost notice; temporary sessions require explicit authorization. For each role propose available Captain-permitted model and effort; obtain approval before launch. Choices may differ by role, including a genuinely independent reviewer, only from approved available choices. No fixed catalog, runtime, adapters, settings.json, or general override. Capability `UNKNOWN` is fail-closed/BLOCKED.

Communication uses host-neutral bounded task/session messages with identities, receipt distinct from terminal completion, evidence location, state and escalation; crew reports to orchestrator. Nested-helper authority must be explicit and bounded; helpers cannot expand role, scope, budget, pane cap, authority, or substitute for independent review. Maximum four live crew panes per tab, excluding orchestrator; no cap evasion by tabs. Automation only where evidenced. Manual fallback requires Captain approval; optional host guides are not implemented. Preserve Captain-only spending, git mutation, and deletion authority; separate G8/G9 read-only contexts and actual identities; same-model reviews are marked `CORRELATED_REVIEW`. Preserve provenance and MIT notices.

## 2. Architecture, scope, and exclusions

`portable-fleet.md` remains the behavioral authority. Eight Markdown schema specifications become canonical under `.agents/reference/schemas/`; preserve all source semantics, field names, types, requiredness, enums, IDs/revisions, evidence invalidation, and conditional rules except explicitly approved host/role/session portability changes above. Preserve IDs and revisions exactly. Deliberate changes only: remove executable YAML representation in favor of readable Markdown tables/rules; replace child-only assumptions with bounded child-or-peer isolated sessions; update role/model selection to Captain-approved per-role choices; add host-neutral session/receipt/completion and explicit bounded nested-helper rules; settle pane/fallback constraints as above. Do not otherwise weaken or reinterpret schema fields.

Update only inventoried active consumer paths: `README.md`, `.agents/INDEX.md`, `.agents/README.md`, `AGENTS.md`, `.agents/rules/agent-control-plane.md`, `.agents/reference/portable-fleet.md`, `scripts/adopt.sh`; `.agents/skills/productivity/{grammars-and-constrained-sampling/SKILL.md,io-verification-control/SKILL.md,decision-gates/SKILL.md,grill-me/SKILL.md,handoff/SKILL.md,writing-plans/SKILL.md,adopt-acon/SKILL.md,prompt-master/SKILL.md,prompt-master/references/templates.md,prompt-master/references/platforms/coding-agents.md}`; `.agents/skills/productivity/decision-gates/examples.md` and `gates/{G8-code-review.md,G9-security-review.md}`; `.agents/reference/crew/{worker.md,ship.md,reviewer.md,code-reviewer.md,security-reviewer.md}`. Confirm exact references again before editing. `.agents/rules/agent-control-plane.md` and root `AGENTS.md` mirror parity is required. `CLAUDE.md` is a symlink, not a second owner. Exclude historical plans, unrelated YAML metadata/examples, lockfiles, and other files without active schema consumers.

Ponytail: YAGNI/no runtime or host guides; reuse existing contracts and tools; zero dependencies; minimal bounded diffs. Safety: no secrets, explicit failure states, exact parity evidence, and independent reviews.

## 3. Ordered task contracts

Each entry is a unique `TASK-NN`, exclusive ownership of at most three repository paths. Execute in listed order; later tasks consume prior outputs. Every task is `[AUTONOMOUS-SHIP]`, except policy text changes still cannot override Captain authority. Plan progress edits are not assigned. Each task brief is sliced to that task only and kept under 2,000 tokens.

### TASK-01 — Create first two contract specs
**Files:** create `.agents/reference/schemas/scout-report.md`; create `.agents/reference/schemas/ship-diff.md`.
**Consumes:** paired YAML source files; existing portable-fleet acceptance/evidence rules.
**Produces:** readable normative field/rules tables, field-by-field parity mapping including requiredness, types, enums, IDs/revisions and conditionals; no YAML deletion.
**Verify:** `test -f` both specs; `git diff --check`; manual parity matrix covers every source field and constraint.

### TASK-02 — Create next two contract specs
**Files:** create `.agents/reference/schemas/grill-interview.md`; create `.agents/reference/schemas/handoff-state.md`.
**Consumes:** paired YAML sources and grill-me/handoff semantics.
**Produces:** complete Markdown parity specs; no YAML deletion.
**Verify:** both paths exist; diff check; parity matrix includes all cardinalities, patterns, requiredness and enums.

### TASK-03 — Create next two contract specs
**Files:** create `.agents/reference/schemas/bearings-digest.md`; create `.agents/reference/schemas/decision-sheet.md`.
**Consumes:** paired YAML sources and the four-section Bearings/seven-gate rules.
**Produces:** complete Markdown parity specs; no YAML deletion.
**Verify:** paths exist; diff check; parity confirms four sections, seven gates, conditional NONE, advisory default and tighten-only rules.

### TASK-04 — Create final two contract specs
**Files:** create `.agents/reference/schemas/task-contract.md`; create `.agents/reference/schemas/review-report.md`.
**Consumes:** paired YAML sources; portable role authorization and G8/G9 review rules.
**Produces:** complete Markdown parity specs, preserving ID pattern/revisions, authorization and review identity/correlation; apply only settled approved role/session changes.
**Verify:** paths exist; diff check; parity includes every field, enum, bound and condition.

### TASK-05 — Update catalogs
**Files:** modify `README.md`, `.agents/INDEX.md`, `.agents/README.md`.
**Consumes:** eight completed Markdown specs and exact inventory.
**Produces:** accurate eight-item Markdown catalog and resolving links; no stale YAML schema catalog/count.
**Verify:** `test -f` all eight paths; all three catalogs link all eight. Guarded absence check returns zero only on confirmed absence and nonzero on match/error: `if grep -nE '\.yaml|7 Machine Schemas|canonical YAML' README.md .agents/INDEX.md .agents/README.md; then exit 1; else rc=$?; test "$rc" -eq 1; fi`; `git diff --check`.

### TASK-06 — Update governance source and mirrored rule
**Files:** modify `AGENTS.md`, `.agents/rules/agent-control-plane.md`, `.agents/reference/portable-fleet.md`.
**Consumes:** approved decisions and eight specs.
**Produces:** host-neutral policies, root/rule mirror parity, preserved MIT/provenance, authority and fail-closed rules, explicit session/task/receipt/completion and bounded-helper contracts; discovery is an authorized future step, not performed here.
**Verify:** compare mirror contents/parity; positive checks for `UNKNOWN`, `BLOCKED`, `CORRELATED_REVIEW`, Captain approval, pane limit, and no-primary-execution; guarded stale-active-reference check (matches/errors nonzero); `git diff --check`.

### TASK-07 — Update skill consumer group one
**Files:** modify `.agents/skills/productivity/grammars-and-constrained-sampling/SKILL.md`, `.agents/skills/productivity/io-verification-control/SKILL.md`, `.agents/skills/productivity/writing-plans/SKILL.md`.
**Consumes:** TASK-01–06 Markdown specs/policy.
**Produces:** accurate links and contract wording without YAML-schema enforcement claims; preserve skills otherwise.
**Verify:** positive links to replacements; guarded search for old canonical links with match/error nonzero; `git diff --check`.

### TASK-08 — Update skill consumer group two
**Files:** modify `.agents/skills/productivity/decision-gates/SKILL.md`, `.agents/skills/productivity/grill-me/SKILL.md`, `.agents/skills/productivity/handoff/SKILL.md`.
**Consumes:** Markdown specs/policy.
**Produces:** updated links and semantics, no unrelated behavior changes.
**Verify:** positive replacement links; guarded stale-link search; `git diff --check`.

### TASK-09 — Update skill consumer group three
**Files:** modify `.agents/skills/productivity/adopt-acon/SKILL.md`, `.agents/skills/productivity/prompt-master/SKILL.md`, `.agents/skills/productivity/prompt-master/references/templates.md`.
**Consumes:** Markdown specs/policy.
**Produces:** updated links and accurate host-neutral brief language.
**Verify:** positive replacement links; guarded stale-link search; `git diff --check`.

### TASK-10 — Update prompt platform, examples, and gates
**Files:** modify `.agents/skills/productivity/prompt-master/references/platforms/coding-agents.md`, `.agents/skills/productivity/decision-gates/examples.md`, `.agents/skills/productivity/decision-gates/gates/G8-code-review.md`.
**Consumes:** Markdown specs/policy.
**Produces:** corrected consumer links; preserve review independence and evidence requirements.
**Verify:** positive links and G8 separate-context checks; guarded stale-link search; `git diff --check`.

### TASK-11 — Update security gate and crew reports
**Files:** modify `.agents/skills/productivity/decision-gates/gates/G9-security-review.md`, `.agents/reference/crew/worker.md`, `.agents/reference/crew/ship.md`.
**Consumes:** Markdown specs/policy.
**Produces:** corrected links, host-neutral bounded session reporting, receipt distinct from completion.
**Verify:** positive links and G9 distinct-context checks; guarded stale-link search; `git diff --check`.

### TASK-12 — Update reviewer crew contracts
**Files:** modify `.agents/reference/crew/reviewer.md`, `.agents/reference/crew/code-reviewer.md`, `.agents/reference/crew/security-reviewer.md`.
**Consumes:** Markdown ReviewReport and portable policy.
**Produces:** updated links and separate G8/G9 identity/context, correlated-review handling.
**Verify:** positive links/identity checks; guarded stale-link search; `git diff --check`.

### TASK-13 — Update adoption inventory behavior
**Files:** modify `scripts/adopt.sh` only.
**Consumes:** exact eight Markdown inventory and existing wholesale reference-copy behavior.
**Produces:** canonical schema count/display reports exactly eight Markdown specs, preserving all copy behavior.
**Verify:** `bash -n scripts/adopt.sh`; safe temporary fixture containing exactly eight canonical Markdown names verifies count 8; inspect fixture cleanup; no adoption against foreign target, no dependencies. `git diff --check`.

### TASK-14 — Pre-retirement reference/parity audit
**Files:** no production file changes; task-local report only.
**Consumes:** all completed conversions and consumer diffs, exact inventoried paths.
**Produces:** independent read-only pre-retirement report mapping every YAML field/constraint to Markdown and verifying all active references resolve, mirror parity, acceptance rules and unchanged unrelated files. Independent reviewer context must report actual authorized choice/availability; distinct G8 and G9 reviews with identities and `CORRELATED_REVIEW` if same model. No review may substitute for the other.
**Verify:** guarded absence checks (confirmed absence exit 0; match or inspection error nonzero); all eight `.md` present; enumerate active exact-path links and resolve them; `bash -n scripts/adopt.sh`; `git diff --check`. If any check/review fails, stop: no retirement.

### TASK-15 — Retire first two approved YAML contracts
**Files:** delete `.agents/reference/schemas/scout-report.yaml`, `.agents/reference/schemas/ship-diff.yaml` only.
**Consumes:** TASK-14 PASS report and paired parity entries.
**Produces:** precisely these two retired sources.
**Verify:** paired `.md` files exist; paired YAML absent; guard inspection errors/matches nonzero; `git diff --check`.

### TASK-16 — Retire next two approved YAML contracts
**Files:** delete `.agents/reference/schemas/grill-interview.yaml`, `.agents/reference/schemas/handoff-state.yaml` only.
**Consumes:** TASK-14 PASS and corresponding task-15 completion.
**Produces:** precisely these two retired sources.
**Verify:** paired Markdown exists, YAML absent, guarded checks, `git diff --check`.

### TASK-17 — Retire next two approved YAML contracts
**Files:** delete `.agents/reference/schemas/bearings-digest.yaml`, `.agents/reference/schemas/decision-sheet.yaml` only.
**Consumes:** TASK-14 PASS and task-16 completion.
**Produces:** precisely these two retired sources.
**Verify:** paired Markdown exists, YAML absent, guarded checks, `git diff --check`.

### TASK-18 — Retire final two approved YAML contracts
**Files:** delete `.agents/reference/schemas/task-contract.yaml`, `.agents/reference/schemas/review-report.yaml` only.
**Consumes:** TASK-14 PASS and task-17 completion.
**Produces:** precisely these two retired sources.
**Verify:** paired Markdown exists; all eight named YAML sources absent; unrelated YAML untouched; guarded checks and `git diff --check`.

### TASK-19 — Final read-only acceptance and independent reviews — COMPLETE
**Files:** no production files; task-local reports.
**Consumes:** all task diffs, parity report, and authorized retirement evidence.
**Produces:** final acceptance inventory, independent G8 and G9 reports, separate read-only contexts, actual writer/reviewer identities, authorization/availability evidence, and correlation marker where applicable. Fixes return to exclusive owner; no edits here.
**Verify:** exact eight `.md` inventory; exact eight YAML absence checks with safe status semantics; resolve all active references; verify root/rule parity, adoption `bash -n`, temporary count fixture procedure, `git diff --check`; G8/G9 terminal reports both approve. Unknown evidence is BLOCKED.

## 4. Acceptance and risks

Acceptance: only eight named canonical YAML files are retired and only after TASK-14 approval; all source semantics/IDs/revisions preserved except the listed approved portability changes; catalogs and exact active consumer references point to Markdown; adoption still copies reference wholesale and counts eight canonical Markdown specs; no runtime, adapter, dependency, settings, CLI probe or host guide; fail-closed `UNKNOWN`/`BLOCKED`; separate G8/G9; preserve attribution. Existing dirty workspace baseline must be preserved; workers must not revert or overwrite pre-existing changes.

No generic test suite is asserted for this documentation-only work. Deterministic link/inventory/parity checks, safe count fixture, shell syntax and diff checks are required. Risks: semantic omission (prevent retirement until independent parity audit), active consumer missed (repeat narrowly scoped exact-name inventory), mistaken absence check (guard grep status including errors), and adopting assumed host capability (discovery requires Captain authorization and evidence). No task stages, commits, pushes, installs, probes, or launches a host.

## 5. Provenance and MIT notice

Preserve required provenance and MIT attribution from `.agents/reference/portable-fleet.md`; no source runtime configuration or persona-selection behavior is adopted. End of provenance and MIT notice.

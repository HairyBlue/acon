# Agentic Conventions & Control Plane Network (ACON) — Centralized Agent Resources

This directory contains repository-wide rules, skills, and the lookup index for AI agents:

- **[INDEX.md](INDEX.md)**: Comprehensive lookup matrix mapping developer symptoms, tasks, and tech stacks to specialist skills.
- **[rules/](rules/)**: Repository and agent operational rules:
  - [`agent-control-plane.md`](rules/agent-control-plane.md): Enforceable multi-agent delegation thresholds, boundary isolation, and Captain authority gates.
  - [`git-conventional-commits.md`](rules/git-conventional-commits.md): Conventional Commits v1.0.0 enforcement.
  - [`progress-reporting.md`](rules/progress-reporting.md): Daily progress reporting standards, Markdown-first local archival, and content exclusions.
  - [`security-secrets-guard.md`](rules/security-secrets-guard.md): Zero-leakage policy for credentials, environment files, and sensitive keys.
- **[skills/](skills/)**: Curated skills organized across 4 specialized domains (36 skills + 67 style presets + 17 craft references):
  - **[`design/`](skills/design/README.md)** (2 skills + 67 presets + 17 craft references): Master design orchestrator, craft engineering (`interface-design`, anti-slop, hierarchy), Impeccable Design Director (`impeccable`), 67 curated aesthetic style presets (`clean`, `sleek`, `bento`, `ant`, etc.), and 17 design craft references (`craft/`).
  - **[`engineering/`](skills/engineering/README.md)** (14 skills): Master orchestrator, TDD, code review, systematic bug diagnosis, domain modeling, codebase design, refactoring, API design, and zero-downtime migrations.
  - **[`productivity/`](skills/productivity/README.md)** (14 skills): Master orchestrator, repository adoption (`adopt-acon`), decision gates (`decision-gates`), 9-dimension intent extraction (`prompt-master`), machine grammars (`grammars-and-constrained-sampling`), I/O & verification control (`io-verification-control`), anti-overengineering (`ponytail`), plan interrogation (`grill-me`), bite-sized planning (`writing-plans`), context compaction (`handoff`), RFC authoring, and progress reporting. The existing [`technical-writing-for-engineers`](skills/productivity/technical-writing-for-engineers/SKILL.md) is also the entry for optional durable-learning proposals: evidence-ground and deduplicate lessons in-session first; persist only after separate Captain approval of exact text/path/scope and assigned-worker verification. Transient handoff is not durable learning.
  - **[`security-devops/`](skills/security-devops/README.md)** (6 skills): Master orchestrator, static security audits (21 modules), git guardrails, git worktrees, shell scripting, conventional commits, and pre-commit hooks.
- **[reference/](reference/)**: Shared engineering reference catalogs, subagent briefs, and machine contracts:
  - **[`crew/README.md`](reference/crew/README.md)**: Canonical capability discovery, authorized role routing and unsupported-mode contract. Reading conventions is not SHIP support; required delegation, isolation, supervision/communication, terminal completion and separate read-only G8/G9 review must be evidenced. Missing required capabilities mean `BLOCKED`; one authorized subscription suffices when capabilities are available. No runtime adapter or automatic scheduling is supplied.
  - **[`crew/`](reference/crew/)**: Specialist subagent persona briefs (`scout.md`, `worker.md`, `reviewer.md`, `oracle.md`, `researcher.md`, `gitops.md`, `ship.md`).
  - **[`workflows/`](reference/workflows/)**: Repeatable multi-agent orchestration recipes (`council.md`, `implement-then-review.md`, `review-loop.md`, `parallel-review.md`, `oracle-first.md`, `scout-then-plan.md`).
  - **[`schemas/`](reference/schemas/)**: Eight normative Markdown contract specifications (readable field/rule tables; not executable validation schemas):
    - [`scout-report.md`](reference/schemas/scout-report.md): Structured audit and exploration reports.
    - [`ship-diff.md`](reference/schemas/ship-diff.md): Implementation specialist task completion summaries.
    - [`grill-interview.md`](reference/schemas/grill-interview.md): Front-loaded alignment interview rounds.
    - [`task-contract.md`](reference/schemas/task-contract.md): Implementation plan atomic task boundaries.
    - [`handoff-state.md`](reference/schemas/handoff-state.md): Session state compaction and context handoffs.
    - [`bearings-digest.md`](reference/schemas/bearings-digest.md): Canonical four-section Fleet Bearings status report.
    - [`decision-sheet.md`](reference/schemas/decision-sheet.md): Machine-native decision gate evaluations and probability sheets.
    - [`review-report.md`](reference/schemas/review-report.md): Independent code/security review findings and outcomes.
  - [`fowler-smells.md`](reference/fowler-smells.md): Consolidated Fowler code smells catalog, diagnostics, and refactoring remedies.

## Provenance and MIT notice

Capability and optional-learning discovery pointers are informed by Fleet `docs/PHILOSOPHY.md` and `skills/compound-learning/SKILL.md`, revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`. See the [local provenance and full MIT notice](reference/crew/README.md#provenance-and-mit-notice). No source runtime or new skill is imported.

## End provenance and MIT notice



# Agentic Conventions & Control Plane Network (ACON) — Centralized Agent Resources

This directory contains repository-wide rules, skills, and the lookup index for AI agents:

- **[INDEX.md](INDEX.md)**: Comprehensive lookup matrix mapping developer symptoms, tasks, and tech stacks to specialist skills.
- **[rules/](rules/)**: Repository and agent operational rules:
  - [`agent-control-plane.md`](rules/agent-control-plane.md): Enforceable multi-agent delegation thresholds, boundary isolation, and Captain authority gates.
  - [`git-conventional-commits.md`](rules/git-conventional-commits.md): Conventional Commits v1.0.0 enforcement.
  - [`progress-reporting.md`](rules/progress-reporting.md): Daily progress reporting standards, Markdown-first local archival, and content exclusions.
  - [`security-secrets-guard.md`](rules/security-secrets-guard.md): Zero-leakage policy for credentials, environment files, and sensitive keys.
- **[skills/](skills/)**: Curated skills organized across 4 specialized domains (36 skills + 67 style presets):
  - **[`design/`](skills/design/README.md)** (2 skills + 67 presets): Master design orchestrator, craft engineering (`interface-design`, anti-slop, hierarchy), Impeccable Design Director (`impeccable`), and 67 curated aesthetic style presets (`clean`, `sleek`, `bento`, `ant`, etc.).
  - **[`engineering/`](skills/engineering/README.md)** (14 skills): Master orchestrator, TDD, code review, systematic bug diagnosis, domain modeling, codebase design, refactoring, API design, and zero-downtime migrations.
  - **[`productivity/`](skills/productivity/README.md)** (14 skills): Master orchestrator, repository adoption (`adopt-acon`), decision gates (`decision-gates`), 9-dimension intent extraction (`prompt-master`), machine grammars (`grammars-and-constrained-sampling`), I/O & verification control (`io-verification-control`), anti-overengineering (`ponytail`), plan interrogation (`grill-me`), bite-sized planning (`writing-plans`), context compaction (`handoff`), RFC authoring, and progress reporting.
  - **[`security-devops/`](skills/security-devops/README.md)** (6 skills): Master orchestrator, static security audits (21 modules), git guardrails, git worktrees, shell scripting, conventional commits, and pre-commit hooks.
- **[reference/](reference/)**: Shared engineering reference catalogs, subagent briefs, and machine contracts:
  - **[`crew/`](reference/crew/)**: Specialist subagent persona briefs (`scout.md`, `worker.md`, `reviewer.md`, `oracle.md`, `researcher.md`, `gitops.md`, `ship.md`).
  - **[`workflows/`](reference/workflows/)**: Repeatable multi-agent orchestration recipes (`council.md`, `implement-then-review.md`, `review-loop.md`, `parallel-review.md`, `oracle-first.md`, `scout-then-plan.md`).
  - **[`schemas/`](reference/schemas/)**: Canonical YAML machine grammars:
    - [`scout-report.yaml`](reference/schemas/scout-report.yaml): Structured audit and exploration reports.
    - [`ship-diff.yaml`](reference/schemas/ship-diff.yaml): Implementation specialist task completion summaries.
    - [`grill-interview.yaml`](reference/schemas/grill-interview.yaml): Front-loaded alignment interview rounds.
    - [`task-contract.yaml`](reference/schemas/task-contract.yaml): Implementation plan atomic task boundaries.
    - [`handoff-state.yaml`](reference/schemas/handoff-state.yaml): Session state compaction and context handoffs.
    - [`bearings-digest.yaml`](reference/schemas/bearings-digest.yaml): Canonical 4-section Fleet Bearings status report.
    - [`decision-sheet.yaml`](reference/schemas/decision-sheet.yaml): Machine-native decision gate evaluations and probability sheets.
  - [`fowler-smells.md`](reference/fowler-smells.md): Consolidated Fowler code smells catalog, diagnostics, and refactoring remedies.



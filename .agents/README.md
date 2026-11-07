# Agentic Conventions & Control Plane Network (ACON) — Centralized Agent Resources

This directory contains repository-wide rules, skills, and the lookup index for AI agents:

- **[INDEX.md](INDEX.md)**: Comprehensive lookup matrix mapping developer symptoms, tasks, and tech stacks to specialist skills.
- **[rules/](rules/)**: Repository and agent operational rules:
  - [`agent-control-plane.md`](rules/agent-control-plane.md): Summary of Operating Modes, No-New-Tests default, Direct Execution default, and Captain authority gates.
  - [`git-conventional-commits.md`](rules/git-conventional-commits.md): Conventional Commits v1.0.0 enforcement.
  - [`progress-reporting.md`](rules/progress-reporting.md): Daily progress reporting standards, Markdown-first local archival, and content exclusions.
  - [`security-secrets-guard.md`](rules/security-secrets-guard.md): Zero-leakage policy for credentials, environment files, and sensitive keys.
- **[skills/](skills/)**: Curated skill content across four specialized domains:
  35 routable leaf skills (4 design, 14 engineering, 11 productivity, 6 security-devops), plus 67 style presets and 17 craft references. Leaf counts exclude the four domain-router `SKILL.md` entrypoints; presets and craft references are separate from skills.
  - **[`design/`](skills/design/README.md)** (4 leaf skills + 67 presets + 17 craft references): Master design orchestrator, craft engineering (`interface-design`, anti-slop, hierarchy), Impeccable Design Director (`impeccable`), `better-interface`, `find-animation-opportunities`, 67 curated aesthetic style presets (`clean`, `sleek`, `bento`, `ant`, etc.), and 17 design craft references (`craft/`).
  - **[`engineering/`](skills/engineering/README.md)** (14 leaf skills): Master orchestrator, refactoring, bug diagnosis, code review, frontend conventions, domain modeling, codebase design, API design, opt-in TDD, and zero-downtime migrations (high-traffic production).
  - **[`productivity/`](skills/productivity/README.md)** (11 leaf skills): Master orchestrator, anti-overengineering (`ponytail`), MPOR reporting (`mpor-report`), daily progress reporting (`daily-progress-report`), plan interrogation (`grill-me`), 9-dimension intent extraction (`prompt-master`), opt-in planning (`writing-plans`), repository adoption (`adopt-acon`), context compaction (`handoff`), RFC authoring (`technical-writing-for-engineers`), and developer stories.
  - **[`security-devops/`](skills/security-devops/README.md)** (6 leaf skills): Master orchestrator, static security audits (21 modules), git guardrails, git worktrees, shell scripting, conventional commits, and pre-commit hooks.
- **[reference/](reference/)**: Shared engineering reference catalogs, subagent briefs, and machine contracts:
  - **[`crew/README.md`](reference/crew/README.md)**: Canonical capability discovery, authorized role routing and unsupported-mode contract.
  - **[`crew/`](reference/crew/)**: Specialist subagent persona briefs (`scout.md`, `worker.md`, `reviewer.md`, `code-reviewer.md`, `security-reviewer.md`, `oracle.md`, `researcher.md`, `gitops.md`, `ship.md`).
  - **[`workflows/`](reference/workflows/)**: Repeatable multi-agent orchestration recipes (`council.md`, `implement-then-review.md`, `review-loop.md`, `parallel-review.md`, `oracle-first.md`, `scout-then-plan.md`).
  - **[`schemas/`](reference/schemas/)**: Seven normative Markdown contract specifications (readable field/rule tables; not executable validation schemas):
    - [`scout-report.md`](reference/schemas/scout-report.md): Structured audit and exploration reports.
    - [`ship-diff.md`](reference/schemas/ship-diff.md): Implementation specialist task completion summaries.
    - [`grill-interview.md`](reference/schemas/grill-interview.md): Front-loaded alignment interview rounds.
    - [`task-contract.md`](reference/schemas/task-contract.md): Implementation plan atomic task boundaries.
    - [`handoff-state.md`](reference/schemas/handoff-state.md): Session state compaction and context handoffs.
    - [`bearings-digest.md`](reference/schemas/bearings-digest.md): Canonical four-section Fleet Bearings status report.
    - [`review-report.md`](reference/schemas/review-report.md): Independent code/security review findings and outcomes.
  - [`fowler-smells.md`](reference/fowler-smells.md): Consolidated Fowler code smells catalog, diagnostics, and refactoring remedies.

## Provenance and MIT notice

Capability and optional-learning discovery pointers are informed by Fleet `docs/PHILOSOPHY.md` and `skills/compound-learning/SKILL.md`, revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`. See the [local provenance and full MIT notice](reference/crew/README.md#provenance-and-mit-notice). No source runtime or new skill is imported.

## End provenance and MIT notice

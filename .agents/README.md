# Centralized Agent Resources

This directory contains repository-wide rules, skills, and the lookup index for AI agents:

- **[INDEX.md](INDEX.md)**: Comprehensive lookup matrix mapping developer symptoms, tasks, and tech stacks to specialist skills.
- **[rules/](rules/)**: Repository and agent operational rules:
  - [`agent-control-plane.md`](rules/agent-control-plane.md): Enforceable multi-agent delegation thresholds, boundary isolation, and Captain authority gates.
  - [`git-conventional-commits.md`](rules/git-conventional-commits.md): Conventional Commits v1.0.0 enforcement.
  - [`progress-reporting.md`](rules/progress-reporting.md): Daily progress reporting standards, Markdown-first local archival, and content exclusions.
  - [`security-secrets-guard.md`](rules/security-secrets-guard.md): Zero-leakage policy for credentials, environment files, and sensitive keys.
- **[skills/](skills/)**: Curated skills organized across 4 specialized domains:
  - **[`design/`](skills/design/README.md)** (3 skills + 67 presets): Master design orchestrator, craft engineering (`interface-design`, anti-slop, hierarchy), Impeccable Design Director (`impeccable`), and 67 curated aesthetic style presets (`clean`, `sleek`, `bento`, `ant`, etc.).
  - **[`engineering/`](skills/engineering/README.md)** (14 skills): Master orchestrator, TDD, code review, systematic bug diagnosis, domain modeling, codebase design, refactoring, API design, and zero-downtime migrations.
  - **[`productivity/`](skills/productivity/README.md)** (13 skills): Master orchestrator, repository adoption (`adopt-acon`), 9-dimension intent extraction (`prompt-master`), machine grammars (`grammars-and-constrained-sampling`), I/O & verification control (`io-verification-control`), anti-overengineering (`ponytail`), plan interrogation (`grill-me`), context compaction (`handoff`), RFC authoring, and progress reporting.
  - **[`security-devops/`](skills/security-devops/README.md)** (6 skills): Master orchestrator, static security audits (21 modules), git guardrails, git worktrees, shell scripting, conventional commits, and pre-commit hooks.
- **[schemas/](schemas/)**: Canonical YAML machine grammars:
  - [`scout-report.yaml`](schemas/scout-report.yaml): Structured audit and exploration reports.
  - [`ship-diff.yaml`](schemas/ship-diff.yaml): Implementation specialist task completion summaries.
  - [`grill-interview.yaml`](schemas/grill-interview.yaml): Front-loaded alignment interview rounds.
  - [`task-contract.yaml`](schemas/task-contract.yaml): Implementation plan atomic task boundaries.
  - [`handoff-state.yaml`](schemas/handoff-state.yaml): Session state compaction and context handoffs.
  - [`bearings-digest.yaml`](schemas/bearings-digest.yaml): Canonical 4-section Fleet Bearings status report.
- **[reference/](reference/)**: Shared engineering reference catalogs:
  - [`fowler-smells.md`](reference/fowler-smells.md): Consolidated Fowler code smells catalog, diagnostics, and refactoring remedies.



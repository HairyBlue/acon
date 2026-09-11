# Centralized Agent Resources

This directory contains repository-wide rules, skills, and the lookup index for AI agents:

- **[INDEX.md](INDEX.md)**: Comprehensive lookup matrix mapping developer symptoms, tasks, and tech stacks to specialist skills.
- **[rules/](rules/)**: Repository and agent operational rules:
  - [`agent-control-plane.md`](rules/agent-control-plane.md): Enforceable multi-agent delegation thresholds, boundary isolation, and Captain authority gates.
  - [`git-conventional-commits.md`](rules/git-conventional-commits.md): Conventional Commits v1.0.0 enforcement.
  - [`progress-reporting.md`](rules/progress-reporting.md): Daily progress reporting standards, Markdown-first local archival, and content exclusions.
  - [`security-secrets-guard.md`](rules/security-secrets-guard.md): Zero-leakage policy for credentials, environment files, and sensitive keys.
- **[skills/](skills/)**: Curated skills organized across 5 specialized domains:
  - **[`design/`](skills/design/README.md)** (2 skills + 67 presets): Master design orchestrator, craft engineering (`interface-design`, anti-slop, hierarchy), and 67 curated aesthetic style presets (`clean`, `sleek`, `bento`, `ant`, etc.).
  - **[`engineering/`](skills/engineering/README.md)** (14 skills): Master orchestrator, TDD, code review, systematic bug diagnosis, domain modeling, codebase design, refactoring, API design, and zero-downtime migrations.
  - **[`frameworks/`](skills/frameworks/README.md)** (8 skills): Master orchestrator, Laravel 13.x, Filament 5.x, Inertia v3, Vue 3, Tailwind CSS, Wayfinder, and Pest testing.
  - **[`productivity/`](skills/productivity/README.md)** (10 skills): Master orchestrator, repository adoption (`adopt-acon`), 9-dimension intent extraction (`prompt-master`), anti-overengineering (`ponytail`), plan interrogation (`grill-me`), context compaction (`handoff`), RFC authoring, and progress reporting.
  - **[`security-devops/`](skills/security-devops/README.md)** (6 skills): Master orchestrator, static security audits (50+ vulnerabilities), git guardrails, git worktrees, shell scripting, conventional commits, and pre-commit hooks.

---

## 📚 References & Prior Art

ACON builds upon and draws architectural inspiration from pioneering patterns in the AI agent and developer tooling ecosystem:

- **[Firstmate](https://github.com/kunchenguid/firstmate)**: Architectural standard for the Agent Control Plane (*"Talk to one agent. Ship with a crew."*), First Mate liaison model, Ship vs. Scout task shaping, non-overlapping file boundary isolation, and Fleet Bearings status digests.
- **[nidhinjs / prompt-master](https://github.com/nidhinjs/prompt-master)**: 9-dimension intent extraction, model-specific prompt calibration, and airtight agent task briefing templates.
- **[Dammyjay93 / interface-design](https://github.com/Dammyjay93/interface-design)**: Craft-first interface design engineering, anti-slop rules, subtle surface elevation, and persistent design memory.
- **[bergside / awesome-design-skills](https://github.com/bergside/awesome-design-skills)**: Curated registry of 67 design system skill presets and token specifications.
- **[Matt Pocock's Skills](https://github.com/mattpocock/skills)**: Modular agent skill conventions, disciplined engineering workflows, specification synthesis, and reproducible agent interactions.
- **[Cal.diy Repository](https://github.com/calcom/cal.diy/tree/main)**: Structural pattern for `.claude`, `.cursor`, and `.agents` symlinks, centralized rules, and cross-IDE agent tooling configuration.
- **[3stoneBrother / code-audit](https://github.com/3stoneBrother/code-audit)**: Static code security analysis methodology, vulnerability checklists (PHP, JS, Python, C#), taint tracking, and verification techniques.
- **[marcelorodrigo / agent-skills](https://github.com/marcelorodrigo/agent-skills)**: Curated agent skills ecosystem, engineering workflows, and prompt architecture.
- **[dietrichgebert / ponytail](https://github.com/dietrichgebert/ponytail)**: Pragmatically lazy senior developer persona, 7-Rung Decision Ladder (YAGNI, stdlib, platform natives, zero-deps, inline clarity), and code-level anti-overengineering reviews.

> **Heartfelt Acknowledgement:** Immense gratitude to the countless open-source developers, researchers, and community builders whose gists, discussions, and experiments have quietly advanced modern agentic conventions and developer tooling. Even where not cited individually by name, your work and shared knowledge form the collective bedrock of this project. Thank you!



# ACON (Agent Collections) - Main Agent Guide

Welcome to the **ACON (Agent Collections)** repository. This repository houses reusable AI agent skills, coding rules, command sets, and framework knowledge bases structured in accordance with the **Cal.diy** agent design pattern, using `.acon/` as its core asset directory.

---

## Skills Navigation (`.acon/skills/`)

- **[`.acon/skills/conventional-commits/SKILL.md`](.acon/skills/conventional-commits/SKILL.md)**: Conventional Commits (v1.0.0) Skill.
- **[`.acon/skills/laravel-projects/SKILL.md`](.acon/skills/laravel-projects/SKILL.md)**: Master skill for Laravel 13.x and Filament 5.x projects.
  - **Laravel 13.x**: [`.acon/skills/laravel-projects/laravel/v13.x/SKILL.md`](.acon/skills/laravel-projects/laravel/v13.x/SKILL.md) (104 official doc files in `docs/`).
  - **Filament 5.x**: [`.acon/skills/laravel-projects/filament/v5.x/SKILL.md`](.acon/skills/laravel-projects/filament/v5.x/SKILL.md) (Official doc files in `docs/`).
- **[`.acon/skills/technical-writing-for-engineers/SKILL.md`](.acon/skills/technical-writing-for-engineers/SKILL.md)**: Guidelines for technical articles & engineering post-mortems.
- **[`.acon/skills/security-audit/SKILL.md`](.acon/skills/security-audit/SKILL.md)**: Static code security auditing suite covering 50+ vulnerability types across PHP, JavaScript/Node, Python, C#/.NET.
  - **Core Logic**: [`core/`](.acon/skills/security-audit/core/) (Taint analysis, verification methodology, anti-hallucination).
  - **Frameworks**: [`frameworks/`](.acon/skills/security-audit/frameworks/) (Laravel, Express/Next.js, Django/FastAPI, ASP.NET Core).
  - **Checklists & Matrix**: [`checklists/`](.acon/skills/security-audit/checklists/) (D1-D10 Matrix & quick checklists).
  - **Deep Language Guides**: [`languages/`](.acon/skills/security-audit/languages/) (PHP, JS/Node, Python, C#/.NET).
  - **Security Concepts**: [`security/`](.acon/skills/security-audit/security/) (Business logic, Auth/OAuth/JWT, GraphQL/Realtime, Supply chain).
  - **Case Studies**: [`cases/real-world-vulns.md`](.acon/skills/security-audit/cases/real-world-vulns.md).
  - **WooYun Intelligence**: [`wooyun/`](.acon/skills/security-audit/wooyun/) (Parameter priorities & bypass techniques).
  - **Reporting**: [`reporting/report-template.md`](.acon/skills/security-audit/reporting/report-template.md).

---

## Rules Navigation (`.acon/rules/`)

### Global / Universal Rules
- **[`.acon/rules/quality-simplicity.md`](.acon/rules/quality-simplicity.md)**: Zero dead code, minimal implementation, mandatory test verification.
- **[`.acon/rules/git-conventional-commits.md`](.acon/rules/git-conventional-commits.md)**: Branching strategy and Conventional Commit formatting.

### Framework-Specific Rules (`.acon/rules/laravel-projects/`)
- **[`api-thin-controllers.md`](.acon/rules/laravel-projects/api-thin-controllers.md)**: Thin controllers & FormRequest validation.
- **[`architecture-action-pattern.md`](.acon/rules/laravel-projects/architecture-action-pattern.md)**: Single-purpose Action classes & transactions.
- **[`data-eloquent-relationships.md`](.acon/rules/laravel-projects/data-eloquent-relationships.md)**: Strict Eloquent typing & eager loading.
- **[`filament-resource-standards.md`](.acon/rules/laravel-projects/filament-resource-standards.md)**: Filament v5 UI, form schema & table column standards.

---

## Agent Configuration Standard

Agent tools reference configuration files through standard dot-folders symlinked back to `.acon/`:

| Directory | Target / Symlinks | Framework / Tooling |
| :--- | :--- | :--- |
| **`.claude/`** | `skills -> ../.acon/skills`, `rules -> ../.acon/rules` | Claude Code CLI |
| **`.cursor/`** | `skills -> ../.acon/skills`, `rules -> ../.acon/rules` | Cursor IDE |
| **`.agents/`** | `skills -> ../.acon/skills`, `rules -> ../.acon/rules` | Antigravity / Generic AI Agents |

### Existing Project Integration Standard:
To use `acon` in any project without naming conflicts or git pollution, symlink `.acon` to the central repository and exclude it:

```bash
ln -s /path/to/acon/.acon .acon && echo ".acon" >> .git/info/exclude
```

If `.claude/`, `.cursor/`, or `.agents/` already exist in a target project, add a reference markdown file (`.claude/skills/acon-reference.md`) instructing the AI agent to inspect `.acon/skills/` and `.acon/rules/`.

---

## References & Inspiration

- **[Cal.diy Repository](https://github.com/calcom/cal.diy/tree/main)**: Structure pattern for `.claude`, `.cursor`, `.agents` symlinks, rules, skills, commands, and knowledge-base structure.
- **[3stoneBrother Code Audit](https://github.com/3stoneBrother/code-audit)**: Source inspiration for multi-language security audit checklists (PHP, JS, Python, C#).
- **[Laravel Documentation (v13.x)](https://github.com/laravel/docs/tree/13.x)**: Source documentation for `laravel-projects/laravel/v13.x`.
- **[Filament Documentation (v5.x)](https://github.com/filamentphp/filament/tree/5.x/docs)**: Source documentation for `laravel-projects/filament/v5.x`.
- **[Technical Writing for Engineers](https://github.com/marcelorodrigo/agent-skills/tree/master/skills/technical-writing-for-engineers)**: Source skill for technical writing guidelines.

# ACON (Agent Collections) - Main Agent Guide

Welcome to the **ACON (Agent Collections)** repository. This repository houses reusable AI agent skills, coding rules, command sets, and framework knowledge bases structured in accordance with the **Cal.diy** agent design pattern.

---

## Skills Navigation (`agents/skills/`)

- **[`agents/skills/conventional-commits/SKILL.md`](agents/skills/conventional-commits/SKILL.md)**: Conventional Commits (v1.0.0) Skill.
- **[`agents/skills/laravel-projects/SKILL.md`](agents/skills/laravel-projects/SKILL.md)**: Master skill for Laravel 13.x and Filament 5.x projects.
  - **Laravel 13.x**: [`agents/skills/laravel-projects/laravel/v13.x/SKILL.md`](agents/skills/laravel-projects/laravel/v13.x/SKILL.md) (104 official doc files in `docs/`).
  - **Filament 5.x**: [`agents/skills/laravel-projects/filament/v5.x/SKILL.md`](agents/skills/laravel-projects/filament/v5.x/SKILL.md) (Official doc files in `docs/`).
- **[`agents/skills/technical-writing-for-engineers/SKILL.md`](agents/skills/technical-writing-for-engineers/SKILL.md)**: Guidelines for technical articles & engineering post-mortems.
- **[`agents/skills/security-audit/SKILL.md`](agents/skills/security-audit/SKILL.md)**: Static code security auditing suite covering 50+ vulnerability types across PHP, JavaScript/Node, Python, C#/.NET.
  - **Core Logic**: [`core/`](agents/skills/security-audit/core/) (Taint analysis, verification methodology, anti-hallucination).
  - **Frameworks**: [`frameworks/`](agents/skills/security-audit/frameworks/) (Laravel, Express/Next.js, Django/FastAPI, ASP.NET Core).
  - **Checklists & Matrix**: [`checklists/`](agents/skills/security-audit/checklists/) (D1-D10 Matrix & quick checklists).
  - **Deep Language Guides**: [`languages/`](agents/skills/security-audit/languages/) (PHP, JS/Node, Python, C#/.NET).
  - **Security Concepts**: [`security/`](agents/skills/security-audit/security/) (Business logic, Auth/OAuth/JWT, GraphQL/Realtime, Supply chain).
  - **Case Studies**: [`cases/real-world-vulns.md`](agents/skills/security-audit/cases/real-world-vulns.md).
  - **WooYun Intelligence**: [`wooyun/`](agents/skills/security-audit/wooyun/) (Parameter priorities & bypass techniques).
  - **Reporting**: [`reporting/report-template.md`](agents/skills/security-audit/reporting/report-template.md).

---

## Rules Navigation (`agents/rules/`)

### Global / Universal Rules
- **[`agents/rules/quality-simplicity.md`](agents/rules/quality-simplicity.md)**: Zero dead code, minimal implementation, mandatory test verification.
- **[`agents/rules/git-conventional-commits.md`](agents/rules/git-conventional-commits.md)**: Branching strategy and Conventional Commit formatting.

### Framework-Specific Rules (`agents/rules/laravel-projects/`)
- **[`api-thin-controllers.md`](agents/rules/laravel-projects/api-thin-controllers.md)**: Thin controllers & FormRequest validation.
- **[`architecture-action-pattern.md`](agents/rules/laravel-projects/architecture-action-pattern.md)**: Single-purpose Action classes & transactions.
- **[`data-eloquent-relationships.md`](agents/rules/laravel-projects/data-eloquent-relationships.md)**: Strict Eloquent typing & eager loading.
- **[`filament-resource-standards.md`](agents/rules/laravel-projects/filament-resource-standards.md)**: Filament v5 UI, form schema & table column standards.

---

## Agent Configuration Standard

Agent tools reference configuration files through standard dot-folders symlinked back to `agents/`:

| Directory | Target / Symlinks | Framework / Tooling |
| :--- | :--- | :--- |
| **`.claude/`** | `skills -> ../agents/skills`, `rules -> ../agents/rules` | Claude Code CLI |
| **`.cursor/`** | `skills -> ../agents/skills`, `rules -> ../agents/rules` | Cursor IDE |
| **`.agents/`** | `skills -> ../agents/skills`, `rules -> ../agents/rules` | Antigravity / Generic AI Agents |

---

## References & Inspiration

- **[Cal.diy Repository](https://github.com/calcom/cal.diy/tree/main)**: Structure pattern for `.claude`, `.cursor`, `.agents` symlinks, rules, skills, commands, and knowledge-base structure.
- **[3stoneBrother Code Audit](https://github.com/3stoneBrother/code-audit)**: Source inspiration for multi-language security audit checklists (PHP, JS, Python, C#).
- **[Laravel Documentation (v13.x)](https://github.com/laravel/docs/tree/13.x)**: Source documentation for `laravel-projects/laravel/v13.x`.
- **[Filament Documentation (v5.x)](https://github.com/filamentphp/filament/tree/5.x/docs)**: Source documentation for `laravel-projects/filament/v5.x`.
- **[Technical Writing for Engineers](https://github.com/marcelorodrigo/agent-skills/tree/master/skills/technical-writing-for-engineers)**: Source skill for technical writing guidelines.

# ACON (Agent Collections) - Main Agent Guide

Welcome to the **ACON (Agent Collections)** repository. This repository houses reusable AI agent skills, coding rules, command sets, and framework knowledge bases structured in accordance with the **Cal.diy** agent design pattern.

---

## Skills Navigation (`agents/skills/`)

- **[`agents/skills/conventional-commits/SKILL.md`](agents/skills/conventional-commits/SKILL.md)**: Conventional Commits (v1.0.0) Skill.
- **[`agents/skills/laravel-projects/SKILL.md`](agents/skills/laravel-projects/SKILL.md)**: Master skill for Laravel 13.x and Filament 5.x projects.
  - **Laravel 13.x**: [`agents/skills/laravel-projects/laravel/v13.x/SKILL.md`](agents/skills/laravel-projects/laravel/v13.x/SKILL.md) (104 official doc files in `docs/`).
  - **Filament 5.x**: [`agents/skills/laravel-projects/filament/v5.x/SKILL.md`](agents/skills/laravel-projects/filament/v5.x/SKILL.md) (Official doc files in `docs/`).
- **[`agents/skills/technical-writing-for-engineers/SKILL.md`](agents/skills/technical-writing-for-engineers/SKILL.md)**: Guidelines for technical articles & engineering post-mortems.

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

## Core Dependency Versions (Laravel Projects)

```json
{
  "php": "^8.2",
  "filament/filament": "^5.3",
  "laravel/framework": "^13.0"
}
```

---

## References & Inspiration

- **[Cal.diy Repository](https://github.com/calcom/cal.diy/tree/main)**: Structure pattern for `.claude`, `.cursor`, `.agents` symlinks, rules, skills, commands, and knowledge-base structure.
- **[Laravel Documentation (v13.x)](https://github.com/laravel/docs/tree/13.x)**: Source documentation for `laravel-projects/laravel/v13.x`.
- **[Filament Documentation (v5.x)](https://github.com/filamentphp/filament/tree/5.x/docs)**: Source documentation for `laravel-projects/filament/v5.x`.
- **[Technical Writing for Engineers](https://github.com/marcelorodrigo/agent-skills/tree/master/skills/technical-writing-for-engineers)**: Source skill for technical writing guidelines.

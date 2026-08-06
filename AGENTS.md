# ACON (Agent Collections) - Main Agent Guide

Welcome to the **ACON (Agent Collections)** repository. This repository houses reusable AI agent skills, coding rules, command sets, and framework knowledge bases structured in accordance with the **Cal.diy** agent design pattern, using `.acon/` as its core asset directory.

---

## Skill & Rule Index

Refer to the central **[`.acon/INDEX.md`](.acon/INDEX.md)** for a complete lookup matrix of all skills, rules, triggers, and guides.

---

## Skills Navigation (`.acon/skills/`)

- **[`.acon/skills/multi-agent-orchestration/SKILL.md`](.acon/skills/multi-agent-orchestration/SKILL.md)**: Parallel multi-agent task orchestration, subagent delegation, and batch multi-file editing boundaries.
- **[`.acon/skills/laravel-projects/SKILL.md`](.acon/skills/laravel-projects/SKILL.md)**: Master skill for Laravel 13.x and Filament 5.x projects.
  - **Laravel 13.x**: [`.acon/skills/laravel-projects/laravel/v13.x/SKILL.md`](.acon/skills/laravel-projects/laravel/v13.x/SKILL.md) (104 official doc files in `docs/`).
  - **Filament 5.x**: [`.acon/skills/laravel-projects/filament/v5.x/SKILL.md`](.acon/skills/laravel-projects/filament/v5.x/SKILL.md) (Official doc files in `docs/`).
- **[`.acon/skills/security-audit/SKILL.md`](.acon/skills/security-audit/SKILL.md)**: Static code security auditing suite covering 50+ vulnerability types across PHP, JavaScript/Node, Python, C#/.NET.
  - **Core Logic**: [`core/`](.acon/skills/security-audit/core/) (Taint analysis, verification methodology, anti-hallucination).
  - **Frameworks**: [`frameworks/`](.acon/skills/security-audit/frameworks/) (Laravel, Express/Next.js, Django/FastAPI, ASP.NET Core).
  - **Checklists & Matrix**: [`checklists/`](.acon/skills/security-audit/checklists/) (D1-D10 Matrix & quick checklists).
  - **Deep Language Guides**: [`languages/`](.acon/skills/security-audit/languages/) (PHP, JS/Node, Python, C#/.NET).
  - **Security Concepts**: [`security/`](.acon/skills/security-audit/security/) (Business logic, Auth/OAuth/JWT, GraphQL/Realtime, Supply chain).
  - **Case Studies**: [`cases/real-world-vulns.md`](.acon/skills/security-audit/cases/real-world-vulns.md).
  - **WooYun Intelligence**: [`wooyun/`](.acon/skills/security-audit/wooyun/) (Parameter priorities & bypass techniques).
  - **Reporting**: [`reporting/report-template.md`](.acon/skills/security-audit/reporting/report-template.md).
- **[`.acon/skills/conventional-commits/SKILL.md`](.acon/skills/conventional-commits/SKILL.md)**: Conventional Commits (v1.0.0) Skill.
- **[`.acon/skills/daily-progress-report/SKILL.md`](.acon/skills/daily-progress-report/SKILL.md)**: Automated daily progress report generator and Notion publisher based on Git commits & conversation history.
- **[`.acon/skills/technical-writing-for-engineers/SKILL.md`](.acon/skills/technical-writing-for-engineers/SKILL.md)**: Guidelines for technical articles & engineering post-mortems.

---

## Rules Navigation (`.acon/rules/`)

### Global / Universal Rules
- **[`.acon/rules/quality-simplicity.md`](.acon/rules/quality-simplicity.md)**: Zero dead code, minimal implementation, mandatory test verification.
- **[`.acon/rules/git-conventional-commits.md`](.acon/rules/git-conventional-commits.md)**: Branching strategy, Conventional Commit formatting, and mandatory user confirmation before `git commit`.
- **[`.acon/rules/multi-agent-delegation.md`](.acon/rules/multi-agent-delegation.md)**: Mandatory subagent delegation threshold (5+ files), non-overlapping file scoping, reactive notifications.
- **[`.acon/rules/progress-report-exclusions.md`](.acon/rules/progress-report-exclusions.md)**: Mandatory exclusion of meta/AI conversations and MCP tool execution logs from all daily progress reports.

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

---

## Flexible Integration for Existing Repositories

When integrating `acon` into any project (even if `AGENTS.md` or `.claude/` already exist):

### 1. Copy `.acon` Folder
Copy the `.acon` directory directly into your target project:
```bash
cp -r /path/to/acon/.acon .acon
```

### 2. Configure Platform Folders (.claude, .cursor, .agents)
- **Folder Does Not Exist**: Create directory and symlink `skills` and `rules` to `.acon`.
- **Folder Already Exists**: Symlink or copy specific skill subfolders manually into their existing directory.
- **Pure `AGENTS.md` Reference**: Skip folder creation entirely and append the reference to `AGENTS.md`.

### 3. Append Reference to Existing `AGENTS.md`
If the project already has an `AGENTS.md`, append this block to the bottom (without overwriting their existing instructions):

```markdown
## ACON Skills & Rules Reference
Refer to [`.acon/INDEX.md`](.acon/INDEX.md) and [`.acon/skills/`](.acon/skills/) for coding standards and security audit skills.
```

### 4. Selective Skill Activation in Chat
Tell your AI agent directly in chat:
> *"Activate `.acon/skills/multi-agent-orchestration/SKILL.md` for this task."*

---

## References & Inspiration

- **[Cal.diy Repository](https://github.com/calcom/cal.diy/tree/main)**: Structure pattern for `.claude`, `.cursor`, `.agents` symlinks, rules, skills, commands, and knowledge-base structure.
- **[3stoneBrother Code Audit](https://github.com/3stoneBrother/code-audit)**: Source inspiration for multi-language security audit checklists (PHP, JS, Python, C#).
- **[Laravel Documentation (v13.x)](https://github.com/laravel/docs/tree/13.x)**: Source documentation for `laravel-projects/laravel/v13.x`.
- **[Filament Documentation (v5.x)](https://github.com/filamentphp/filament/tree/5.x/docs)**: Source documentation for `laravel-projects/filament/v5.x`.
- **[Technical Writing for Engineers](https://github.com/marcelorodrigo/agent-skills/tree/master/skills/technical-writing-for-engineers)**: Source skill for technical writing guidelines.

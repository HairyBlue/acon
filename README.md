# ACON - Agent Collections

A modular, cross-project repository for AI agent skills, rules, commands, and domain knowledge bases, following the **Cal.diy** agent directory pattern.

---

## Directory Layout

```
acon/
├── README.md                          # Overview & repository sitemap
├── AGENTS.md                          # Main entry point for AI agents
├── .claude/                           # Claude Code agent symlinks -> ../agents/skills, ../agents/rules
├── .cursor/                           # Cursor IDE agent symlinks -> ../agents/skills, ../agents/rules
├── .agents/                           # Universal / Antigravity agent symlinks -> ../agents/skills, ../agents/rules
└── agents/                            # Centralized Agent Assets
    ├── README.md
    ├── commands.md
    ├── knowledge-base.md
    ├── rules/                         # Categorized Agent Rules
    │   ├── quality-simplicity.md     # Global rule
    │   ├── git-conventional-commits.md # Global rule
    │   └── laravel-projects/          # Laravel-Specific Rules
    │       ├── api-thin-controllers.md
    │       ├── architecture-action-pattern.md
    │       ├── data-eloquent-relationships.md
    │       └── filament-resource-standards.md
    └── skills/                        # Modular Agent Skills
        ├── conventional-commits/
        │   └── SKILL.md
        ├── laravel-projects/
        │   ├── SKILL.md
        │   ├── commands.md
        │   ├── knowledge-base.md
        │   ├── laravel/v13.x/ (SKILL.md + 104 docs)
        │   └── filament/v5.x/ (SKILL.md + 14 docs)
        └── technical-writing-for-engineers/
            └── SKILL.md
```

---

## How to Symlink into Other Projects

To use these skills and rules in your project, symlink `.claude`, `.cursor`, or `.agents` into your project root:

```bash
ln -s /path/to/acon/.claude .claude
ln -s /path/to/acon/.cursor .cursor
ln -s /path/to/acon/.agents .agents
```

---

## References & Inspiration

This repository is structured and inspired by the following open-source projects:

- **[Cal.diy Repository](https://github.com/calcom/cal.diy/tree/main)**: Architectural pattern for `.claude`, `.cursor`, `.agents` symlinks, rules, skills, commands, and knowledge-base structure.
- **[Laravel Documentation (v13.x)](https://github.com/laravel/docs/tree/13.x)**: Official documentation source for the `laravel-projects/laravel/v13.x` skill set.
- **[Filament Documentation (v5.x)](https://github.com/filamentphp/filament/tree/5.x/docs)**: Official documentation source for the `laravel-projects/filament/v5.x` skill set.
- **[Technical Writing for Engineers](https://github.com/marcelorodrigo/agent-skills/tree/master/skills/technical-writing-for-engineers)**: Skill specification for writing technical articles and engineering post-mortems.

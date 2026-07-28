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
        ├── security-audit/            # Security Audit Skill Suite (Optional)
        │   ├── SKILL.md               # Master audit orchestration guide
        │   ├── core/                  # Taint analysis, verification, anti-hallucination
        │   ├── frameworks/            # Laravel, Express/Next.js, Django/FastAPI, ASP.NET
        │   ├── checklists/            # Coverage matrix & language checklists
        │   ├── languages/             # Deep language security guides (PHP, JS, Python, C#)
        │   ├── security/              # Business logic, Auth/OAuth/JWT, GraphQL, Supply chain
        │   ├── cases/                 # Real-world vulnerability case studies
        │   ├── wooyun/                # Parameter priority (TOP_VULNERABLE_PARAMS) & bypasses
        │   └── reporting/             # Report templates
        └── technical-writing-for-engineers/
            └── SKILL.md
```

---

## How to Symlink into Other Projects

To use **all** skills and rules in your project, symlink `.claude`, `.cursor`, or `.agents` into your project root:

```bash
ln -s /path/to/acon/.claude .claude
ln -s /path/to/acon/.cursor .cursor
ln -s /path/to/acon/.agents .agents
```

---

## Targeted Selective Integration Guide

If you only want specific skills or rules for a project stack (e.g., Laravel), copy or symlink only the relevant directories manually.

### Example 1: Selective Copy for Laravel Projects

To install **only** Laravel skills, Laravel rules, global rules, and conventional commit guidelines into a target Laravel project:

```bash
# Set your ACON repository path and target project path
ACON_DIR="/path/to/acon"
TARGET_DIR="/path/to/your-laravel-project"

cd "$TARGET_DIR"

# 1. Create target agent directories
mkdir -p agents/skills agents/rules/laravel-projects

# 2. Copy Laravel and Conventional Commit skills
cp -r "$ACON_DIR/agents/skills/laravel-projects" agents/skills/
cp -r "$ACON_DIR/agents/skills/conventional-commits" agents/skills/

# 3. Copy global rules and Laravel-specific rules
cp "$ACON_DIR/agents/rules/quality-simplicity.md" agents/rules/
cp "$ACON_DIR/agents/rules/git-conventional-commits.md" agents/rules/
cp -r "$ACON_DIR/agents/rules/laravel-projects/"* agents/rules/laravel-projects/

# 4. Copy AGENTS.md guide (excluding ACON README)
cp "$ACON_DIR/AGENTS.md" ./

# 5. Create standard platform dot-folders with relative symlinks
mkdir -p .claude .cursor .agents
ln -sf ../agents/skills .claude/skills && ln -sf ../agents/rules .claude/rules
ln -sf ../agents/skills .cursor/skills && ln -sf ../agents/rules .cursor/rules
ln -sf ../agents/skills .agents/skills && ln -sf ../agents/rules .agents/rules
```

---

### Example 2: Including Optional Security Audit Skill Suite

The **`security-audit`** skill suite is **optional**. 

- **To include security auditing**: Copy the `security-audit` skill folder into your project's `agents/skills/`:
  ```bash
  cp -r "$ACON_DIR/agents/skills/security-audit" agents/skills/
  ```
- **To exclude security auditing**: Simply skip copying `security-audit/`. Your project will continue to use only the stack skills you selected.

---

## References & Inspiration

This repository is structured and inspired by the following open-source projects:

- **[Cal.diy Repository](https://github.com/calcom/cal.diy/tree/main)**: Architectural pattern for `.claude`, `.cursor`, `.agents` symlinks, rules, skills, commands, and knowledge-base structure.
- **[3stoneBrother Code Audit](https://github.com/3stoneBrother/code-audit)**: Source inspiration for multi-language security audit checklists (PHP, JS, Python, C#).
- **[Laravel Documentation (v13.x)](https://github.com/laravel/docs/tree/13.x)**: Official documentation source for the `laravel-projects/laravel/v13.x` skill set.
- **[Filament Documentation (v5.x)](https://github.com/filamentphp/filament/tree/5.x/docs)**: Official documentation source for the `laravel-projects/filament/v5.x` skill set.
- **[Technical Writing for Engineers](https://github.com/marcelorodrigo/agent-skills/tree/master/skills/technical-writing-for-engineers)**: Skill specification for writing technical articles and engineering post-mortems.

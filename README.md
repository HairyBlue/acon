# ACON - Agent Collections

A modular, cross-project repository for AI agent skills, rules, commands, and domain knowledge bases, following the **Cal.diy** agent directory pattern, using `.acon/` as its core asset directory.

---

## Directory Layout

```
acon/
├── README.md                          # Overview & repository sitemap
├── AGENTS.md                          # Main entry point for AI agents
├── .claude/                           # Claude Code agent symlinks -> ../.acon/skills, ../.acon/rules
├── .cursor/                           # Cursor IDE agent symlinks -> ../.acon/skills, ../.acon/rules
├── .agents/                           # Universal / Antigravity agent symlinks -> ../.acon/skills, ../.acon/rules
└── .acon/                             # Centralized Agent Assets
    ├── INDEX.md                       # Fast symptom & stack lookup matrix
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

## How to Use ACON in Any Project (Manual Symlinks)

Integrate ACON into any target project in 3 simple copy-paste steps (without git pollution or conflicts):

### Step 1: Symlink `.acon` Container
```bash
cd /path/to/target-project

# Symlink your central .acon folder
ln -s /path/to/acon/.acon .acon
echo ".acon" >> .git/info/exclude
```

---

### Step 2: Symlink Platform Dot-Folders (.claude, .cursor, .agents)
```bash
# Create platform tool directories
mkdir -p .claude .cursor .agents

# Symlink skills and rules to .acon
ln -sf ../.acon/skills .claude/skills && ln -sf ../.acon/rules .claude/rules
ln -sf ../.acon/skills .cursor/skills && ln -sf ../.acon/rules .cursor/rules
ln -sf ../.acon/skills .agents/skills && ln -sf ../.acon/rules .agents/rules

# Exclude platform folders from Git
echo ".claude" >> .git/info/exclude
echo ".cursor" >> .git/info/exclude
echo ".agents" >> .git/info/exclude
```

---

### Step 3: Append Reference to `AGENTS.md` (Optional)

If the project already has an `AGENTS.md`, append this section to the bottom:

```bash
cat << 'EOF' >> AGENTS.md

## ACON Skills & Rules Reference
Refer to [`.acon/INDEX.md`](.acon/INDEX.md) and [`.acon/skills/`](.acon/skills/) for coding standards and security audit skills.
EOF
```

---

### Selective Skill Activation in Chat

You can activate any specific skill on demand simply by telling your AI agent in chat:

> *"Activate `.acon/skills/laravel-projects/SKILL.md` for this task."*  
> *"Use `.acon/skills/security-audit/SKILL.md` to perform a code review."*

---

## References & Inspiration

- **[Cal.diy Repository](https://github.com/calcom/cal.diy/tree/main)**: Architectural pattern for `.claude`, `.cursor`, `.agents` symlinks, rules, skills, commands, and knowledge-base structure.
- **[3stoneBrother Code Audit](https://github.com/3stoneBrother/code-audit)**: Source inspiration for multi-language security audit checklists (PHP, JS, Python, C#).
- **[Laravel Documentation (v13.x)](https://github.com/laravel/docs/tree/13.x)**: Official documentation source for the `laravel-projects/laravel/v13.x` skill set.
- **[Filament Documentation (v5.x)](https://github.com/filamentphp/filament/tree/5.x/docs)**: Official documentation source for the `laravel-projects/filament/v5.x` skill set.
- **[Technical Writing for Engineers](https://github.com/marcelorodrigo/agent-skills/tree/master/skills/technical-writing-for-engineers)**: Skill specification for writing technical articles and engineering post-mortems.

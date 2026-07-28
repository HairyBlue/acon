# ACON - Agent Collections

A modular, cross-project repository for AI agent skills, rules, commands, and domain knowledge bases, following the **Cal.diy** agent directory pattern, using `.acon/` as its core asset directory.

---

## Directory Layout

```
acon/
├── README.md                          # Overview & repository sitemap
├── AGENTS.md                          # Main entry point for AI agents
├── setup-acon.sh                      # Executable integration script
├── .claude/                           # Claude Code agent symlinks -> ../.acon/skills, ../.acon/rules
├── .cursor/                           # Cursor IDE agent symlinks -> ../.acon/skills, ../.acon/rules
├── .agents/                           # Universal / Antigravity agent symlinks -> ../.acon/skills, ../.acon/rules
└── .acon/                             # Centralized Agent Assets
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
        ├── acon-reference.md          # Built-in reference file for AI agents
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

## How to Integrate ACON into Any Target Project

Integrating `acon` into any project takes seconds and ensures **100% zero naming conflicts** (even if the target repository already has `agents/`, `.claude/`, or `.cursor/`).

---

### Method 1: Using `setup-acon.sh` (Recommended)

#### Option A: Run inside target project folder
```bash
cd /path/to/target-project
/home/mewho/ai-stuff/acon/setup-acon.sh
```

#### Option B: Run from anywhere by passing target path
```bash
/home/mewho/ai-stuff/acon/setup-acon.sh /path/to/target-project
```

#### Option C: Install `setup-acon` system command (Optional)
```bash
sudo ln -s /home/mewho/ai-stuff/acon/setup-acon.sh /usr/local/bin/setup-acon

# Now run anywhere:
cd /path/to/target-project
setup-acon
```

---

### Method 2: Manual Terminal Commands

If you prefer to perform integration manually without the script:

#### Step 1: Open Target Project & Symlink `.acon`
```bash
cd /path/to/target-project
ln -s /home/mewho/ai-stuff/acon/.acon .acon
echo ".acon" >> .git/info/exclude
```

#### Step 2: Configure AI Platforms (.claude, .cursor, .agents)

**Case A: If `.claude/`, `.cursor/`, or `.agents/` ALREADY exist in the project**:
Symlink the built-in `acon-reference.md` file:
```bash
mkdir -p .claude/skills .cursor/skills .agents/skills

ln -sf /home/mewho/ai-stuff/acon/.acon/skills/acon-reference.md .claude/skills/acon-reference.md
ln -sf /home/mewho/ai-stuff/acon/.acon/skills/acon-reference.md .cursor/skills/acon-reference.md
ln -sf /home/mewho/ai-stuff/acon/.acon/skills/acon-reference.md .agents/skills/acon-reference.md

echo ".claude/skills/acon-reference.md" >> .git/info/exclude
echo ".cursor/skills/acon-reference.md" >> .git/info/exclude
echo ".agents/skills/acon-reference.md" >> .git/info/exclude
```

**Case B: If `.claude/`, `.cursor/`, or `.agents/` DO NOT exist in the project**:
Create standard relative symlinks:
```bash
mkdir -p .claude .cursor .agents

ln -sf ../.acon/skills .claude/skills && ln -sf ../.acon/rules .claude/rules
ln -sf ../.acon/skills .cursor/skills && ln -sf ../.acon/rules .cursor/rules
ln -sf ../.acon/skills .agents/skills && ln -sf ../.acon/rules .agents/rules

echo ".claude" >> .git/info/exclude
echo ".cursor" >> .git/info/exclude
echo ".agents" >> .git/info/exclude
```

---

## References & Inspiration

- **[Cal.diy Repository](https://github.com/calcom/cal.diy/tree/main)**: Architectural pattern for `.claude`, `.cursor`, `.agents` symlinks, rules, skills, commands, and knowledge-base structure.
- **[3stoneBrother Code Audit](https://github.com/3stoneBrother/code-audit)**: Source inspiration for multi-language security audit checklists (PHP, JS, Python, C#).
- **[Laravel Documentation (v13.x)](https://github.com/laravel/docs/tree/13.x)**: Official documentation source for the `laravel-projects/laravel/v13.x` skill set.
- **[Filament Documentation (v5.x)](https://github.com/filamentphp/filament/tree/5.x/docs)**: Official documentation source for the `laravel-projects/filament/v5.x` skill set.
- **[Technical Writing for Engineers](https://github.com/marcelorodrigo/agent-skills/tree/master/skills/technical-writing-for-engineers)**: Skill specification for writing technical articles and engineering post-mortems.

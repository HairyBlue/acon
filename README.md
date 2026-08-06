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
    │   ├── multi-agent-delegation.md # Global rule
    │   └── laravel-projects/          # Laravel-Specific Rules
    │       ├── api-thin-controllers.md
    │       ├── architecture-action-pattern.md
    │       ├── data-eloquent-relationships.md
    │       └── filament-resource-standards.md
    └── skills/                        # Modular Agent Skills
        ├── multi-agent-orchestration/ # Parallel Subagent Delegation Skill
        │   └── SKILL.md
        ├── conventional-commits/
        │   └── SKILL.md
        ├── daily-progress-report/     # Automated Daily Summary & Notion Publishing Skill
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

## How to Use ACON in Any Target Project

Integrate ACON into any target project as a standalone `.acon` directory in 3 simple steps:

### Step 1: Copy `.acon` into Your Target Project

Clone or download the `acon` repository, then copy `.acon` into your target project root:

```bash
cd /path/to/target-project

# Copy .acon directory to your project root
cp -r /path/to/acon/.acon .acon

# (Optional) Exclude .acon from Git if you prefer not to commit it
echo ".acon" >> .git/info/exclude
```

---

### Step 2: Configure Platform Folders (.claude, .cursor, .agents)

Choose the setup option that best fits your target project:

#### Option A: If `.claude/`, `.cursor/`, or `.agents/` DO NOT exist yet
Create the directories and symlink `skills` and `rules` directly to `.acon`:

```bash
mkdir -p .claude .cursor .agents

ln -sf ../.acon/skills .claude/skills && ln -sf ../.acon/rules .claude/rules
ln -sf ../.acon/skills .cursor/skills && ln -sf ../.acon/rules .cursor/rules
ln -sf ../.acon/skills .agents/skills && ln -sf ../.acon/rules .agents/rules
```

#### Option B: If `.claude/`, `.cursor/`, or `.agents/` ALREADY exist in your project
Do not overwrite their folder. Either symlink or copy individual skills into their existing folder:

```bash
# Example: Symlink specific skills into existing .claude/skills/
ln -sf /path/to/target-project/.acon/skills/laravel-projects .claude/skills/laravel-projects

# OR copy skill files directly into their existing folder:
cp -r .acon/skills/laravel-projects .claude/skills/
```

#### Option C: Pure `AGENTS.md` Reference (Zero Symlinking / Copying)
Skip creating or modifying platform folders entirely! Simply append references to your existing `AGENTS.md` (see Step 3 below).

---

### Step 3: Append Reference to `AGENTS.md`

If your project already has an `AGENTS.md`, append this section to the bottom:

```bash
cat << 'EOF' >> AGENTS.md

## ACON Skills & Rules Reference
Refer to [`.acon/INDEX.md`](.acon/INDEX.md) and [`.acon/skills/`](.acon/skills/) for coding standards and security audit skills.
EOF
```

---

### Selective Skill Activation in Chat

You can activate any specific skill on demand simply by telling your AI agent in chat:

> *"Activate `.acon/skills/multi-agent-orchestration/SKILL.md` for this task."*  
> *"Activate `.acon/skills/laravel-projects/SKILL.md` for this task."*  
> *"Use `.acon/skills/security-audit/SKILL.md` to perform a code review."*

---

## References & Inspiration

- **[Cal.diy Repository](https://github.com/calcom/cal.diy/tree/main)**: Architectural pattern for `.claude`, `.cursor`, `.agents` symlinks, rules, skills, commands, and knowledge-base structure.
- **[3stoneBrother Code Audit](https://github.com/3stoneBrother/code-audit)**: Source inspiration for multi-language security audit checklists (PHP, JS, Python, C#).
- **[Laravel Documentation (v13.x)](https://github.com/laravel/docs/tree/13.x)**: Official documentation source for the `laravel-projects/laravel/v13.x` skill set.
- **[Filament Documentation (v5.x)](https://github.com/filamentphp/filament/tree/5.x/docs)**: Official documentation source for the `laravel-projects/filament/v5.x` skill set.
- **[Technical Writing for Engineers](https://github.com/marcelorodrigo/agent-skills/tree/master/skills/technical-writing-for-engineers)**: Skill specification for writing technical articles and engineering post-mortems.

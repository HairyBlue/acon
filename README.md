# ACON - Agent Collections & Memory Files

**ACON** is a centralized, plug-and-play repository of production-grade **`AGENTS.md` templates**, **AI agent skills**, **coding rules**, and **security auditing suites**.

Skills are organized into four dedicated, bloat-free suites: **Engineering**, **Productivity**, **Frameworks**, and **Security & DevOps**.

---

## 📁 Repository Structure

```
acon/
├── README.md                          # Human-facing guide and catalog
├── memory-files/                      # Ready-to-copy AGENTS.md templates per stack
│   ├── laravel-project/AGENTS.md      # Laravel (Foundation, PHP, Eloquent, Inertia/Vue, Wayfinder, Pint, Pest)
│   ├── node-express-project/AGENTS.md # Node.js, Express, TypeScript, Zod, Vitest
│   ├── python-fastapi-project/AGENTS.md # Python 3.11+, FastAPI, Pydantic v2, Pytest, Ruff
│   ├── dotnet-asp-project/AGENTS.md   # C# / .NET 8/9, ASP.NET Core, EF Core, xUnit
│   └── generic-fullstack/AGENTS.md    # Universal fullstack template (Quality, Commits, Delegation)
├── .agents/                           # Central physical source of truth
│   ├── INDEX.md                       # Comprehensive symptom, stack, and skill matrix
│   ├── README.md
│   ├── commands.md
│   ├── knowledge-base.md
│   ├── rules/                         # Global Cross-Project Rules
│   │   ├── quality-simplicity.md
│   │   ├── git-conventional-commits.md
│   │   ├── multi-agent-delegation.md
│   │   └── progress-report-exclusions.md
│   └── skills/                        # 36 Curated Modular Agent Skills
│       ├── engineering/               # 15 Skills (tdd, code-review, diagnosing-bugs, domain-modeling, to-spec...)
│       ├── productivity/              # 8 Skills (grill-me, handoff, teach, to-questionnaire, writing-for-agents...)
│       ├── frameworks/                # 8 Skills (laravel-best-practices, laravel-boost, inertia-vue, wayfinder...)
│       └── security-devops/           # 5 Skills (security-audit, multi-agent-orchestration, git-guardrails...)
├── .claude/                           # Claude Code CLI (symlinked to individual skills & rules)
└── .cursor/                           # Cursor IDE (symlinked to individual skills & rules)
```

---

## 🚀 How to Use ACON in Your Projects

### Workflow 1: Bootstrap a New Project in Seconds

Copy the appropriate `AGENTS.md` memory template into your target project:

```bash
cd /path/to/my-target-project

# Example 1: Setting up a Laravel project
cp /path/to/acon/memory-files/laravel-project/AGENTS.md ./AGENTS.md

# Example 2: Setting up a Node / Express project
cp /path/to/acon/memory-files/node-express-project/AGENTS.md ./AGENTS.md

# Example 3: Setting up a Python / FastAPI project
cp /path/to/acon/memory-files/python-fastapi-project/AGENTS.md ./AGENTS.md
```

---

### Workflow 2: Selectively Import Skill Suites

Because skills are categorized into subdirectories, you can import only the specific suites your project needs:

```bash
cd /path/to/my-target-project
mkdir -p .agents/skills

# Copy only Laravel & frontend framework skills:
cp -r /path/to/acon/.agents/skills/frameworks/* .agents/skills/

# Copy engineering problem-solving skills (TDD, code-review, diagnosing-bugs):
cp -r /path/to/acon/.agents/skills/engineering/* .agents/skills/

# Copy security & git guardrail skills:
cp -r /path/to/acon/.agents/skills/security-devops/* .agents/skills/
```

---

### Workflow 3: Full Project Symlink

```bash
cd /path/to/my-target-project

# Symlink whole .agents directory
ln -sf /path/to/acon/.agents .agents

# Symlink for Claude Code or Cursor IDE
mkdir -p .claude .cursor
ln -sf /path/to/acon/.claude/skills .claude/skills && ln -sf /path/to/acon/.agents/rules .claude/rules
ln -sf /path/to/acon/.cursor/skills .cursor/skills && ln -sf /path/to/acon/.agents/rules .cursor/rules
```

---

## 🛠️ Curated Skills Directory (`.agents/skills/`)

### ⚙️ 1. Engineering (`.agents/skills/engineering/` - 15 Skills)
- **`code-review`**: Parallel two-axis review (Standards adherence + Spec conformance).
- **`codebase-design`**: Deep module design principles (small interfaces, clean seams).
- **`diagnosing-bugs`**: Systematic red-test feedback loop, hypothesis testing, and regression verification.
- **`domain-modeling`**: Ubiquitous language definition, scenario testing, and ADR tracking.
- **`grill-with-docs`**: Grilling sessions that simultaneously build domain models and ADRs.
- **`implement`**: Spec-driven implementation loop driving TDD and code review.
- **`improve-codebase-architecture`**: Scans codebase for deepening opportunities.
- **`prototype`**: Rapid throwaway HTML/UI prototypes to validate state and interaction design.
- **`research`**: Primary-source technical investigations captured as cited Markdown documents.
- **`resolving-merge-conflicts`**: Hunk-by-hunk conflict resolution tracing original commit intent.
- **`tdd`**: Strict red-green-refactor loop.
- **`to-spec` & `to-tickets`**: Conversation-to-spec synthesis and tracer-bullet ticket breakdown.
- **`setup-ts-deep-modules`**: Enforces deep module boundaries in TypeScript with dependency-cruiser.
- **`wizard`**: Interactive CLI wizard generation for manual cloud and human setup tasks.

### 🧠 2. Productivity (`.agents/skills/productivity/` - 8 Skills)
- **`grill-me`**: Relentless design & plan interrogation to eliminate edge-case blind spots.
- **`handoff`**: Compacts conversation context into a structured handoff document.
- **`teach`**: Multi-session interactive technical coaching with glossaries and learning records.
- **`to-questionnaire`**: Formats complex design decisions into fillable Markdown questionnaires.
- **`wait-what`**: Re-explains unclear concepts in plain English with missing context.
- **`writing-for-agents`**: Guidelines for authoring skills, rules, and prompt memory files.
- **`daily-progress-report`**: Work summary and Notion publishing via MCP.
- **`technical-writing-for-engineers`**: Technical RFCs, architecture decisions, and post-mortems.

### 🌐 3. Frameworks (`.agents/skills/frameworks/` - 8 Skills)
- **`laravel-best-practices`**: 19 comprehensive rules covering queries, caching, queues, events, db performance.
- **`laravel-boost`**: Modular guidance for Laravel Boost MCP tools and `.ai/rules` persistence.
- **`laravel-projects`**: Complete offline documentation for Laravel 13.x and Filament 5.x.
- **`inertia-vue-development`**: Inertia v3 + Vue 3 client-side SPA patterns, forms, hooks, deferred props.
- **`tailwindcss-development`**: Tailwind CSS layout structures and responsive styling.
- **`wayfinder-development`**: Laravel Wayfinder TypeScript route binding generator.
- **`testing-best-practices`**: Pest and PHPUnit testing standards, isolation, assertions.
- **`infer-conventions`**: Repository convention analysis and discovery checklist.

### 🔒 4. Security & DevOps (`.agents/skills/security-devops/` - 5 Skills)
- **`security-audit`**: Static security analysis (50+ vulnerability types across PHP, JS, Python, C#).
- **`multi-agent-orchestration`**: Subagent task delegation for 5+ file tasks.
- **`conventional-commits`**: Conventional Commits v1.0.0 specification enforcement.
- **`git-guardrails-claude-code`**: PreToolUse hooks blocking destructive git operations.
- **`setup-pre-commit`**: Husky + lint-staged + Prettier / typecheck pre-commit hooks.

---

## 🔍 Central Lookup Matrix

Refer to **[`.agents/INDEX.md`](.agents/INDEX.md)** for a fast symptom, stack, and rule lookup matrix.

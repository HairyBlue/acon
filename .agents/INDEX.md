# ACON Index — Skill, Rule & Memory File Lookup Matrix

This index maps developer symptoms, task goals, technology stacks, and engineering workflows to the exact skill or rule in `.agents/` and template memory files in `memory-files/`.

---

## 1. Quick Symptom & Task Lookup

| Symptom / Task Goal | Likely Cause / Area | Recommended Skill or Rule |
| :--- | :--- | :--- |
| **New Project Bootstrap / Agent Setup** | Need pre-configured `AGENTS.md` for a project stack | [`memory-files/`](../memory-files/) (Laravel, Node/Express, FastAPI, .NET, Fullstack) |
| **Relentless plan / design interrogation** | Plan has unresolved branches, ambiguities, or missing edge cases | [`.agents/skills/productivity/grill-me/SKILL.md`](skills/productivity/grill-me/SKILL.md) |
| **Grill plan while generating ADRs & domain docs** | Need to sharpen domain terms while interrogating a design | [`.agents/skills/engineering/grill-with-docs/SKILL.md`](skills/engineering/grill-with-docs/SKILL.md), [`.agents/skills/engineering/domain-modeling/SKILL.md`](skills/engineering/domain-modeling/SKILL.md) |
| **Turn conversation into a formal spec** | Architecture settled, need an actionable specification | [`.agents/skills/engineering/to-spec/SKILL.md`](skills/engineering/to-spec/SKILL.md) |
| **Break plan into tracer-bullet tickets** | Large task needing modular tickets with blocking dependencies | [`.agents/skills/engineering/to-tickets/SKILL.md`](skills/engineering/to-tickets/SKILL.md) |
| **Execute spec with TDD and code review** | Building feature from spec/tickets via red-green loop | [`.agents/skills/engineering/implement/SKILL.md`](skills/engineering/implement/SKILL.md), [`.agents/skills/engineering/tdd/SKILL.md`](skills/engineering/tdd/SKILL.md) |
| **Rigorous code review (Standards + Spec)** | Two-axis diff review against coding standards and issue specs | [`.agents/skills/engineering/code-review/SKILL.md`](skills/engineering/code-review/SKILL.md) |
| **Deep module & clean architecture design** | Designing interfaces with small surfaces and hidden complexity | [`.agents/skills/engineering/codebase-design/SKILL.md`](skills/engineering/codebase-design/SKILL.md), [`.agents/skills/engineering/improve-codebase-architecture/SKILL.md`](skills/engineering/improve-codebase-architecture/SKILL.md) |
| **Enforce deep modules in TypeScript** | Setting up dependency-cruiser boundary rules | [`.agents/skills/engineering/setup-ts-deep-modules/SKILL.md`](skills/engineering/setup-ts-deep-modules/SKILL.md) |
| **Hard bug or performance regression** | Root cause elusive, need systematic red-test feedback loop | [`.agents/skills/engineering/diagnosing-bugs/SKILL.md`](skills/engineering/diagnosing-bugs/SKILL.md) |
| **Complex merge or rebase conflict** | Hunk-by-hunk conflict resolution tracing original intent | [`.agents/skills/engineering/resolving-merge-conflicts/SKILL.md`](skills/engineering/resolving-merge-conflicts/SKILL.md) |
| **Primary-source technical research** | Gathering cited findings into a structured markdown document | [`.agents/skills/engineering/research/SKILL.md`](skills/engineering/research/SKILL.md) |
| **Throwaway prototype for UX/logic** | Validate UI interaction or state before writing production code | [`.agents/skills/engineering/prototype/SKILL.md`](skills/engineering/prototype/SKILL.md) |
| **Interactive CLI setup wizard for humans** | Guide user through manual cloud/secret/dashboard setup | [`.agents/skills/engineering/wizard/SKILL.md`](skills/engineering/wizard/SKILL.md) |
| **Session compacting & agent handoff** | Hand off ongoing conversation state to another session | [`.agents/skills/productivity/handoff/SKILL.md`](skills/productivity/handoff/SKILL.md) |
| **Teaching technical concepts over sessions** | Interactive coaching with glossaries and learning records | [`.agents/skills/productivity/teach/SKILL.md`](skills/productivity/teach/SKILL.md) |
| **Decision questionnaire for teammates** | Turn complex design choices into a fillable questionnaire | [`.agents/skills/productivity/to-questionnaire/SKILL.md`](skills/productivity/to-questionnaire/SKILL.md) |
| **AI explanation didn't land / jargon heavy** | Re-pitch explanation in plain English with missing context | [`.agents/skills/productivity/wait-what/SKILL.md`](skills/productivity/wait-what/SKILL.md) |
| **Authoring skills & guidelines for AI** | Writing effective prompt files, skills, and AGENTS.md | [`.agents/skills/productivity/writing-for-agents/SKILL.md`](skills/productivity/writing-for-agents/SKILL.md) |
| **Technical writing & post-mortems** | Authoring RFCs, architecture decisions, and post-mortems | [`.agents/skills/productivity/technical-writing-for-engineers/SKILL.md`](skills/productivity/technical-writing-for-engineers/SKILL.md) |
| **Daily progress report / Notion summary** | Daily summary from Git commits & conversation history | [`.agents/skills/productivity/daily-progress-report/SKILL.md`](skills/productivity/daily-progress-report/SKILL.md) |
| **Batch multi-file edits / Subagents** | 5+ files to edit, parallel refactoring, multi-component work | [`.agents/skills/security-devops/multi-agent-orchestration/SKILL.md`](skills/security-devops/multi-agent-orchestration/SKILL.md), [`.agents/rules/multi-agent-delegation.md`](rules/multi-agent-delegation.md) |
| **Discovering codebase conventions** | Analyzing patterns, naming conventions, and architecture | [`.agents/skills/frameworks/infer-conventions/SKILL.md`](skills/frameworks/infer-conventions/SKILL.md) |
| **Laravel Boost MCP & Doc search** | Using `database-query`, `database-schema`, `search-docs`, `.ai/rules` | [`.agents/skills/frameworks/laravel-boost/SKILL.md`](skills/frameworks/laravel-boost/SKILL.md) |
| **Laravel architecture & query tuning** | Advanced queries, caching, queues, events, db performance | [`.agents/skills/frameworks/laravel-best-practices/SKILL.md`](skills/frameworks/laravel-best-practices/SKILL.md) |
| **Pest / PHPUnit testing conventions** | Assertions, endpoint tests, isolation, mock data | [`.agents/skills/frameworks/testing-best-practices/SKILL.md`](skills/frameworks/testing-best-practices/SKILL.md) |
| **Inertia.js v3 + Vue 3 SPA development** | Page components, `<Link>`, `<Form>`, `useHttp`, deferred props | [`.agents/skills/frameworks/inertia-vue-development/SKILL.md`](skills/frameworks/inertia-vue-development/SKILL.md) |
| **Tailwind CSS styling & UI components** | Layout structures, responsive design, utility classes | [`.agents/skills/frameworks/tailwindcss-development/SKILL.md`](skills/frameworks/tailwindcss-development/SKILL.md) |
| **TypeScript route binding (Wayfinder)** | Type-safe Laravel routes in frontend `@/actions/` | [`.agents/skills/frameworks/wayfinder-development/SKILL.md`](skills/frameworks/wayfinder-development/SKILL.md) |
| **Static code security audit** | OWASP Top 10, WooYun parameter priorities, taint analysis | [`.agents/skills/security-devops/security-audit/SKILL.md`](skills/security-devops/security-audit/SKILL.md) |
| **Git pre-commit hooks & guardrails** | Block destructive git commands or set up Husky/lint-staged | [`.agents/skills/security-devops/git-guardrails-claude-code/SKILL.md`](skills/security-devops/git-guardrails-claude-code/SKILL.md), [`.agents/skills/security-devops/setup-pre-commit/SKILL.md`](skills/security-devops/setup-pre-commit/SKILL.md) |

---

## 2. Category & Suite Index

| Category / Directory | Count | Main Entry File |
| :--- | :--- | :--- |
| **[`memory-files/`](../memory-files/)** | 5 Templates | Ready-to-copy `AGENTS.md` memory files (Laravel, Node/Express, FastAPI, .NET, Fullstack) |
| **[`skills/engineering/`](skills/engineering/)** | 15 Skills | Problem solving, architecture, TDD, debugging, code review, merge conflicts, ticket mapping |
| **[`skills/productivity/`](skills/productivity/)** | 8 Skills | Interrogation (`grill-me`), handoffs, questionnaires, technical writing, coaching |
| **[`skills/frameworks/`](skills/frameworks/)** | 8 Skills | Laravel 13, Filament 5, Inertia v3, Vue 3, Tailwind CSS, Wayfinder, Pest |
| **[`skills/security-devops/`](skills/security-devops/)** | 5 Skills | Security audit (21 modules), multi-agent orchestration, git guardrails, conventional commits |
| **[`rules/`](rules/)** | 4 Global Rules | [`.agents/rules/`](rules/) (`quality-simplicity.md`, `git-conventional-commits.md`, `multi-agent-delegation.md`, `progress-report-exclusions.md`) |

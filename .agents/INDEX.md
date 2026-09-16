# ACON Index — Skill & Rule Lookup Matrix

This index maps developer symptoms, task goals, technology stacks, and engineering workflows to the exact skill or rule in `.agents/` and the root `AGENTS.md` Control Plane constitution.

---

## 1. Quick Symptom & Task Lookup

| Symptom / Task Goal | Likely Cause / Area | Recommended Skill or Rule |
| :--- | :--- | :--- |
| **Agent Orchestration & Control Plane** | Multi-agent coordination, specialist dispatch, Ship vs. Scout, Bearings status | [`AGENTS.md`](../AGENTS.md), [`.agents/rules/agent-control-plane.md`](rules/agent-control-plane.md) |
| **Relentless plan / design interrogation** | Plan has unresolved branches, ambiguities, or missing edge cases | [`.agents/skills/productivity/grill-me/SKILL.md`](skills/productivity/grill-me/SKILL.md) |
| **Grill plan while generating ADRs & domain docs** | Need to sharpen domain terms while interrogating a design | [`.agents/skills/productivity/grill-me/SKILL.md`](skills/productivity/grill-me/SKILL.md), [`.agents/skills/engineering/domain-modeling/SKILL.md`](skills/engineering/domain-modeling/SKILL.md) |
| **Turn conversation into a formal spec** | Architecture settled, need an actionable specification | [`.agents/skills/engineering/to-spec/SKILL.md`](skills/engineering/to-spec/SKILL.md) |
| **API & RESTful contract design** | Resource modeling, RFC 7807 problem details, idempotency keys, cursor pagination | [`.agents/skills/engineering/api-design/SKILL.md`](skills/engineering/api-design/SKILL.md) |
| **Prompt engineering & agent briefing** | Brain dump to clean task spec, 9-dimension extraction, model calibration | [`.agents/skills/productivity/prompt-master/SKILL.md`](skills/productivity/prompt-master/SKILL.md) |
| **Break plan into tracer-bullet tickets** | Large task needing modular tickets with blocking dependencies | [`.agents/skills/engineering/to-tickets/SKILL.md`](skills/engineering/to-tickets/SKILL.md) |
| **Execute spec with TDD and code review** | Building feature from spec/tickets via red-green loop | [`.agents/skills/engineering/tdd/SKILL.md`](skills/engineering/tdd/SKILL.md), [`.agents/skills/engineering/code-review/SKILL.md`](skills/engineering/code-review/SKILL.md) |
| **Refactoring & code smell cleanup** | Fowler refactoring catalog, green-to-green invariant, Two-Hats rule, strangler fig | [`.agents/skills/engineering/refactoring/SKILL.md`](skills/engineering/refactoring/SKILL.md) |
| **Zero-downtime database migrations** | 5-phase Expand/Contract, concurrent indexing, lock timeouts, batched backfills | [`.agents/skills/engineering/zero-downtime-migrations/SKILL.md`](skills/engineering/zero-downtime-migrations/SKILL.md) |
| **Rigorous code review (Standards + Spec)** | Two-axis diff review against coding standards and issue specs | [`.agents/skills/engineering/code-review/SKILL.md`](skills/engineering/code-review/SKILL.md) |
| **Deep module & clean architecture design** | Designing interfaces with small surfaces and hidden complexity | [`.agents/skills/engineering/codebase-design/SKILL.md`](skills/engineering/codebase-design/SKILL.md), [`.agents/skills/engineering/improve-codebase-architecture/SKILL.md`](skills/engineering/improve-codebase-architecture/SKILL.md) |
| **Enforce deep modules in TypeScript** | Setting up dependency-cruiser boundary rules | [`.agents/skills/engineering/setup-ts-deep-modules/SKILL.md`](skills/engineering/setup-ts-deep-modules/SKILL.md) |
| **Hard bug or performance regression** | Root cause elusive, need systematic red-test feedback loop | [`.agents/skills/engineering/diagnosing-bugs/SKILL.md`](skills/engineering/diagnosing-bugs/SKILL.md) |
| **Throwaway prototype for UX/logic** | Validate UI interaction or state before writing production code | [`.agents/skills/engineering/prototype/SKILL.md`](skills/engineering/prototype/SKILL.md) |
| **Interactive CLI setup wizard for humans** | Guide user through manual cloud/secret/dashboard setup | [`.agents/skills/engineering/wizard/SKILL.md`](skills/engineering/wizard/SKILL.md) |
| **Session compacting & agent handoff** | Hand off ongoing conversation state to another session | [`.agents/skills/productivity/handoff/SKILL.md`](skills/productivity/handoff/SKILL.md) |
| **Machine grammars & constrained sampling** | Eliminate conversational token bloat, preamble fluff, YAML/JSON schemas, regex/enum locks | [`.agents/skills/productivity/grammars-and-constrained-sampling/SKILL.md`](skills/productivity/grammars-and-constrained-sampling/SKILL.md) |
| **Decision questionnaire for teammates** | Turn complex design choices into a fillable questionnaire | [`.agents/skills/productivity/to-questionnaire/SKILL.md`](skills/productivity/to-questionnaire/SKILL.md) |
| **Authoring skills & guidelines for AI** | Writing effective prompt files, skills, and AGENTS.md | [`.agents/skills/productivity/writing-for-agents/SKILL.md`](skills/productivity/writing-for-agents/SKILL.md) |
| **Technical writing & post-mortems** | Authoring RFCs, architecture decisions, and post-mortems | [`.agents/skills/productivity/technical-writing-for-engineers/SKILL.md`](skills/productivity/technical-writing-for-engineers/SKILL.md) |
| **Daily progress report / Notion summary** | Daily summary from Git commits & conversation history | [`.agents/skills/productivity/daily-progress-report/SKILL.md`](skills/productivity/daily-progress-report/SKILL.md) |
| **Developer stories & portfolio case studies** | Anti-slop technical narratives, builder journeys, dispatches, CASI framework | [`.agents/skills/productivity/developer-story/SKILL.md`](skills/productivity/developer-story/SKILL.md) |
| **Anti-overengineering & YAGNI code razor** | Stop AI bloat, 7-Rung Decision Ladder, helper elimination, debt ledger | [`.agents/skills/productivity/ponytail/SKILL.md`](skills/productivity/ponytail/SKILL.md) |
| **Adopt ACON into repository / sync** | Bootstrap Control Plane, skills catalog, zero-symlink invariant, Two-Tier AGENTS.md (`scripts/adopt.sh`) | [`.agents/skills/productivity/adopt-acon/SKILL.md`](skills/productivity/adopt-acon/SKILL.md) |
| **Multi-Agent Orchestration & Control Plane** | 5+ files, specialist subagents, Ship vs. Scout tasks, Bearings status | [`AGENTS.md`](../AGENTS.md), [`.agents/rules/agent-control-plane.md`](rules/agent-control-plane.md) |
| **Discovering codebase conventions** | Analyzing patterns, naming conventions, and architecture | [`.agents/skills/frameworks/infer-conventions/SKILL.md`](skills/frameworks/infer-conventions/SKILL.md) |
| **Laravel Boost MCP & Doc search** | Using `database-query`, `database-schema`, `search-docs`, `.ai/rules` | [`.agents/skills/frameworks/laravel-boost/SKILL.md`](skills/frameworks/laravel-boost/SKILL.md) |
| **Laravel architecture & query tuning** | Advanced queries, caching, queues, events, db performance | [`.agents/skills/frameworks/laravel-best-practices/SKILL.md`](skills/frameworks/laravel-best-practices/SKILL.md) |
| **Pest / PHPUnit testing conventions** | Assertions, endpoint tests, isolation, mock data | [`.agents/skills/frameworks/testing-best-practices/SKILL.md`](skills/frameworks/testing-best-practices/SKILL.md) |
| **Inertia.js v3 + Vue 3 SPA development** | Page components, `<Link>`, `<Form>`, `useHttp`, deferred props | [`.agents/skills/frameworks/inertia-vue-development/SKILL.md`](skills/frameworks/inertia-vue-development/SKILL.md) |
| **Tailwind CSS styling & UI components** | Layout structures, responsive design, utility classes | [`.agents/skills/frameworks/tailwindcss-development/SKILL.md`](skills/frameworks/tailwindcss-development/SKILL.md) |
| **TypeScript route binding (Wayfinder)** | Type-safe Laravel routes in frontend `@/actions/` | [`.agents/skills/frameworks/wayfinder-development/SKILL.md`](skills/frameworks/wayfinder-development/SKILL.md) |
| **Craft UI/UX design & intent routing** | Stop generic AI slop, enforce hierarchy, select from 67 styles | [`.agents/skills/design/SKILL.md`](skills/design/SKILL.md), [`.agents/skills/design/interface-design/SKILL.md`](skills/design/interface-design/SKILL.md) |
| **Impeccable Design Director & Engine** | 23 lifecycle commands, craft floor quality floor, mechanical anti-pattern detector CLI | [`.agents/skills/design/impeccable/SKILL.md`](skills/design/impeccable/SKILL.md) |
| **Clean / Minimalist UI design** | Ample whitespace, 8pt grid, clear contrast, low clutter | [`.agents/skills/design/styles/clean/DESIGN.md`](skills/design/styles/clean/DESIGN.md), [`.agents/skills/design/styles/minimal/DESIGN.md`](skills/design/styles/minimal/DESIGN.md) |
| **Slick / Modern SaaS UI design** | Linear/Vercel feel, dark elevation, Inter + Mono, subtle borders | [`.agents/skills/design/styles/sleek/DESIGN.md`](skills/design/styles/sleek/DESIGN.md), [`.agents/skills/design/styles/bento/DESIGN.md`](skills/design/styles/bento/DESIGN.md) |
| **Audit or strip generic AI design slop** | Eliminate unmotivated purple gradients, flat hierarchy, monotone grid | [`.agents/skills/design/interface-design/commands/design-deslop.md`](skills/design/interface-design/commands/design-deslop.md), [`.agents/skills/design/interface-design/commands/design-review.md`](skills/design/interface-design/commands/design-review.md) |
| **Static code security audit** | OWASP Top 10, WooYun parameter priorities, taint analysis | [`.agents/skills/security-devops/security-audit/SKILL.md`](skills/security-devops/security-audit/SKILL.md) |
| **Secrets & credential leakage protection** | Zero-leakage policy for env files, API keys, and credentials | [`.agents/rules/security-secrets-guard.md`](rules/security-secrets-guard.md) |
| **Git pre-commit hooks & guardrails** | Block destructive git commands or set up Husky/lint-staged | [`.agents/skills/security-devops/git-guardrails-claude-code/SKILL.md`](skills/security-devops/git-guardrails-claude-code/SKILL.md), [`.agents/skills/security-devops/setup-pre-commit/SKILL.md`](skills/security-devops/setup-pre-commit/SKILL.md) |
| **Git worktrees & branch isolation** | Multi-agent worktree isolation topology, lifecycle, collision avoidance | [`.agents/skills/security-devops/git-worktrees/SKILL.md`](skills/security-devops/git-worktrees/SKILL.md) |
| **Shell automation & bash scripts** | Strict modes (`set -euo pipefail`), cleanup traps, safe quoting, `getopts` | [`.agents/skills/security-devops/shell-scripting/SKILL.md`](skills/security-devops/shell-scripting/SKILL.md) |

---

## 2. Category & Suite Index

| Category / Directory | Count | Main Entry File |
| :--- | :--- | :--- |
| **[`skills/design/`](skills/design/)** | 3 Skills + 67 Presets | Master design orchestrator, craft engineering (`interface-design`), Impeccable Design Director (`impeccable`), and 67 curated aesthetic style presets (`clean`, `sleek`, `bento`, `ant`, etc.) |


| **[`skills/engineering/`](skills/engineering/)** | 14 Skills | Problem solving, architecture, TDD, debugging, code review, ticket mapping, refactoring, API design, zero-downtime migrations |
| **[`skills/productivity/`](skills/productivity/)** | 12 Skills | Repository adoption (`adopt-acon`), interrogation (`grill-me`), 9-dimension prompting (`prompt-master`), machine grammars (`grammars-and-constrained-sampling`), anti-overengineering (`ponytail`), handoffs, developer stories |
| **[`skills/frameworks/`](skills/frameworks/)** | 8 Skills | Laravel 13, Filament 5, Inertia v3, Vue 3, Tailwind CSS, Wayfinder, Pest |
| **[`skills/security-devops/`](skills/security-devops/)** | 6 Skills | Security audit (21 modules), git guardrails, git worktrees, shell scripting, conventional commits, pre-commit |
| **[`scripts/`](../scripts/adopt.sh)** | 1 Automation Script | Repository adoption & synchronization script (`scripts/adopt.sh`) |
| **[`rules/`](rules/)** | 4 Global Rules | [`.agents/rules/`](rules/) (`agent-control-plane.md`, `security-secrets-guard.md`, `git-conventional-commits.md`, `progress-reporting.md`) |

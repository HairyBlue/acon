# Agentic Conventions & Control Plane Network (ACON) — Index & Lookup Matrix

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
| **Frontend file structure, thin controllers, no custom primitives** | Frontend conventions & service-layer | [`.agents/skills/engineering/frontend-conventions/SKILL.md`](skills/engineering/frontend-conventions/SKILL.md) |
| **Deep module & clean architecture design** | Designing interfaces with small surfaces and hidden complexity | [`.agents/skills/engineering/codebase-design/SKILL.md`](skills/engineering/codebase-design/SKILL.md), [`.agents/skills/engineering/improve-codebase-architecture/SKILL.md`](skills/engineering/improve-codebase-architecture/SKILL.md) |
| **Enforce deep modules in TypeScript** | Setting up dependency-cruiser boundary rules | [`.agents/skills/engineering/setup-ts-deep-modules/SKILL.md`](skills/engineering/setup-ts-deep-modules/SKILL.md) |
| **Hard bug or performance regression** | Root cause elusive, need systematic red-test feedback loop | [`.agents/skills/engineering/diagnosing-bugs/SKILL.md`](skills/engineering/diagnosing-bugs/SKILL.md) |
| **Throwaway prototype for UX/logic** | Validate UI interaction or state before writing production code | [`.agents/skills/engineering/prototype/SKILL.md`](skills/engineering/prototype/SKILL.md) |
| **Interactive CLI setup wizard for humans** | Guide user through manual cloud/secret/dashboard setup | [`.agents/skills/engineering/wizard/SKILL.md`](skills/engineering/wizard/SKILL.md) |
| **Session compacting & agent handoff** | Hand off ongoing conversation state to another session | [`.agents/skills/productivity/handoff/SKILL.md`](skills/productivity/handoff/SKILL.md) |
| **Machine grammars & schema locks** | Eliminate conversational token bloat, Token-0 anchoring, zero preamble, YAML schemas, closed enums | [`.agents/skills/productivity/grammars-and-constrained-sampling/SKILL.md`](skills/productivity/grammars-and-constrained-sampling/SKILL.md) |
| **Dynamic sampling & I/O verification control** | Master 4-stage lifecycle: context slicing, sampling calibration, machine contracts, compiler loops | [`.agents/skills/productivity/io-verification-control/SKILL.md`](skills/productivity/io-verification-control/SKILL.md) |
| **Decision questionnaire for teammates** | Turn complex design choices into a fillable questionnaire | [`.agents/skills/productivity/to-questionnaire/SKILL.md`](skills/productivity/to-questionnaire/SKILL.md) |
| **Writing or structuring implementation plans / plan-first gate / docs/plans/** | Bite-sized TDD implementation planning, interface contracts (Consumes/Produces), zero-placeholder specs | [`.agents/skills/productivity/writing-plans/SKILL.md`](skills/productivity/writing-plans/SKILL.md) |
| **Evaluating decision gates / Jev probability sheets / task shape & slop audit / deliverable verification** | Machine-native decision intelligence, 7 typed decision gates (G1–G7), calibration logging, dual-scout redundancy | [`.agents/skills/productivity/decision-gates/SKILL.md`](skills/productivity/decision-gates/SKILL.md) |
| **Authoring skills & guidelines for AI** | Writing effective prompt files, skills, and AGENTS.md | [`.agents/skills/productivity/writing-for-agents/SKILL.md`](skills/productivity/writing-for-agents/SKILL.md) |
| **Technical writing & post-mortems** | Authoring RFCs, architecture decisions, and post-mortems | [`.agents/skills/productivity/technical-writing-for-engineers/SKILL.md`](skills/productivity/technical-writing-for-engineers/SKILL.md) |
| **Daily progress report / Notion summary** | Daily summary from Git commits & conversation history | [`.agents/skills/productivity/daily-progress-report/SKILL.md`](skills/productivity/daily-progress-report/SKILL.md) |
| **Developer stories & portfolio case studies** | Anti-slop technical narratives, builder journeys, dispatches, CASI framework | [`.agents/skills/productivity/developer-story/SKILL.md`](skills/productivity/developer-story/SKILL.md) |
| **Anti-overengineering & YAGNI code razor** | Stop AI bloat, 7-Rung Decision Ladder, helper elimination, debt ledger | [`.agents/skills/productivity/ponytail/SKILL.md`](skills/productivity/ponytail/SKILL.md) |
| **Adopt ACON into repository / sync** | Bootstrap Control Plane, skills catalog, zero-symlink invariant, Two-Tier AGENTS.md (`scripts/adopt.sh`) | [`.agents/skills/productivity/adopt-acon/SKILL.md`](skills/productivity/adopt-acon/SKILL.md) |
| **Craft UI/UX design & intent routing** | Stop generic AI slop, enforce hierarchy, select from 67 styles | [`.agents/skills/design/SKILL.md`](skills/design/SKILL.md), [`.agents/skills/design/interface-design/SKILL.md`](skills/design/interface-design/SKILL.md) |
| **Impeccable Design Director & Engine** | 23 lifecycle commands, craft floor quality floor, mechanical anti-pattern detector CLI | [`.agents/skills/design/impeccable/SKILL.md`](skills/design/impeccable/SKILL.md) |
| **Clean / Minimalist UI design** | Ample whitespace, 8pt grid, clear contrast, low clutter | [`.agents/skills/design/styles/clean/DESIGN.md`](skills/design/styles/clean/DESIGN.md), [`.agents/skills/design/styles/minimal/DESIGN.md`](skills/design/styles/minimal/DESIGN.md) |
| **Slick / Modern SaaS UI design** | Linear/Vercel feel, dark elevation, Inter + Mono, subtle borders | [`.agents/skills/design/styles/sleek/DESIGN.md`](skills/design/styles/sleek/DESIGN.md), [`.agents/skills/design/styles/bento/DESIGN.md`](skills/design/styles/bento/DESIGN.md) |
| **Audit or strip generic AI design slop** | Eliminate unmotivated purple gradients, flat hierarchy, monotone grid | [`.agents/skills/design/interface-design/commands/design-deslop.md`](skills/design/interface-design/commands/design-deslop.md), [`.agents/skills/design/interface-design/commands/design-review.md`](skills/design/interface-design/commands/design-review.md) |
| **Form UX & schema validation** | Real-time validation timing, accessible inputs, multi-step flows, error recovery | [`.agents/skills/design/craft/form-validation.md`](skills/design/craft/form-validation.md) |
| **UI state coverage (5 states)** | Empty, loading, error, success, and partial states across interactive surfaces | [`.agents/skills/design/craft/state-coverage.md`](skills/design/craft/state-coverage.md) |
| **Accessibility baseline (WCAG 2.2)** | Contrast ratios, focus rings, touch targets, screen readers, keyboard navigation | [`.agents/skills/design/craft/accessibility-baseline.md`](skills/design/craft/accessibility-baseline.md) |
| **Motion, springs & micro-interactions** | Physics-based animation, spring dynamics, transition choreographies, reduced motion | [`.agents/skills/design/craft/motion.md`](skills/design/craft/motion.md) |
| **Typography hierarchy & rhythm** | Type scales, vertical rhythm, font pairing, line-height calibration, tension contracts | [`.agents/skills/design/craft/typography-hierarchy.md`](skills/design/craft/typography-hierarchy.md) |
| **Color tokens & palette discipline** | Semantic color tokens, 60-30-10 rule, dark mode surfaces, accent caps | [`.agents/skills/design/craft/color.md`](skills/design/craft/color.md) |
| **RTL & BiDi layout support** | Logical CSS properties, mirroring, bi-directional text, RTL-safe icons | [`.agents/skills/design/craft/rtl-and-bidi.md`](skills/design/craft/rtl-and-bidi.md) |
| **UX laws & cognitive models** | Fitts's Law, Hick's Law, Miller's Law, Jakob's Law, Doherty Threshold | [`.agents/skills/design/craft/laws-of-ux.md`](skills/design/craft/laws-of-ux.md) |
| **Static code security audit** | OWASP Top 10 (2021), OWASP API Security Top 10 (2023), D1-D10 matrix, taint analysis, AST triage, closed-loop remediation | [`.agents/skills/security-devops/security-audit/SKILL.md`](skills/security-devops/security-audit/SKILL.md) |
| **Secrets & credential leakage protection** | Zero-leakage policy for env files, API keys, and credentials | [`.agents/rules/security-secrets-guard.md`](rules/security-secrets-guard.md) |
| **Git pre-commit hooks & guardrails** | Block destructive git commands or set up Husky/lint-staged | [`.agents/skills/security-devops/git-guardrails/SKILL.md`](skills/security-devops/git-guardrails/SKILL.md), [`.agents/skills/security-devops/setup-pre-commit/SKILL.md`](skills/security-devops/setup-pre-commit/SKILL.md) |
| **Git worktrees & branch isolation** | Multi-agent worktree isolation topology, lifecycle, collision avoidance | [`.agents/skills/security-devops/git-worktrees/SKILL.md`](skills/security-devops/git-worktrees/SKILL.md) |
| **Shell automation & bash scripts** | Strict modes (`set -euo pipefail`), cleanup traps, safe quoting, `getopts` | [`.agents/skills/security-devops/shell-scripting/SKILL.md`](skills/security-devops/shell-scripting/SKILL.md) |

---

## 2. Category & Suite Index

| Category / Directory | Count | Main Entry File |
| :--- | :--- | :--- |
| **[`skills/design/`](skills/design/)** | 2 Skills + 67 Presets + 17 Craft References | Master design orchestrator, craft engineering (`interface-design`), Impeccable Design Director (`impeccable`), 67 curated aesthetic style presets (`clean`, `sleek`, `bento`, `ant`, etc.), and 17 design craft references (`anti-ai-slop`, `color`, `typography-hierarchy`, etc.) |
| **[`skills/engineering/`](skills/engineering/)** | 15 Skills | Problem solving, architecture, TDD, debugging, code review, ticket mapping, refactoring, API design, zero-downtime migrations, frontend-conventions |
| **[`skills/productivity/`](skills/productivity/)** | 14 Skills | Repository adoption (`adopt-acon`), decision gates (`decision-gates`), interrogation (`grill-me`), 9-dimension prompting (`prompt-master`), machine grammars (`grammars-and-constrained-sampling`), I/O & verification control (`io-verification-control`), anti-overengineering (`ponytail`), bite-sized planning (`writing-plans`), handoffs, developer stories |
| **[`skills/security-devops/`](skills/security-devops/)** | 6 Skills | Security audit (universal engine), git guardrails, git worktrees, shell scripting, conventional commits, pre-commit |
| **[`scripts/`](../scripts/adopt.sh)** | 1 Automation Script | Repository adoption & synchronization script (`scripts/adopt.sh`) |
| **[`rules/`](rules/)** | 4 Global Rules | [`.agents/rules/`](rules/) (`agent-control-plane.md`, `security-secrets-guard.md`, `git-conventional-commits.md`, `progress-reporting.md`) |
| **[`reference/schemas/`](reference/schemas/)** | 7 Machine Schemas | Canonical YAML schemas (`scout-report.yaml`, `ship-diff.yaml`, `grill-interview.yaml`, `task-contract.yaml`, `handoff-state.yaml`, `bearings-digest.yaml`, `decision-sheet.yaml`) |
| **[`reference/`](reference/)** | 1 Reference Catalog | Consolidated reference catalogs (`fowler-smells.md`) |

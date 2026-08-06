# ACON Index — Skill & Rule Lookup Matrix

This index maps developer symptoms, task goals, technology stacks, and security auditing requirements to the exact skill or rule in `.acon/`.

---

## 1. Quick Symptom & Task Lookup

Use this section to quickly identify which skill or rule resolves your immediate problem.

| Symptom / Task Goal | Likely Cause / Area | Recommended Skill or Rule |
| :--- | :--- | :--- |
| **Batch multi-file edits / Subagent delegation** | 5+ files to edit, parallel refactoring, multi-component generation | [`.acon/skills/multi-agent-orchestration/SKILL.md`](skills/multi-agent-orchestration/SKILL.md), [`.acon/rules/multi-agent-delegation.md`](rules/multi-agent-delegation.md) |
| **SQL injection / Raw query vulnerability** | Concatenation in `DB::raw()`, `FromSqlRaw()`, `sequelize.query()` | [`.acon/skills/security-audit/checklists/coverage-matrix.md`](skills/security-audit/checklists/coverage-matrix.md), [`.acon/skills/security-audit/languages/php.md`](skills/security-audit/languages/php.md) |
| **IDOR / User accessing another user's data** | Missing ownership validation in `find($id)` or controller | [`.acon/skills/security-audit/security/auth-oauth-jwt.md`](skills/security-audit/security/auth-oauth-jwt.md), [`.acon/skills/security-audit/checklists/coverage-matrix.md`](skills/security-audit/checklists/coverage-matrix.md) |
| **Mass assignment / Unrestricted fields updated** | `$request->all()` passed directly into `create()` / `update()` | [`.acon/rules/laravel-projects/api-thin-controllers.md`](rules/laravel-projects/api-thin-controllers.md), [`.acon/skills/security-audit/security/business-logic.md`](skills/security-audit/security/business-logic.md) |
| **Fat controllers / Bloated business logic** | Inline database queries, validation, & side-effects in controllers | [`.acon/rules/laravel-projects/api-thin-controllers.md`](rules/laravel-projects/api-thin-controllers.md), [`.acon/rules/laravel-projects/architecture-action-pattern.md`](rules/laravel-projects/architecture-action-pattern.md) |
| **N+1 query performance bottleneck** | Lazy loading Eloquent relationships in loops | [`.acon/rules/laravel-projects/data-eloquent-relationships.md`](rules/laravel-projects/data-eloquent-relationships.md) |
| **Filament v5 Resource schema unorganized** | Ad-hoc form inputs or missing table column definitions | [`.acon/rules/laravel-projects/filament-resource-standards.md`](rules/laravel-projects/filament-resource-standards.md) |
| **Git commit message unformatted or unapproved** | Missing Conventional Commit format or direct main commit | [`.acon/rules/git-conventional-commits.md`](rules/git-conventional-commits.md), [`.acon/skills/conventional-commits/SKILL.md`](skills/conventional-commits/SKILL.md) |
| **Daily progress report / Notion summary** | Daily summary from Git commits & conversation history | [`.acon/skills/daily-progress-report/SKILL.md`](skills/daily-progress-report/SKILL.md) |
| **Technical post-mortem or RFC writing** | Unstructured engineering docs or missing narrative arc | [`.acon/skills/technical-writing-for-engineers/SKILL.md`](skills/technical-writing-for-engineers/SKILL.md) |

---

## 2. Category & Suite Index

Summary of all available skill suites and rule categories in `.acon/`:

| Category | Skills / Rules Count | Target Scope | Main Entry File |
| :--- | :--- | :--- | :--- |
| **`skills/multi-agent-orchestration/`** | 1 Skill | Subagent delegation, parallel file edits, non-overlapping file scopes | [`.acon/skills/multi-agent-orchestration/SKILL.md`](skills/multi-agent-orchestration/SKILL.md) |
| **`skills/laravel-projects/`** | 2 Sub-skills + 118 Docs | Laravel 13.x, Filament 5.x, Eloquent, Livewire 3, Pest | [`.acon/skills/laravel-projects/SKILL.md`](skills/laravel-projects/SKILL.md) |
| **`skills/security-audit/`** | 21 Modules | Static security code analysis across PHP, JS/Node, Python, C# | [`.acon/skills/security-audit/SKILL.md`](skills/security-audit/SKILL.md) |
| **`skills/conventional-commits/`** | 1 Skill | Git Conventional Commits v1.0.0 header specification | [`.acon/skills/conventional-commits/SKILL.md`](skills/conventional-commits/SKILL.md) |
| **`skills/daily-progress-report/`** | 1 Skill | Automated daily progress report generator & Notion publisher | [`.acon/skills/daily-progress-report/SKILL.md`](skills/daily-progress-report/SKILL.md) |
| **`skills/technical-writing-for-engineers/`** | 1 Skill | Engineering post-mortems, RFCs, and architecture docs | [`.acon/skills/technical-writing-for-engineers/SKILL.md`](skills/technical-writing-for-engineers/SKILL.md) |
| **`rules/` (Global)** | 4 Rules | Quality & simplicity, commit confirmation policy, multi-agent delegation, report exclusions | [`.acon/rules/progress-report-exclusions.md`](rules/progress-report-exclusions.md) |
| **`rules/laravel-projects/`** | 4 Rules | Coding standards for Controllers, Actions, Eloquent, Filament | [`.acon/rules/laravel-projects/`](rules/laravel-projects/) |

---

## 3. Detailed Security Audit Suite Index (`skills/security-audit/`)

The security auditing skill is divided into 7 specialized subcategories:

| Subcategory | Focus & Coverage | File Links |
| :--- | :--- | :--- |
| **`core/`** | Taint analysis, false-positive elimination, anti-hallucination rules | [`taint-analysis.md`](skills/security-audit/core/taint-analysis.md), [`verification-methodology.md`](skills/security-audit/core/verification-methodology.md), [`anti-hallucination.md`](skills/security-audit/core/anti-hallucination.md) |
| **`frameworks/`** | Framework-specific vulnerabilities & anti-patterns | [`laravel.md`](skills/security-audit/frameworks/laravel.md), [`express-nextjs.md`](skills/security-audit/frameworks/express-nextjs.md), [`django-fastapi.md`](skills/security-audit/frameworks/django-fastapi.md), [`dotnet-asp.md`](skills/security-audit/frameworks/dotnet-asp.md) |
| **`languages/`** | Deep language security (Type confusion, Prototype pollution, Pickle, BinaryFormatter) | [`php.md`](skills/security-audit/languages/php.md), [`javascript.md`](skills/security-audit/languages/javascript.md), [`python.md`](skills/security-audit/languages/python.md), [`dotnet.md`](skills/security-audit/languages/dotnet.md) |
| **`checklists/`** | Universal OWASP D1-D10 security matrix & quick checklists | [`coverage-matrix.md`](skills/security-audit/checklists/coverage-matrix.md), [`php.md`](skills/security-audit/checklists/php.md), [`javascript.md`](skills/security-audit/checklists/javascript.md), [`python.md`](skills/security-audit/checklists/python.md), [`dotnet.md`](skills/security-audit/checklists/dotnet.md) |
| **`security/`** | Complex security domains (Business logic, Auth/OAuth/JWT, GraphQL, Supply Chain) | [`business-logic.md`](skills/security-audit/security/business-logic.md), [`auth-oauth-jwt.md`](skills/security-audit/security/auth-oauth-jwt.md), [`graphql-realtime.md`](skills/security-audit/security/graphql-realtime.md), [`supply-chain-infra.md`](skills/security-audit/security/supply-chain-infra.md) |
| **`wooyun/`** | 88,000+ real-world vulnerability parameter priorities & WAF bypasses | [`INDEX.md`](skills/security-audit/wooyun/INDEX.md), [`bypass-techniques.md`](skills/security-audit/wooyun/bypass-techniques.md), [`logic-flaw-patterns.md`](skills/security-audit/wooyun/logic-flaw-patterns.md) |
| **`reporting/`** | Standardized executive & technical vulnerability report format | [`report-template.md`](skills/security-audit/reporting/report-template.md) |

---

## 4. Technology Stack Matrix

| Technology | Available Skills & Rules |
| :--- | :--- |
| **Multi-Agent / Orchestration** | Skill: [multi-agent-orchestration](skills/multi-agent-orchestration/SKILL.md)<br>Rule: [multi-agent-delegation](rules/multi-agent-delegation.md) |
| **Laravel 13.x / PHP 8.2+** | Skill: [laravel-projects](skills/laravel-projects/SKILL.md)<br>Docs: [Laravel 13.x Docs](skills/laravel-projects/laravel/v13.x/SKILL.md)<br>Rules: [api-thin-controllers](rules/laravel-projects/api-thin-controllers.md), [architecture-action-pattern](rules/laravel-projects/architecture-action-pattern.md), [data-eloquent-relationships](rules/laravel-projects/data-eloquent-relationships.md)<br>Security: [PHP Deep Guide](skills/security-audit/languages/php.md), [Laravel Security](skills/security-audit/frameworks/laravel.md) |
| **Filament 5.x** | Skill: [laravel-projects](skills/laravel-projects/SKILL.md)<br>Docs: [Filament 5.x Docs](skills/laravel-projects/filament/v5.x/SKILL.md)<br>Rules: [filament-resource-standards](rules/laravel-projects/filament-resource-standards.md) |
| **JavaScript / Node.js / Express** | Skill: [security-audit](skills/security-audit/SKILL.md)<br>Security: [JS Deep Guide](skills/security-audit/languages/javascript.md), [Express/Next.js Security](skills/security-audit/frameworks/express-nextjs.md) |
| **Python / Django / FastAPI** | Skill: [security-audit](skills/security-audit/SKILL.md)<br>Security: [Python Deep Guide](skills/security-audit/languages/python.md), [Django/FastAPI Security](skills/security-audit/frameworks/django-fastapi.md) |
| **C# / .NET Core / ASP.NET** | Skill: [security-audit](skills/security-audit/SKILL.md)<br>Security: [C# Deep Guide](skills/security-audit/languages/dotnet.md), [ASP.NET Security](skills/security-audit/frameworks/dotnet-asp.md) |
| **Git / Source Control** | Skill: [conventional-commits](skills/conventional-commits/SKILL.md)<br>Rules: [git-conventional-commits](rules/git-conventional-commits.md) |
| **Notion / Daily Reporting** | Skill: [daily-progress-report](skills/daily-progress-report/SKILL.md) |

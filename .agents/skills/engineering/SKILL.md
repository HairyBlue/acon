---
name: engineering
description: "Master engineering orchestration suite covering refactoring, bug diagnosis, code review, domain modeling, spec synthesis, architecture design, frontend conventions, and opt-in TDD."
license: MIT
metadata:
  author: acon
---

# Engineering Master Suite

This skill serves as the primary router and master guide for core software engineering workflows in ACON.

---

## Suite Directory & Child Skills

| Skill Name | Description & When to Activate | Child Path |
| :--- | :--- | :--- |
| **`api-design`** | RESTful modeling, RFC 7807 problem details, idempotency keys, keyset pagination, and HMAC webhook reliability. | [`api-design/SKILL.md`](api-design/SKILL.md) |
| **`code-review`** | Two-axis diff review (Standards adherence + Spec conformance) via parallel subagents. | [`code-review/SKILL.md`](code-review/SKILL.md) |
| **`codebase-design`** | Discipline and vocabulary for designing deep modules with narrow interfaces and clean seams. | [`codebase-design/SKILL.md`](codebase-design/SKILL.md) |
| **`diagnosing-bugs`** | Fast-path direct fixes for obvious bugs; phased feedback loop for elusive/flaky bugs. | [`diagnosing-bugs/SKILL.md`](diagnosing-bugs/SKILL.md) |
| **`frontend-conventions`** | Modular file structure (≤300 lines), pragmatic logic separation, and zero reinvention of UI primitives. | [`frontend-conventions/SKILL.md`](frontend-conventions/SKILL.md) |
| **`domain-modeling`** | Ubiquitous language definition, scenario stress-testing, and ADR documentation. | [`domain-modeling/SKILL.md`](domain-modeling/SKILL.md) |
| **`improve-codebase-architecture`** | Scans codebase for deepening opportunities and presents an actionable improvement report. | [`improve-codebase-architecture/SKILL.md`](improve-codebase-architecture/SKILL.md) |
| **`prototype`** | Rapid throwaway HTML/UI prototypes to validate state and interaction design before production code. | [`prototype/SKILL.md`](prototype/SKILL.md) |
| **`refactoring`** | Fowler refactoring catalog, Two-Hats rule, guard clauses, extract/inline method, polymorphism, and strangler fig. | [`refactoring/SKILL.md`](refactoring/SKILL.md) |
| **`setup-ts-deep-modules`** | Enforces deep module boundaries in TypeScript with `dependency-cruiser` (opt-in). | [`setup-ts-deep-modules/SKILL.md`](setup-ts-deep-modules/SKILL.md) |
| **`tdd`** | Opt-in test-driven development red-green-refactor loop (activate ONLY when tests are explicitly requested). | [`tdd/SKILL.md`](tdd/SKILL.md) |
| **`to-spec`** | Synthesizes active architectural conversations into an actionable specification (opt-in). | [`to-spec/SKILL.md`](to-spec/SKILL.md) |
| **`wizard`** | Generates an interactive CLI bash wizard for manual human tasks (cloud setup, secrets). | [`wizard/SKILL.md`](wizard/SKILL.md) |
| **`zero-downtime-migrations`** | 5-phase Expand/Contract pattern and online index creation (activate ONLY for high-traffic production databases). | [`zero-downtime-migrations/SKILL.md`](zero-downtime-migrations/SKILL.md) |

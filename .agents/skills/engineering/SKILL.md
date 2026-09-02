---
name: engineering
description: "Master engineering orchestration suite covering TDD, code review, bug diagnosis, domain modeling, spec synthesis, architecture design, and merge conflict resolution."
license: MIT
metadata:
  author: acon
---

# Engineering Master Suite

This skill serves as the primary router and master guide for all core software engineering workflows in ACON.

---

## Suite Directory & Child Skills

| Skill Name | Description & When to Activate | Child Path |
| :--- | :--- | :--- |
| **`code-review`** | Two-axis diff review (Standards adherence + Spec conformance) via parallel subagents. | [`code-review/SKILL.md`](code-review/SKILL.md) |
| **`codebase-design`** | Discipline and vocabulary for designing deep modules with narrow interfaces and clean seams. | [`codebase-design/SKILL.md`](codebase-design/SKILL.md) |
| **`diagnosing-bugs`** | Systematic bug diagnosis loop: red-test creation $\rightarrow$ minimize $\rightarrow$ hypothesize $\rightarrow$ instrument $\rightarrow$ fix $\rightarrow$ regression-test. | [`diagnosing-bugs/SKILL.md`](diagnosing-bugs/SKILL.md) |
| **`domain-modeling`** | Ubiquitous language definition, scenario stress-testing, and ADR documentation. | [`domain-modeling/SKILL.md`](domain-modeling/SKILL.md) |
| **`grill-with-docs`** | Grilling session that simultaneously sharpens domain terms, builds models, and updates ADRs inline. | [`grill-with-docs/SKILL.md`](grill-with-docs/SKILL.md) |
| **`implement`** | Spec-driven implementation loop driving TDD at agreed seams and ending in code review. | [`implement/SKILL.md`](implement/SKILL.md) |
| **`improve-codebase-architecture`** | Scans codebase for deepening opportunities and presents an actionable improvement report. | [`improve-codebase-architecture/SKILL.md`](improve-codebase-architecture/SKILL.md) |
| **`prototype`** | Rapid throwaway HTML/UI prototypes to validate state and interaction design before production code. | [`prototype/SKILL.md`](prototype/SKILL.md) |
| **`research`** | Primary-source technical investigations captured as cited Markdown documents. | [`research/SKILL.md`](research/SKILL.md) |
| **`resolving-merge-conflicts`** | Hunk-by-hunk conflict resolution tracing original commit intent. | [`resolving-merge-conflicts/SKILL.md`](resolving-merge-conflicts/SKILL.md) |
| **`setup-ts-deep-modules`** | Enforces deep module boundaries in TypeScript with `dependency-cruiser`. | [`setup-ts-deep-modules/SKILL.md`](setup-ts-deep-modules/SKILL.md) |
| **`tdd`** | Strict test-driven development red-green-refactor loop. | [`tdd/SKILL.md`](tdd/SKILL.md) |
| **`to-spec`** | Synthesizes active architectural conversations into an actionable specification. | [`to-spec/SKILL.md`](to-spec/SKILL.md) |
| **`to-tickets`** | Breaks any plan or spec into tracer-bullet tickets with explicit blocking edges. | [`to-tickets/SKILL.md`](to-tickets/SKILL.md) |
| **`wizard`** | Generates an interactive CLI bash wizard for manual human tasks (cloud setup, secrets). | [`wizard/SKILL.md`](wizard/SKILL.md) |

---

## Workflow Guide

```
Plan / Ideate ──> [grill-with-docs] / [domain-modeling]
        │
        ├──> [to-spec] ──> [to-tickets]
        │
        └──> [implement] ──> [tdd] ──> [code-review]
```

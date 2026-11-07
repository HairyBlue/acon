---
name: writing-plans
description: "Use ONLY when the Captain explicitly requests an implementation plan (/plan or 'write a plan') or for massive multi-system architectural rewrites."
disable-model-invocation: true
license: MIT
metadata:
  author: acon
---

# Writing Implementation Plans (`writing-plans`)

> *"Default to Direct Execution. Write a formal plan ONLY when explicitly requested by the Captain or for a massive multi-system architectural rewrite."*

Implementation planning decomposes large architectural rewrites into self-contained units of work when requested. For everyday features, refactors, UI updates, database migrations, or bug fixes, **skip this skill and execute directly**.

---

## 1. The Plan-First Gate (Opt-In / Major Rewrites Only)

- **Plan Required (ONLY these two cases):**
  1. *Explicit Captain Command:* The user explicitly asks for a plan (`"write a plan"`, `"plan this"`, `/plan`).
  2. *Massive Multi-System Architectural Rewrite:* Rewriting core architecture from scratch across multiple subsystems with high ambiguity.
- **Plan Exempt (Direct Execution — Default for Everything Else):**
  1. *Normal Features & Business Logic:* Adding features, endpoints, components, or state logic.
  2. *Database & Schema Changes:* Adding/modifying tables, columns, queries, or standard migrations.
  3. *Refactors & Cleanups:* Single-file or multi-file refactors, renames, and restructuring.
  4. *UI, Styling & Bug Fixes:* Visual changes, forms, CRUD scaffolding, and defect fixes—regardless of file count.

When a plan IS required, save it to:
```text
docs/plans/YYYY-MM-DD-<feature-name>.md
```
and pause for Captain sign-off before modifying production code.

---

## 2. Engineering Governance: Strict Pairing with Ponytail

Every implementation plan MUST strictly follow the [`ponytail`](../ponytail/SKILL.md) 7-Rung Decision Ladder (YAGNI → Codebase Reuse → Stdlib First → Platform Natives → Zero New Dependencies → Inline Clarity → Minimum Working Diff).

### Verification Standard (No Unrequested Test Bloat)
- **Default Verification:** Specify deterministic **compiler, typecheck, and linter** commands (`tsc --noEmit`, `npm run build`, `eslint`, etc.) for tasks.
- **No Unrequested Tests:** Do **NOT** include unit, frontend, database, or integration test-writing steps in the plan unless the Captain explicitly asked for tests.

---

## 3. Concrete Task Specifications & Parallel Crew Slicing

When authoring a plan, decompose work so **non-conflicting tasks can be executed in parallel by multiple crew workers** rather than sequentially by a single worker:
- **Parallel Tracks First (Cross-Layer & Intra-Layer):** Group independent file scopes so multiple workers run simultaneously—not just 1 backend + 1 frontend, but also **2+ Frontend Workers** on non-conflicting pages/components and **2+ Backend Workers** on non-conflicting routes/services.
- **Synthesis Slice Last:** If multiple parallel workers need to register into a shared file (e.g., `routes.ts`, barrel `index.ts`), isolate that shared file into a final Synthesis task after the parallel tracks complete.

Avoid vague placeholders (`"TODO"`, `"TBD"`). Each task in the plan should specify:
- **Goal:** One-sentence objective.
- **Files (Non-Overlapping):** Exact paths to create or modify.
- **Parallel Group / Track:** Which tasks can run at the same time by separate workers.
- **Interface Contract (`Consumes` / `Produces`):** Key types or signatures shared between tasks (following [`.agents/reference/schemas/task-contract.md`](../../../reference/schemas/task-contract.md) when delegating to a crew).
- **Implementation Summary / Key Code:** Concrete changes to apply.
- **Verification Command:** Exact build, typecheck, or lint command to confirm exit code `0`.

---

## 4. Canonical Implementation Plan Template

```markdown
# Implementation Plan: [Feature / Architecture Name]

- **Plan File:** `docs/plans/YYYY-MM-DD-[feature-name].md`
- **Date:** YYYY-MM-DD
- **Status:** [Draft | Approved | In Progress | Completed]

---

## 1. Context & Objective
[Brief explanation of the goal. 1–2 paragraphs.]

## 2. Architecture & Ponytail Alignment
- **Approach:** [High-level approach and why it is the simplest working solution]
- **YAGNI / Zero New Deps:** [Confirmation of zero unrequested abstractions or dependencies]

---

## 3. Implementation Tasks

### - [ ] Task 1: [Short Action-Oriented Title]
- **Goal:** [One-sentence objective]
- **Files:**
  - `Modify:` `src/path/to/file.ts`
- **Changes:**
  [Concrete code block or exact modification details]
- **Verification:**
  ```bash
  npm run typecheck && npm run lint
  ```

### - [ ] Task 2: [Short Action-Oriented Title]
...
```

## Provenance and MIT notice

Bounded-delegation wording is an ACON reconciliation informed by Fleet `docs/PHILOSOPHY.md`, revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`. See the [local provenance and full MIT notice](../../../reference/crew/README.md#provenance-and-mit-notice). No source runtime or persona selection is adopted.

## End provenance and MIT notice

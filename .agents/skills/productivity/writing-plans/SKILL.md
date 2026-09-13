---
name: writing-plans
description: "Use when you have a spec or requirements for a multi-step task, architectural refactor, or complex feature, before touching code."
license: MIT
metadata:
  author: acon
---

# Writing Implementation Plans (`writing-plans`)

> *"Assume the implementer has zero context and questionable taste. Give them exact files, exact signatures, full code blocks, and concrete test assertions."*

Implementation planning is the mandatory bridge between system requirements and autonomous agent execution. The goal of an implementation plan is to decompose complex features, refactors, and architectural migrations into self-contained, bite-sized units of work that can be executed with zero ambiguity, zero guesswork, and zero token bloat.

---

## 1. Core Philosophy: The Plan-First Invariant

AI coding agents excel at focused execution within well-defined boundaries, but degrade rapidly when forced to plan, explore, and write complex code simultaneously. 

### Core Tenets
1. **Zero Context, Questionable Taste Assumption:** Always author plans assuming the downstream worker has zero memory of previous conversations, zero intuition about architectural subtleties, and an inclination toward speculative over-engineering unless strictly constrained.
2. **The Plan-First Gate:** For any task that modifies $\ge 3$ files, touches cross-subsystem boundaries, or executes architectural refactoring, the Control Plane MUST draft a comprehensive implementation plan and secure Captain sign-off BEFORE any execution worker touches code.
3. **Externalized Disk State:** The implementation plan is saved directly to disk at:
   ```
   docs/plans/YYYY-MM-DD-<feature-name>.md
   ```
   This disk file is the single source of truth. Task progress is tracked live using markdown checkboxes (`- [ ]` and `- [x]`).
4. **Separation of Planning and Execution:** Authoring the plan is a discrete phase. Never mix planning iterations with active codebase modifications.

---

## 2. Engineering Governance: Strict Pairing with Ponytail

Every implementation plan created under `writing-plans` MUST strictly pair with the [`ponytail`](../ponytail/SKILL.md) anti-overengineering framework.

### The 7-Rung Ladder in Plan Design
Before specifying any task or component in the plan, evaluate it against the 7 rungs:
1. **Rung 1 (YAGNI):** Does this file or abstraction need to exist at all? Reject speculative hooks, generic interfaces for single implementations, and unrequested flexibility.
2. **Rung 2 (Codebase Reuse):** Has another module in the repository already solved this? Audit existing helpers and models before creating new ones.
3. **Rung 3 (Stdlib First):** Use language and runtime built-ins (`crypto.randomUUID()`, `structuredClone()`, `pathlib`) rather than pulling in external libraries.
4. **Rung 4 (Platform Natives):** Leverage native platform features (e.g., HTML `<dialog>`, CSS Grid, native FormData) rather than custom multi-file state machines.
5. **Rung 5 (Zero New Dependencies):** Zero new dependencies in manifests (`package.json`, `composer.json`, `pyproject.toml`) without explicit prior Captain authorization.
6. **Rung 6 (Inline Clarity):** Keep simple logic inline at the call site. Do not introduce single-use 3-line micro-helpers.
7. **Rung 7 (Minimum Working Diff):** Design the smallest possible diff that completely satisfies the requirements and passes all tests.

### The Non-Negotiable Safety Invariant
While minimizing code diffs, the plan must never compromise on the 5 safety pillars:
- **Security:** Parameterized queries, input sanitization, CSRF/CORS compliance, zero secrets in source.
- **Runtime Validation:** Schema validation at all network/IO boundaries (`zod`, `valibot`, `FormRequest`, `pydantic`).
- **Error Handling:** Explicit failure modes, status codes, and clear diagnostics (no empty `catch` blocks).
- **Accessibility:** Semantic HTML elements, ARIA labels, keyboard navigability.
- **Automated Tests:** 100% test pass rate across unit, integration, and edge cases.

---

## 3. The "No Placeholders" Mandate (Zero Hand-Waving)

A plan with placeholders is not an implementation plan—it is an unfinished thought. Downstream subagents will hallucinate missing details or invent incompatible interfaces if placeholders are permitted.

### Strictly Prohibited
❌ `"TODO: implement later"`  
❌ `"TBD / figure out in implementation"`  
❌ `"Add appropriate error handling"`  
❌ `"Write unit tests for the above"` (without the test code)  
❌ `"Wire up the database query"` (without the exact query or ORM call)  
❌ Pseudo-code or hand-waving bullet points for code logic  

### Mandatory Requirement
Every code task MUST include:
- **Exact File Paths:** Absolute or workspace-relative paths for all files created, modified, or tested.
- **Target Lines / Symbols:** Specific classes, functions, or line ranges being targeted in existing files.
- **Full Implementation Code Blocks:** The exact code to be written, including imports, types, and logic.
- **Full Test Code Blocks:** Complete, runnable test suites asserting concrete behaviors, inputs, and expected outputs.
- **Exact Shell Commands:** The precise verification commands to execute and their expected outputs.

---

## 4. Task Right-Sizing & Interface Contracts

To prevent execution failures, tasks must be broken down into atomic, right-sized units with clear interface boundaries.

### Right-Sizing Guidelines
- **Granularity:** Each task should represent approximately 15 to 30 minutes of subagent execution work.
- **Single Responsibility:** A task should touch a small, cohesive set of files (ideally 1–2 production files plus their corresponding test file).
- **Independent Verifiability:** Every individual task must end with a concrete passing test suite before moving to the next task.

### Interface Contracts: Consumes & Produces
To eliminate integration bugs when tasks are executed by separate subagents, every task specification must declare its interface contracts:

- **`Consumes`:** The exact types, interfaces, schemas, or function signatures imported from earlier tasks or existing codebase modules.
- **`Produces`:** The exact types, interfaces, schemas, functions, or endpoints created by this task that will be consumed by subsequent tasks.

```markdown
#### Interface Contract
- **Consumes:**
  ```typescript
  import { UserRecord } from '@/types/user';
  import { DbClient } from '@/db/client';
  ```
- **Produces:**
  ```typescript
  export interface BillingSummary {
    userId: string;
    totalDueCents: number;
    currency: 'usd';
  }
  export function calculateBillingSummary(user: UserRecord, db: DbClient): Promise<BillingSummary>;
  ```
```

### The 5-Step Bite-Sized TDD Cycle
Every code task in the plan must specify the 5 TDD steps:
1. **Step 1: Write Failing Test:** Provide the full test code block targeting the unit or feature.
2. **Step 2: Verify Test Failure:** State the exact test runner command and the expected failure mode (e.g., `Expected calculateBillingSummary to be defined`).
3. **Step 3: Write Minimal Implementation:** Provide the exact code fulfilling the test, adhering strictly to Ponytail.
4. **Step 4: Verify Test Pass:** State the exact test runner command and the expected passing confirmation.
5. **Step 5: Codebase Verification & Static Checks:** Run linters, type checkers, and formatters (`npm run lint`, `phpstan`, `tsc --noEmit`).

---

## 5. Context Hygiene, Handoffs, and Subagent Context Slicing

### The Context Degradation Problem
As an AI conversation extends, conversational history accumulates dozens of tool calls, exploratory outputs, and intermediate reasoning steps (often 50k–100k+ tokens). In large contexts:
- Model attention thins, leading to missed instructions.
- Instruction drift and hallucinated APIs increase.
- Tool call latency and token costs soar.

ACON solves context degradation through **Externalized Disk State**, **Context Handoffs**, and **Subagent Context Slicing**.

```mermaid
flowchart TD
    Req["Captain Requirement"] --> Plan["Control Plane writes plan<br>(docs/plans/YYYY-MM-DD-feature.md)"]
    Plan --> SignOff{"Captain Sign-off"}
    SignOff -->|Approved| Handoff["Trigger handoff skill<br>(Compact summary <3k tokens)"]
    Handoff --> Reset["Session Reset / Fresh State"]
    Reset --> Dispatch["Control Plane reads docs/plans/..."]
    Dispatch --> Slice1["Slice Task 1 ONLY"] --> Worker1["Subagent 1 (Executes Task 1)"]
    Worker1 --> Check1["Mark - [x] Task 1 on disk"]
    Check1 --> Slice2["Slice Task 2 ONLY"] --> Worker2["Subagent 2 (Executes Task 2)"]
    Worker2 --> Check2["Mark - [x] Task 2 on disk"]
```

### Externalized Disk State
The plan file `docs/plans/YYYY-MM-DD-<feature-name>.md` lives in the repository on disk.
- It survives agent session restarts, process crashes, and harness context limits.
- When an execution worker completes a task, the task's checkbox is updated to `- [x]` in the file.
- Any agent joining the project can immediately view the exact baseline and remaining work by inspecting the plan file.

### Session Resets via `handoff`
When the planning phase concludes and the Captain signs off on the plan:
1. The Control Plane activates [`handoff`](../handoff/SKILL.md) to generate a high-density, low-token summary (<3k tokens) referencing the plan file path.
2. The Captain or Control Plane triggers a session reset (e.g., `/clear` or starting a fresh command thread).
3. The new session loads with zero conversational baggage, reads `docs/plans/YYYY-MM-DD-<feature-name>.md`, and immediately begins autonomous crew flight.

### Subagent Context Slicing (The Slicing Rule)
When the Control Plane dispatches a specialist worker via `invoke_subagent`:
- **NEVER dump the entire 500-line plan or the multi-turn conversation history into the subagent brief.**
- **Slice ONLY Task N:** The prompt brief for Worker N must contain strictly:
  1. The objective of Task N.
  2. The specific file boundaries (`Create`, `Modify`, `Test`).
  3. The `Consumes` and `Produces` interface contracts.
  4. The concrete TDD steps and code blocks for Task N.
  5. The verification commands and Ponytail constraints.
- Keeping subagent briefs lean (<2k tokens) guarantees laser focus, avoids boundary violations, and eliminates hallucinations.

---

## 6. Canonical Implementation Plan Template

When authoring a plan in `docs/plans/YYYY-MM-DD-<feature-name>.md`, use the following standard structure:

```markdown
# Implementation Plan: [Feature Name]

- **Plan File:** `docs/plans/YYYY-MM-DD-[feature-name].md`
- **Author:** [Control Plane / Specialist Name]
- **Date:** YYYY-MM-DD
- **Status:** [Draft | In Review | Approved | In Progress | Completed]
- **Target Branch:** `feature/[feature-name]`

---

## 1. Context & Objective
[Brief explanation of the requirement, user problem, or architectural goal. 1–2 paragraphs.]

---

## 2. Architecture & Design Decisions
- **Approach:** [High-level architectural approach chosen and rationale]
- **Alternatives Considered:** [1–2 alternatives rejected and why, referencing Ponytail rungs]
- **Affected Subsystems:** [List of services, packages, directories impacted]

---

## 3. Engineering Constraints & Ponytail Alignment
- **YAGNI Check:** [What speculative features or abstractions were deliberately omitted]
- **Dependencies:** [Explicit confirmation: 0 new dependencies, or Captain-approved exception]
- **Platform/Stdlib:** [Natives utilized instead of external packages]
- **Safety Invariants:** [Validation schemas, security measures, test coverage targets]

---

## 4. Pre-requisites & Environment Setup
```bash
# Commands needed before running tasks (e.g. database migration, fixture setup)
```

---

## 5. Implementation Tasks

### - [ ] Task 1: [Short Action-Oriented Title]
- **Goal:** [One-sentence objective of this task]
- **Files:**
  - `Create:` `src/domain/billing/calculator.ts`
  - `Modify:` `src/domain/billing/types.ts`
  - `Test:` `tests/domain/billing/calculator.test.ts`
- **Interface Contract:**
  - `Consumes:` `import { AccountTier } from '@/domain/account/types';`
  - `Produces:` `export function calculateProration(tier: AccountTier, daysRemaining: number): number;`

#### Step 1: Write Failing Test
```typescript
// tests/domain/billing/calculator.test.ts
import { describe, it, expect } from 'vitest';
import { calculateProration } from '@/domain/billing/calculator';

describe('calculateProration', () => {
  it('calculates correct remaining balance for pro tier', () => {
    const result = calculateProration('PRO', 15);
    expect(result).toBe(1500);
  });
});
```

#### Step 2: Verify Test Failure
```bash
npx vitest run tests/domain/billing/calculator.test.ts
# Expected output: ReferenceError: calculateProration is not defined
```

#### Step 3: Minimal Implementation
```typescript
// src/domain/billing/calculator.ts
import { AccountTier } from '@/domain/account/types';

export function calculateProration(tier: AccountTier, daysRemaining: number): number {
  const dailyRateCents = tier === 'PRO' ? 100 : 50;
  return dailyRateCents * daysRemaining;
}
```

#### Step 4: Verify Test Passes
```bash
npx vitest run tests/domain/billing/calculator.test.ts
# Expected output: Tests: 1 passed, 1 total
```

#### Step 5: Verification & Quality Checks
```bash
npx eslint src/domain/billing/calculator.ts
npx tsc --noEmit
```

---

### - [ ] Task 2: [Short Action-Oriented Title]
... [Repeated structure for Task 2, Task 3, etc.]

---

## 6. Integration & Acceptance Verification
- [ ] Complete test suite passes: `npm test` or `php artisan test`
- [ ] Linter & Typecheck: `npm run lint && npm run typecheck`
- [ ] End-to-end user scenario validation:
  ```bash
  # Concrete curl command, CLI invocation, or browser test
  ```

---

## 7. Rollback & Risk Strategy
- **Failure Recovery:** [How to revert cleanly if verification fails]
- **Data Migration Impact:** [Notes on schema reversibility if applicable]
```

---

## 7. Authoring Workflow: Step-by-Step

When the Captain requests a complex feature, follow this operational cadence:

1. **Intake & Intent Extraction:**  
   Run `prompt-master` 9-dimension extraction. If forks or ambiguities exist, trigger `grill-me` for quick alignment.
2. **Read-Only Codebase Scouting:**  
   Dispatch a `Codebase Scout` via `invoke_subagent` to locate existing patterns, utility functions, test conventions, and integration seams. Never guess file contents or function signatures.
3. **Draft Implementation Plan:**  
   Write the complete plan using the template above, enforcing the Ponytail ladder, interface contracts, and complete code blocks. Save to `docs/plans/YYYY-MM-DD-<feature-name>.md`.
4. **Self-Audit against Mandates:**  
   - Are there any "TODO", "TBD", or "appropriate error handling" hand-waving statements? (Fix them).
   - Are all test code blocks and commands complete? (Verify them).
   - Are interfaces between tasks cleanly typed and matching? (Check signatures).
5. **Captain Presentation & Approval Gate:**  
   Present the plan summary, file locations, and trade-offs to the Captain. Explicitly ask for sign-off before proceeding.
6. **Handoff & Context Reset (Optional but Recommended for Large Missions):**  
   If the conversation is long (>20k tokens), execute `handoff` and start a fresh session targeting `docs/plans/YYYY-MM-DD-<feature-name>.md`.
7. **Task Slicing & Autonomous Dispatch:**  
   Slice Task 1 into a subagent brief (`invoke_subagent`). When Task 1 reports complete and passes verification, mark `- [x]` in the plan file, and proceed to Task 2.

---
name: multi-agent-orchestration
description: Parallel multi-agent task orchestration and subagent delegation. Guides agents on when to spawn concurrent subagents for multi-file edits, how to partition non-overlapping file boundaries, and how to synthesize parallel results.
license: MIT
metadata:
  version: "1.0.0"
  supported_tools: ["invoke_subagent", "define_subagent", "send_message"]
---

# Multi-Agent Orchestration & Parallel File Delegation

This skill provides guidelines and patterns for decomposing complex tasks and spawning concurrent subagents when editing multiple files or performing large-scale codebase operations.

---

## 1. Decision Matrix: When to Delegate

Assess the task before deciding to spawn subagents:

### ✅ USE Multiple Subagents When:
- **Batch Multi-File Edits**: Modifying or creating 5+ independent files (e.g. updating 10 API controllers, migrating 15 Vue components, generating 8 test files).
- **Domain-Isolated Tasks**: Tasks that map naturally to separate directories or modules (e.g. Subagent A refactors `frontend/`, Subagent B updates `backend/`, Subagent C audits `docs/`).
- **Parallel Research & Auditing**: Security code reviews across multiple sub-frameworks or large codebase sub-folders.
- **Independent Task Execution**: Tasks where Subagent B does not depend on the line-by-line output of Subagent A.

### ❌ DO NOT Use Subagents (Use Single Agent) When:
- **Tightly Coupled Sequential Changes**: Step 2 requires inspecting the exact code produced in Step 1.
- **Single or Few File Modifications**: 1 to 3 files can be edited faster directly without subagent invocation overhead.
- **Single Bug Debugging**: Tracing a single stack trace or exception across shared runtime execution.
- **Shared File Mutations**: Editing the exact same file simultaneously (causes write race conditions).

---

## 2. Core Partitioning Principles

To ensure clean, conflict-free parallel execution, enforce these 3 rules:

### Rule A: Strict Non-Overlapping File Scope
Assign mutually exclusive file boundaries to each subagent.
- **Correct**:
  - Subagent 1: Owns `app/Http/Controllers/Api/V1/*`
  - Subagent 2: Owns `app/Http/Controllers/Api/V2/*`
  - Subagent 3: Owns `tests/Feature/Api/*`
- **Incorrect**:
  - Subagent 1 and Subagent 2 both editing `routes/api.php` at the same time.

### Rule B: Self-Contained Prompts
Each subagent operates in a separate context window. Provide complete context in the prompt:
1. Target file paths to edit or create.
2. Design standards, interfaces, or type signatures to conform to.
3. Expected completion criteria.
4. Instruction **NOT** to run `git commit` or `git push` directly.

### Rule C: Reactive Wakeup (No Polling Loops)
After launching concurrent subagents via `invoke_subagent`, **do NOT poll in a loop**. Stop calling tools or proceed with independent parent work. The system will automatically wake up the parent agent when subagents complete.

---

## 3. Orchestration Workflow

```text
Phase 1: Inventory & Scope Mapping
  └─ List all files needing edits. Group into non-overlapping directory/module clusters.

Phase 2: Subagent Spawning
  └─ Call invoke_subagent() with distinct role names, clear prompts, and assigned file scopes.

Phase 3: Execution & Wait
  └─ Subagents execute concurrently. Parent agent awaits background notifications.

Phase 4: Synthesis & Verification
  └─ Parent inspects modified files, runs build/test suite, and verifies integration.
```

---

## 4. Subagent Spawning Example (JSON Pattern)

When spawning parallel subagents for multi-file edits, format `invoke_subagent` calls as follows:

```json
{
  "Subagents": [
    {
      "TypeName": "self",
      "Role": "Frontend Component Refactorer",
      "Prompt": "Refactor all Vue 3 components in src/components/dashboard/ to use TypeScript <script setup>. Do NOT edit files outside src/components/dashboard/.",
      "Model": "pro"
    },
    {
      "TypeName": "self",
      "Role": "Backend Action Writer",
      "Prompt": "Create single-purpose Action classes in app/Actions/Dashboard/ for each endpoint in Controllers/DashboardController.php. Do NOT edit frontend files.",
      "Model": "pro"
    },
    {
      "TypeName": "self",
      "Role": "Feature Test Suite Writer",
      "Prompt": "Create Pest tests for all dashboard endpoints in tests/Feature/DashboardTest.php matching the action contracts.",
      "Model": "pro"
    }
  ]
}
```

---

## 5. Verification & Rollback Policy

After all subagents finish:
1. **Run Automated Verification**: Execute the build tool (`npm run build`, `composer test`, `pytest`, `dotnet test`) to verify all subagent changes work seamlessly together.
2. **Audit File Integrity**: Check for unintended file deletions or missing imports across module boundaries.
3. **Consolidate Summary**: Present a unified summary of changes across all subagents to the user.

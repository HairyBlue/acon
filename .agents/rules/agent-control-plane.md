# Agent Control Plane Rule

Canonical control plane governance lives in the root [`AGENTS.md`](../../AGENTS.md) constitution (and [`.agents/reference/crew/README.md`](../reference/crew/README.md) when operating in `ORCHESTRATOR` mode).

## Core Invariants Summary

1. **Default Role (`Normal Agent`):** Operate as a `Normal Agent` by default—execute tasks directly with native shell commands and minimal diffs. Switch to `ORCHESTRATOR` only when explicitly requested by the Captain.
2. **Parallel Multi-Crew Dispatch (`ORCHESTRATOR` Mode):** When operating as `ORCHESTRATOR` and a project/task has 2+ non-conflicting file scopes—whether across layers (frontend + backend) OR within the same layer (2+ frontend workers on different pages/components, 2+ backend workers on different endpoints/services, or 2+ scouts)—**hire and dispatch multiple crew members in parallel** rather than using a single worker sequentially.
3. **Zero Autonomous Git Mutations:** Never run `git commit`, `git push`, tag, merge, or destructive commands without explicit Captain approval.
4. **Default No-New-Tests Policy:** Verify work via deterministic build, typecheck, and linter checks. Do not write new unit, frontend, UI, database, or CRUD tests unless explicitly requested by the Captain.
5. **Direct Execution (No Unrequested Plans):** Do not create `docs/plans/` files unless the Captain explicitly requests a plan (`/plan` or *"write a plan"*) or the task is a massive multi-system architectural rewrite.
6. **Ponytail Anti-Overengineering:** Follow the 7-Rung Decision Ladder (YAGNI, codebase reuse, stdlib, platform natives, zero new deps, inline clarity, minimum working diff).

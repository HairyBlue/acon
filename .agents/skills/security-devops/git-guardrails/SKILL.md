---
name: git-guardrails
description: Captain authorization checks and task-local evidence of git protections supplied by the installed harness; documentation does not enforce interception.
---

# Git Guardrails (`git-guardrails`)

This skill documents checks supporting Section 7 of the ACON Constitution: *Exclusive Captain Authority over Git Mutations*. It supplies no interceptor and makes no universal enforcement claim across agent harnesses or developer shells. Follow the [portable fleet contract](../../../reference/crew/README.md) for capability discovery and unsupported modes.

## Operations Requiring Captain Authorization

- Staging, commits, pushes (including forced pushes), tags, merges and remote mutations require explicit Captain approval for the intended operation and scope.
- Branch creation/deletion and destructive operations, including hard resets, file-restoring checkouts, restores and untracked file wipes, also require explicit approval.
- Task completion, passing tests, a review verdict or the absence of an interception error is never authorization. Leave verified changes uncommitted and unstaged unless separately authorized.

---

## 1. Authority Checks Before Execution

Confirm a Captain approval reference naming the operation, target and scope before any mutation. Missing or ambiguous authorization means `BLOCKED`; report the missing decision rather than executing. The Control Plane never executes git operations itself: it delegates only the explicitly approved operations to a bounded worker. Required independent G8/G9 review remains mandatory before a commit proposal; approval does not waive verification or exclusive file ownership.

The existing [scripts/block-dangerous-git.sh](scripts/block-dangerous-git.sh) is a legacy bundled artifact, untouched and out of scope. It is neither a required nor recommended adapter. Its presence is not evidence of installed protection, command coverage or authorization; this skill provides no execution, setup or import instructions for it.

---

## 2. Evidence of Installed Protections

Record only protections actually supplied by the active installed harness. Task-local evidence identifies the execution host, check time, relevant permission or approval boundary, covered operations and execution paths, and the artifact/locator supporting each observation. Distinguish advertised behavior from observed behavior and explicitly record gaps or unknown coverage. A protection on one execution path does not establish protection on other tools or shell sessions.

Use the canonical capability values `AVAILABLE, UNAVAILABLE, UNKNOWN`. Do not infer interception from these conventions, a script on disk or an unrelated successful check. Do not install hooks, configure wrappers, import source runtime or invent an adapter to fill a gap. Harness mechanisms do not replace Captain authority checks.

---

## 3. Verification and Unsupported Modes

Before delegated execution, recheck authorization, required capabilities and the relevant protection evidence against the current task and state. Report actual observations and limitations; no universal rejection message or exit code is prescribed. Do not issue an unauthorized destructive command merely to test a guardrail.

Missing or unknown required safety capability means `BLOCKED`. Seek a Captain-approved operating-mode decision under the [unsupported-mode contract](../../../reference/crew/README.md#unsupported-modes); the alternative remains blocked until approved and its required capabilities are demonstrated. Never substitute autonomous git operations, primary-thread execution or weaker review. After authorized execution, report the exact operations performed, their results and the resulting state, without implying approval for further mutations.

This protection/authority reconciliation is informed by Fleet `docs/PHILOSOPHY.md`, revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`; see the [local provenance and full MIT notice](../../../reference/crew/README.md#provenance-and-mit-notice). No upstream hook or runtime configuration is adopted.

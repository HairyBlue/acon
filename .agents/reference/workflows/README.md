# ACON Workflows

Named repeatable patterns. Reference these in briefs or invoke by name.

| Workflow | Trigger phrase | What happens |
|---|---|---|
| `scout-then-plan` | "Scout before planning" | Scout recon → Control Plane shapes plan |
| `implement-then-review` | "Implement, then review" | Worker implements → Reviewer checks → Worker applies authorized fixes |
| `review-loop` | "Review loop, max N rounds" | Reviewer → Worker (authorized fixes) → Reviewer, up to N rounds |
| `parallel-review` | "Parallel reviewers for X, Y, Z" | Independent reviewers assess assigned focus axes when supported; otherwise supported sequential isolated reviews |
| `oracle-first` | "Get oracle's opinion first" | Oracle challenges the plan → Control Plane considers advice → separately authorized dispatch |
| `council` | "/council" or "convene advisors" | Independent read-only pitches → attributed synthesis → Captain decides; no implementation authority |

See individual workflow files for full operating procedures. Delegated work and review
require the capabilities and authorization described in the
[portable fleet reference](../crew/README.md); names in this index do not imply
transport, concurrency, runtime permissions or automatic completion delivery.

**Origin:** Adapted from Fleet `references/communication-contract.md` and
`references/fleet-coordination-patterns.md` at revision
`0af843fa2c92413ea16c50e50bd8a9e24f1d1995`; digest concepts retain attribution to
disler/cmux. See the [local provenance and MIT notice](../crew/README.md#provenance-and-mit-notice).

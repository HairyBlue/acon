# council

**Trigger:** `/council` · "Convene advisors" · "Debate this decision"

## Purpose

Structured, read-only advice on a high-stakes decision. Advisors develop independent,
evidence-grounded positions; the Control Plane preserves agreement and dissent; the
Captain decides. Council output never authorizes implementation.

## Structure

| Advisor | Perspective |
|---------|------------|
| `pragmatist` | Recommend a proportionate path, its principal trade-off and a credible runner-up. |
| `skeptic` | Test assumptions and identify grounded risks, missing evidence and what would change the position. |
| `idealist` | Assess whether the proposal coherently meets its stated outcomes and dependencies, without expanding the ask. |

These are perspectives, not required named personas or fixed assignments. Each advisor
must reason independently and ground claims in cited artifacts or explicitly mark them
UNPROVEN. Do not expose prior pitches before the independent first round.

## Steps

1. The Control Plane confirms the required delegation, isolated-context, communication
   and terminal-completion capabilities using the [canonical capability contract](../crew/README.md#capability-discovery).
   Run independent pitches concurrently only when supported; otherwise use sequential,
   isolated advisor contexts only when supported. If required capability is unavailable
   or unknown, stop as BLOCKED; do not substitute the writer/lead context or presume
   delivery. Assign the decision under debate and a perspective, not a mandated voice
   topology.
2. Each advisor returns the report below. A receipt or `ACKNOWLEDGED` state is not a
   completed report. `COMPLETED` requires the full fields and artifact references;
   disagreement is not failure. A blocked advisor reports `BLOCKED` and why.
3. At most one cross-examination turn per advisor is permitted, capped at **≤500 tokens
   per advisor**. Advisors may then update their own position and must record whether it
   changed and the evidence that changed it. Cross-examination does not replace an
   independent first-round pitch.
4. The Control Plane synthesizes attributed consensus, dissent and rejected positions,
   with evidence and reasons; preserves changed/minority positions and unresolved
   unknowns; and records a recommendation and Captain-decision reference. Empty
   `captain_decision_ref` means pending. Do not collapse disagreement into consensus.
5. Present the bounded synthesis to the Captain as a Bearings item under "Captain's Call"
   when action is required. Only the Captain decides. A report, agreement or lead
   synthesis is advisory; any implementation requires separate authorization and the
   applicable workflow and G7/G8/G9 review.

## Advisor report fields

| Field | Required meaning |
|---|---|
| `advisor` | Identifies the advisor/context for attribution. |
| `position` | Clear recommendation or conclusion with its principal trade-off and credible runner-up where applicable. |
| `evidence` | Claims with artifact and locator; explicitly mark unsupported claims UNPROVEN. |
| `falsifier` | Concrete observation that would change the position; never an empty placeholder. |
| `changed` | Boolean indicating whether the position changed after cross-examination. |
| `evidence_that_changed_position` | Nonempty evidence when `changed: true`; empty when false. |
| `concerns` | At most three distinct, grounded concerns; do not manufacture concerns when the proposal is sound. |
| `state` | Exactly `[ACKNOWLEDGED, COMPLETED, BLOCKED]`. Acknowledgment means receipt only; COMPLETED requires all fields and referenced artifacts. |

## Synthesis fields

| Field | Required meaning |
|---|---|
| `consensus` | Shared conclusions, each attributed to advisors and evidence. |
| `dissent` | Minority or conflicting positions, attributed with evidence; retain changed positions. |
| `rejected_positions` | Rejected positions, named advisors, evidence and an explicit reason for rejection. |
| `recommendation` | Control Plane's advisory recommendation, rationale and material trade-off; not a decision. |
| `captain_decision_ref` | Captain decision reference, or empty while pending; never infer authorization from silence. |

## Guard rails

- Advisors are read-only; no file edits, dispatch authority, or implementation during council.
- Preserve existing requirements and decision authority. Do not invent blockers or turn
  uncertainty into a verdict; identify what evidence would resolve it.
- Keep findings proportional to the ask. Closed findings stay closed unless a distinct,
  named regression is evidenced. A blocking concern must enforce an existing invariant,
  not create a new requirement.
- The installed harness owns communication, isolation and completion delivery; this
  workflow assumes no transport, automatic wake, polling, or concurrency guarantee.

**Origin:** Adapted from Fleet `references/communication-contract.md` and
`references/fleet-coordination-patterns.md` at revision
`0af843fa2c92413ea16c50e50bd8a9e24f1d1995`; digest concepts retain attribution to
disler/cmux. See the [local provenance and MIT notice](../crew/README.md#provenance-and-mit-notice).

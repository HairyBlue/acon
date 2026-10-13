# implement-then-review

**Trigger:** "Implement this, then review it" · "Build and review" · "Worker then reviewer"

## Purpose

Standard ship-quality loop. Catches regressions, missed edge cases, and unnecessary
complexity before the diff is presented to the Captain. Generic review is advisory;
it cannot replace mandatory G7, G8 or G9.

## Steps

1. **Control Plane** assigns **Worker** the bounded task contract and verified execution capability.

2. **Worker** implements within scope, runs the required verification, and reports the diff and evidence.

3. **Control Plane** runs G7 deliverable audit on the returned work. G7 must pass before review; a failure returns only scoped findings to the assigned Worker.

4. A separate **Reviewer** may perform a generic focus review using the objective, current diff and verification evidence. Its `PASS` or `PASS_WITH_NOTES` is advisory only; `FAIL` findings go to the assigned Worker as a bounded fix list.

5. After any correction, affected assertion evidence is invalidated and re-established, then G7 is rerun. No earlier review approves the changed diff.

6. Once G7 passes on the final state, conduct mandatory G8 code review and G9 security review in separate read-only reviewer contexts. Both applicable schema-based reviews must pass on that same final diff; a generic reviewer result cannot satisfy either gate. Missing required delegation, completion evidence or independent review isolation is `BLOCKED`.

7. Present the reviewed result and any advisory notes to the Captain. Neither a review result nor this workflow authorizes implementation outside the task or git mutation.

## Concurrency note

Worker and generic Reviewer may run sequentially. A reviewer must inspect the current diff. Do not assume concurrency or reuse a writer context as an independent reviewer; use separate sequential isolated review contexts when supported, otherwise report `BLOCKED`.

## Provenance

Adapted from `skills/orchestration-verification/SKILL.md` and informed by `docs/PHILOSOPHY.md` at `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`; see the local [MIT notice](../crew/README.md#provenance-and-mit-notice).

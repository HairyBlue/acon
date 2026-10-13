# review-loop

**Trigger:** "Review loop, max N rounds" · "Keep reviewing until clean"

## Purpose

Iterative advisory review with bounded corrections. A generic Reviewer verdict is not
terminal acceptance: G7 must pass before mandatory G8 code review and G9 security review.

## Steps

1. **Control Plane** sets `MAX_ROUNDS` (default: 3). Tracks `round = 1`.

2. A separate **Reviewer** inspects the current diff and reports findings. Generic review is advisory and does not replace G7, G8 or G9.

3. If verdict is `FAIL` and `round < MAX_ROUNDS`, the assigned **Worker** receives findings as a scoped fix list, applies only those fixes, reruns verification and reports the changed diff. Increment `round` and return to step 2.

4. Every correction invalidates affected assertion evidence. Re-establish affected proof and rerun G7 against the corrected final state; stale or unknown proof is not success.

5. After G7 passes, require G8 and G9 reviews of the same final diff in separate read-only reviewer contexts. A generic `PASS` or `PASS_WITH_NOTES` is not a substitute. Missing required review isolation or completion evidence is `BLOCKED`.

6. If a generic review remains `FAIL` at `MAX_ROUNDS`, or a mandatory gate rejects at its existing limit, escalate outstanding findings to the Captain. Do not loop further without Captain direction. Present only after the required gates pass.

## Guard rails

- Each Worker fix pass is delegated to the assigned writer and scoped strictly to reported issues; reviewers do not edit.
- No new features or refactors during fix passes.
- The round cap is a hard stop — not a suggestion. A correction never inherits approval for the prior diff.

## Provenance

Adapted from `skills/orchestration-verification/SKILL.md` and informed by `docs/PHILOSOPHY.md` at `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`; see the local [MIT notice](../crew/README.md#provenance-and-mit-notice).

# review-loop

**Trigger:** "Review loop, max N rounds" · "Keep reviewing until clean"

## Purpose

Iterative quality gate. Runs Reviewer → Worker (fixes) → Reviewer until the verdict
is `PASS` or the round cap is hit.

## Steps

1. **Control Plane** sets `MAX_ROUNDS` (default: 3). Tracks `round = 1`.

2. **Reviewer** reviews the current state of the files. Reports findings.

3. If verdict is `PASS` or `PASS_WITH_NOTES` → done. Present to Captain.

4. If verdict is `FAIL` and `round < MAX_ROUNDS`:
   - **Worker** receives Reviewer's findings as an explicit fix list.
   - Worker applies fixes, re-runs `Verify`, reports.
   - `round++` → go to step 2.

5. If `round == MAX_ROUNDS` and still `FAIL`:
   - Control Plane escalates to Captain with the outstanding findings list.
   - Do not loop further without Captain direction.

## Guard rails

- Each Worker fix pass is scoped strictly to the Reviewer's reported issues.
- No new features or refactors during fix passes.
- Round cap is a hard stop — not a suggestion.

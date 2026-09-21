# implement-then-review

**Trigger:** "Implement this, then review it" · "Build and review" · "Worker then reviewer"

## Purpose

Standard ship-quality loop. Catches regressions, missed edge cases, and unnecessary
complexity before the diff is presented to the Captain.

## Steps

1. **Control Plane** dispatches **Worker** with the task contract.

2. **Worker** implements, runs `Verify`, reports diff.

3. **Control Plane** dispatches **Reviewer** with:
   - The original task objective (what it was supposed to do)
   - The Worker's diff output
   - The same `Verify` command

4. **Reviewer** reports findings with severity ratings.

5. **Control Plane** evaluates:
   - `PASS` → present to Captain.
   - `PASS_WITH_NOTES` → present with notes, Captain decides.
   - `FAIL` → dispatch Worker again with Reviewer's findings as a fix list.

## Concurrency note

Worker and Reviewer run sequentially. Reviewer must see the final diff, not a
speculative one.

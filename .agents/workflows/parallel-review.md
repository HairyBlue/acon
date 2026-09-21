# parallel-review

**Trigger:** "Parallel reviewers for X, Y, Z" · "Run reviewers concurrently"

## Purpose

Faster, deeper review by splitting focus axes across independent Reviewers running
simultaneously. Each Reviewer has a single axis — no overlap.

## Standard Axes

Assign one axis per Reviewer. Mix and match as needed:

| Axis | Reviewer focus |
|------|---------------|
| `correctness` | Logic errors, wrong conditions, bad edge cases |
| `tests` | Coverage gaps, missing edge cases, weak assertions |
| `complexity` | Over-engineering, unnecessary abstractions, dead code |
| `security` | Injection, secret leakage, unvalidated input |
| `spec` | Does the implementation match the stated objective? |
| `performance` | Obvious bottlenecks, N+1 queries, unnecessary allocations |

## Steps

1. **Control Plane** defines the axes (2–4 recommended, max 5).

2. **Control Plane** dispatches all Reviewers concurrently, each briefed with:
   - The diff or file scope
   - Their single assigned axis
   - The `Verify` command

3. **Control Plane** collects all reports and deduplicates overlapping findings
   (same file + same issue reported by multiple reviewers → merge into one).

4. Findings are ranked by severity across all axes. Present to Captain or route
   to `review-loop` if `FAIL` findings exist.

## File isolation

Reviewers may read the same files — that is fine. They must never write to the
same file concurrently.

# parallel-review

**Trigger:** "Parallel reviewers for X, Y, Z" · "Run reviewers concurrently"

## Purpose

Focused generic reviews can split axes across independent reviewers, but concurrency is
optional and depends on demonstrated harness capability. These advisory reviews never
replace G7, mandatory G8 code review or G9 security review.

## Standard Axes

Assign one axis per Reviewer. Mix and match as needed:

| Axis | Reviewer focus |
|------|---------------|
| `correctness` | Logic errors, wrong conditions, bad edge cases |
| `tests` | Coverage gaps, missing edge cases, weak assertions |
| `complexity` | Over-engineering, unnecessary abstractions, dead code |
| `security` | Injection, secret leakage, unvalidated input |
| `spec` | Does the implementation match the stated objective? |
| `performance` | Potential bottlenecks; measured claims require named artifacts |

## Steps

1. **Control Plane** defines the axes (2–4 recommended, max 5), task boundary and current diff.

2. If concurrent isolated review is available, dispatch focused reviewers with the diff, their single axis and relevant verification evidence. Otherwise use separate sequential isolated reviewer contexts if supported. Do not reuse the writer context; if neither mode is supported, report `BLOCKED`.

3. Collect terminal reports and deduplicate overlapping findings. A generic `PASS` or `PASS_WITH_NOTES` is advisory only; findings requiring correction go to the assigned Worker, never to a reviewer for direct edits.

4. After any correction, invalidate affected assertion proof, re-establish it and rerun G7 on the corrected state. Then G8 and G9 must independently review the final diff in separate read-only contexts. Focus-axis reviews do not substitute for either mandatory gate.

5. Present only after required G7/G8/G9 results are complete; unresolved findings escalate within existing bounded review limits.

## File isolation

Reviewers may read the same files. Writers remain exclusively assigned; reviewers are read-only. Do not presume concurrent execution, automatic delivery or polling. Missing required delegation, isolation or terminal completion evidence is `BLOCKED`.

## Provenance

Adapted from `skills/orchestration-verification/SKILL.md` and informed by `docs/PHILOSOPHY.md` at `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`; see the local [MIT notice](../crew/README.md#provenance-and-mit-notice).

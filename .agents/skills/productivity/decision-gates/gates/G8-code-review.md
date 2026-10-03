# G8 — Code Review Gate

## Trigger
Mandatory after every SHIP task, before commit proposal.

## Input
Worker diff, plan/spec, coding standards.

## Evaluator
Code Reviewer (`crew/code-reviewer.md`)

## Output
`review-report.yaml` with `reviewer_type: CODE`

## Outcome Table
- **PASS**: Proceed to G9.
- **FAIL (<3 cycles)**: Route findings to writer.
- **FAIL (>=3 cycles)**: ESCALATE (5-Element).

## Config
- `reviewer_model`: inherit
- `max_cycles`: 3
- Log `CORRELATED_REVIEW` if models match.

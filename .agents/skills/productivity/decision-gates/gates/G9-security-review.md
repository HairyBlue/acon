# G9 — Security Review Gate

## Trigger
Mandatory after G8 PASS, before commit proposal.

## Input
Worker diff, plan/spec, security standards.

## Evaluator
Security Reviewer (`crew/security-reviewer.md`)

## Output
`review-report.yaml` with `reviewer_type: SECURITY`

## Outcome Table
- **PASS**: Bearings digest.
- **FAIL (CRITICAL/HIGH)**: Route to writer.
- **FAIL (MEDIUM/LOW)**: WARN in Bearings, proceed.
- **FAIL (>=3 cycles)**: ESCALATE.

## Config
- `reviewer_model`: inherit
- `max_cycles`: 3
- Scope is proportional.

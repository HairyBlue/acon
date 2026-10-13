# G8 — Code Review Gate

## Trigger
Mandatory after every SHIP task, before commit proposal.

## Input
Worker diff, plan/spec, coding standards, and current TaskContract `requirements`/`parity` plus ShipDiff `assertion_evidence` and relevant verification results. Check every dispatched requirement revision and the full applicable parity inventory, not selected examples; distinguish observed behavior from unproven runtime claims. The review report records actual reviewer/writer choice identities (`reviewer_choice_ref`, `writer_choice_ref`), current `authorization_ref`, `availability_checked_at` and separate `context_ref` using the readable [ReviewReport specification](../../../../reference/schemas/review-report.md). The specification and report do not prove independence.

## Evaluator
Code Reviewer (`crew/code-reviewer.md`)

## Output
A review report with `reviewer_type: CODE` conforming to the readable [ReviewReport specification](../../../../reference/schemas/review-report.md)

## Outcome Table
- **PASS**: Proceed to G9.
- **FAIL (<3 cycles)**: Route findings to writer.
- **FAIL (>=3 cycles)**: ESCALATE (5-Element).

## Config
- Reviewer selection: propose an available Captain-permitted choice and supported effort for this role, including REVIEWER, and obtain Captain approval before launch. Record actual identities and report `CORRELATED_REVIEW` when evidence shows a shared underlying model.
- Before review, verify available delegation, isolated contexts, review isolation, read-only review, supervision, communication and terminal completion delivery as required by the portable-fleet capability contract. Unknown or unavailable required capability, identity, authorization, availability evidence or reviewer context is `BLOCKED`, never PASS. Do not reuse the writer context or substitute weaker review; follow `.agents/reference/crew/README.md` for unsupported modes and authorized-role routing.
- `max_cycles`: 3
- Review judgment and report fields: [`code-reviewer.md`](../../../../reference/crew/code-reviewer.md) and the readable [`review-report.md`](../../../../reference/schemas/review-report.md). The adapted reviewer source is `agents/code-reviewer.md` at revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`; see [local provenance and MIT notice](../../../../reference/crew/README.md#provenance-and-mit-notice).

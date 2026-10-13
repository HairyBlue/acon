# G9 — Security Review Gate

## Trigger
Mandatory after G8 PASS, before commit proposal.

## Input
Worker diff, plan/spec, security standards, and current TaskContract `requirements`/`parity` plus ShipDiff `assertion_evidence` and relevant verification results. Review trust boundaries and every applicable dispatched requirement revision and parity member, distinguishing evidenced exploit paths from hypotheses and unproven runtime claims. The review report records actual reviewer/writer choice identities (`reviewer_choice_ref`, `writer_choice_ref`), current `authorization_ref`, `availability_checked_at` and separate `context_ref` using `.agents/reference/schemas/review-report.md`. The schema and report do not prove independence; require a separate read-only reviewer context from the writer and verify distinct context evidence.

## Evaluator
Security Reviewer (`crew/security-reviewer.md`)

## Output
`review-report.md` with `reviewer_type: SECURITY`

## Outcome Table
- **PASS**: Bearings digest.
- **FAIL (CRITICAL/HIGH)**: Route to writer.
- **FAIL (MEDIUM/LOW)**: WARN in Bearings, proceed.
- **FAIL (>=3 cycles)**: ESCALATE.

## Config
- Reviewer selection: `INHERIT`, the current Captain-authorized choice; it is not assumed to match the writer. Record actual identities and report `CORRELATED_REVIEW` when evidence shows a shared underlying model.
- Before review, verify available delegation, isolated contexts, review isolation, read-only review, supervision, communication and terminal completion delivery as required by the portable-fleet capability contract. Unknown or unavailable required capability, identity, authorization, availability evidence or reviewer context is `BLOCKED`, never PASS. Do not reuse the writer context or substitute weaker review; follow `.agents/reference/crew/README.md` for unsupported modes and authorized-role routing.
- `max_cycles`: 3
- Scope is proportional. Review judgment and report fields: [`security-reviewer.md`](../../../../reference/crew/security-reviewer.md) and [`review-report.md`](../../../../reference/schemas/review-report.md). The adapted reviewer source is `agents/security-auditor.md` at revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`; see [local provenance and MIT notice](../../../../reference/crew/README.md#provenance-and-mit-notice).

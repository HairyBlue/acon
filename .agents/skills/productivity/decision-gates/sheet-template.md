# Decision Sheet Template & Self-Lint Checklist

This reference provides the blank template, filled examples, and mandatory 7-point self-lint checklist for generating and validating **Decision Sheets** under the ACON Decision Gates protocol.

---

## 1. Blank JSON Decision Sheet Template

```json
{
  "gate": "<gate-id>",
  "evaluator": "<scout|worker|reviewer|oracle|evidence-auditor|control-plane>",
  "stateRef": "<verifiable reference, title, or hash of the evaluated state>",
  "answers": {
    "<question-id-1>": {
      "p": 0.0,
      "evidence": "<verbatim quote <= 120 chars, or NONE if p <= 0.2>"
    },
    "<question-id-2>": {
      "choice": "<OPTION_ID>",
      "p": {
        "<OPTION_A>": 0.7,
        "<OPTION_B>": 0.3
      },
      "evidence": "<verbatim quote <= 120 chars>"
    },
    "<question-id-3>": {
      "score": 0,
      "evidence": "<verbatim quote <= 120 chars>"
    }
  }
}
```

---

## 2. Filled Concrete Examples

### Example 1: `plan-first` (G2) — Triggered Architecture Gate
Evaluating a mission proposing an event-driven webhook intake pipeline:

```json
{
  "gate": "plan-first",
  "evaluator": "control-plane",
  "stateRef": "Mission Intake: Stripe webhook listener and ledger debit integration",
  "answers": {
    "newSystemFromScratch": {
      "p": 0.2,
      "evidence": "NONE"
    },
    "largeRefactorOrMigration": {
      "p": 0.1,
      "evidence": "NONE"
    },
    "schemaChange": {
      "p": 0.9,
      "evidence": "create table webhook_events (id uuid primary key, payload jsonb, status text)"
    },
    "coreBusinessLogic": {
      "p": 0.8,
      "evidence": "debits customer balance immediately upon signature verification"
    },
    "highAmbiguityTradeoffs": {
      "p": 0.2,
      "evidence": "NONE"
    },
    "designOrStylingOnly": {
      "p": 0.0,
      "evidence": "NONE"
    },
    "mechanicalRefactor": {
      "p": 0.0,
      "evidence": "NONE"
    },
    "obviousSinglePath": {
      "p": 0.2,
      "evidence": "NONE"
    }
  }
}
```
*Outcome lookup:* `schemaChange p=0.9 >= 0.6` matches Priority 2 `TRIGGER_REQUIRED` $\rightarrow$ Outcome: `REQUIRED` (status: `OK`).

---

### Example 2: `task-shape` (G3) — Choice Question with Probability Distribution
Evaluating a component refactor task:

```json
{
  "gate": "task-shape",
  "evaluator": "control-plane",
  "stateRef": "Task brief: Refactor order summary table styling using Tailwind",
  "answers": {
    "shape": {
      "choice": "SHIP",
      "p": {
        "SHIP": 0.9,
        "SCOUT": 0.1
      },
      "evidence": "update OrderSummary.tsx with dark mode classes and verify layout in browser"
    },
    "tier": {
      "choice": "TIER_2",
      "p": {
        "TIER_1": 0.1,
        "TIER_2": 0.8,
        "TIER_3": 0.1
      },
      "evidence": "plan-exempt single-agent UI styling task scoped strictly to OrderSummary.tsx"
    }
  }
}
```
*Outcome lookup:* Both choices meet `minTop: 0.6` $\rightarrow$ Outcome: `shape: SHIP`, `tier: TIER_2` (status: `OK`).

---

### Example 3: `deliverable-audit` (G7) — Universal Post-Flight Diff Verification
Evaluating a completed worker git diff:

```json
{
  "gate": "deliverable-audit",
  "evaluator": "reviewer",
  "stateRef": "Worker PR diff #14: implement HMAC verification for incoming webhooks",
  "answers": {
    "scopeCreep": {
      "p": 0.1,
      "evidence": "NONE"
    },
    "unauthorizedDeps": {
      "p": 0.0,
      "evidence": "NONE"
    },
    "ponytailViolation": {
      "p": 0.1,
      "evidence": "NONE"
    },
    "testsSufficient": {
      "p": 0.9,
      "evidence": "12 passed in tests/Feature/WebhookHmacTest.php, 100% assertion pass rate"
    }
  }
}
```
*Outcome lookup:* Matches Priority 4 `VERIFICATION_PASSED` $\rightarrow$ Outcome: `APPROVE` (status: `OK`).

---

## 3. The 7-Point Mandatory Self-Lint Checklist

Before any Decision Sheet is evaluated against a gate's Outcome Rules, the evaluator (or reviewing agent) must audit the sheet against this 7-point checklist:

1. **Declared Completeness:**
   Every question declared in the gate file must be answered exactly once, in the declared sequence. No declared question may be omitted, and no extraneous keys may exist in the `answers` map.
2. **Coarse Discrete Granularity:**
   Every probability value $p$ must be a coarse multiple of `0.1` between `0.0` and `1.0` inclusive (i.e. `0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0`). Continuous floats (e.g. `0.85`, `0.733`) are forbidden.
3. **Normalized Distributions (Choice Questions):**
   For `choice` questions:
   - The `p` map must cover exactly all declared options in the gate specification.
   - The sum of probabilities across all options must equal `1.0` (a margin of $\pm 0.1$ is tolerated for rounding).
   - The declared `choice` key must match the option with the strictly highest probability. A tie for the top probability is unresolved and forces status `UNCERTAIN`.
4. **Valid Level Indices (Score Questions):**
   For `score` questions:
   - The score must be an integer index matching a declared level (0-indexed, where 0 represents the lowest level).
   - Negative numbers or floats are invalid.
5. **Grounded Verbatim Evidence ($\le 120$ characters):**
   - Every `choice` answer and every `score` answer must include a non-empty `evidence` string.
   - Every `boolean` answer with $p \ge 0.3$ must include a non-empty `evidence` string.
   - The `evidence` string must be an exact verbatim substring from the input state, with maximum length of 120 characters.
   - The `"NONE"` literal is permitted strictly for booleans where $p \le 0.2$.
6. **Citation Re-Verification Check:**
   - The evaluator must re-read the input state and verify that each quoted `evidence` string appears literally in the source text (case-insensitive, whitespace-normalized).
   - If an evidence quote cannot be verified in the input state, that answer is marked **UNVERIFIED**.
   - An unverified answer can never support a relaxing outcome (`SKIP`, `NOT_REQUIRED`, `ELIGIBLE`, `APPROVE`). Any outcome rule depending on an unverified answer immediately yields status `UNCERTAIN`.
7. **Controlled Enums & Verbatim Identifiers:**
   - Any specialist persona, modular skill ID, or style preset cited in answers (such as in G5 `skill-route`) must exist verbatim in `.agents/INDEX.md` or the native crew manifest.
   - Invented, hallucinated, or misspelled IDs immediately invalidate the sheet.

---

## 4. Lint Failure Recovery Protocol

- **Single Repair Attempt:** If a Decision Sheet fails self-lint (e.g., missing evidence quote, unnormalized probabilities, invalid enum ID), the evaluator is permitted **one** immediate repair pass to re-read the state and correct the sheet.
- **Fail-Closed Default:** If a sheet fails self-lint a second time, the sheet is marked **`INVALID`**. An `INVALID` sheet is handled as **`UNCERTAIN`**, forcing the gate's safest conservative default and escalating to the Command Bridge.

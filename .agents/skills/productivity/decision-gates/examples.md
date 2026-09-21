# Worked Examples: ACON Decision Gates Protocol (`examples.md`)

This document provides **28 fully worked reference cases** (exactly 4 cases per gate across all 7 gates) illustrating the execution of the ACON Decision Gates protocol. Every case demonstrates:
1. The verbatim input **State** received by the evaluator.
2. The schema-locked JSON **Decision Sheet** conforming to `.agents/reference/schemas/decision-sheet.yaml`.
3. The **Self-Lint & Citation Verification Audit** against the 7-point checklist in `sheet-template.md`.
4. The exact standardized **Result Block** derived from the gate's Outcome Rules table.

---

## Table of Contents
- [Gate G1: `grill-trigger` (Phase I Alignment)](#gate-g1-grill-trigger)
- [Gate G2: `plan-first` (Phase II Architecture Gate)](#gate-g2-plan-first)
- [Gate G3: `task-shape` (Phase II Dispatch Classification)](#gate-g3-task-shape)
- [Gate G4: `anti-slop` (Phase II Pre-Flight Audit)](#gate-g4-anti-slop)
- [Gate G5: `skill-route` (Pre-Flight Specialist Routing)](#gate-g5-skill-route)
- [Gate G6: `bearings-triage` (Fleet Governance Status Triage)](#gate-g6-bearings-triage)
- [Gate G7: `deliverable-audit` (Phase IV Post-Flight Verification)](#gate-g7-deliverable-audit)

---

## Gate G1: `grill-trigger`

Evaluates objective clarity and architectural forks in Phase I to determine whether to trigger upfront `grill-me` alignment (~30s Captain calibration).

### Case G1-1: Crisp Objective with Established Direction (Autonomous Skip)

**State:**
```text
Add a health check endpoint at GET /health returning JSON { status: "ok", timestamp: ISOString }. Use the existing Express router in src/routes/index.ts and verify with supertest.
```

**Decision Sheet:**
```json
{
  "gate": "grill-trigger",
  "evaluator": "control-plane",
  "stateRef": "GET /health endpoint request",
  "answers": {
    "unresolvedFork": {
      "p": 0.1,
      "evidence": "NONE"
    },
    "ambiguousIntent": {
      "p": 0.1,
      "evidence": "NONE"
    },
    "missingCriticalConstraint": {
      "p": 0.1,
      "evidence": "NONE"
    }
  }
}
```

**Self-Lint & Verification Note:**
- All 3 questions answered in sequence. Probabilities are valid tenths $\le 0.2$ with permitted `"NONE"`.
- Outcome lookup matches Priority 4 `TRIGGERS_CLEAR` (all triggers $p \le 0.3$).

**Expected Result Block:**
```
GATE RESULT
gate: grill-trigger | mode: advisory | status: OK | sheets: 1
askCaptain: SKIP | relaxing: yes | binding: no | notes: all triggers p<=0.1, intent crisp and bounded
```

---

### Case G1-2: Architectural Fork Requiring Captain Decision (Ask Triggered)

**State:**
```text
Refactor session persistence. We can either migrate to a distributed Redis cluster or use a PostgreSQL JSONB session table with row-level locks. Choose whichever works best and ship it.
```

**Decision Sheet:**
```json
{
  "gate": "grill-trigger",
  "evaluator": "control-plane",
  "stateRef": "Session persistence refactor directive",
  "answers": {
    "unresolvedFork": {
      "p": 0.9,
      "evidence": "either migrate to a distributed Redis cluster or use a PostgreSQL JSONB session table"
    },
    "ambiguousIntent": {
      "p": 0.2,
      "evidence": "NONE"
    },
    "missingCriticalConstraint": {
      "p": 0.3,
      "evidence": "Choose whichever works best"
    }
  }
}
```

**Self-Lint & Verification Note:**
- Verbatim citation for `unresolvedFork` verified in state. Citation for `missingCriticalConstraint` verified in state.
- Outcome lookup matches Priority 2 `TRIGGER_REQUIRED` (`unresolvedFork p=0.9 >= 0.6`).

**Expected Result Block:**
```
GATE RESULT
gate: grill-trigger | mode: advisory | status: OK | sheets: 1
askCaptain: ASK | relaxing: no | binding: no | notes: unresolvedFork p=0.9 >= 0.6 (Redis vs Postgres fork)
```

---

### Case G1-3: Boundary Ambiguity Case ($p=0.4$ Uncertain - Safe Default Ask)

**State:**
```text
Integrate an external weather forecasting provider for delivery routing. Cache responses if practical and handle network errors appropriately.
```

**Decision Sheet:**
```json
{
  "gate": "grill-trigger",
  "evaluator": "control-plane",
  "stateRef": "Weather provider integration request",
  "answers": {
    "unresolvedFork": {
      "p": 0.2,
      "evidence": "NONE"
    },
    "ambiguousIntent": {
      "p": 0.4,
      "evidence": "Cache responses if practical"
    },
    "missingCriticalConstraint": {
      "p": 0.4,
      "evidence": "Integrate an external weather forecasting provider"
    }
  }
}
```

**Self-Lint & Verification Note:**
- Verbatim quotes $\le 120$ characters verified in state text.
- Neither trigger reaches `0.6`, but both match `uncertainAt: 0.4`. Matches Priority 3 `TRIGGER_UNCERTAIN`.

**Expected Result Block:**
```
GATE RESULT
gate: grill-trigger | mode: advisory | status: UNCERTAIN | sheets: 1
askCaptain: ASK | relaxing: no | binding: no | notes: ambiguousIntent p=0.4 in uncertain range [0.4..0.5]; safe default halts for Captain alignment
```

---

### Case G1-4: Mechanical Check Hit (Empty State)

**State:**
```text
   
```

**Decision Sheet:**
*(Sheet generation bypassed due to mechanical pre-check failure)*

**Self-Lint & Verification Note:**
- Input state is whitespace-only. Triggers mechanical check `EMPTY_STATE`.

**Expected Result Block:**
```
GATE RESULT
gate: grill-trigger | mode: advisory | status: OK | sheets: 0
askCaptain: ASK | relaxing: no | binding: no | notes: mechanical check EMPTY_STATE forced ASK
```

---

## Gate G2: `plan-first`

Evaluates architectural risk, database migrations, and systemic ambiguity under §4 Rule 10 to mandate a formal plan in `docs/plans/`.

### Case G2-1: Mechanical Command Trigger (`/plan` Explicit Directive)

**State:**
```text
Objective: /plan Implement idempotency key middleware for payment ledger transactions using Postgres unique index.
```

**Decision Sheet:**
```json
{
  "gate": "plan-first",
  "evaluator": "control-plane",
  "stateRef": "/plan payment idempotency directive",
  "answers": {
    "newSystemFromScratch": {
      "p": 0.2,
      "evidence": "NONE"
    },
    "largeRefactorOrMigration": {
      "p": 0.2,
      "evidence": "NONE"
    },
    "schemaChange": {
      "p": 0.8,
      "evidence": "Postgres unique index"
    },
    "coreBusinessLogic": {
      "p": 0.8,
      "evidence": "payment ledger transactions"
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

**Self-Lint & Verification Note:**
- State contains literal `/plan`. Mechanical check `EXPLICIT_PLAN_COMMAND` triggered.
- Triggers Priority 1 `MECHANICAL_HIT`.

**Expected Result Block:**
```
GATE RESULT
gate: plan-first | mode: advisory | status: OK | sheets: 1
planRequired: REQUIRED | relaxing: no | binding: no | notes: mechanical check EXPLICIT_PLAN_COMMAND hit (/plan in state)
```

---

### Case G2-2: Dominant Architectural Trigger (Database Schema Change)

**State:**
```text
Create new partitioned table order_ledger_entries in PostgreSQL with composite primary key (tenant_id, entry_id) and foreign key to accounts.
```

**Decision Sheet:**
```json
{
  "gate": "plan-first",
  "evaluator": "control-plane",
  "stateRef": "Partitioned order ledger table creation",
  "answers": {
    "newSystemFromScratch": {
      "p": 0.3,
      "evidence": "Create new partitioned table"
    },
    "largeRefactorOrMigration": {
      "p": 0.3,
      "evidence": "order_ledger_entries in PostgreSQL"
    },
    "schemaChange": {
      "p": 0.9,
      "evidence": "Create new partitioned table order_ledger_entries in PostgreSQL with composite primary key"
    },
    "coreBusinessLogic": {
      "p": 0.8,
      "evidence": "order_ledger_entries"
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

**Self-Lint & Verification Note:**
- Verbatim evidence verified in state text. All 8 questions answered in declared order.
- Priority 2 `TRIGGER_DOMINANT` matches (`schemaChange p=0.9 >= 0.6`).

**Expected Result Block:**
```
GATE RESULT
gate: plan-first | mode: advisory | status: OK | sheets: 1
planRequired: REQUIRED | relaxing: no | binding: no | notes: trigger schemaChange p=0.9 >= 0.6 dominant
```

---

### Case G2-3: Exemption Defeating Borderline Trigger (Visual Styling Exemption)

**State:**
```text
Update admin layout: change navbar border color to border-slate-700 and adjust padding across 14 component templates. May touch markup structure slightly.
```

**Decision Sheet:**
```json
{
  "gate": "plan-first",
  "evaluator": "control-plane",
  "stateRef": "Admin navbar styling update",
  "answers": {
    "newSystemFromScratch": {
      "p": 0.0,
      "evidence": "NONE"
    },
    "largeRefactorOrMigration": {
      "p": 0.4,
      "evidence": "adjust padding across 14 component templates. May touch markup structure slightly"
    },
    "schemaChange": {
      "p": 0.0,
      "evidence": "NONE"
    },
    "coreBusinessLogic": {
      "p": 0.0,
      "evidence": "NONE"
    },
    "highAmbiguityTradeoffs": {
      "p": 0.1,
      "evidence": "NONE"
    },
    "designOrStylingOnly": {
      "p": 0.9,
      "evidence": "change navbar border color to border-slate-700 and adjust padding"
    },
    "mechanicalRefactor": {
      "p": 0.8,
      "evidence": "across 14 component templates"
    },
    "obviousSinglePath": {
      "p": 0.8,
      "evidence": "Update admin layout"
    }
  }
}
```

**Self-Lint & Verification Note:**
- Verbatim quotes verified in state.
- Trigger `largeRefactorOrMigration p=0.4` is in borderline range ($[0.4..0.5]$).
- Exemption `designOrStylingOnly p=0.9 >= 0.7` is verified and overrides the borderline trigger per Priority 3 `BORDERLINE_EXEMPT`.

**Expected Result Block:**
```
GATE RESULT
gate: plan-first | mode: advisory | status: OK | sheets: 1
planRequired: NOT_REQUIRED | relaxing: yes | binding: no | notes: borderline trigger p=0.4 defeated by verified designOrStylingOnly p=0.9 >= 0.7
```

---

### Case G2-4: Citation Invalidation Case (Hallucinated Evidence Quote)

**State:**
```text
Add in-memory rate-limiter middleware using standard express-rate-limit configuration with 100 req/min threshold.
```

**Decision Sheet:**
```json
{
  "gate": "plan-first",
  "evaluator": "control-plane",
  "stateRef": "Express rate-limiter setup",
  "answers": {
    "newSystemFromScratch": {
      "p": 0.1,
      "evidence": "NONE"
    },
    "largeRefactorOrMigration": {
      "p": 0.1,
      "evidence": "NONE"
    },
    "schemaChange": {
      "p": 0.5,
      "evidence": "creates rate_limit_buckets database table"
    },
    "coreBusinessLogic": {
      "p": 0.3,
      "evidence": "rate-limiter middleware"
    },
    "highAmbiguityTradeoffs": {
      "p": 0.1,
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
      "p": 0.8,
      "evidence": "standard express-rate-limit configuration"
    }
  }
}
```

**Self-Lint & Verification Note:**
- **LINT AUDIT FAILURE (Rule 6):** The quote `"creates rate_limit_buckets database table"` does NOT exist anywhere in the input state.
- `schemaChange` is marked **UNVERIFIED**. An unverified answer cannot be trusted, forcing status `UNCERTAIN`.

**Expected Result Block:**
```
GATE RESULT
gate: plan-first | mode: advisory | status: UNCERTAIN | sheets: 1
planRequired: REQUIRED | relaxing: no | binding: no | notes: citation verification failed for schemaChange quote; safe default forces REQUIRED
```

---

## Gate G3: `task-shape`

Classifies task deliverable nature (`SHIP` vs `SCOUT`) and dispatch calibration tier (`TIER_1`, `TIER_2`, `TIER_3`).

### Case G3-1: Clear Single-Agent Bounded Implementation (SHIP Tier 2)

**State:**
```text
Task: Implement HMAC verification for incoming webhooks in src/auth/hmac.ts and author unit tests in test/auth/hmac.test.ts. Compile and run npm test.
```

**Decision Sheet:**
```json
{
  "gate": "task-shape",
  "evaluator": "control-plane",
  "stateRef": "HMAC webhook implementation task",
  "answers": {
    "shape": {
      "choice": "SHIP",
      "p": {
        "SHIP": 0.9,
        "SCOUT": 0.1
      },
      "evidence": "Implement HMAC verification for incoming webhooks in src/auth/hmac.ts"
    },
    "tier": {
      "choice": "TIER_2",
      "p": {
        "TIER_1": 0.2,
        "TIER_2": 0.7,
        "TIER_3": 0.1
      },
      "evidence": "author unit tests in test/auth/hmac.test.ts. Compile and run npm test"
    }
  }
}
```

**Self-Lint & Verification Note:**
- Probabilities sum to 1.0. Citations verified in state.
- Both choices meet `minTop: 0.6`. Matches Priority 2 `CLEAR_SHAPE` and `CLEAR_TIER`.

**Expected Result Block:**
```
GATE RESULT
gate: task-shape | mode: advisory | status: OK | sheets: 1
shape: SHIP | tier: TIER_2 | relaxing: yes | binding: no | notes: shape SHIP p=0.9 >= 0.6; tier TIER_2 p=0.7 >= 0.6
```

---

### Case G3-2: Architectural Multi-Worker Mission (SHIP Tier 1)

**State:**
```text
Task: Migrate ORM from Sequelize to Prisma across users, products, and checkout modules using concurrent specialist workers and git worktrees.
```

**Decision Sheet:**
```json
{
  "gate": "task-shape",
  "evaluator": "control-plane",
  "stateRef": "Sequelize to Prisma ORM migration",
  "answers": {
    "shape": {
      "choice": "SHIP",
      "p": {
        "SHIP": 0.9,
        "SCOUT": 0.1
      },
      "evidence": "Migrate ORM from Sequelize to Prisma across users, products, and checkout"
    },
    "tier": {
      "choice": "TIER_1",
      "p": {
        "TIER_1": 0.9,
        "TIER_2": 0.1,
        "TIER_3": 0.0
      },
      "evidence": "using concurrent specialist workers and git worktrees"
    }
  }
}
```

**Self-Lint & Verification Note:**
- Probabilities normalized. Citations verified in state.
- Matches Priority 2 `CLEAR_SHAPE` (`SHIP`) and Priority 2 `CLEAR_TIER` (`TIER_1`).

**Expected Result Block:**
```
GATE RESULT
gate: task-shape | mode: advisory | status: OK | sheets: 1
shape: SHIP | tier: TIER_1 | relaxing: no | binding: no | notes: architectural multi-worker mission mandates Tier 1 full calibration
```

---

### Case G3-3: Read-Only Trivial Inspection (SCOUT Tier 3)

**State:**
```text
Task: Read package.json to verify the exact pinned version of Tailwind CSS and inspect tailwind.config.js plugins array. Read-only lookup.
```

**Decision Sheet:**
```json
{
  "gate": "task-shape",
  "evaluator": "control-plane",
  "stateRef": "Tailwind version inspection",
  "answers": {
    "shape": {
      "choice": "SCOUT",
      "p": {
        "SHIP": 0.0,
        "SCOUT": 1.0
      },
      "evidence": "Read-only lookup"
    },
    "tier": {
      "choice": "TIER_3",
      "p": {
        "TIER_1": 0.0,
        "TIER_2": 0.1,
        "TIER_3": 0.9
      },
      "evidence": "Read package.json to verify the exact pinned version of Tailwind CSS"
    }
  }
}
```

**Self-Lint & Verification Note:**
- Citations verified in state text. Probabilities normalized to 1.0.
- Matches Priority 2 `CLEAR_SHAPE` (`SCOUT`) and Priority 2 `CLEAR_TIER` (`TIER_3`).

**Expected Result Block:**
```
GATE RESULT
gate: task-shape | mode: advisory | status: OK | sheets: 1
shape: SCOUT | tier: TIER_3 | relaxing: no | binding: no | notes: trivial read-only lookup routes to lightweight Tier 3 Scout dispatch
```

---

### Case G3-4: Borderline Tie Case ($p=0.5$ Uncertainty - Safe Defaults)

**State:**
```text
Task: Investigate flaky checkout integration test in CI. Inspect runner logs, reproduce locally if possible, and either submit a fix or write a diagnostic report.
```

**Decision Sheet:**
```json
{
  "gate": "task-shape",
  "evaluator": "control-plane",
  "stateRef": "Flaky test investigation and potential fix",
  "answers": {
    "shape": {
      "choice": "SCOUT",
      "p": {
        "SHIP": 0.5,
        "SCOUT": 0.5
      },
      "evidence": "either submit a fix or write a diagnostic report"
    },
    "tier": {
      "choice": "TIER_2",
      "p": {
        "TIER_1": 0.3,
        "TIER_2": 0.5,
        "TIER_3": 0.2
      },
      "evidence": "Investigate flaky checkout integration test in CI"
    }
  }
}
```

**Self-Lint & Verification Note:**
- `shape` is tied at 0.5/0.5 (fails `minTop: 0.6`). Triggers Priority 3 `UNCERTAIN_SHAPE`.
- `tier` top choice `TIER_2` is 0.5 (fails `minTop: 0.6`). Triggers Priority 3 `UNCERTAIN_TIER`.
- Both safe defaults adopted (`shape: SCOUT`, `tier: TIER_1`).

**Expected Result Block:**
```
GATE RESULT
gate: task-shape | mode: advisory | status: UNCERTAIN | sheets: 1
shape: SCOUT | tier: TIER_1 | relaxing: no | binding: no | notes: shape tie (0.5/0.5) and tier top p=0.5 < 0.6; safe defaults force SCOUT and TIER_1
```

---

## Gate G4: `anti-slop`

Pre-flight audit enforcing the 8 Anti-Slop Properties ($\le 3$ files, automated closed loop, domain separation, repro-first bug fixes) before worker dispatch.

### Case G4-1: Clean Passing Brief (ELIGIBLE)

**State:**
```text
### Task Brief: T2 SHIP (worker)
Objective: Implement JWT claim validation in src/auth/validator.ts.
Scope: src/auth/validator.ts and test/auth/validator.test.ts. No external files.
Deliverable: Verified code passing npm test -- test/auth/validator.test.ts with exit code 0.
Verification: Automated vitest suite exercising valid, expired, and tampered token signatures.
```

**Decision Sheet:**
```json
{
  "gate": "anti-slop",
  "evaluator": "scout",
  "stateRef": "T2 JWT validator brief",
  "answers": {
    "hasAutomatedVerification": {
      "p": 0.9,
      "evidence": "npm test -- test/auth/validator.test.ts with exit code 0"
    },
    "isBoundedScope": {
      "p": 0.9,
      "evidence": "Scope: src/auth/validator.ts and test/auth/validator.test.ts. No external files"
    },
    "touchesHumanCoreDomain": {
      "p": 0.1,
      "evidence": "NONE"
    },
    "isBugFix": {
      "p": 0.1,
      "evidence": "NONE"
    },
    "briefHasReproTestFirst": {
      "p": 0.0,
      "evidence": "NONE"
    },
    "needsNewTests": {
      "p": 0.8,
      "evidence": "Automated vitest suite exercising valid, expired, and tampered token signatures"
    },
    "briefSpecifiesTests": {
      "p": 0.9,
      "evidence": "exercising valid, expired, and tampered token signatures"
    }
  }
}
```

**Self-Lint & Verification Note:**
- File count is 2 ($\le 3$). Mandatory headers present.
- `touchesHumanCoreDomain` expect false ($u = 0.1 \le 0.3 \rightarrow$ PASS).
- `briefSpecifiesTests` active because `needsNewTests >= 0.5` ($u = 0.1 \le 0.3 \rightarrow$ PASS).
- Matches Priority 4 `CHECKLIST_PASS`.

**Expected Result Block:**
```
GATE RESULT
gate: anti-slop | mode: advisory | status: OK | sheets: 1
eligibility: ELIGIBLE | relaxing: yes | binding: no | notes: all 8 Anti-Slop checklist properties satisfied
```

---

### Case G4-2: Mechanical Check Hit (File Count Exceeded - BLOCKED)

**State:**
```text
### Task Brief
Objective: Refactor component hierarchy.
Scope: src/A.tsx, src/B.tsx, src/C.tsx, src/D.tsx, and test/A.test.tsx.
Deliverable: Working components.
```

**Decision Sheet:**
*(Sheet evaluation bypassed due to mechanical check failure)*

**Self-Lint & Verification Note:**
- Target file list contains 5 files, violating the Anti-Gobble $\le 3$ files rule.
- Mechanical check `FILE_COUNT_EXCEEDED` triggered immediately.

**Expected Result Block:**
```
GATE RESULT
gate: anti-slop | mode: advisory | status: OK | sheets: 0
eligibility: BLOCKED | relaxing: no | binding: no | notes: mechanical check FILE_COUNT_EXCEEDED hit (5 files > 3 max limit)
```

---

### Case G4-3: Missing Reproduction Test on Defect Ticket (BLOCKED)

**State:**
```text
### Task Brief: Bug Fix
Objective: Fix null pointer exception in customer invoice generation when billing address is omitted.
Scope: src/billing/invoice.ts.
Deliverable: Edit invoice.ts directly to add optional chaining on billing address. Run full regression suite.
```

**Decision Sheet:**
```json
{
  "gate": "anti-slop",
  "evaluator": "scout",
  "stateRef": "Invoice null pointer bug fix brief",
  "answers": {
    "hasAutomatedVerification": {
      "p": 0.8,
      "evidence": "Run full regression suite"
    },
    "isBoundedScope": {
      "p": 0.8,
      "evidence": "Scope: src/billing/invoice.ts"
    },
    "touchesHumanCoreDomain": {
      "p": 0.2,
      "evidence": "NONE"
    },
    "isBugFix": {
      "p": 0.9,
      "evidence": "Fix null pointer exception in customer invoice generation"
    },
    "briefHasReproTestFirst": {
      "p": 0.1,
      "evidence": "NONE"
    },
    "needsNewTests": {
      "p": 0.2,
      "evidence": "NONE"
    },
    "briefSpecifiesTests": {
      "p": 0.2,
      "evidence": "NONE"
    }
  }
}
```

**Self-Lint & Verification Note:**
- `isBugFix p=0.9 >= 0.5` activates `briefHasReproTestFirst`.
- Unexpected probability $u = 1.0 - 0.1 = 0.9 \ge 0.6 \rightarrow$ **FAILS**.
- Matches Priority 2 `CHECKLIST_FAIL`.

**Expected Result Block:**
```
GATE RESULT
gate: anti-slop | mode: advisory | status: OK | sheets: 1
eligibility: BLOCKED | relaxing: no | binding: no | notes: failed briefHasReproTestFirst (u=0.9); bug fixes require reproduction test before mutating production code
```

---

### Case G4-4: Human-Core Domain Hit (`[HUMAN-CORE / AI-TEST]` Partition)

**State:**
```text
### Task Brief
Objective: Implement core RSA-4096 private key derivation and ECDSA signature generator in src/crypto/keys.ts.
Scope: src/crypto/keys.ts.
Deliverable: Working cryptography library.
```

**Decision Sheet:**
```json
{
  "gate": "anti-slop",
  "evaluator": "scout",
  "stateRef": "RSA key derivation task brief",
  "answers": {
    "hasAutomatedVerification": {
      "p": 0.7,
      "evidence": "Working cryptography library"
    },
    "isBoundedScope": {
      "p": 0.8,
      "evidence": "Scope: src/crypto/keys.ts"
    },
    "touchesHumanCoreDomain": {
      "p": 0.9,
      "evidence": "Implement core RSA-4096 private key derivation and ECDSA signature generator"
    },
    "isBugFix": {
      "p": 0.1,
      "evidence": "NONE"
    },
    "briefHasReproTestFirst": {
      "p": 0.0,
      "evidence": "NONE"
    },
    "needsNewTests": {
      "p": 0.8,
      "evidence": "Working cryptography library"
    },
    "briefSpecifiesTests": {
      "p": 0.3,
      "evidence": "Working cryptography library"
    }
  }
}
```

**Self-Lint & Verification Note:**
- `touchesHumanCoreDomain` expects false. Unexpected probability $u = p = 0.9 \ge 0.6 \rightarrow$ **FAILS**.
- Matches Priority 2 `CHECKLIST_FAIL`.

**Expected Result Block:**
```
GATE RESULT
gate: anti-slop | mode: advisory | status: OK | sheets: 1
eligibility: BLOCKED | relaxing: no | binding: no | notes: touchesHumanCoreDomain u=0.9 failed; AI prohibited from authoring core crypto algorithms; partition to [HUMAN-CORE / AI-TEST]
```

---

## Gate G5: `skill-route`

Deterministically routes tasks to specialist personas and modular skills from `.agents/INDEX.md`.

### Case G5-1: Clear Backend Specialist Routing

**State:**
```text
Task: Author test-driven customer refund service in src/billing/refund.ts handling partial refunds, ledger balance checks, and Stripe gateway mocks.
```

**Decision Sheet:**
```json
{
  "gate": "skill-route",
  "evaluator": "control-plane",
  "stateRef": "Customer refund service task",
  "answers": {
    "agent": {
      "choice": "worker",
      "p": {
        "worker": 0.9,
        "scout": 0.05,
        "reviewer": 0.05,
        "oracle": 0.0,
        "evidence-auditor": 0.0
      },
      "evidence": "Author test-driven customer refund service in src/billing/refund.ts"
    },
    "primarySkill": {
      "choice": "tdd",
      "p": {
        "tdd": 0.8,
        "domain-modeling": 0.1,
        "NONE": 0.1
      },
      "evidence": "Author test-driven customer refund service"
    },
    "secondarySkill": {
      "choice": "domain-modeling",
      "p": {
        "domain-modeling": 0.7,
        "NONE": 0.3
      },
      "evidence": "handling partial refunds, ledger balance checks"
    },
    "stylePreset": {
      "choice": "NONE",
      "p": {
        "NONE": 1.0
      },
      "evidence": "backend service with no frontend UI components"
    }
  }
}
```

**Self-Lint & Verification Note:**
- All skill IDs exist verbatim in `.agents/INDEX.md`.
- All choices meet `minTop: 0.5`. Auto-appends `ponytail` by constitutional rule.

**Expected Result Block:**
```
GATE RESULT
gate: skill-route | mode: advisory | status: OK | sheets: 1
agent: worker | primarySkill: tdd | secondarySkill: domain-modeling | stylePreset: NONE | notes: ponytail automatically appended to worker brief
```

---

### Case G5-2: Frontend UI Specialist with Bento Style Preset

**State:**
```text
Task: Build marketing pricing grid component in React with Tailwind CSS adhering to Bento layout styling and subtle borders.
```

**Decision Sheet:**
```json
{
  "gate": "skill-route",
  "evaluator": "control-plane",
  "stateRef": "Marketing pricing grid component",
  "answers": {
    "agent": {
      "choice": "worker",
      "p": {
        "worker": 0.9,
        "scout": 0.1,
        "reviewer": 0.0,
        "oracle": 0.0,
        "evidence-auditor": 0.0
      },
      "evidence": "Build marketing pricing grid component in React"
    },
    "primarySkill": {
      "choice": "interface-design",
      "p": {
        "interface-design": 0.7,
        "impeccable": 0.2,
        "NONE": 0.1
      },
      "evidence": "marketing pricing grid component in React with Tailwind CSS"
    },
    "secondarySkill": {
      "choice": "impeccable",
      "p": {
        "impeccable": 0.6,
        "NONE": 0.4
      },
      "evidence": "subtle borders"
    },
    "stylePreset": {
      "choice": "bento",
      "p": {
        "bento": 0.8,
        "minimal": 0.2,
        "NONE": 0.0
      },
      "evidence": "adhering to Bento layout styling"
    }
  }
}
```

**Self-Lint & Verification Note:**
- Preset `bento` exists verbatim in `.agents/skills/design/styles/`.
- All choices meet `minTop: 0.5`.

**Expected Result Block:**
```
GATE RESULT
gate: skill-route | mode: advisory | status: OK | sheets: 1
agent: worker | primarySkill: interface-design | secondarySkill: impeccable | stylePreset: bento | notes: ponytail automatically appended to worker brief
```

---

### Case G5-3: Invented Skill ID Failing Self-Lint (INVALID Sheet)

**State:**
```text
Task: Optimize database connection pool settings and add connection health heartbeat.
```

**Decision Sheet:**
```json
{
  "gate": "skill-route",
  "evaluator": "control-plane",
  "stateRef": "Database connection pool optimization",
  "answers": {
    "agent": {
      "choice": "worker",
      "p": {
        "worker": 0.8,
        "scout": 0.2,
        "reviewer": 0.0,
        "oracle": 0.0,
        "evidence-auditor": 0.0
      },
      "evidence": "Optimize database connection pool settings"
    },
    "primarySkill": {
      "choice": "hyper-postgres-tuner-v2",
      "p": {
        "hyper-postgres-tuner-v2": 0.9,
        "NONE": 0.1
      },
      "evidence": "Optimize database connection pool settings"
    },
    "secondarySkill": {
      "choice": "NONE",
      "p": {
        "NONE": 1.0
      },
      "evidence": "NONE"
    },
    "stylePreset": {
      "choice": "NONE",
      "p": {
        "NONE": 1.0
      },
      "evidence": "NONE"
    }
  }
}
```

**Self-Lint & Verification Note:**
- **LINT AUDIT FAILURE (Rule 7):** Skill ID `hyper-postgres-tuner-v2` does not exist in `.agents/INDEX.md`.
- Evaluator repair attempt fails to resolve valid catalog ID. Sheet marked `INVALID`.

**Expected Result Block:**
```
GATE RESULT
gate: skill-route | mode: advisory | status: INVALID | sheets: 1
agent: scout | primarySkill: NONE | secondarySkill: NONE | stylePreset: NONE | notes: sheet INVALID due to invented skill ID hyper-postgres-tuner-v2; safe fallback to scout
```

---

### Case G5-4: Ambiguous Task Routing Fallback (UNCERTAIN)

**State:**
```text
Task: Look into the application performance. Maybe write some tests, or benchmark API endpoints, or suggest architecture cleanup.
```

**Decision Sheet:**
```json
{
  "gate": "skill-route",
  "evaluator": "control-plane",
  "stateRef": "Ambiguous application performance task",
  "answers": {
    "agent": {
      "choice": "worker",
      "p": {
        "worker": 0.35,
        "scout": 0.35,
        "reviewer": 0.3,
        "oracle": 0.0,
        "evidence-auditor": 0.0
      },
      "evidence": "Look into the application performance"
    },
    "primarySkill": {
      "choice": "tdd",
      "p": {
        "tdd": 0.3,
        "refactoring": 0.3,
        "diagnosing-bugs": 0.3,
        "NONE": 0.1
      },
      "evidence": "Maybe write some tests, or benchmark API endpoints"
    },
    "secondarySkill": {
      "choice": "NONE",
      "p": {
        "NONE": 1.0
      },
      "evidence": "NONE"
    },
    "stylePreset": {
      "choice": "NONE",
      "p": {
        "NONE": 1.0
      },
      "evidence": "NONE"
    }
  }
}
```

**Self-Lint & Verification Note:**
- Top agent probability is 0.35 ($< 0.5$ threshold). Tied between `worker` and `scout`.
- Triggers Priority 3 `UNCERTAIN_CHOICE`.

**Expected Result Block:**
```
GATE RESULT
gate: skill-route | mode: advisory | status: UNCERTAIN | sheets: 1
agent: scout | primarySkill: diagnosing-bugs | secondarySkill: NONE | stylePreset: NONE | notes: agent and skill top p<0.5; suggested top agents: [scout, worker, reviewer]; suggested skills: [diagnosing-bugs, tdd, refactoring]
```

---

## Gate G6: `bearings-triage`

Triages operational status events, blockers, and completions into the 4 Bearings sections or Section 1 (`CAPTAINS_CALL`).

### Case G6-1: Mechanical Escalation (Destructive Command Attempt)

**State:**
```text
Worker subagent 8c96f419 requested execution of git reset --hard origin/master to discard uncommitted working tree changes.
```

**Decision Sheet:**
*(Sheet generation bypassed due to mechanical check failure)*

**Self-Lint & Verification Note:**
- State literally contains `git reset --hard`.
- Mechanical check `DESTRUCTIVE_COMMAND` triggered immediately.

**Expected Result Block:**
```
GATE RESULT
gate: bearings-triage | mode: advisory | status: OK | sheets: 0
captainsCall: CAPTAINS_CALL | severity: CRITICAL | relaxing: no | binding: no | notes: mechanical check DESTRUCTIVE_COMMAND triggered (git reset --hard in state)
```

---

### Case G6-2: High-Severity Blocker Halting Fleet

**State:**
```text
Database migration failed with relation users_pkey already exists. Downstream workers T3 and T4 are blocked and cannot proceed.
```

**Decision Sheet:**
```json
{
  "gate": "bearings-triage",
  "evaluator": "control-plane",
  "stateRef": "Users table migration deadlock report",
  "answers": {
    "needsCaptainAction": {
      "p": 0.4,
      "evidence": "Downstream workers T3 and T4 are blocked and cannot proceed"
    },
    "blocksOtherWork": {
      "p": 0.9,
      "evidence": "Downstream workers T3 and T4 are blocked and cannot proceed"
    },
    "severity": {
      "score": 2,
      "evidence": "Database migration failed with relation users_pkey already exists"
    }
  }
}
```

**Self-Lint & Verification Note:**
- Citations verified in state. Score index 2 corresponds to `HIGH`.
- `blocksOtherWork p=0.9 >= 0.6` matches Priority 3 `BLOCKER_DOMINANT`.

**Expected Result Block:**
```
GATE RESULT
gate: bearings-triage | mode: advisory | status: OK | sheets: 1
captainsCall: CAPTAINS_CALL | severity: HIGH | relaxing: no | binding: no | notes: blocksOtherWork p=0.9 >= 0.6 halts downstream workers T3 and T4
```

---

### Case G6-3: Routine Landed Task Completion

**State:**
```text
Task T4 complete: Authored G1, G2, G3 gate definitions in .agents/skills/productivity/decision-gates/gates/. All 7 mandated sections verified.
```

**Decision Sheet:**
```json
{
  "gate": "bearings-triage",
  "evaluator": "control-plane",
  "stateRef": "Task T4 completion notice",
  "answers": {
    "needsCaptainAction": {
      "p": 0.1,
      "evidence": "NONE"
    },
    "blocksOtherWork": {
      "p": 0.0,
      "evidence": "NONE"
    },
    "severity": {
      "score": 0,
      "evidence": "Task T4 complete: Authored G1, G2, G3 gate definitions"
    }
  }
}
```

**Self-Lint & Verification Note:**
- Both trigger probabilities $p < 0.3$. Score index 0 matches `LOW`.
- Matches Priority 5 `ROUTINE_DIGEST`.

**Expected Result Block:**
```
GATE RESULT
gate: bearings-triage | mode: advisory | status: OK | sheets: 1
captainsCall: OTHER_SECTION | severity: LOW | relaxing: yes | binding: no | notes: routine task completion triaged to Section 2 (Recently Landed)
```

---

### Case G6-4: Informational Operational Progress (Underway)

**State:**
```text
Worker subagent 7a50c062 is actively authoring G5-skill-route.md in isolated worktree. 2 of 4 files completed.
```

**Decision Sheet:**
```json
{
  "gate": "bearings-triage",
  "evaluator": "control-plane",
  "stateRef": "Worker 7a50c062 progress ping",
  "answers": {
    "needsCaptainAction": {
      "p": 0.0,
      "evidence": "NONE"
    },
    "blocksOtherWork": {
      "p": 0.1,
      "evidence": "NONE"
    },
    "severity": {
      "score": 0,
      "evidence": "Worker subagent 7a50c062 is actively authoring G5-skill-route.md"
    }
  }
}
```

**Self-Lint & Verification Note:**
- All triggers $< 0.3$. Matches Priority 5 `ROUTINE_DIGEST`.
- Categorized into Section 3 (`Underway`).

**Expected Result Block:**
```
GATE RESULT
gate: bearings-triage | mode: advisory | status: OK | sheets: 1
captainsCall: OTHER_SECTION | severity: LOW | relaxing: yes | binding: no | notes: live progress triaged to Section 3 (Underway)
```

---

## Gate G7: `deliverable-audit`

Post-flight universal verification auditing worker git diffs against Ponytail simplicity, scope bounds, and test coverage before Phase IV synthesis.

### Case G7-1: Clean Compliant Diff (APPROVE)

**State:**
```text
Diff: Modifies src/utils/slug.ts (+12 -2) and test/utils/slug.test.ts (+28 -0). Strictly implements lowercase alphanumeric slugifier.
Test Output: PASS test/utils/slug.test.ts (8 tests, 100% passed, exit code 0).
Linter Output: Clean (0 errors, 0 warnings).
```

**Decision Sheet:**
```json
{
  "gate": "deliverable-audit",
  "evaluator": "reviewer",
  "stateRef": "Worker slugifier diff and test run",
  "answers": {
    "scopeCreep": {
      "p": 0.0,
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
      "evidence": "PASS test/utils/slug.test.ts (8 tests, 100% passed, exit code 0)"
    }
  }
}
```

**Self-Lint & Verification Note:**
- Zero scope creep, zero unauthorized dependencies. Tests pass with exit code 0.
- Matches Priority 4 `VERIFICATION_PASSED` (`scopeCreep <= 0.1`, `unauthorizedDeps <= 0.1`, `ponytailViolation <= 0.2`, `testsSufficient >= 0.7`).

**Expected Result Block:**
```
GATE RESULT
gate: deliverable-audit | mode: advisory | status: OK | sheets: 1
deliverableStatus: APPROVE | relaxing: yes | binding: no | notes: universal verification passed; deliverable approved for Central Synthesis
```

---

### Case G7-2: Mechanical Check Failure (Non-Zero Test Exit Code)

**State:**
```text
Diff: Modifies src/api/users.ts (+14 -4).
Test Output: FAIL test/api/users.test.ts: Expected status code 200, received 500 (1 failed, 7 passed). Command exited with code 1.
```

**Decision Sheet:**
*(Sheet evaluation bypassed due to mechanical check failure)*

**Self-Lint & Verification Note:**
- Automated test suite exited with code 1.
- Mechanical check `NON_ZERO_EXIT_CODE` triggered immediately.

**Expected Result Block:**
```
GATE RESULT
gate: deliverable-audit | mode: advisory | status: OK | sheets: 0
deliverableStatus: REJECT_RETRY | relaxing: no | binding: no | notes: mechanical check NON_ZERO_EXIT_CODE hit (test runner exit code 1)
```

---

### Case G7-3: Scope Creep & Boundary Violation (REJECT_RETRY)

**State:**
```text
Contract Boundary: Scoped strictly to src/components/Button.tsx.
Diff: Modifies src/components/Button.tsx, src/components/Input.tsx, and global styles/theme.css (+140 -20), adding custom CSS variables and refactoring input fields.
Test Output: All tests passed (exit code 0).
```

**Decision Sheet:**
```json
{
  "gate": "deliverable-audit",
  "evaluator": "reviewer",
  "stateRef": "Button styling diff with scope leak",
  "answers": {
    "scopeCreep": {
      "p": 0.9,
      "evidence": "Modifies src/components/Button.tsx, src/components/Input.tsx, and global styles/theme.css"
    },
    "unauthorizedDeps": {
      "p": 0.0,
      "evidence": "NONE"
    },
    "ponytailViolation": {
      "p": 0.6,
      "evidence": "adding custom CSS variables and refactoring input fields"
    },
    "testsSufficient": {
      "p": 0.7,
      "evidence": "All tests passed (exit code 0)"
    }
  }
}
```

**Self-Lint & Verification Note:**
- Modifies files outside assigned scope boundary (`src/components/Input.tsx`, `styles/theme.css`).
- Triggers mechanical check `OUT_OF_BOUNDS_FILES` and Priority 2 `VERIFICATION_DEFECT` (`scopeCreep p=0.9 >= 0.4`).

**Expected Result Block:**
```
GATE RESULT
gate: deliverable-audit | mode: advisory | status: OK | sheets: 1
deliverableStatus: REJECT_RETRY | relaxing: no | binding: no | notes: out of bounds file modification and scopeCreep p=0.9 >= 0.4; rejected for retry
```

---

### Case G7-4: Borderline Quality Requiring Captain Escalation (ESCALATE_CAPTAIN)

**State:**
```text
Contract: Optimize database query in src/repo/order.ts.
Diff: Modifies src/repo/order.ts to replace ORM query with raw SQL query using string concatenation for table prefix. Unit tests pass (exit code 0).
Worker Note: String concatenation safe because table prefix is internal constant, but flags lint warning.
```

**Decision Sheet:**
```json
{
  "gate": "deliverable-audit",
  "evaluator": "reviewer",
  "stateRef": "Raw SQL query optimization diff",
  "answers": {
    "scopeCreep": {
      "p": 0.2,
      "evidence": "replace ORM query with raw SQL query"
    },
    "unauthorizedDeps": {
      "p": 0.0,
      "evidence": "NONE"
    },
    "ponytailViolation": {
      "p": 0.4,
      "evidence": "using string concatenation for table prefix"
    },
    "testsSufficient": {
      "p": 0.6,
      "evidence": "Unit tests pass (exit code 0)"
    }
  }
}
```

**Self-Lint & Verification Note:**
- `scopeCreep p=0.2` in borderline $[0.2..0.3]$.
- `ponytailViolation p=0.4` in borderline $[0.3..0.4]$.
- `testsSufficient p=0.6` in borderline $[0.5..0.6]$.
- Matches Priority 3 `BORDERLINE_UNCERTAIN`.

**Expected Result Block:**
```
GATE RESULT
gate: deliverable-audit | mode: advisory | status: UNCERTAIN | sheets: 1
deliverableStatus: ESCALATE_CAPTAIN | relaxing: no | binding: no | notes: borderline ponytailViolation p=0.4 and testsSufficient p=0.6; escalate raw SQL trade-off to Captain's Call
```

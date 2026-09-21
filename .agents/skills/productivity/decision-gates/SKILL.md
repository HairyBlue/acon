---
name: decision-gates
description: Machine-native decision protocol and verification gates for ACON agent fleets (the Jev concept, no code). Enforces typed probability sheets, deterministic outcome lookup tables, dual-blind redundancy, and empirical calibration logging.
metadata:
  version: "1.0.0"
  category: productivity
---

# Decision Gates Protocol (`decision-gates`)

> **Firstmate Architectural Standard:** *"Talk to one agent. Ship with a crew."*  
> **The Machine Contract Standard:** *"Typed decisions over prose deliberation. Lookup tables over improvisational debate."*  
> **The Governance Invariant:** *"Tighten-only. Advisory by default. Zero code."*

`decision-gates` is the machine-native decision and verification protocol for the **ACON** (Agentic Conventions & Orchestration Network) agent fleet. Borrowing the core theoretical concept of **Jev (TypeSafe)**—without introducing external software, code, packages, or APIs—it transforms high-ambiguity LLM deliberation into structured, typed probability sheets resolved through deterministic lookup tables.

---

## 1. Operating Philosophy & Core Invariants

### 1.1 Machine-Native Intelligence vs. Conversational Deliberation
Traditional multi-agent frameworks rely heavily on conversational prose: agents deliberate in chat, debate interpretations, and negotiate boundaries in open-ended text. This introduces three systemic failure modes:
1. **Sycophancy & Mode Dropping:** RLHF-tuned language models default to agreeable, verbose prose that masks technical ambiguity and downplays edge cases.
2. **Improvisational Drift:** LLMs make arbitrary scope and architectural decisions dynamically when faced with uncertainty, bypassing human intent.
3. **Unverifiable Rationale:** Conversational arguments cannot be audited, benchmarked, or calibrated across multiple missions.

`decision-gates` establishes **Machine-Native Intelligence**:
- **State In, Typed Answers Out:** An evaluator (the Control Plane or a specialist Scout) receives a bounded input state and answers a fixed sequence of independent questions.
- **Typed Primitives Only:** Every answer is strictly a `boolean` (probability $p \in [0.0..1.0]$), a `choice` (closed enum set with distribution), or a `score` (ordered discrete level index). Conversational prose is forbidden.
- **Ordered Lookup Tables (No Improvisation):** The evaluator maps typed answers to outcomes using an ordered, first-match-wins lookup table with coarse tenth thresholds.
- **Automate the Clear, Escalate the Uncertain:** High-certainty conditions execute autonomously. Borderline or ambiguous conditions route immediately to the Captain (`CAPTAINS_CALL`), `grill-me`, or an advisory `oracle`.

### 1.2 The Five Core Invariants

1. **Zero Code Invariant (Pure Markdown Protocol):**  
   Only the theoretical concept of Jev is borrowed. Every gate, sheet, and log is pure markdown or YAML schema (`.agents/schemas/decision-sheet.yaml`). Do not add Python, Node, shell scripts, SDKs, external APIs, or network calls. Nothing in this protocol is ever "called" or "run" as executable software.
2. **Tighten-Only Invariant:**  
   Gate outcomes may only add governance rigor (mandating an implementation plan, raising dispatch tier, requiring scout reconnaissance, or escalating to the Captain). A gate outcome must **NEVER** drop or relax a requirement imposed by the constitution, compiler/test runner, or Captain.
3. **Advisory by Default (`Mode: advisory`):**  
   Every gate ships in `advisory` mode. Relaxing outcomes are strictly non-binding suggestions. Tightening outcomes guide the Control Plane but remain advisory until the Captain explicitly promotes a gate to `Mode: enforce` based on logged calibration data.
4. **Mechanical Verifiability & Count First:**  
   Mechanical checks (file counts, required keys, literal string matches) take precedence over probability estimation. If an evaluator cannot verify text literally or with absolute certainty, the result is `UNCERTAIN`.
5. **Exclusive Captain Authority Unbroken:**  
   Captain-only authority is inviolable: git commits, pushes, merges, branch deletions, destructive terminal commands (`git reset --hard`, `DROP TABLE`, `rm -rf`), new dependency installations, external credentials, and `[HUMAN-CORE]` domain algorithms remain exclusively under Captain command.

---

## 2. Fleet Lifecycle Gate Mapping

The protocol defines seven canonical decision gates distributed across the 4-phase ACON operational lifecycle:

```
[Captain Intake]
       │
  (Phase I: Alignment) ─────────► G1: grill-trigger (Clarifying questions needed?)
       │
  (Phase II: Task Shaping) ─────► G2: plan-first    (Formal docs/plans/ required?)
       │                    ├───► G3: task-shape    (SHIP vs SCOUT? Tier 1, 2, or 3?)
       │                    ├───► G4: anti-slop     (Task brief valid? Bounds <= 3 files?)
       │                    └───► G5: skill-route   (Specialist persona & modular skills?)
       ▼
  (Phase III: Crew Flight) ─────► Autonomous worker(s) in isolated .worktrees/
       │
  (Phase IV: Gatekeeping) ──────► G7: deliverable-audit (Diff clean? Ponytail compliant? Tests passed?)
       │
  (Fleet Bearings Digest) ──────► G6: bearings-triage  (Status triage to Captain's Call?)
```

| Gate ID | Name | Operating Phase | Evaluator Persona | Core Mandate |
| :--- | :--- | :--- | :--- | :--- |
| **G1** | `grill-trigger` | Phase I Alignment | Control Plane | Evaluates objective ambiguity and forks to trigger upfront `grill-me` alignment (~30s). |
| **G2** | `plan-first` | Phase II Shaping | Control Plane | Evaluates architectural risk (§4 Rule 10) to mandate plans in `docs/plans/`. |
| **G3** | `task-shape` | Phase II Shaping | Control Plane | Classifies execution shape (`SHIP` vs `SCOUT`) and pre-dispatch calibration tier (1, 2, 3). |
| **G4** | `anti-slop` | Phase II Pre-Flight | Codebase Scout | Pre-flight audit against the 8 Anti-Slop properties ($\le 3$ files, test specs, no overlap). |
| **G5** | `skill-route` | Phase II Pre-Flight | Control Plane | Selects specialist persona and modular skills from `.agents/INDEX.md`. |
| **G6** | `bearings-triage` | Fleet Governance | Control Plane | Triages events, errors, and blockers into Bearings digest sections or `CAPTAINS_CALL`. |
| **G7** | `deliverable-audit` | Phase IV Gatekeeping | Reviewer / Scout | Post-flight universal verification of worker git diffs against Ponytail, scope, and tests. |

---

## 3. How Evaluators Produce Decision Sheets

### 3.1 The Machine Contract (Zero Preamble & Token-0 Anchoring)
Evaluators must never emit conversational filler (*"Certainly!"*, *"Here is my assessment"*). The first emitted character must be the structural opening `{` of the JSON Decision Sheet.

All decision sheets conform strictly to `.agents/schemas/decision-sheet.yaml`:
```json
{
  "gate": "plan-first",
  "evaluator": "scout",
  "stateRef": "Phase II task decomposition for webhook ingest",
  "answers": {
    "schemaChange": { "p": 0.9, "evidence": "adds a new orders table" },
    "highAmbiguityTradeoffs": { "p": 0.1, "evidence": "NONE" },
    "shape": { "choice": "SHIP", "p": { "SHIP": 0.8, "SCOUT": 0.2 }, "evidence": "implement webhook handler" },
    "severity": { "score": 2, "evidence": "customers cannot check out" }
  }
}
```

### 3.2 Grounded Verbatim Citations
To eliminate hallucinated certainty without model retraining:
- **Verbatim Evidence Invariant:** For every `choice` and `score`, and for every `boolean` with $p \ge 0.3$, the evaluator must provide an exact verbatim substring ($\le 120$ characters) copied directly from the input state.
- **The `"NONE"` Exception:** `"NONE"` is permitted strictly for booleans where $p \le 0.2$.
- **Verification Rule:** During self-lint, the evaluator re-reads the input state. If a cited quote cannot be located literally (case/whitespace insensitive), that answer is marked **UNVERIFIED**. An unverified answer can never support a relaxing outcome, and any rule relying upon it forces status `UNCERTAIN`.

### 3.3 Evaluator Role Partitioning
- **Intake Gates (G1, G2, G3):** Evaluated directly on the Command Bridge by the Control Plane during mission intake and task decomposition.
- **Inspection Gates (G4, G7):** Evaluated by specialist subagents (`scout` or `reviewer`) to uphold the Control Plane Zero-Archaeology Mandate.
- **Redundant Dual Sheets:** Evaluated by two independent `scout` subagents dispatched in parallel.

---

## 4. Outcome Rule Recipes

Gate files declare ordered Outcome Rules evaluated top-to-bottom. The first rule whose condition matches determines the outcome. All numerical comparisons use coarse tenths (`0.0, 0.1 ... 1.0`).

### 4.1 ANY-TRIGGER
Used when any single high-probability risk factor mandates a tightening outcome (e.g., G1, G2).
- **Parameters:** Trigger questions array, `requiredAt` threshold (e.g. 0.6), `uncertainAt` threshold (e.g. 0.4), optional exemption questions array, `exemptAt` threshold (e.g. 0.7).
- **Evaluation Algorithm:**
  1. If any trigger $p \ge requiredAt$: outcome is **YES** (status `OK`). An exemption can never override this.
  2. Else if any trigger $p \ge uncertainAt$:
     - If a verified exemption question has $p \ge exemptAt$: outcome is **NO** (status `OK`).
     - Otherwise: status is **`UNCERTAIN`**, and the outcome resolves to the gate's declared `On Uncertain` safe default.
  3. Else: outcome is **NO** (status `OK`).

### 4.2 PICK-CHOICE
Used for categorical classifiers selecting among discrete options (e.g., G3, G5).
- **Parameters:** Choice question, declared options list, `minTop` confidence threshold (typically 0.5 or 0.6).
- **Evaluation Algorithm:**
  1. The evaluator selects the option with highest probability.
  2. If the winning option's $p \ge minTop$: outcome is the selected option (status `OK`).
  3. If there is a tie or the winning option's $p < minTop$: status is **`UNCERTAIN`**, and the outcome resolves to the declared `On Uncertain` default.

### 4.3 CHECKLIST
Used for multi-factor qualification gates (e.g., G4 `anti-slop`).
- **Parameters:** Checklist items with expected polarity (`expect: true` or `expect: false`), optional prerequisite conditions (e.g., `"if isBugFix >= 0.5"`).
- **Evaluation Algorithm:**
  1. For each active item, compute unexpected probability $u$:
     - For `expect: true`: $u = 1.0 - p$.
     - For `expect: false`: $u = p$.
  2. Evaluate item status:
     - $u \ge 0.6$: item **FAILS**.
     - $u \in [0.4..0.5]$: item **UNCERTAIN**.
     - $u \le 0.3$: item **PASSES**.
  3. Derive aggregate outcome:
     - If any item FAILS: outcome is **`BLOCKED`** (status `OK`, listing failed question IDs).
     - Else if any item is UNCERTAIN: status is **`UNCERTAIN`**, outcome is safe default (`BLOCKED`).
     - Else (all items pass): outcome is **`ELIGIBLE`** (status `OK`).

### 4.4 SCORE-ROUNDUP
Used for ordinal severity and complexity levels (e.g., G6 `bearings-triage`).
- **Parameters:** Score question, ordered discrete levels ($0, 1, 2, ... N$).
- **Evaluation Algorithm:**
  1. The outcome is the level corresponding to the score integer index.
  2. When reconciling two independent sheets, the **higher (tighter) level** is selected.

---

## 5. Result Block Specification

When a gate is evaluated, the Control Plane records a standardized Result Block:

```
GATE RESULT
gate: plan-first | mode: advisory | status: OK | sheets: 1
planRequired: REQUIRED | relaxing: no | binding: no | schemaChange p=0.9
```

### Field Definitions:
- **`gate`**: The gate ID (`grill-trigger`, `plan-first`, etc.).
- **`mode`**: `advisory` or `enforce`.
- **`status`**:
  - `OK`: Lookup table resolved cleanly.
  - `UNCERTAIN`: Probability fell into ambiguous threshold band, or dual sheets disagreed.
  - `INVALID`: Sheet failed self-lint validation and could not be repaired.
- **`relaxing`**: `yes` if the outcome loosens or bypasses a governance requirement (`NOT_REQUIRED`, `SKIP`, `ELIGIBLE`, `APPROVE`). Relaxing outcomes are **always advisory**.
- **`binding`**: `yes` strictly when `Mode: enforce` AND the outcome is tightening (`REQUIRED`, `ASK`, `BLOCKED`, `REJECT_RETRY`). A binding outcome legally obligates the Control Plane to execute the tightening action.
- **`sheets`**: Number of independent sheets evaluated (1 or 2).
- **Trailing rationale**: The specific trigger question and probability value that determined the outcome.

---

## 6. Redundancy via Dual-Scout Blind Dispatches

For high-stakes missions—specifically **Tier 1 multi-agent missions**, database schema mutations, and `[HUMAN-CORE]` domain tasks—the Control Plane employs **Dual-Blind Redundancy**:

1. **Parallel Dispatch:** The Control Plane launches two independent `scout` subagents (`Scout-A` and `Scout-B`).
2. **Context Isolation:** Each Scout receives the identical state and gate specification. Neither Scout sees the other's prompt, existence, or output.
3. **Independent Resolution:** Each Scout generates a self-linted Decision Sheet and derives an outcome.
4. **Reconciliation Protocol:**
   - For each rule, compare outcomes against the gate's declared `Tight Order`.
   - If both sheets yield the identical outcome: status is `OK`, outcome is confirmed.
   - If outcomes differ: the status is marked **`UNCERTAIN`**, the tighter outcome is adopted as the interim safe default, and the divergence is logged and escalated to the Captain or advisory `oracle`.

---

## 7. Decision Log & Empirical Calibration Review

All gate outcomes are recorded in `.agents/skills/productivity/decision-gates/log.md` to establish an empirical audit trail and prevent subjective drift.

### 7.1 Strict Append Invariant
The Decision Log is strictly updated by the mission's **Phase IV closing worker** in its isolated worktree during mission wrap-up. The Control Plane includes the mission's gate results and any Captain overrides in the handoff brief. Nothing else writes to the log.

### 7.2 Log Structure
```markdown
| Date | Mission | Gate | Rule | Outcome | Status | Mode | Crew Role | Captain Override | Disagreement Type |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 2026-09-20 | auth-jwt | plan-first | planRequired | REQUIRED | OK | advisory | control-plane | NONE | NONE |
```

### 7.3 Calibration Review Procedure
When the Captain requests an audit (*"review the gates"* or *"check calibration"*), the Control Plane dispatches a `scout` subagent to analyze `.agents/skills/productivity/decision-gates/log.md`:
1. **Sample Adequacy:** If a gate has $< 30$ logged entries, the Scout reports: `"Sample size too small for statistical calibration (<30 rows)."`
2. **Error Rate Computations:**
   - **Tightening Override Rate:** Percentage of tightening outcomes overridden by the Captain (indicating false alarms or over-conservatism).
   - **False-Relaxing Rate:** Percentage of relaxing outcomes where the Captain stepped in to mandate tighter governance (indicating dangerous permissiveness).
3. **Promotion Gate to `Mode: enforce`:**  
   The Captain may promote a gate from `Mode: advisory` to `Mode: enforce` in a reviewed commit only if:
   - Sample size $\ge 30$ logged missions.
   - Tightening override rate $\le 15\%$.
   - False-relaxing rate $\le 5\%$.

---

## 8. Authority Boundaries & Safety Invariants

1. **No Silent Upgrades:** A gate outcome can never authorize a git commit, push, merge, branch deletion, or destructive CLI execution.
2. **Deterministic Overrides Rule:** Compiler errors, linter failures, and test breakages (non-zero exit codes) unconditionally override any gate sheet, forcing `REJECT_RETRY`.
3. **Human-Core Invariant:** Work touching billing calculations, cryptography, or auth/authz policies must never be relaxed by a gate. If G4 detects `touchesHumanCoreDomain`, AI authoring is blocked and partitioned to `[HUMAN-CORE / AI-TEST]`.

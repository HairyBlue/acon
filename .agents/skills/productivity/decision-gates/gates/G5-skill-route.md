Mode: advisory

## State
The evaluator receives the calibrated task brief, objective statement, and deliverable scope.

## Mechanical Checks
| Check | Condition | Forced Status | Forced Outcome | Description |
| :--- | :--- | :--- | :--- | :--- |
| `EMPTY_STATE` | Input state is empty, whitespace-only, or missing | `OK` | `agent: scout`, `primarySkill: NONE`, `secondarySkill: NONE`, `stylePreset: NONE` | Missing brief context forces default read-only scout reconnaissance |

## Questions
| id | type | rubric |
| :--- | :--- | :--- |
| `agent` | `choice` | Closed options from the native fleet crew roster: <br>• `worker`: Implementation specialist. Modifies files, writes code, fixes bugs, and executes test suites. Assign high probability (`p >= 0.6`) when the task involves code/file editing.<br>• `scout`: Read-only investigator. Inspects codebase structure, traces data flows, evaluates dependencies, and generates dual-blind Decision Sheets. Assign high probability (`p >= 0.6`) for read-only archaeology or diagnostic spikes.<br>• `reviewer`: Post-flight auditor. Reviews git diffs, verifies edge cases, audits test coverage, and enforces Ponytail simplicity. Assign high probability (`p >= 0.6`) when auditing completed worker deliverables.<br>• `oracle`: Advisory evaluator. Challenges assumptions, analyzes complex trade-offs, and provides second opinions on risky decisions. Assign high probability (`p >= 0.6`) when architectural direction is ambiguous or when gates yield `UNCERTAIN`.<br>• `evidence-auditor`: Fact-checking specialist. Verifies verbatim citations and checks claims against sources. Assign high probability (`p >= 0.6`) for citation grounding and verification audits.<br>Probabilities must sum to 1.0 ($\pm 0.1$). Verbatim evidence quote required from state. |
| `primarySkill` | `choice` | Primary domain skill required for task execution. Must be selected verbatim from valid skill IDs in `.agents/INDEX.md` (e.g., `tdd`, `refactoring`, `diagnosing-bugs`, `security-audit`, `interface-design`, `impeccable`, `git-worktrees`, `zero-downtime-migrations`, `api-design`, `domain-modeling`, `code-review`, `codebase-design`, `to-spec`, `to-tickets`, `prompt-master`, `grill-me`, `ponytail`, `handoff`, `grammars-and-constrained-sampling`, `io-verification-control`, `shell-scripting`, `git-guardrails`) or `NONE`. Invented IDs make the sheet `INVALID`. Probabilities must sum to 1.0 ($\pm 0.1$). Verbatim evidence quote required from state. |
| `secondarySkill` | `choice` | Secondary or supporting domain skill. Must be selected verbatim from valid skill IDs in `.agents/INDEX.md` or `NONE`. Invented IDs make the sheet `INVALID`. Probabilities must sum to 1.0 ($\pm 0.1$). Verbatim evidence quote required from state. |
| `stylePreset` | `choice` | Design aesthetic preset. Relevant only when `agent` is `worker` and the task touches frontend UI styling or components; otherwise `NONE`. Must be selected verbatim from the 67 presets in `.agents/skills/design/styles/` (e.g., `clean`, `sleek`, `bento`, `ant`, `minimal`, `brutalist`, `glass`, `retro`, `terminal`) or `NONE`. Probabilities must sum to 1.0 ($\pm 0.1$). Verbatim evidence quote required from state. |

## Outcome Rules
Rule recipe: PICK-CHOICE (`minTop: 0.5`).
Evaluated independently for each question (`agent`, `primarySkill`, `secondarySkill`, `stylePreset`):

| Priority | Rule Name | Condition | Status | Outcome | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | `MECHANICAL_HIT` | Mechanical check `EMPTY_STATE` triggered | `OK` | Default scout routing | Empty state forces safe read-only scout assignment |
| 2 | `CLEAR_CHOICE` | Top choice probability `p >= 0.5` | `OK` | Top choice selected | Option meets certainty threshold |
| 3 | `UNCERTAIN_CHOICE` | Top choice probability `p < 0.5` or tie | `UNCERTAIN` | Top 3 suggestions | Ambiguous routing; suggests top candidates for Control Plane selection |

### Mandatory Constitutional Invariants (Applied Automatically by Rule)
Regardless of the evaluator's sheet answers, the Control Plane automatically applies these universal constraints:
1. **Ponytail Invariant:** `productivity/ponytail` is automatically appended to EVERY `worker` dispatch brief to enforce the 7-Rung Decision Ladder and anti-overengineering rules.
2. **Worktree Isolation Invariant:** `security-devops/git-worktrees` is automatically appended to EVERY concurrent `worker` dispatch brief.
3. **Security Invariant:** `security-devops/security-audit` is automatically appended to EVERY security review or security-sensitive task.

## Tight Order
### Agent Tight Order
1. `scout` (tightest: read-only, non-mutating)
2. `oracle` (read-only advisory)
3. `evidence-auditor` (read-only verification)
4. `reviewer` (read-only diff audit)
5. `worker` (loosest: code and AST mutation)

### Skill Tight Order
1. Specific valid skill ID from `.agents/INDEX.md` (tighter: specialized guidance)
2. `NONE` (loosest: no specialized skill loaded)

## On Uncertain
- Suggest the top 3 highest-probability options.
- The Control Plane performs manual resolution before worker dispatch.

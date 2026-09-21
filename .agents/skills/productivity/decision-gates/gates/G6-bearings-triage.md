Mode: advisory

## State
The evaluator receives one status item (operational event, error report, blocker, or task completion result).

## Mechanical Checks
| Check | Condition | Forced Status | Forced Outcome | Description |
| :--- | :--- | :--- | :--- | :--- |
| `DESTRUCTIVE_COMMAND` | State literally contains `git reset --hard`, `git clean -fd`, `DROP TABLE`, `rm -rf`, or `git push --force` | `OK` | `captainsCall: CAPTAINS_CALL`, `severity: CRITICAL` | Destructive operations require explicit Captain authorization |
| `MISSING_CREDENTIALS` | State literally reports missing credentials, secrets, tokens, or API keys | `OK` | `captainsCall: CAPTAINS_CALL`, `severity: HIGH` | Missing authentication credentials halt execution for Captain input |
| `EMPTY_STATE` | Input state is empty, whitespace-only, or missing | `OK` | `captainsCall: CAPTAINS_CALL`, `severity: MEDIUM` | Missing status context forces escalation to prevent silent failures |

## Questions
| id | type | rubric |
| :--- | :--- | :--- |
| `needsCaptainAction` | `boolean` | Rate high (`p >= 0.5`) if the item requires explicit Captain authorization, direction, PR/diff approval, or a trade-off decision. Rate low (`p <= 0.2`) if the item is purely informational or an internal worker status update. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `blocksOtherWork` | `boolean` | Rate high (`p >= 0.6`) if the blocker halts downstream tasks, freezes concurrent workers, or stops the entire fleet mission. Rate low (`p <= 0.2`) if work continues unimpeded or alternative tasks can proceed. Verbatim quote required for `p >= 0.3`. Permitted `"NONE"` only for `p <= 0.2`. |
| `severity` | `score` | Ordered severity levels: <br>• Level 0 (`LOW`): Routine operational progress, clean test passes, non-blocking notes.<br>• Level 1 (`MEDIUM`): Self-contained recoverable warning, minor test retry, non-blocking ambiguity.<br>• Level 2 (`HIGH`): Blocker halting a specialist, failing regression suite, scope conflict, unapproved architectural fork.<br>• Level 3 (`CRITICAL`): Unrecoverable error, destructive operation attempt, secret leakage risk, syntax/system crash.<br>Verbatim quote required from state for levels 1, 2, and 3. |

## Outcome Rules
Rule recipes:
- `captainsCall`: ANY-TRIGGER (`requiredAt: 0.5` for `needsCaptainAction`, `requiredAt: 0.6` for `blocksOtherWork`, `uncertainAt: 0.3`).
- `severity`: SCORE-ROUNDUP.

Evaluated in strict first-match-wins order:

### Captain's Call Triage Rules
| Priority | Rule Name | Condition | Status | Outcome | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | `MECHANICAL_ESCALATION` | Any mechanical check (`DESTRUCTIVE_COMMAND`, `MISSING_CREDENTIALS`, `EMPTY_STATE`) triggered | `OK` | `CAPTAINS_CALL` | Mandatory constitutional escalation to Section 1 (Captain's Call) |
| 2 | `ACTION_REQUIRED` | `needsCaptainAction p >= 0.5` | `OK` | `CAPTAINS_CALL` | Requires Captain decision or authority; escalate immediately |
| 3 | `BLOCKER_DOMINANT` | `blocksOtherWork p >= 0.6` | `OK` | `CAPTAINS_CALL` | Fleet blocker requiring external unblocking or steering |
| 4 | `TRIAGE_UNCERTAIN` | Either question `p >= 0.3` | `UNCERTAIN` | `CAPTAINS_CALL` | Ambiguous severity; safe default elevates to Captain's Call |
| 5 | `ROUTINE_DIGEST` | All trigger questions `p < 0.3` | `OK` | `OTHER_SECTION` | Informational status; triage into Section 2 (`Recently Landed`), Section 3 (`Underway`), or Section 4 (`Charted Next`) |

### Severity Score Rules (SCORE-ROUNDUP)
- Level 0 $\rightarrow$ `LOW`
- Level 1 $\rightarrow$ `MEDIUM`
- Level 2 $\rightarrow$ `HIGH`
- Level 3 $\rightarrow$ `CRITICAL`

### Constitutional Non-Suppression Invariant
A gate evaluation may ADD items to Section 1 (Captain's Call), but it may NEVER suppress or downgrade an item that a constitutional rule, automated tool exit code, or subagent message already placed there.

## Tight Order
1. `CAPTAINS_CALL` (tightest: halts or interrupts to present item in Section 1 of Bearings digest)
2. `OTHER_SECTION` (loosest: categorized into routine digest sections 2, 3, or 4)

## On Uncertain
`CAPTAINS_CALL`

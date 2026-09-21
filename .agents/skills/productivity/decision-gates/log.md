# ACON Decision Gates Calibration Log

This log records every machine-native Decision Gate evaluation across the ACON fleet lifecycle. It provides the empirical audit trail required for statistical calibration audits and gate promotion from `Mode: advisory` to `Mode: enforce`.

---

## 1. Operating Rules & Logging Invariants

1. **Strict Append Invariant:**  
   Entries in this log are appended strictly by the mission's **Phase IV closing worker** inside its isolated `.worktrees/` environment during mission wrap-up. The Control Plane compiles the mission's gate results and Captain steering decisions into the final closing brief. No background daemon, automated hook, or unassigned agent may write to this file.
2. **Deterministic Record of Overrides:**  
   Every entry tracks whether the Captain accepted the gate's recommendation or issued an explicit steering override. Overrides are categorized by `Disagreement Type` to quantify gate precision:
   - `NONE`: Captain aligned with gate outcome, or gate operated under autonomous flight.
   - `FALSE_POSITIVE_RESTRICTIVE`: Gate mandated a restrictive action (e.g. `REQUIRED`, `ASK`, `BLOCKED`, `REJECT_RETRY`) that the Captain explicitly deemed unnecessary and bypassed.
   - `FALSE_NEGATIVE_PERMISSIVE`: Gate recommended a relaxed action (e.g. `NOT_REQUIRED`, `SKIP`, `ELIGIBLE`, `APPROVE`) that the Captain rejected to demand stricter governance.
3. **Calibration Review Protocol:**  
   When the Captain requests a calibration review (*"review the gates"* or *"check calibration"*), a dispatched `scout` subagent reads this log and tallies metrics per gate and rule:
   - Total rows logged.
   - `UNCERTAIN` rate.
   - Tightening override rate ($\text{Overrides} / \text{Tightening Outcomes}$).
   - False-relaxing rate ($\text{Overrides} / \text{Relaxing Outcomes}$).
   Gates with $< 30$ logged rows are flagged as having an inadequate statistical sample.
4. **Promotion Thresholds:**  
   A gate may be promoted from `Mode: advisory` to `Mode: enforce` via a reviewed Captain-approved commit only if:
   - Logged rows $\ge 30$.
   - Tightening override rate $\le 15\%$.
   - False-relaxing rate $\le 5\%$.

---

## 2. Decision Log Records

| Date | Mission | Gate | Rule | Outcome | Status | Mode | Crew Role | Captain Override | Disagreement Type |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 2026-09-20 | baseline-audit | plan-first | planRequired | NOT_REQUIRED | OK | advisory | control-plane | NONE | NONE |
| 2026-09-20 | decision-gates-setup | task-shape | shape | SHIP | OK | advisory | control-plane | NONE | NONE |

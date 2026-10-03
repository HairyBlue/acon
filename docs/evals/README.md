# A/B Evaluation Protocol

## Purpose
Measure hardening outcome of ACON methodology. Note: NO fabricated results should be included in these logs.

## Protocol
*   **Condition A (Baseline)**: Standard operations without ACON rules/gates.
*   **Condition B (Hardened)**: Operations utilizing full ACON rules and gates.
*   **Constraint**: Both conditions must use the same model, task, and harness.

## Task Set Template
1.  Single-file fix
2.  Multi-file refactor
3.  New feature 1
4.  New feature 2
5.  Security audit
6.  Bug diagnosis
7.  Performance fix
8.  Architecture decision
9.  Cross-cutting change
10. From-scratch module

## Metrics
*   Gate failures caught
*   Defects reaching Captain
*   Tokens used
*   Wall-clock time
*   Test pass rate
*   Quality ratchet
*   Scope creep
*   Review cycles

## Results

### Per-Task Results

| Task | Condition | Gate Failures | Defects | Tokens | Time | Test Rate | Quality Ratchet | Scope Creep | Review Cycles |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Task 1 | A | | | | | | | | |
| Task 1 | B | | | | | | | | |
| Task 2 | A | | | | | | | | |
| Task 2 | B | | | | | | | | |
| Task 3 | A | | | | | | | | |
| Task 3 | B | | | | | | | | |
| Task 4 | A | | | | | | | | |
| Task 4 | B | | | | | | | | |
| Task 5 | A | | | | | | | | |
| Task 5 | B | | | | | | | | |
| Task 6 | A | | | | | | | | |
| Task 6 | B | | | | | | | | |
| Task 7 | A | | | | | | | | |
| Task 7 | B | | | | | | | | |
| Task 8 | A | | | | | | | | |
| Task 8 | B | | | | | | | | |
| Task 9 | A | | | | | | | | |
| Task 9 | B | | | | | | | | |
| Task 10| A | | | | | | | | |
| Task 10| B | | | | | | | | |

### Aggregate Summary

| Metric | Condition A (Baseline) | Condition B (Hardened) | Difference |
| :--- | :--- | :--- | :--- |
| Avg Gate Failures | | | |
| Avg Defects | | | |
| Avg Tokens | | | |
| Avg Time | | | |
| Avg Test Rate | | | |
| Avg Quality Ratchet | | | |
| Avg Scope Creep | | | |
| Avg Review Cycles | | | |

## Running Eval
1.  Setup identical environments for Condition A and B.
2.  Select a task from the Task Set Template.
3.  Execute the task under Condition A, logging all metrics.
4.  Reset environment.
5.  Execute the task under Condition B, logging all metrics.
6.  Record results in the tables above.

# ACON Hardening Plan

> Harden ACON's assurance, enforcement, and measurement to close gaps G1–G7.

**Status:** `AWAITING_CAPTAIN_SIGNOFF`
**Date:** 2026-10-03
**Author:** Control Plane (First Mate)

---

## 1. Mission Summary

Transform ACON from a prose-only governance framework into one with verifiable gates, independent review, deterministic quality measurement, and an evaluation protocol. The scout found:

| Finding | Impact |
|---------|--------|
| 11/12 rules are `PROSE_ONLY`, 1 `PARTIAL` | Zero programmatic enforcement |
| All 7 gates are `PROSE_ONLY` | LLM self-evaluates everything |
| No CI/CD, no git hooks installed | Nothing runs automatically |
| 4 material contradictions (C1, C2, C4) | Constitution has internal conflicts |
| 6 harness-dependent claims (H1–H6) | Aspirational on most harnesses |
| Zero test/lint/typecheck in repo | No verification baseline |

---

## 2. Captain Decisions (Phase I Alignment)

| Decision | Answer | Impact |
|----------|--------|--------|
| (a) Harnesses | Harness-agnostic (global adoption) | Enforcement matrix per-harness, no vendor lock-in |
| (b) Reviewer model | `inherit` + `CORRELATED_REVIEW` warning | No model routing complexity in W2 |
| (c) Tier 0 fast path | Yes: ≤1 file, ≤10 lines, no logic, review gate required | Add to §4 Rule 7 |

---

## 3. Architectural Decisions

| ID | Decision | Rationale |
|----|----------|----------|
| AD-1 | Resolve C1 with **Synthesis Worker** subagent | Maintains zero-execution purity. Control Plane dispatches a synthesis worker for shared entry points instead of editing code itself. |
| AD-2 | Resolve C4: "≤2k applies to task contract; skill content is additional, uncapped" | Both rules serve valid purposes on different content — task scope vs. instruction completeness. |
| AD-3 | Resolve C2: scope Zero Code Invariant to "gate files, schemas, templates, logs" | Skill scripts and adoption scripts are tools, not gates. Invariant's intent is pure-data decision logic. |
| AD-4 | Reword all harness claims with "where the harness supports it" | ACON is harness-agnostic. Temperature, token anchoring, etc. become aspirational guidance, not guarantees. |
| AD-5 | Add rule-precedence hierarchy | Provides deterministic conflict resolution: Safety > Captain > Constitutional Invariants > Operating Model > Rules > Gates > Skills > Presets. |
| AD-6 | Review gates as G8 (Code) + G9 (Security), mandatory after SHIP | Clean gate numbering extension, separate from G7 (Control Plane's own deliverable audit). |
| AD-7 | Quality script is stack-detecting, report-only, runs only installed tools | Zero new dependency mandate. Exit 0 always unless `--strict`. |

---

## 4. Task Breakdown

### Phase 1: Parallel Tasks (non-overlapping file scopes)

All Phase 1 tasks can execute concurrently — zero file collisions.

---

#### T-P1: Reword harness-dependent skill files \[W1\]

**Objective:** Remove determinism guarantees; add "where the harness supports it" conditionals.

**Files (2):**
1. `.agents/skills/productivity/io-verification-control/SKILL.md`
2. `.agents/skills/productivity/grammars-and-constrained-sampling/SKILL.md`

**Consumes:** Scout claims H1–H3, H5–H6
**Produces:** Reworded files with hedged language; no removed functionality

**Verification:**
```bash
# No unhedged determinism claims
grep -n "must set\|guaranteed\|enforce.*temp\|deterministic.*output" \
  .agents/skills/productivity/io-verification-control/SKILL.md \
  .agents/skills/productivity/grammars-and-constrained-sampling/SKILL.md
# Expected: zero matches or all within "where supported" context
```

---

#### T-P2: Create review report schema \[W2\]

**Objective:** Define closed-enum YAML schema for review reports.

**Files (1):**
- `.agents/reference/schemas/review-report.yaml`

**Consumes:** Mission spec W2
**Produces:** Schema with:
- `verdict`: enum `[PASS, FAIL]`
- `reviewer_type`: enum `[CODE, SECURITY]`
- `correlation_warning`: enum `[CORRELATED_REVIEW, INDEPENDENT_REVIEW]`
- `findings[]`: `file`, `line`, `severity` enum `[CRITICAL, HIGH, MEDIUM, LOW]`, `category`, `evidence`, `suggested_fix`
- `cycles_completed`: integer
- `escalated`: boolean

**Verification:**
```bash
python3 -c "import yaml; yaml.safe_load(open('.agents/reference/schemas/review-report.yaml'))"
grep -c "verdict\|severity\|findings\|evidence\|suggested_fix" .agents/reference/schemas/review-report.yaml
# Expected: ≥5
```

---

#### T-P3: Create reviewer crew specifications \[W2\]

**Objective:** Define code-reviewer and security-reviewer personas.

**Files (2):**
- `.agents/reference/crew/code-reviewer.md`
- `.agents/reference/crew/security-reviewer.md`

**Consumes:** Existing crew format (`.agents/reference/crew/reviewer.md`), mission spec W2
**Produces:** Crew specs defining:
- Read-only mandate (never the diff author)
- Input: diff + plan + standards only
- Output: `review-report.yaml` conformant
- Code reviewer: correctness, clarity, simplicity, spec conformance
- Security reviewer: OWASP Top 10, secrets, input validation, fail-open guards
- Loop control: 3-cycle max → 5-Element Escalation

**Verification:**
```bash
grep -l "review-report.yaml" .agents/reference/crew/code-reviewer.md .agents/reference/crew/security-reviewer.md
```

---

#### T-P4: Create review gate specifications \[W2\]

**Objective:** Create G8 and G9 gate specs; update decision-gates SKILL.md.

**Files (3):**
- `.agents/skills/productivity/decision-gates/gates/G8-code-review.md`
- `.agents/skills/productivity/decision-gates/gates/G9-security-review.md`
- `.agents/skills/productivity/decision-gates/SKILL.md` (append)

**Consumes:** T-P2 schema, T-P3 crew specs, existing gate format
**Produces:** Gate specs:
- Trigger: mandatory after every SHIP task, before commit proposal
- PASS → proceed; FAIL → route findings back to writer
- 3-cycle loop with escalation
- `reviewer_model: inherit`; log `CORRELATED_REVIEW` if same model

**Verification:**
```bash
ls .agents/skills/productivity/decision-gates/gates/G8-code-review.md
ls .agents/skills/productivity/decision-gates/gates/G9-security-review.md
grep "G8\|G9" .agents/skills/productivity/decision-gates/SKILL.md
```

---

#### T-P5: Create quality report schema + config \[W3\]

**Objective:** Define quality measurement schema and default thresholds.

**Files (2):**
- `.agents/reference/schemas/quality-report.yaml`
- `.agents/quality.yaml`

**Consumes:** Mission spec W3
**Produces:**
- Schema: metrics per file (`complexity`, `function_length`, `nesting_depth`, `argument_count`, `file_lines`, `duplication_pct`), each with `value`, `threshold`, `status` enum `[PASS, WARN, FAIL]`, `ratchet_comparison` enum `[IMPROVED, UNCHANGED, REGRESSED]`
- Config: defaults (cyclomatic >10, function >50 lines, nesting >4, args >5, file >500 lines), `report_only: true`, ratchet baseline path

**Verification:**
```bash
python3 -c "import yaml; yaml.safe_load(open('.agents/reference/schemas/quality-report.yaml'))"
python3 -c "import yaml; yaml.safe_load(open('.agents/quality.yaml'))"
```

---

#### T-P6: Create quality check script \[W3\]

**Objective:** Language-detecting quality check that runs only installed tools.

**Files (1):**
- `scripts/quality-check`

**Consumes:** `.agents/quality.yaml` config, mission spec W3 tool list
**Produces:** Shell script that:
1. Detects stack from project files (`package.json`, `pyproject.toml`, `composer.json`, `Cargo.toml`)
2. Checks for installed tools (Python: radon/ruff/vulture; JS/TS: eslint/knip; PHP: phpstan/phpmd; Rust: clippy; Duplication: jscpd)
3. Runs only what's installed — zero failures if nothing available
4. Outputs YAML conforming to `quality-report.yaml` schema
5. Ratchet mode: compares changed files against baseline, flags regressions
6. Report-only by default (exit 0); `--strict` exits non-zero on FAIL

**Verification:**
```bash
head -1 scripts/quality-check | grep -q "^#!"
chmod +x scripts/quality-check
bash scripts/quality-check --help 2>&1 | grep -qi "quality\|usage"
```

---

#### T-P7: Create mutation testing guide \[W4\]

**Objective:** Document mutation testing as optional gate for business-logic modules.

**Files (1):**
- `docs/mutation-testing.md`

**Consumes:** Mission spec W4
**Produces:** Guide covering:
- When to use: Plan-Required business logic only (monetary, auth, state machines)
- When to skip: UI, CRUD, glue code (Pragmatic Testing Gate)
- Tools per stack: mutmut/cosmic-ray (Python), Stryker (JS/TS), Infection (PHP), cargo-mutants (Rust)
- Configurable minimum mutation score
- Report: surviving mutants as findings → Test & QA Engineer
- Integration: optional gate for `[HUMAN-CORE]` domains

**Verification:**
```bash
grep -c "mutmut\|Stryker\|Infection\|cargo-mutants\|monetary\|auth\|state.machine" docs/mutation-testing.md
# Expected: ≥5
```

---

#### T-P8: Create enforcement matrix \[W5\]

**Objective:** Map every rule to HARD or SOFT enforcement, per harness.

**Files (1):**
- `docs/enforcement-matrix.md`

**Consumes:** Scout report §2, mission spec W5
**Produces:** Matrix with:
- Rows: §4 Rules 1–12 + new rules + Gates G1–G9
- Columns: Generic | Claude Code | Gemini CLI | Cursor | Codex | Local Models
- Values: `HARD` or `SOFT`
- Per-harness enforcement snippets (e.g., Claude Code `pre_tool_use_hook`)
- `UNVERIFIED` where mechanism exists but untested
- Cheap enforcement wins already implemented: `block-dangerous-git.sh` install instructions, CI workflow template

**Verification:**
```bash
grep -c "Rule\|G[0-9]" docs/enforcement-matrix.md
# Expected: ≥20
```

---

#### T-P9: Create evaluation protocol \[W6\]

**Objective:** A/B eval protocol with metrics and empty results table.

**Files (1):**
- `docs/evals/README.md`

**Consumes:** Mission spec W6
**Produces:**
- Protocol: baseline ACON vs hardened ACON, same model, same tasks
- Task set template: 5–10 tasks (single-file fix, multi-file refactor, new feature, security audit, bug diagnosis)
- Metrics: gate failures caught, defects reaching Captain, tokens, wall-clock time, test pass rate, quality-report deltas
- Empty results table for Captain
- NO fabricated results

**Verification:**
```bash
grep -c "baseline\|metric\|task.set\|results" docs/evals/README.md
# Expected: ≥4
```

---

### Phase 2: Sequential Tasks (AGENTS.md — single file, applied in order)

These MUST execute sequentially. Each modifies `AGENTS.md`.

---

#### T-S1: Fix AGENTS.md contradictions + add Tier 0 \[W1\]

**Objective:** Resolve C1, C2, C4; add rule-precedence; reword §6; add Tier 0.

**Files (1):** `AGENTS.md`

**Depends on:** T-P1 (for consistency with skill file rewording)

**Consumes:** Scout contradictions, architectural decisions AD-1–AD-5, Captain decision (c)

**Produces (specific diffs):**
1. **C1 fix:** Replace shared-entry-point synthesis by Control Plane with delegation to a Synthesis Worker subagent. Add Synthesis Worker to §4 Rule 1 crew roster.
2. **C2 fix:** Clarify Zero Code Invariant scope: "gate files, schemas, templates, and decision logs" — skill scripts and adoption scripts explicitly permitted.
3. **C4 fix:** Clarify context slicing: "≤2k tokens for the task contract (objective, boundaries, constraints, verification); inlined skill content per Rule 2-bis is additional and uncapped."
4. **§6 harness claims:** Add "where the harness supports it" to §6.1 (Token-0), §6.2 (schema-locked), §6.4 (sampling calibration).
5. **Rule-precedence (new §10):** Safety Invariant > Captain directives > Constitutional Invariants > Operating Model > Numbered Rules > Bounded Scope > Gates > Skills > Presets.
6. **Tier 0 (§4 Rule 7 table):** Add row: ≤1 file, ≤10 lines, no logic change, review gate required, skip plan/worktree.

**Verification:**
```bash
grep -c "reserved for central synthesis by the Control Plane" AGENTS.md  # Expected: 0
grep -c "Synthesis Worker" AGENTS.md  # Expected: ≥1
grep -c "task contract" AGENTS.md  # Expected: ≥1
grep -c "Tier 0" AGENTS.md  # Expected: ≥1
grep -c "precedence" AGENTS.md  # Expected: ≥1
```

---

#### T-S2: Wire review gates into AGENTS.md \[W2\]

**Objective:** Add mandatory independent review gates to the constitution.

**Files (1):** `AGENTS.md`

**Depends on:** T-S1, T-P2, T-P3, T-P4

**Produces:**
1. New rule in §4: mandatory code review (G8) and security review (G9) after SHIP, before commit proposal
2. Update §2 Phase IV lifecycle to include G8/G9 between G7 and commit proposal
3. Update Mermaid diagram
4. Reference `review-report.yaml`, crew specs
5. Loop control: 3-cycle max → 5-Element Escalation
6. `reviewer_model: inherit` + `CORRELATED_REVIEW` warning

**Verification:**
```bash
grep -c "G8\|G9\|code.review\|security.review\|CORRELATED_REVIEW" AGENTS.md
# Expected: ≥5
```

---

#### T-S3: Wire quality + mutation references into AGENTS.md \[W3, W4\]

**Objective:** Add quality gate and mutation testing references.

**Files (1):** `AGENTS.md`

**Depends on:** T-S2, T-P5, T-P6, T-P7

**Produces:**
1. Quality check as Phase IV verification step (after test pass, before review gates)
2. Reference `scripts/quality-check` and `.agents/quality.yaml`
3. Ratchet rule: changed files must not regress
4. Mutation testing as optional gate for `[HUMAN-CORE]` business logic
5. Reference `docs/mutation-testing.md`

**Verification:**
```bash
grep -c "quality-check\|quality.yaml\|mutation\|ratchet" AGENTS.md
# Expected: ≥4
```

---

### Phase 3: Verification

#### T-V1: Re-scout AGENTS.md

**Objective:** Fresh contradiction scan. Must return `READY`.

**Depends on:** All Phase 2 tasks
**Produces:** Scout report; verdict must be `READY`.

---

## 5. Dependency Graph

```
Phase 1 (Parallel):          Phase 2 (Sequential):       Phase 3:
  T-P1 (skill files) ──┐
  T-P2 (review schema) ─┤
  T-P3 (crew specs) ────┤
  T-P4 (gate specs) ────┼─→ T-S1 ─→ T-S2 ─→ T-S3 ──→ T-V1
  T-P5 (quality schema) ─┤     (C1,C2,   (review   (quality    (re-scout)
  T-P6 (quality script) ─┤      C4,§6,    gates)    + mutation)
  T-P7 (mutation docs) ──┤      Tier 0,
  T-P8 (enforcement) ───┤      precedence)
  T-P9 (eval protocol) ─┘
```

## 6. Gap Coverage Matrix

| Gap | Workstream | Tasks | Resolution |
|-----|-----------|-------|------------|
| G1: §1 vs Phase IV contradiction | W1 | T-S1 | Synthesis Worker subagent replaces Control Plane editing |
| G2: Harness-dependent overclaims | W1 | T-P1, T-S1 | "Where supported" conditionals throughout |
| G3: No independent review gate | W2 | T-P2, T-P3, T-P4, T-S2 | Mandatory G8 (code) + G9 (security) gates |
| G4: Prose-only enforcement | W5 | T-P8 | Enforcement matrix documenting HARD vs SOFT per harness |
| G5: No quality measurement | W3 | T-P5, T-P6, T-S3 | `quality-check` script + ratchet rule |
| G6: No mutation testing | W4 | T-P7, T-S3 | Optional gate for business logic modules |
| G7: No measured evidence | W6 | T-P9 | A/B eval protocol (template only, no fabricated results) |

## 7. Constraints

- **Zero new dependencies** without Captain approval
- **Zero git commits** until Captain signs off on deliverables
- **Report-only** for `quality-check` by default
- **Optional** mutation testing (business logic only)
- **`UNVERIFIED`** items explicitly marked in enforcement matrix
- **Ponytail constraints:** YAGNI, reuse existing schemas/formats, stdlib, minimum working diff
- **≤3 files per SHIP task**, closed-loop verification

---

## Checklist

- [ ] T-P1: Reword harness-dependent skill files
- [ ] T-P2: Create review report schema
- [ ] T-P3: Create reviewer crew specs
- [ ] T-P4: Create review gate specs + update decision-gates SKILL.md
- [ ] T-P5: Create quality report schema + config
- [ ] T-P6: Create quality check script
- [ ] T-P7: Create mutation testing guide
- [ ] T-P8: Create enforcement matrix
- [ ] T-P9: Create evaluation protocol
- [ ] T-S1: Fix AGENTS.md contradictions + Tier 0 + precedence
- [ ] T-S2: Wire review gates into AGENTS.md
- [ ] T-S3: Wire quality + mutation refs into AGENTS.md
- [ ] T-V1: Re-scout verification (→ READY)

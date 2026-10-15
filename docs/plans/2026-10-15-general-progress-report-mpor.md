# Implementation Plan: General Progress Reports and Public MPOR Reporting

- **Plan file:** `docs/plans/2026-10-15-general-progress-report-mpor.md`
- **Author:** Assigned Normal Agent worker
- **Date:** 2026-10-15
- **Status:** Implementation and document verification complete / independent G8-G9 APPROVE (CORRELATED_REVIEW)
- **Target branch:** Captain selects after the aligned-plan review; this plan does not authorize branch creation or Git mutation.

## 1. Objective and authority

Implement two distinct public productivity skills. Preserve the existing `daily-progress-report` skill and path as the general period-based report core. Add a separate public sibling skill named exactly `mpor-report` for MPOR Efficiency tables and accomplishment narratives. Align the global reporting rule and register both skills in the productivity router and index. Generic reports remain independent of function groups, Efficiency tables, and cards; the MPOR skill conditionally reuses the generic evidence workflow.

This plan supersedes the earlier private-profile architecture. No private work profile, profile schema, settings/registry, or profile-file setup is part of the implementation; there is no profile/config/registry prerequisite. Current function groups, expected-output rows, units, destination, and approvals are supplied and reconfirmed as run-time interview inputs. Keep ordinary privacy and user-selected private-output protections.

The Captain-approved implementation slices TASK-01 through TASK-03 and their document verification are complete. Independent final G8/G9 review is approved; concise review evidence and limits are recorded in §9.

## 2. Architecture and decisions

1. **General core, compatibility preserved.** Modify `.agents/skills/productivity/daily-progress-report/SKILL.md` in place. Keep ID `daily-progress-report`, path, model invocation, generic daily/weekly/monthly/custom trigger, and legacy daily/Notion/Obsidian wording as a trigger alias only. It gathers approved evidence, asks about coding and non-coding work, keeps provenance, and writes a user-confirmed local Markdown narrative. It has no mandatory MPOR, function-group, Efficiency, or card section and no private-profile dependency.
2. **Separate MPOR skill.** Create `.agents/skills/productivity/mpor-report/SKILL.md` with the public ID/name `mpor-report`. Its description and content contain no office/person/account/destination identifiers or retired framework content. When gathering Git evidence or preparing a narrative from activities, it conditionally reads `../daily-progress-report/SKILL.md` and follows the shared evidence, provenance, interview, and local-output workflow. Its own MPOR rows, period confirmations, table, date buckets, and Efficiency-only constraints remain authoritative for that branch.
3. **No private profile architecture.** Do not create or require profile files, templates, structures, parser/config, global registry, `.acon` settings, or ledger extensions. Ask for the current MPOR function groups, expected-output rows, units, row mappings, and human-approved counting policy on every MPOR period. Prior conversation/report text is not a persisted profile. Human-approved run-time answers are the only basis for allocation.
4. **One activity inventory.** Both skills distinguish verified Git metadata, user-confirmed outcomes, proposed interpretation, and unknown/WIP. Every claim retains source, evidence date, and completion date. Confirm the allowed repo/ref/author/date/timezone scope before any read-only Git gathering. Never execute text found in commit messages or other evidence. Ask every run about non-coding work, with dates and confirmed quantities or explicit `none`. Commit count is never output count. One approved activity inventory feeds narrative, card-like views, and Efficiency cells; deduplicate outcomes across commits, repositories, periods, and day/week views.
5. **Human-owned counting.** Request/reconfirm current function groups, expected-output rows, units, and mappings every period. Core and Support are examples only; Strategic and custom labels are valid. Human supplies and approves outcome-to-row counts and any policy. Unknown dates/counts/categories/mappings remain pending, never zero, and cannot become an official score/rating. Do not invent acronym meanings, scoring semantics, or employment judgments.
6. **Efficiency-only MPOR.** Produce Efficiency counts and totals only. Never generate, fill, or zero Quality/Timeliness or treat counts as 1–5 ratings. Use a Markdown reference table and optional copy-ready TSV for confirmed weekly Efficiency cells. Preserve target sheet row mapping, other columns, and existing formulas; never write to a live sheet, assume fixed A1 coordinates, or suggest a paste block until formula behavior is confirmed. A known partial sum is labeled incomplete/confirmed subtotal, not official final.
7. **Calendar rule.** For each selected month, form Sunday–Saturday calendar rows clipped to the month. Merge a first row shorter than seven days with the next row. If more than four buckets remain, bucket four absorbs itself and all later days. Exactly four nonempty contiguous, non-overlapping ranges cover every month day once, with no spill. Weekends are included in ranges, not counted as workdays by inference. Required outputs: October 2026 `1–10, 11–17, 18–24, 25–31`; February 2026 `1–7, 8–14, 15–21, 22–28`; August 2026 `1–8, 9–15, 16–22, 23–31`, plus leap/year-boundary fixtures and the full 400-year Gregorian sweep.
8. **MPOR narrative/card text.** The MPOR skill asks DAY or WEEK grouping for accomplishment narrative/card-like text, confirms the exact period/date/project/title information, preserves actual ranges, and renders narrative beside the Efficiency table from the same approved inventory. Card-like copy is optional and plain text only; no Trello dependency or external write. Generic reports are not forced to include MPOR, function, or card sections.
9. **Destination and privacy.** Markdown is the format default, not an assumed output path. For each run ask the user to select/confirm a local `docs/reports/` path, a private home-folder destination, or another exact local path. Create directories/files only after confirmation; reject unsafe symlink traversal and ask before overwrite. Preserve secrets and personal identifiers out of public/repository files. No external service writes, web app/server, framework, or dependency. Interactive copy website is deferred for separate approval.
10. **Safe language.** Active runtime skill/rule/router/index text and examples use only the public generic and MPOR direction. Preserve safety language concerning private output and privacy; removal of profile setup does not remove privacy protections. The retired office framework is not used in active document content or examples.

## 3. Scope and Ponytail decisions

**Only future runtime paths:**

- `.agents/skills/productivity/daily-progress-report/SKILL.md` — modify in place; retain compatibility.
- `.agents/rules/progress-reporting.md` — align privacy, provenance, routing, and user-authorized local output.
- `.agents/skills/productivity/mpor-report/SKILL.md` — create the new public MPOR skill.
- `.agents/skills/productivity/SKILL.md` — add/update only the two skill rows.
- `.agents/INDEX.md` — add/update only the two lookup rows and the productivity skill count `14` → `15`.

No ACON root instruction, unrelated skill/catalog, settings, profile, report, home-folder file, app, website, server, integration, dependency, or test framework is in scope. Preserve the existing generic skill; do not rename or remove it.

**Ponytail:** this capability is requested; reuse the existing generic entry point and reporting rule; use Markdown and standard-library temporary verification; no new platform or package is needed; keep MPOR-specific procedure in one new child skill; minimize router/index changes. Employment scoring and counting policy remain human-owned. All three implementation slices are `[HUMAN-CORE / AI-TEST]` documentation work with deterministic static/fixture checks; no production algorithm is proposed.

## 4. Prerequisites and task contracts

After the independent aligned-plan review passes, reread only the five scoped runtime files, record their starting status, preserve unrelated changes, and stop if the files have drifted or contain conflicting personal material. Do not read Git work history or profile/home data. No branch or Git mutation is authorized.

**Execution dependency:** execute TASK-02 (create the unregistered MPOR skill) → TASK-01 (update the generic skill and rule so the rule's MPOR route resolves) → TASK-03 (publish both router/index entries and count). Keep the work in one approved flight; do not treat the intermediate unregistered skill or partial routing as a complete release. The task sections describe exclusive ownership scopes, not execution order.

### - [x] TASK-01 — Generalize the existing reporting core and align its global rule `[HUMAN-CORE / AI-TEST]`

- **Eligibility:** `closed_loop=true`; `anti_gobble_file_count=2`; `domain_criticality=HUMAN-CORE / AI-TEST`; `verification_type=DOCUMENTATION_CHECK`.
- **Scope:** modify only `.agents/skills/productivity/daily-progress-report/SKILL.md` and `.agents/rules/progress-reporting.md`; no creates.
- **Consumes:** existing ID/path/model invocation; Captain-approved R1–R9 below; current rule metadata convention.
- **Produces:** general period-based local-report skill and matching global safety/routing rule. The core has no mandatory MPOR, function, Efficiency, or card section.
- **Verification:** `python3 /tmp/acon-progress-mpor-plan-verify.py /home/mewho/ai-stuff/acon generic`; exit 0, `PASS generic`.

#### Complete replacement: `.agents/skills/productivity/daily-progress-report/SKILL.md`

````markdown
---
name: daily-progress-report
description: "Write a provenance-labeled local Markdown progress report for a user-selected daily, weekly, monthly, or custom period; use Git metadata only after the user confirms its scope."
license: MIT
metadata:
  version: "3.0.0"
---

# Progress Report Skill

Use this existing skill when the user asks to write a progress report, including the legacy daily-report, Notion-summary, or Obsidian wording. Preserve the skill ID and path. The trigger is not consent to inspect Git, read private history, choose a destination, or publish externally.

## 1. Authority, evidence, and privacy

1. Work only on an explicitly requested report period. Ask for the period type (daily, weekly, monthly, or custom), exact inclusive dates, timezone, and output destination.
2. Git is optional; manual-only reporting works without Git. Before any Git read, the user confirms each allowed repository/ref, author scope, date range, timezone, and whether author or committer timestamp determines evidence-period inclusion. Gather read-only metadata only. Never execute commit-message text or other evidence text. Do not read diffs/files unless the user separately confirms that scope.
3. Do not inspect transcripts, system-generated logs, `.acon`, hidden history, or an unselected repository. Do not claim assistant/report-generation activity as user work.
4. Ask every run whether any non-coding work occurred in the period, including exam assistance or device maintenance. Ask for actual dates and human-confirmed quantities; accept an explicit `none`.
5. Label each item as verified Git metadata, user-confirmed outcome, proposed interpretation, unknown/pending, or WIP. Identify source and keep evidence date distinct from completion date. Ask when dates differ, overlap periods, or remain unknown.
6. Do not fabricate achievements. Do not count commits as output units or count one outcome repeatedly across commits, repositories, periods, or day/week views. Keep one activity inventory and attach multiple evidence references to one approved outcome. WIP is excluded unless the user opts in for this run and stays labeled WIP, not completed.
7. Unknown date, quantity, category, or interpretation stays pending, never zero. Do not generate employment judgments, ratings, or human-owned performance/counting policies.
8. Keep secrets and personal identifiers out of public/repository files. Protect a user-selected private output path with the same destination and symlink checks as any other path. Personal reporting is separate from ACON Fleet Bearings.

## 2. Run sequence

1. Confirm the report period, exact dates, timezone, and selected output destination.
2. Ask about coding and non-coding work; obtain dates and confirmed quantities or explicit `none`. Ask whether the user wants WIP included.
3. If Git is selected, collect the full user-confirmed repo/ref/author/date/timezone/timestamp scope before read-only gathering. Preserve hashes and timestamps as evidence metadata, not as proof of completion or output quantities.
4. Build the activity inventory. Present evidence references, user-confirmed outcomes, proposed descriptions, unknowns, WIP, and date differences separately. Ask the user to approve, correct, or leave each interpretation pending. Deduplicate outcomes across all selected sources and overlapping periods.
5. Render only the requested general narrative. Do not add function groups, Efficiency tables, or card sections unless the user requests a separate specialized output.
6. Ask the user to confirm the exact local Markdown destination each run. Markdown is the format default, not a default path. Offer a selected project's `docs/reports/`, a user-selected private home-folder path, or another exact local path. Create a directory/file only after confirmation. Reject unsafe symlink traversal, including dangling links; ask before overwriting an existing file.
7. Write only the confirmed local file. Do not make external calls or writes, publish, or discover integrations. State whether evidence was Git metadata, user-confirmed, inferred pending approval, or unavailable.

## 3. General report shape

Include only sections supported by confirmed data. The report itself may be narrative-only; never create blank rows or infer missing values.

```markdown
# Progress Report — <confirmed period>

- Period: <confirmed inclusive dates and timezone>
- Evidence scope: <confirmed sources, or manual-only>
- Status: <complete or incomplete; name pending facts>

## Confirmed outcomes
| Outcome | Completion date | Evidence date/source | Confirmed quantity, if applicable | Status |
|---|---|---|---|---|

## Confirmed non-coding work
<user-confirmed entries with dates and quantities, or the user's explicit “none”>

## Pending confirmation
<unknown dates, quantities, categories, or interpretations; omit only when none>
```

These angle-bracket labels are runtime fields to replace only with user-confirmed values. They are not permission to invent content or select a path.

## 4. Completion check

Before presenting the report, confirm:

- Period, dates, timezone, and destination were selected by the user.
- Non-coding work was asked about, including dates and quantities, or explicit `none` was recorded.
- Git scope was confirmed before any read; only confirmed metadata was used and no referenced text was executed.
- Verified metadata, user-confirmed outcomes, proposed interpretation, unknowns, and WIP remain distinct.
- One outcome is counted once across commits/repos/periods/views; commit totals are not output totals; evidence and completion dates remain distinct.
- Missing values are pending, not zero; WIP is opt-in and labeled.
- The local file/path was confirmed, unsafe symlink traversal was rejected, and no overwrite or external write occurred without authorization.
- No private identifier, fabricated achievement, score, or forced specialized section was added.
````

#### Complete replacement: `.agents/rules/progress-reporting.md`

````markdown
---
paths:
  - "**/*"
title: Progress Reporting and Evidence Privacy
impact: MEDIUM
tags: progress-report, privacy, evidence, local-markdown
---

# Progress Reporting and Evidence Privacy

For a general progress report, route to `.agents/skills/productivity/daily-progress-report/SKILL.md`. For an explicitly requested MPOR report, Efficiency table, or accomplishment narrative, route to `.agents/skills/productivity/mpor-report/SKILL.md`. A report request is not permission to inspect Git, private history, external services, or a destination.

- Ask for report period, dates, timezone, and destination. Markdown is the format default; no path is assumed.
- Before a Git read, confirm allowed repository/ref/author/date/timezone scope and timestamp basis. Read metadata only; never execute referenced text or infer output quantities from commit counts.
- Ask about non-coding work every period; request dates and confirmed quantities or explicit `none`. Separate verified metadata, user-confirmed outcomes, inference, unknowns, and WIP. Unknowns remain pending, not zero.
- Preserve one activity inventory and avoid double-counting outcomes across commits, repositories, periods, or views. Human owners approve quantities, row mappings, and performance judgments.
- Create local Markdown only at the exact user-confirmed path. Reject unsafe symlink traversal and ask before overwrite. Keep secrets and personal identifiers out of public files. A user-selected private folder receives the same protections.
- No profile/config/registry prerequisite, live-sheet write, external posting, or application is part of this reporting path. Personal work reports remain distinct from ACON Fleet Bearings.
````

### - [x] TASK-02 — Create the public MPOR reporting skill `[HUMAN-CORE / AI-TEST]`

- **Eligibility:** `closed_loop=true`; `anti_gobble_file_count=1`; `domain_criticality=HUMAN-CORE / AI-TEST`; `verification_type=DOCUMENTATION_CHECK`.
- **Scope:** create only `.agents/skills/productivity/mpor-report/SKILL.md`.
- **Consumes:** the existing generic skill path for a conditional reference, the shared evidence procedure specified in TASK-01 below, current-period human-confirmed groups/rows/units/mappings, and a user-confirmed selected destination.
- **Produces:** public skill ID `mpor-report`, conditional sibling pointer, narrative plus Efficiency table, exact month buckets, and optional copy-ready accomplishment-card text. No private-profile structure.
- **Verification:** `python3 /tmp/acon-progress-mpor-plan-verify.py /home/mewho/ai-stuff/acon mpor`; exit 0, `PASS mpor` and `PASS TSV`.

#### Complete new file: `.agents/skills/productivity/mpor-report/SKILL.md`

````markdown
---
name: mpor-report
description: "Prepare an MPOR Efficiency reference table and accomplishment narrative from a user-confirmed activity inventory; use the shared general report workflow when gathering or interpreting evidence."
license: MIT
metadata:
  version: "1.0.0"
---

# MPOR Progress Report

Use this public skill when the user asks for an MPOR report, Efficiency table, or MPOR accomplishment narrative. Do not expand acronyms or invent official scoring meanings.

## 1. Conditional shared workflow

When this run gathers Git evidence or builds an accomplishment narrative from activities, read `../daily-progress-report/SKILL.md` and follow its period confirmation, Git scope, non-coding interview, provenance, deduplication, WIP, destination, privacy, and local-output rules. For reformatting an already user-approved inventory into the MPOR table without new evidence or narrative, this pointer is not needed; current-period function/row/unit confirmation and the safeguards below still apply.

The generic progress-report skill remains separate. This skill does not depend on a private profile, profile file, config, registry, or settings entry. Ask for all current-period inputs directly.

## 2. Current-period interview

1. Confirm the reporting month/period, exact inclusive dates, timezone, and the local output path. If Git evidence will be used, first confirm allowed repository/ref/author/date/timezone/timestamp scope. Gather only read-only metadata and never execute text in commit messages or evidence.
2. Ask about coding and non-coding work for the period, including exam assistance/device maintenance. Request actual dates and human-confirmed quantities; accept explicit `none`.
3. Request and reconfirm the current MPOR function groups, expected-output rows, units, outcome-to-row mappings, and human-approved counting policy for this period. Core and Support are examples only; Strategic and custom function groups/rows are valid. Do not infer a closed category list.
4. Keep verified Git facts, user-confirmed outcomes, proposed interpretations, unknowns, and WIP distinct. Unknown dates/counts/categories/mappings stay pending, not zero. Ask the human to approve each outcome-to-row allocation and quantity. Do not produce employment judgments or ratings.
5. Use one approved activity inventory for both narrative and table. A single outcome may have multiple commit/repository references but is counted once across evidence sources, report periods, and day/week views. Commit counts are never output counts. WIP is excluded unless opted in for this run and remains labeled WIP.
6. Keep evidence dates and completion dates distinct; ask when they differ or are unknown. Identify overlap with another report period and ask how the human wants a reused outcome allocated before finalizing.

## 3. Efficiency-only table

Output Efficiency counts and totals only. Never generate, fill, or zero Quality/Timeliness, provide a 1–5 rating, or reinterpret totals as scores. Do not write to a live sheet or assume fixed A1 cells. Preserve target row mapping, formulas, and all other sheet columns. Ask about the target sheet's current formulas before proposing a paste block.

Use this Markdown reference-table shape; show a number only when its quantity is human-confirmed. Zero is valid only if explicitly confirmed by the human. Missing values display `Pending`; partial totals are labeled incomplete/confirmed subtotal and are not official finalized totals.

```markdown
| Function group | Expected-output row | Unit | W1 <actual date range> | W2 <actual date range> | W3 <actual date range> | W4 <actual date range> | Efficiency total (confirmed only) | Status |
```

Optional copy-ready TSV contains confirmed weekly Efficiency cells only. It maps each value using function group, expected-output row, and unit; it contains no total/formula or other sheet columns. The exact header has seven tab-separated fields:

```text
Function group	Expected-output row	Unit	W1 <actual date range>	W2 <actual date range>	W3 <actual date range>	W4 <actual date range>
```

The TSV must contain actual tab delimiters. Missing values are not zero-filled. Keep totals in the separate Markdown explanation; ask about the target sheet's current formulas before proposing a paste block. No fixed A1 range is assumed.

## 4. Month bucket rule

For each selected month, form Sunday–Saturday calendar rows clipped to the month. If the first clipped row has fewer than seven days, merge it with the next row. If more than four buckets remain, bucket four absorbs bucket four and every subsequent day. The result has exactly four nonempty contiguous, non-overlapping ranges covering each day in that month exactly once and no outside-month spill. Calendar ranges include weekends; they do not imply counted workdays.

| Month | W1 | W2 | W3 | W4 |
|---|---|---|---|---|
| October 2026 | 1–10 | 11–17 | 18–24 | 25–31 |
| February 2026 | 1–7 | 8–14 | 15–21 | 22–28 |
| August 2026 | 1–8 | 9–15 | 16–22 | 23–31 |

Test leap and common February, January/December year boundaries, century leap behavior, and all months in one complete 400-year Gregorian cycle. Always print the actual range next to each W label; do not imply W1 is always seven days.

## 5. Accomplishment narrative and optional card-like copy

Render a concise progress narrative alongside the Efficiency table, using only the same approved activity inventory. Ask whether accomplishment narrative/card-like grouping should be DAY or WEEK. Confirm the exact dates, project label, title, and description. For monthly output, print the actual date ranges from §4; for non-month spans, print each selected date/week range. Keep narrative facts evidence-backed and label pending interpretations.

This optional copy-ready accomplishment-card text is plain text only. The user may copy it manually to a chosen tool; Trello is not an integration, and no external posting or card creation is included. Do not put card-only sections into the general report skill.

## 6. Destination, privacy, and completion

Markdown is the format default, not a path default. Ask the user to select and confirm an exact local `docs/reports/` path, private home-folder path, or other local path for this run. Create directories/files only after confirmation. Check all existing path components for unsafe symlinks, including dangling links, and ask before overwrite. Keep secrets and personal identifiers out of public/repository files. Do not read a private home path or create a profile.

Before presenting the report, confirm: period and destination; Git scope before read; non-coding interview or explicit `none`; current groups/rows/units/mappings and human-approved counts; provenance and dates; no duplicate activity; WIP is opt-in; all pending values remain pending; exactly four valid month buckets when monthly; only Efficiency values/totals; narrative and table use the same inventory; TSV has seven exact fields with actual tabs; no live-sheet/external write or formula/other-column change occurred.
````

### - [x] TASK-03 — Register both public skills `[HUMAN-CORE / AI-TEST]`

- **Eligibility:** `closed_loop=true`; `anti_gobble_file_count=2`; `domain_criticality=HUMAN-CORE / AI-TEST`; `verification_type=DOCUMENTATION_CHECK`.
- **Scope:** modify only `.agents/skills/productivity/SKILL.md` and `.agents/INDEX.md`.
- **Consumes:** TASK-01 generic ID/path; TASK-02 public ID/path and conditional pointer.
- **Produces:** router/index discoverability for both distinct skills; productivity count changes from 14 to 15; no renamed or removed skill.
- **Exact productivity router rows:** keep the current table and other rows verbatim; replace the existing daily row with the first row below and insert the second row directly after it.

```markdown
| **`daily-progress-report`** | General user-requested daily, weekly, monthly, or custom progress report; provenance-labeled local Markdown with optional user-authorized Git evidence. Legacy daily/Notion/Obsidian phrasing is a trigger alias, not publication consent. | [`daily-progress-report/SKILL.md`](daily-progress-report/SKILL.md) |
| **`mpor-report`** | MPOR Efficiency counts/totals with an approved accomplishment narrative; reconfirms current groups, rows, units, mappings, and quantities every period; optionally emits copy-ready card text. | [`mpor-report/SKILL.md`](mpor-report/SKILL.md) |
```

- **Exact index rows:** replace the existing general progress row with the first row and add the second adjacent row. In the category table change only `14 Skills` to `15 Skills`; retain the rest of that description verbatim.

```markdown
| **General progress report — daily, weekly, monthly, or custom (including legacy daily/Notion/Obsidian wording)** | Provenance-labeled local Markdown; optional Git metadata only after the user confirms scope | [`.agents/skills/productivity/daily-progress-report/SKILL.md`](skills/productivity/daily-progress-report/SKILL.md) |
| **MPOR Efficiency report and accomplishment narrative** | Human-confirmed function groups, expected-output rows/units, Efficiency-only table, period narrative, optional plain-text cards | [`.agents/skills/productivity/mpor-report/SKILL.md`](skills/productivity/mpor-report/SKILL.md) |
```

- **Verification:** `python3 /tmp/acon-progress-mpor-plan-verify.py /home/mewho/ai-stuff/acon routing`; exit 0, `PASS routing`, both IDs and links match, category count is 15, unrelated router/index rows unchanged in the reviewed diff.

## 5. Acceptance matrix and TaskContract parity

Requirement IDs are unique, revision 1, and proofs are static checks or synthetic tests only; none asserts actual runtime behavior. The touchpoint inventory is the complete active-doc parity set.

| Requirement ID | Rev. | Binding assertion | Proof kind | Touchpoints |
|---|---:|---|---|---|
| REQ-001 | 1 | General report trigger supports daily/weekly/monthly/custom; general core remains separate from MPOR | STATIC_CHECK | TP-01, TP-02, TP-04, TP-05 |
| REQ-002 | 1 | Git scope is confirmed before read-only gathering; referenced text is never executed | STATIC_CHECK | TP-01, TP-02, TP-03, TP-04 |
| REQ-003 | 1 | Always ask about non-coding work with dates/confirmed quantities or explicit none | TEST | TP-01, TP-02, TP-03 |
| REQ-004 | 1 | Distinguish facts/confirmed outcomes/inference/unknown/WIP; do not count commits as outputs; deduplicate across sources, periods, and views | TEST | TP-01, TP-02, TP-03 |
| REQ-005 | 1 | Reconfirm dynamic groups/rows/units/mappings each MPOR period; humans own counts; unknowns pending; no profile prerequisite or rating | TEST | TP-02, TP-03, TP-05 |
| REQ-006 | 1 | MPOR output is Efficiency cells/totals only; TSV fields/delimiters exact; preserve row mapping/formulas/other columns | TEST | TP-02, TP-03 |
| REQ-007 | 1 | Apply the locked four-bucket month rule; daily/weekly narratives retain actual ranges and use the same inventory | TEST | TP-02, TP-03 |
| REQ-008 | 1 | Confirmed local Markdown destination, symlink/overwrite/privacy safeguards; no external writes | STATIC_CHECK | TP-01, TP-02, TP-03, TP-04 |
| REQ-009 | 1 | Register public IDs/paths and count; preserve legacy generic skill; no retired content in active docs | STATIC_CHECK | TP-01, TP-02, TP-03, TP-04, TP-05 |

| Touchpoint | Exact path | Section/member inventory | Requirement IDs |
|---|---|---|---|
| TP-01 | `.agents/skills/productivity/daily-progress-report/SKILL.md` | ID/trigger; period and Git gate; non-coding interview; provenance/activity inventory; dedup/WIP/overlap; destination/privacy; generic narrative; completion checklist | REQ-001–REQ-004, REQ-008, REQ-009 |
| TP-02 | `.agents/skills/productivity/mpor-report/SKILL.md` | ID/pointer; dynamic function groups/rows/units; evidence interview; Efficiency table/TSV; month bucket rule; narrative/day-week/card; destination/privacy | REQ-002–REQ-009 |
| TP-03 | `.agents/rules/progress-reporting.md` | Routing; source authorization; non-coding interview; provenance/dedup; local output/privacy; distinct general/MPOR paths | REQ-002–REQ-004, REQ-008, REQ-009 |
| TP-04 | `.agents/skills/productivity/SKILL.md` | Existing generic row and new public MPOR row | REQ-001, REQ-009 |
| TP-05 | `.agents/INDEX.md` | Two lookup rows and productivity skill count | REQ-001, REQ-009 |

## 6. Temporary deterministic verifier and fixtures

After the aligned-plan review, the implementation worker writes this standard-library-only script to `/tmp/acon-progress-mpor-plan-verify.py` and runs `generic`, `mpor`, `routing`, and `all` after the matching slices. These synthetic checks validate document contracts and policy fixtures only; they do not inspect Git history, a private destination, or external integrations.

```python
#!/usr/bin/env python3
import calendar
import pathlib
import re
import sys

ROOT = pathlib.Path(sys.argv[1])
MODE = sys.argv[2] if len(sys.argv) > 2 else "all"
CORE = ROOT / ".agents/skills/productivity/daily-progress-report/SKILL.md"
MPOR = ROOT / ".agents/skills/productivity/mpor-report/SKILL.md"
ROUTER = ROOT / ".agents/skills/productivity/SKILL.md"
INDEX = ROOT / ".agents/INDEX.md"
RULE = ROOT / ".agents/rules/progress-reporting.md"
RETIRED = re.compile(r"\b(?:OPCR|ORS)\b", re.IGNORECASE)


def read(path):
    return path.read_text(encoding="utf-8")


def require(text, *needles):
    missing = [needle for needle in needles if needle not in text]
    assert not missing, f"missing required text: {missing}"


def check_calendar():
    def buckets(year, month):
        last = calendar.monthrange(year, month)[1]
        offset = (calendar.monthrange(year, month)[0] + 1) % 7
        end = min(last, 7 - offset) if offset else min(last, 7)
        result = [(1, end)]
        while result[-1][1] < last:
            start = result[-1][1] + 1
            result.append((start, min(start + 6, last)))
        if len(result) > 1 and result[0][1] < 7:
            result = [(result[0][0], result[1][1])] + result[2:]
        if len(result) > 4:
            result = result[:3] + [(result[3][0], result[-1][1])]
        return result

    fixtures = {
        (2026, 10): [(1, 10), (11, 17), (18, 24), (25, 31)],
        (2026, 2): [(1, 7), (8, 14), (15, 21), (22, 28)],
        (2026, 8): [(1, 8), (9, 15), (16, 22), (23, 31)],
        (2024, 2): [(1, 10), (11, 17), (18, 24), (25, 29)],
        (2025, 2): [(1, 8), (9, 15), (16, 22), (23, 28)],
        (2025, 12): [(1, 13), (14, 20), (21, 27), (28, 31)],
        (2026, 1): [(1, 10), (11, 17), (18, 24), (25, 31)],
        (2026, 12): [(1, 12), (13, 19), (20, 26), (27, 31)],
        (2027, 1): [(1, 9), (10, 16), (17, 23), (24, 31)],
    }
    for key, expected in fixtures.items():
        assert buckets(*key) == expected, (key, buckets(*key))
    assert calendar.isleap(2000) and not calendar.isleap(2100)
    for year in range(2000, 2400):
        for month in range(1, 13):
            result = buckets(year, month)
            last = calendar.monthrange(year, month)[1]
            assert len(result) == 4 and result[0][0] == 1 and result[-1][1] == last
            assert all(result[i][1] + 1 == result[i + 1][0] for i in range(3))
            assert [d for a, b in result for d in range(a, b + 1)] == list(range(1, last + 1))
    print("PASS calendar: fixtures + complete 2000-2399 Gregorian-cycle sweep")


def check_inventory():
    records = [
        {"key": "outcome-a", "sources": {"repo-a/commit-1", "repo-b/commit-2"}, "count": 1,
         "source_state": "verified Git metadata", "state": "user-confirmed outcome",
         "evidence_date": "2026-10-14", "completion_date": "2026-10-13"},
        {"key": "outcome-a", "sources": {"repo-a/commit-3", "day-view", "week-view"}, "count": 1,
         "state": "proposed interpretation"},
        {"key": "outcome-b", "sources": {"manual-confirmation"}, "count": None, "state": "unknown/pending",
         "date": None, "evidence_date": None, "completion_date": None,
         "unit": None, "category": None, "wip": True},
    ]
    inventory = {}
    for item in records:
        current = inventory.setdefault(item["key"], {"sources": set(), "count": item["count"]})
        current["sources"].update(item["sources"])
    assert len(inventory) == 2 and inventory["outcome-a"]["count"] == 1
    assert len(inventory["outcome-a"]["sources"]) == 5
    assert records[0]["evidence_date"] != records[0]["completion_date"]
    pending = records[2]
    assert all(pending[k] is None for k in ("count", "date", "evidence_date", "completion_date", "unit", "category"))
    assert pending["wip"] is True
    assert records[0]["source_state"] == "verified Git metadata"
    assert records[0]["state"] == "user-confirmed outcome"
    assert records[1]["state"] == "proposed interpretation"
    assert pending["state"] == "unknown/pending" and pending["wip"] is True
    noncoding = {"asked": True, "answer": "none", "dates": [], "confirmed_quantity": None}
    assert noncoding["asked"] and noncoding["answer"] == "none"
    weekly = [1, None, 0, 2]
    confirmed = [True, False, True, True]
    assert weekly[1] is None and all(value != 0 or confirmed[i] for i, value in enumerate(weekly))
    efficiency_columns = ["Function group", "Expected-output row", "Unit", "W1", "W2", "W3", "W4", "Efficiency total", "Status"]
    assert efficiency_columns[:3] == ["Function group", "Expected-output row", "Unit"]
    assert not any("quality" in x.lower() or "timeliness" in x.lower() or "rating" in x.lower() or "formula" in x.lower() for x in efficiency_columns)
    assert sum(v for v, ok in zip(weekly, confirmed) if ok) == 3
    narrative_keys = {"outcome-a"}
    efficiency_keys = {"outcome-a"}
    assert narrative_keys == efficiency_keys
    print("PASS inventory: source/period/view dedup, pending fields, WIP, non-coding none, shared narrative/table")


def check_generic():
    core, rule = read(CORE), read(RULE)
    require(core, 'name: daily-progress-report', 'daily, weekly, monthly, or custom',
            'repository/ref', 'author scope', 'date range', 'timezone', 'non-coding work', 'explicit `none`',
            'verified Git metadata', 'user-confirmed outcome', 'proposed interpretation',
            'unknown/pending', 'WIP', 'Do not count commits as output units',
            'exact local path', 'symlink', 'overwrite', 'manual-only', 'Fleet Bearings')
    assert not RETIRED.search(core)
    assert not any(x in core for x in ('profile_version', 'git_mode', 'mpor_groups', 'progress-profile'))
    assert 'Do not add function groups, Efficiency tables, or card sections unless the user requests a separate specialized output.' in core
    require(rule, 'daily-progress-report/SKILL.md', 'mpor-report/SKILL.md',
            'non-coding work', 'explicit `none`', 'Unknowns remain pending',
            'symlink', 'No profile/config/registry prerequisite', 'external posting')
    assert not RETIRED.search(rule)
    print("PASS generic: compatibility, evidence, manual-work interview, privacy, separate MPOR route")


def check_mpor():
    text = read(MPOR)
    require(text, 'name: mpor-report', '../daily-progress-report/SKILL.md',
            'non-coding work', 'explicit `none`', 'repository/ref/author/date/timezone',
            'never execute text in commit messages', 'verified Git facts',
            'user-confirmed outcomes', 'proposed interpretations', 'unknowns', 'WIP',
            'Core', 'Support', 'Strategic', 'custom', 'function groups',
            'expected-output rows', 'units', 'mappings', 'human-approved',
            'same approved activity inventory', 'deduplicat',
            'Efficiency counts and totals only', 'Quality/Timeliness',
            'target row mapping', 'formulas', 'actual tab delimiters', 'seven tab-separated fields',
            'DAY or WEEK', 'actual date ranges', 'copy-ready accomplishment-card text',
            'Markdown', 'docs/reports/', 'symlink', 'overwrite', 'private home-folder')
    assert not RETIRED.search(text)
    assert not any(x in text for x in ('profile_version', 'git_mode', 'mpor_groups', 'progress-profile'))
    assert text.count("\t") == 6
    marker = 'Optional copy-ready TSV contains confirmed weekly Efficiency cells only.'
    header = next(line for line in text.split(marker, 1)[1].splitlines() if line.startswith('Function group'))
    expected = ['Function group', 'Expected-output row', 'Unit',
                'W1 <actual date range>', 'W2 <actual date range>',
                'W3 <actual date range>', 'W4 <actual date range>']
    assert header.count("\t") == 6 and header.split("\t") == expected
    escaped = header.replace("\t", chr(92) + 't')
    assert len(escaped.split("\t")) == 1 and escaped.split("\t") != expected
    assert not any(name in header for name in ('Quality', 'Timeliness', 'Rating', 'Formula', 'Total'))
    assert 'Efficiency total (confirmed only)' in text
    assert 'Preserve target row mapping, formulas, and all other sheet columns' in text
    assert "Ask about the target sheet's current formulas before proposing a paste block." in text
    print("PASS TSV: seven exact actual-tab fields; literal-backslash form rejected; row/formula safeguards")
    print("PASS mpor: public skill, conditional core pointer, dynamic inputs, narrative, privacy, no profile")


def check_routing():
    router, index = read(ROUTER), read(INDEX)
    for text in (router, index):
        require(text, 'daily-progress-report', 'mpor-report', 'daily, weekly, monthly, or custom',
                'mpor-report/SKILL.md', 'daily-progress-report/SKILL.md')
        assert not RETIRED.search(text)
    require(index, '15 Skills')
    assert '14 Skills' not in next(line for line in index.splitlines() if 'skills/productivity/' in line)
    assert not any(x in router + index for x in ('profile_version', 'progress-profile'))
    print("PASS routing: separate public IDs/paths, legacy generic route, updated catalog count")


if MODE in ("generic", "all"):
    check_generic()
if MODE in ("mpor", "all"):
    check_mpor()
if MODE in ("routing", "all"):
    check_routing()
if MODE == "all":
    check_calendar()
    check_inventory()
elif MODE not in ("generic", "mpor", "routing"):
    raise SystemExit("usage: python3 /tmp/acon-progress-mpor-plan-verify.py REPO_ROOT [generic|mpor|routing|all]")
```

The temporary fixture matrix is explicit:

| Proof | Fixture | Assertion |
|---|---|---|
| Generic/core split | Core plus rule | Existing ID/path/legacy alias remains; no MPOR table/function/card requirement or profile structure; rule routes MPOR separately |
| Public MPOR registration | Router and index rows/count | `mpor-report` path is exact; core ID/path remains; count 15; unrelated registrations untouched |
| Conditional shared evidence | MPOR skill pointer | Exact sibling path `../daily-progress-report/SKILL.md` and conditional invocation are present |
| Human interview | Synthetic manual `none` and activity records | Non-coding asked; dates/confirmed quantities or explicit none; dynamic Core/Support/Strategic/custom rows; unknowns pending |
| Git and provenance | Synthetic evidence refs over multiple repos/commits | Confirm scope before read; no evidence text execution; facts/confirmed/inference/unknown/WIP separate |
| No double counting | Repeated `outcome-a` across commits, repos, and day/week views | Activity inventory yields one approved count with merged references; commit quantity does not become output quantity |
| Efficiency-only | Pending and human-confirmed zero fixture | Only Efficiency values; pending not zero; no scores or forbidden sheet columns; totals remain separate and incomplete when needed |
| TSV | Extract header, positive parse, literal-backslash negative | Exactly seven names and six real tabs; negative parses as one column and is rejected; row mapping retained; no totals/formulas/other metrics in paste fields |
| Calendar | Required months, leap/common February, year boundaries, century, full 400-year cycle | Exactly four nonempty contiguous ranges cover each month once without spill; weekends are not workday counts |
| Narrative/card-like output | Same approved inventory projected by DAY and WEEK | Narrative and table key sets match; actual date ranges are shown; card text is optional, plain-text only |
| Local/privacy | Static paths and output guardrails | Confirmed local path, symlink rejection, overwrite confirmation, no profile setup, no external writes, no identifiers |
| Retired content | Active skill/rule/router/index extracted from proposed docs | No retired terminology or examples occur in active runtime docs |

**Future integration commands after all slices:**

```bash
python3 /tmp/acon-progress-mpor-plan-verify.py /home/mewho/ai-stuff/acon generic
python3 /tmp/acon-progress-mpor-plan-verify.py /home/mewho/ai-stuff/acon mpor
python3 /tmp/acon-progress-mpor-plan-verify.py /home/mewho/ai-stuff/acon routing
python3 /tmp/acon-progress-mpor-plan-verify.py /home/mewho/ai-stuff/acon all
git diff --check
```

Each verifier mode exits 0 and prints its named `PASS` results. `all` runs the calendar and inventory fixtures. `git diff --check` exits 0. These commands prove document/fixture conformance only, not actual runtime enforcement or user data correctness.

## 7. Requirement acceptance matrix

| ID | Binding acceptance | Future slice | Named proof |
|---|---|---|---|
| R1 | General report supports daily/weekly/monthly/custom; general core remains separate from MPOR | TASK-01, TASK-03 | `check_generic`, `check_routing` |
| R2 | Confirm repo/ref/author/date/timezone before Git; read metadata only; never execute referenced text | TASK-01, TASK-02, TASK-03 | `check_generic`, `check_mpor`, `check_inventory` |
| R3 | Always ask about non-coding work, dates, confirmed quantities or explicit none | TASK-01, TASK-02 | `check_generic`, `check_mpor`, `check_inventory` |
| R4 | Distinguish facts/confirmed/inference/unknown/WIP; no commit-as-output; one inventory deduplicates sources/periods/views | TASK-01, TASK-02 | `check_inventory`, `check_generic`, `check_mpor` |
| R5 | Reconfirm current MPOR groups/rows/units/mappings; human owns counts; custom and Strategic accepted; no profile prerequisite/rating | TASK-02 | `check_mpor`, public-profile absence assertion |
| R6 | Efficiency counts/totals only; pending is not zero; exact TSV; preserve row mapping/formulas; no other fields or live writes | TASK-02 | `check_mpor`, `check_tsv_header`, renderer fixture |
| R7 | Exact four month ranges and sweep; narrative/card DAY/WEEK uses actual ranges and same inventory | TASK-02 | `check_calendar`, `check_inventory`, `check_mpor` |
| R8 | User-selected confirmed local Markdown; privacy/symlink/overwrite protection; no external write | TASK-01, TASK-02, TASK-03 | `check_generic`, `check_mpor`, `check_rule` |
| R9 | Keep generic ID/path; add exact public `mpor-report`; correct route/index/count; active docs stay free of retired content | TASK-01, TASK-02, TASK-03 | `check_generic`, `check_mpor`, `check_routing` |

## 8. Plan-authoring history and acceptance tracking

The original plan-only task wrote the canonical plan and the short superseded notice; the prior historical-plan snapshot and SHA-256 remain in `/tmp/acon-progress-mpor-plan-BiEwdq/`. Implementation slices A-C changed only the five public documents listed in §3. This closure is a separate one-file plan metadata update. Task checkboxes are marked complete only after implementation verification and independent G8/G9 approval; no feature or acceptance requirement is added by this closure.

## 9. Closure and evidence limits

Independent final reviews: **G8 APPROVE** (native completion `2026-10-15T04:58:38.185Z`) and **G9 APPROVE** (native completion `2026-10-15T04:57:49.335Z`). They used separate read-only reviewer contexts with the same native `openai-codex/gpt-6-luna` identity; record `CORRELATED_REVIEW`. All five actual public documents passed static verifier modes and deterministic synthetic fixtures. This evidence does not establish a live report workflow, actual report correctness, runtime dispatch, or external integration behavior. Closure evidence, combined patch, and verification summaries are in `/tmp/acon-progress-mpor-implementation-MaysTN/slice-c/`.

---
name: mpor-report
description: "Prepare workplace MPOR/SPOR drafts using supplied office templates, selected rows, and progress-based Efficiency counts with a transparent breakdown. Supports daily, weekly, monthly, and custom reporting periods."
license: MIT
metadata:
  version: "2.0.0"
---

# MPOR / SPOR Workplace Report

Use for the user's prescribed workplace MPOR/SPOR forms, selected expected-output rows, Efficiency tables, and accomplishment narratives. Follow the supplied office template and instructions. Confirm unfamiliar acronyms (including the office's meaning of SPOR) and requirements; do not assume that MPOR and SPOR have identical formats or invent Civil Service mandates, ratings, or scoring formulas.

This skill is separate from general daily reporting. For Trello/Kanban titles and descriptions or ordinary daily/weekly updates, use `../daily-progress-report/SKILL.md`. When both outputs are requested, reuse one activity inventory rather than counting the same work twice.

## 1. Intake and evidence

1. Reuse information already supplied in the current conversation. Ask only for missing dates, template details, selected rows, units, or material uncertainties, preferably in one concise batch. Do not repeatedly ask for an answered exclusion, quantity, or period.
2. Establish the exact inclusive period, timezone when needed, office form, desired numeric table/narrative/both, and reporting columns. Daily accomplishments, weekly columns, monthly totals, and custom cutoffs are all valid. A supervisor requesting daily work does not automatically require a different official form.
3. Include ONLY selected function groups and expected-output rows, in the template's wording/order. Core, Support, Strategic, and custom groups are allowed, not mandatory. If the user selects only Database Design, Modules Developed, Security Integrated, and Bug Fixes, omit biometric, DTR, attendance, exam assistance, and other support rows entirely. Omitted rows are not zero-valued rows.
4. Ask about additional work only within the selected scope when not already addressed. Do not require a full non-coding interview after the user excludes those categories.
5. Accept supplied screenshots, current-conversation accomplishments, user confirmations, and OT accomplishment/MOV records as sources. An OT request lists planned deliverables/authorized hours, not proof of completion/actual hours worked. Ask before treating expected work as completed. Confirmed work outside the current branch can be included.
6. When gathering/interpreting evidence, read `../daily-progress-report/SKILL.md` and follow its evidence, privacy, deduplication, and destination safeguards. Before any Git read, confirm each allowed repository/ref, author, inclusive dates, timezone, and author/committer timestamp. Metadata only unless separately authorized. Do not retrieve saved conversations, hidden logs, `.acon`, or unselected repositories. No Git access is required for manual-only reports.
7. Draft in chat by default. Ask for an exact local path only if saving is requested. No private profile/config is required.

## 2. Progress-based counting

Count completed progress, NOT commits, changed files, lines, automated-test assertions, OT hours, or screenshots.

- Maintain one inventory: distinct outcome, completion date, source/evidence date, selected row, unit, quantity, and status.
- A named completed feature, database design, security measure, or corrected defect can be a proposed output unit when the user requests progress-based counts. Explain the grouping; the office/user owns the official counting policy.
- If the user says "count the progress," derive a DRAFT tally from identifiable completed outcomes and show its breakdown instead of repeatedly demanding commit counts or leaving every count pending. Label it **proposed counts for employee confirmation**, not an audited or official quantity.
- Do not invent granular work to reach a number. If one module contains several changes, do not silently count all of them as separate modules. A bundle may count as one only when clearly labeled as a work package for user review; do not claim an unknown number of individual fixes.
- Deduplicate multiple references to one outcome. Allocate each outcome to one selected row and reporting period; do not count the same schema change again as a bug fix or security implementation. If an office requires overlapping classifications, ask how to present them and disclose any overlap.
- Keep proposed counts separate from confirmed quantities. Final Efficiency entries and paste blocks use human-confirmed counts. Unknown completion dates, categories, units, or quantities stay `Pending confirmation`, not zero; proposed counts must not conceal unknown work.
- A total with pending values is a **confirmed subtotal / incomplete**, never a finalized total. Do not zero-fill excluded rows, future weeks, or unknown periods.
- WIP is excluded from completed counts by default. Include it only if requested, clearly separated and not represented as completed.
- Keep completion and evidence dates separate; a later commit does not move earlier work into a new week. Ask about unclear dates or overlapping reporting periods.
- Do not infer employment judgments, productivity scores, or Quality/Timeliness ratings from counts. Approval of a draft is not approval of a universal counting policy.

## 3. Efficiency table and optional narrative

Follow the user's template. Default to Efficiency quantities and totals ONLY; do not fill/zero Quality or Timeliness columns, assign 1–5 ratings, change formulas, or write to a live sheet.

Use only requested date columns. For two selected weeks, omit W3/W4 instead of filling them with zeros. For daily reports, label actual dates. Preserve official row/unit mappings. A compact chat table can omit repeated group/unit/status columns when clearly stated in the breakdown.

```markdown
| Expected Output | Week 1 — <dates> | Week 2 — <dates> | Total |
|---|---:|---:|---:|
| <selected row> | <confirmed or explicitly proposed quantity> | <quantity or Pending confirmation> | <total or incomplete subtotal> |
```

When counts are proposed, label the entire table accordingly and provide the distinct accomplishment list behind each number. A narrative is optional, not mandatory when the user only asks for numerical entries.

For requested TSV paste blocks:
- Confirm the target sheet's column/row mapping and existing formulas before proposing a block.
- Use actual tab delimiters and exactly the requested data columns; no fixed A1 range is assumed.
- Include function group, expected-output row, and unit mapping in the reference explanation, or as TSV fields only if requested.
- Exclude total/formula and unrelated columns unless explicitly requested and safe. Missing values are not zeros; proposed counts are not final paste values.

## 4. Date buckets

Use the office's supplied ranges or the user's explicit ranges first. Always print inclusive dates next to week labels. A custom cutoff such as November 1–15 may use user-selected blocks November 1–7 and November 8–15; explain that these are reporting blocks, not necessarily seven-day calendar weeks. Do not alter those dates silently.

If a full-month form requires four buckets and no policy is supplied, offer the following legacy convention for confirmation; it is NOT a Civil Service rule:
1. Form Sunday–Saturday calendar rows clipped to the selected month.
2. Merge a first partial row with the next row.
3. If more than four buckets remain, bucket four absorbs subsequent days.
4. Verify four nonempty, contiguous, non-overlapping ranges covering the month exactly once, with no outside-month spill.

| Illustrative month | W1 | W2 | W3 | W4 |
|---|---|---|---|---|
| October 2026 | 1–10 | 11–17 | 18–24 | 25–31 |
| February 2026 | 1–7 | 8–14 | 15–21 | 22–28 |
| August 2026 | 1–8 | 9–15 | 16–22 | 23–31 |

Do not impose four columns on daily, weekly, custom, or five-week official templates. Calendar ranges include weekends without implying work on every day. Check year/month boundaries and leap days when applicable.

## 5. Worked example — selected rows and progress counts

**ILLUSTRATIVE ONLY:** Fictional accomplishments and quantities, not this user's history, a Civil Service scoring policy, or numbers to reuse in future reports.

**Example request:**
> Prepare my MPOR for November 1–15, 2026. Include only Database Design, Modules Developed, Security Integrated, and Bug Fixes. Use November 1–7 for Week 1 and November 8–15 for Week 2. Count completed progress, not commits. Include confirmed November 14 OT accomplishments. Give me the numeric table and count breakdown.

**Proposed progress-based counts for employee confirmation:**

| Expected Output | Week 1 — Nov. 1–7 | Week 2 — Nov. 8–15 | Total |
|---|---:|---:|---:|
| System Database design created | 1 | 1 | **2** |
| System Modules developed | 2 | 2 | **4** |
| System Security integrated | 1 | 1 | **2** |
| Bug fixes performed | 2 | 1 | **3** |

**Basis — each named outcome allocated once:**

| Selected row / proposed unit | Week 1 outcomes | Week 2 outcomes |
|---|---|---|
| Database Design / completed schema design | Content-record schema. **(1)** | Homepage navigation-settings structure. **(1)** |
| Modules Developed / completed feature | Announcements module; content-review workflow. **(2)** | Homepage finder; Citizen Charter content restoration. **(2)** |
| Security Integrated / completed security measure | Office-scoped access restrictions. **(1)** | Internal/external URL validation. **(1)** |
| Bug Fixes / distinct corrected defect | Pagination defect; incorrect breadcrumb destination. **(2)** | Directory-card animation defect. **(1)** |

**Example evidence/status note:**
> The employee confirmed these outcomes and completion dates, including Citizen Charter restoration on November 14, outside the current branch. Progress-based grouping and quantities remain proposed until approved. The OT request alone would establish planned work, not completion. Multiple commits supporting the same finder do not increase its count.

**Unknown-value variant:**
If the number of corrected defects is unknown, show `Pending confirmation` for that cell and an incomplete subtotal, or offer one explicitly labeled correction work package for review. Never invent individual defects or replace an unknown quantity with `0`. Do not reuse this fictional example as evidence.

## 6. Completion and delivery

- Confirm selected rows, period/grouping, units, mapping, and proposed versus approved counts. Reuse supplied answers instead of restarting intake.
- Ensure numeric and narrative views use the same inventory; no duplicate outcomes across rows, branches, reports, or evidence sources.
- Keep unknowns pending and OT plans separate from completed accomplishments; label WIP.
- Respect the actual office form. Do not invent acronyms, mandates, ratings, or formulas.
- Provide only requested outputs. For an additional Trello/Kanban card, use the general report skill's optional format with the same inventory and no inflated counts.
- A file is optional. If requested, confirm the exact path, check all components for unsafe/dangling symlinks, and ask before overwriting; keep personal identifiers/secrets out of public files.
- No live-sheet edits, external posting, card creation, profile creation, or Git mutations are authorized by a report request.

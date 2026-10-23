# Implementation Plan: Portable Design Audit Skills

- **Plan File:** `docs/plans/2026-10-22-portable-design-audit-skills.md`
- **Author:** Planning Worker
- **Date:** 2026-10-22
- **Status:** In Review — Captain-approved implementation and static/adoption checks complete; independent release G8/G9 pending
- **Target Branch:** Existing branch; no branch creation is proposed

## 1. Context & Objective

Add two original, portable ACON design skills for explicit read-only discovery work: `better-interface` audits an existing interface across accessibility, layout, writing, typography, and UI polish; `find-animation-opportunities` identifies supported motion opportunities and rejected candidates. Neither skill builds, fixes, implements, launches helpers, assumes or installs design tools, or persists a report by default.

Keep these as on-demand leaves under `.agents/skills/design/`. Existing interface building/refinement remains routed through `design` and `interface-design`; the existing `design-review` remains the focused craft/hierarchy review, while `impeccable` retains its broader technical design audit. The motion skill only discovers and evaluates candidate seams. It does not implement animation. Both new skills read the design router's three mandatory core craft references before review/discovery, consult applicable domain-specific ACON craft references conditionally, and use evidence from the authorized task context. They do not require Figma, a selected canvas/frame, a browser, a fixed viewport, external services, a new package, or an assumed rendering capability.

Research established the requested functional distinctions. This plan specifies original ACON text only. Per Captain direction, license/provenance investigation and copying of downloaded wording or license files were skipped. No rights, license status, or ACON ownership of external source files is asserted or verified.

## 2. Authorized Findings and Affected Surface (planning-time snapshot)

These findings record the pre-implementation baseline and proposed scope; current completion is summarized in §8.

- `.agents/skills/design/` currently contains three `SKILL.md` files: the `design` suite/router plus the `interface-design` and `impeccable` leaves. Thus there are two current child skills; the two proposed leaves make four. The design subtree has 67 `styles/*/DESIGN.md` presets and 17 craft guidance files (18 Markdown files including `craft/README.md`). Preserve those counts.
- `.agents/INDEX.md` has the design category count `2 Skills + 67 Presets + 17 Craft References`, an existing broad UI lookup and an existing AI-slop audit lookup. Add explicit multi-domain-audit and motion-discovery lookup rows; change only the affected child-skill count to four.
- `README.md` repeats the `2 Skills` count in the repository tree and design catalog heading, and lists the existing `interface-design` and `impeccable` skills. Update those two counts to four and add concise entries for the two new leaves. Keep 67 presets and 17 craft references unchanged.
- `.agents/skills/design/SKILL.md` is the design router and intent-to-style guide. Add explicit routing for requested multi-domain audits and motion-opportunity discovery while retaining the existing build/styling/fix path and craft floor.
- `.agents/skills/design/README.md` lists the suite contents. Add the new leaves there; its preset and craft inventories remain unchanged.
- `scripts/adopt.sh` copies `.agents/skills/` recursively using `rsync -avL --delete`, and reports the installed skill count dynamically with `find ... -name "SKILL.md"`. No adoption-script change is justified.
- `tests/adopt-acon-session-ledger.sh` already checks adoption behavior and copied skill/reference content. Extend this existing fixture with focused assertions that the two new files, their routing, relative references, and expected four-leaf design count arrive in the adopted target. Do not add another test file.
- Both proposed skill paths were checked absent before drafting: `.agents/skills/design/better-interface/SKILL.md` and `.agents/skills/design/find-animation-opportunities/SKILL.md`. If either exists at implementation time, stop rather than overwrite.

Unrelated pre-existing working-tree changes are recorded in `/tmp/acon-portable-design-skills-plan-tyRWMk/evidence/status-before.txt`: `.agents/reference/crew/README.md`, `.agents/skills/design/interface-design/commands/design-review.md`, `.gitignore`, `tests/adopt-acon-session-ledger.sh`, and the untracked `docs/plans/2026-10-21-cli-crew-job-title-skills.md`. Preserve them and attribute none of them to this plan's future implementation.

## 3. Design Decisions and Constraints

1. **Two narrow leaves, not a router or suite:** `better-interface` is invoked for an explicit multi-domain audit of existing UI. `find-animation-opportunities` is invoked for explicit read-only motion discovery. Routine building, styling, or fixing stays on the existing implementation route.
2. **Distinct from existing review paths:** A narrow hierarchy/craft review remains `interface-design/commands/design-review.md`; a broad technical/design-system audit remains with `impeccable`. Neither new skill duplicates those outputs or changes their behavior.
3. **Evidence, not assumed capability:** Separate source-only observations (`path:line`) from actually observed rendered screens/states/viewports. Use keyboard/browser/rendering only if the tool and authorization are actually available and the action is safe; do not perform consequential or uncertain actions. Mark unavailable evidence `Not verified`.
4. **Bounded, review-only results:** Use quick/full scope modes, explicit inventory and coverage, finite prioritized findings, rejected candidates, root-cause/user-impact rationale, limitations, and a verdict. Do not invent scores, inflate severity, make ungrounded root-cause claims, or apply fixes. No automatic report-file persistence.
5. **Craft and motion remain canonical:** Both leaves first read the router's always-required `anti-ai-slop.md`, `state-coverage.md`, and `minimalism-discipline.md`; domain-specific craft files remain conditional. Motion findings reuse the current motion guide and its reduced-motion/tokens guidance; no fixed duration rule supersedes project tokens, frequency, function, or reduced-motion needs.
6. **No runtime expansion:** No Figma/canvas assumptions, scripts, hooks, validators, external services, third-party text/license files, dependencies, new reference tree, app-source work, or internal multi-agent orchestration.
7. **Ponytail:** YAGNI; reuse the existing design router, review path, craft references, adoption script and fixture; zero dependencies; minimum coherent catalog edits. Plan approval and implementation authorization remain separate; future implementation receives fresh scope approval and independent G8/G9.

## 4. Implementation Tasks

The three sequential tasks were implemented in separately approved, non-overlapping slices. Each slice completed only its listed files. The checkmarks below record implementation-slice completion, not independent release approval or publication authority.

### - [x] Task 1: Create the two read-only skill leaves `[AUTONOMOUS-SHIP]` — completed implementation slice

- **Scope — create only:**
  - `.agents/skills/design/better-interface/SKILL.md`
  - `.agents/skills/design/find-animation-opportunities/SKILL.md`
- **Consumes:** Existing ACON design/craft behavior and these canonical sources: `.agents/skills/design/interface-design/commands/design-review.md`, `.agents/skills/design/impeccable/SKILL.md`, the always-required `.agents/skills/design/craft/anti-ai-slop.md`, `state-coverage.md`, and `minimalism-discipline.md`, plus conditional domain references `accessibility-baseline.md`, `typography.md`, `copywriting.md`, and `motion.md`. Resolve links from each new leaf's own directory. Do not copy their checklists wholesale.
- **Produces:** The following complete final files.

#### `better-interface/SKILL.md` — complete proposed content

~~~markdown
---
name: better-interface
description: "Use when explicitly requesting a multi-domain, read-only audit of an existing interface across accessibility, layout, writing, typography, and UI polish; not for routine building, styling, or fixing."
---

# Better Interface Audit

Audit an existing interface only within the scope the user names. This skill reports evidence and improvement opportunities; it does not modify application files, apply fixes, launch helpers, use unapproved tools, or save a report unless separately authorized by an explicit bounded task.

## Required core craft consultation

Before each audit, read and apply the design suite's mandatory core references: [anti-slop invariants](../craft/anti-ai-slop.md), [interactive-state coverage](../craft/state-coverage.md), and [minimalism discipline](../craft/minimalism-discipline.md). Reuse their guidance; do not duplicate their checklists. Apply minimalism to recommendations: do not propose added UI unless the user's request, accessibility/function, or task requires it. Consult other domain craft references only when the audit reaches that domain.

## Choose scope and depth

First name the requested product surface, user task, and review boundary. Use only supplied source, screenshots/rendered observations, and task-authorized tools. If the boundary is unclear, ask one focused question or state the narrow assumption and limit the audit to it.

- **Quick audit:** one named screen or short flow; inspect each of the five domains below once, then report the highest-impact supported findings.
- **Full audit:** the explicitly named screens/flow and their relevant states; record coverage separately for all five domains and distinguish complete, partial, not in scope, and **Not verified**.

Do not broaden a named screen into an application-wide audit. If the requested inventory is too large for one pass, state what was covered and what remains unreviewed.

A single-view craft/hierarchy review belongs to [the existing design review](../interface-design/commands/design-review.md). A broader technical/design-system audit remains with [Impeccable](../impeccable/SKILL.md). Use this skill for the explicit multi-domain audit, not as a replacement for either.

## Gather evidence before judging

Separate what the evidence shows from interpretation:

- **Source-only:** cite `path:line` for each source-based finding. Describe what the code establishes; source inspection alone does not prove a rendered result or runtime behavior.
- **Supplied screenshot/image:** it can support direct observations limited to the visual state depicted (for example, visible hierarchy, text, spacing, and apparent layout). Identify the artifact and its known screen/state. Record viewport or state provenance only when supplied; if unknown, mark that provenance **Not verified**, never invent it. An image does not establish interaction, other states, timing, responsiveness, keyboard/screen-reader behavior, or runtime behavior.
- **Rendered/observed:** identify the screen/state, evidence artifact or authorized observation, and actual viewport only when known. Do not imply a browser or render tool was used unless it was.
- **Unavailable:** mark the relevant check **Not verified**. Do not infer runtime results from missing source, an absent tool, an unobserved interaction, or unknown image provenance. Do not discard valid image-limited observations merely because a browser is unavailable.

Keyboard or other interaction checks are conditional on an available authorized method and a safe, non-consequential action. Do not submit, delete, purchase, publish, change account state, or otherwise cause consequential changes. If safety or authorization is unclear, do not perform the action and mark it **Not verified**.

## Inspect the five domains

Record coverage for each domain, even when there is no supported finding:

1. **Accessibility:** inspect only applicable evidence, including keyboard access/focus and semantics. When relevant, consult [the accessibility floor](../craft/accessibility-baseline.md) and apply the already-read mandatory state-coverage reference; do not reproduce their full checklists here.
2. **Layout:** examine hierarchy, navigation, grouping, density, spacing, responsive evidence, and whether the named task remains clear. For craft-level hierarchy questions, use the existing focused review rather than duplicating its scoring or approval bar.
3. **Writing:** assess whether visible labels, instructions, errors, and actions are clear, truthful, and useful for the named user task. Consult [copywriting guidance](../craft/copywriting.md) only when content is in scope.
4. **Typography:** assess readable hierarchy and legibility against the interface's own system. Consult [typography guidance](../craft/typography.md) when type is in scope; do not impose a new type scale on the project.
5. **UI polish:** inspect supported evidence for state completeness, consistency, and details that materially affect use. Apply the already-read mandatory state-coverage reference when interactive states are relevant. Do not claim states were exercised unless observed.

## Filter and prioritize

For each candidate, ask whether evidence supports a real user cost, a plausible root cause, and a specific improvement. Keep observed facts, hypotheses, and **Not verified** assertions distinct; never report a hypothesis or unverified assertion as an established defect. If the cause is uncertain, label it as a hypothesis. Reject taste-only preferences, duplicate findings, unsupported runtime claims, out-of-scope issues, and issues already settled by supplied project guidance; record a concise rejected-candidate reason.

Assign each finding an explicit existing ACON severity: `CRITICAL`, `HIGH`, `MEDIUM`, or `LOW`. Justify it with supported user impact and evidence; do not inflate severity or compute numeric/aggregate scores. An unverified impact cannot be presented as confirmed severity. Prioritize by supported user impact, recurrence, and confidence. Return at most five principal findings, grouping repeated instances only when they share the same evidenced cause; state any additional confirmed finding count omitted from the priority list. The coverage table still accounts for every in-scope domain and surface.

## Report and verdict

Return a concise report in the current interaction; do not persist it automatically:

- **Scope and mode:** named surface, task, assumptions, quick/full.
- **Coverage:** each of the five domains and each named surface/state, marked complete, partial, not in scope, or **Not verified**.
- **Prioritized findings (at most five):** domain; `CRITICAL|HIGH|MEDIUM|LOW` severity; evidence and evidence kind; observed fact; root cause or explicitly labeled hypothesis; supported user impact; specific recommended decision; priority rationale. Identify every unverified assertion as **Not verified**.
- **Rejected candidates:** screened-out candidate and evidence-based reason, or `None identified`.
- **Verification gaps:** unavailable source, state, viewport, keyboard or runtime checks.
- **Verdict:** `READY`, `NEEDS_WORK`, or `INSUFFICIENT_EVIDENCE`, with a short evidence-grounded reason.

The verdict is advisory. Do not approve a product change on behalf of its owner and do not make fixes. Implementation requires a separate bounded assignment. A report based only on text/screenshots must say so; this skill does not make checks automatic or confer tools or authorization.
~~~

#### `find-animation-opportunities/SKILL.md` — complete proposed content

~~~markdown
---
name: find-animation-opportunities
description: "Use when explicitly asking to discover or audit motion opportunities in an existing interface; read-only analysis, not animation implementation or routine UI work."
---

# Find Animation Opportunities

Discover whether motion would help a named existing interaction. This is a read-only analysis skill: do not add, alter, or remove animation, edit application files, launch helpers, use unapproved tools, or persist a report without a separate explicit bounded assignment.

## Required core craft consultation

Before each discovery, read and apply the design suite's mandatory core references: [anti-slop invariants](../craft/anti-ai-slop.md), [interactive-state coverage](../craft/state-coverage.md), and [minimalism discipline](../craft/minimalism-discipline.md). Reuse their guidance rather than copying their checklists. Minimalism is the default: recommend no added motion unless evidence shows it serves the user's task. Consult other domain craft references only when the discovery reaches that domain; the motion guide is required when evaluating motion candidates.

## Bound the discovery

Name the supplied interface, screen/flow, and interaction scope. Use only task-provided source, images, rendered observations, and tools already available and authorized. Do not assume Figma, a canvas, a selected frame, a browser, fixed viewport dimensions, or any external service. If the scope is unclear, ask one focused question or state the narrow assumption.

Separate evidence types. Source findings cite `path:line` and describe only what source establishes. A supplied image supports only the visible state it depicts; unknown screen/state or viewport provenance is **Not verified**, not guessed. An image does not prove timing, frequency, feel, interaction, responsive behavior, or runtime behavior. A rendered/runtime observation names the actual screen and state, evidence artifact, and viewport only when known. Mark missing evidence **Not verified**.

Only perform a keyboard or other interaction check when an authorized method is available and the action is safe and non-consequential. If an action can alter consequential state, or safety/authorization is unclear, do not perform it; mark it **Not verified**.

## Inventory and gate candidate seams

List the in-scope interaction seams before proposing motion—for example, a state change, disclosure, navigation transition, reorder, or progress update. For every candidate, record its evidence and assess these gates in order:

1. **Frequency:** use observed or supplied usage evidence. Repeated, rapid, or keyboard-repeatable actions favor no animation or immediate feedback. Unknown frequency is **Not verified**, not permission to assume rarity.
2. **Purpose:** motion must support feedback, continuity, or hierarchy. Reject decoration, “premium” effect, filler, and motion that merely teaches what static content can communicate.
3. **Speed and fit:** assess travel/amplitude, latency, recurrence, existing project tokens, and interaction context. Defer to supplied tokens and relevant platform guidance; do not prescribe a universal duration or replace project tokens with a fixed timing rule.
4. **Function and accessibility:** motion must preserve the user's task, state clarity, and usable feedback, and honor the existing reduced-motion policy. When relevant, consult [the canonical motion guide](../craft/motion.md) rather than copying its timing tables. If reduced-motion behavior or functional necessity cannot be established, mark that gate **Not verified**.

A candidate survives only when evidence supports a user-serving purpose, a plausible frequency/speed fit, and a reduced-motion-compatible treatment. Otherwise reject it with the failed gate and evidence. “No motion” is a valid and often preferable result. Never recommend animation solely to make an interface feel alive.

## Bound coverage and report

Screen all seams in the named boundary when feasible. If the inventory cannot be completed, state the reviewed subset and mark the remainder **Not verified**; never call a sample exhaustive. Keep the response finite and bounded: report at most five prioritized supported survivors and five representative rejected candidates. Also report counts for seams screened, screened survivors, screened rejections, and unreviewed remainder (or `unknown` when it cannot be counted). Counts apply only to the screened inventory; do not extrapolate to omitted/unreviewed seams or claim they were fully assessed. Group repeated seams only when their cause and required motion decision match. Prioritize by user benefit and evidence, not an invented score.

Return in the current interaction, without automatic report-file persistence:

- **Scope and evidence:** named surface/flow, source-only versus rendered/runtime evidence, and limitations.
- **Coverage:** seams screened, partially screened, and **Not verified**.
- **Coverage counts:** screened seams; screened survivors; screened rejections; unreviewed remainder or `unknown`; do not imply these counts cover omitted seams.
- **Survivors (at most five prioritized):** seam; observed state/path; evidence; purpose; frequency and speed evidence; reduced-motion behavior to preserve; why motion is preferable to no motion.
- **Rejected candidates (at most five representative):** seam; failed gate; evidence-based reason, including decorative purpose, excessive/repeated use, unsupported frequency, or reduced-motion uncertainty. State the total rejection count only for the screened inventory.
- **Verdict:** `OPPORTUNITIES_FOUND`, `NO_SUPPORTED_OPPORTUNITY`, or `INSUFFICIENT_EVIDENCE`, with a concise explanation.

The output is discovery, not a motion specification or implementation request. Do not supply invented timing/easing values, animation code, or a claim that motion was tested. Implementation requires separate scope, authorization, available tools, and verification. This skill creates none of them.
~~~

- **Verification:** Planned implementation checks must confirm the exact `name` fields, trigger descriptions, both full bodies, mandatory core references, and all relative links. From each new skill directory, check `test -f ../craft/anti-ai-slop.md`, `test -f ../craft/state-coverage.md`, and `test -f ../craft/minimalism-discipline.md`. From `better-interface`, additionally check `test -f ../craft/accessibility-baseline.md`, `test -f ../craft/typography.md`, `test -f ../craft/copywriting.md`, `test -f ../interface-design/commands/design-review.md`, and `test -f ../impeccable/SKILL.md`. From `find-animation-opportunities`, check `test -f ../craft/motion.md`. These are future verification only.

### - [x] Task 2: Register the leaves and route only explicit audit requests `[AUTONOMOUS-SHIP]` — completed implementation slice

- **Scope — modify only:** `.agents/INDEX.md`, `.agents/skills/design/SKILL.md`, `.agents/skills/design/README.md`.
- **Consumes:** Task 1's canonical paths and distinctions; observed current lookup rows and router.
- **Produces:**
  1. In `.agents/INDEX.md`'s quick lookup, insert these exact rows immediately after the existing `Audit or strip generic AI design slop` row. Keep the general design, existing review/deslop, and Impeccable rows unchanged:

     | **Explicit multi-domain UI audit** | Read-only existing-interface audit across accessibility, layout, writing, typography, and polish; evidence, coverage, prioritized findings, and verdict | [`.agents/skills/design/better-interface/SKILL.md`](skills/design/better-interface/SKILL.md) |
     | **Motion opportunity discovery** | Read-only scan of existing interaction seams; gate by frequency, purpose, speed, function, and reduced motion | [`.agents/skills/design/find-animation-opportunities/SKILL.md`](skills/design/find-animation-opportunities/SKILL.md) |

  2. In the category count row, replace only the exact row ``| **[`skills/design/`](skills/design/)** | 2 Skills + 67 Presets + 17 Craft References |`` with ``| **[`skills/design/`](skills/design/)** | 4 Skills + 67 Presets + 17 Craft References |``. The count is two current child leaves plus these two proposed children; the suite/router file is not counted as a child skill. Preset/craft counts remain 67/17.
  3. In `.agents/skills/design/SKILL.md`, after the intent-to-style guide introduction and before aesthetic style routing, insert this router paragraph:

     > For an explicitly requested multi-domain audit of an existing interface, use [`better-interface`](better-interface/SKILL.md); a narrow craft/hierarchy review remains [`interface-design/commands/design-review.md`](interface-design/commands/design-review.md), and a broader technical design audit remains [`impeccable`](impeccable/SKILL.md). For explicit read-only discovery of motion opportunities in existing UI, use [`find-animation-opportunities`](find-animation-opportunities/SKILL.md). Routine building, styling, or fixing stays on this suite's existing implementation path. These audit skills do not apply fixes, replace the craft floor, or supply unavailable tools.

     These are links relative to `.agents/skills/design/SKILL.md`. Do not route generic UI implementation requests to the audit leaves.
  4. In `.agents/skills/design/README.md`'s Suite Structure list, insert these exact bullets after the existing interface-design entry and before impeccable:

     - **[`better-interface/`](better-interface/SKILL.md)**: Read-only multi-domain audit of existing UI across accessibility, layout, writing, typography, and polish.
     - **[`find-animation-opportunities/`](find-animation-opportunities/SKILL.md)**: Read-only discovery and evidence-based rejection of existing-UI motion candidates.

     Preserve the existing interface-design, impeccable, craft, and styles descriptions and all counts.
- **Verification:** Future deterministic checks include `grep -Fq` for both link targets in the index, router, and suite README, `grep -Fq '4 Skills + 67 Presets + 17 Craft References' .agents/INDEX.md`, plus `test -f` for the two files created in Task 1. Run `git diff --check -- .agents/INDEX.md .agents/skills/design/SKILL.md .agents/skills/design/README.md` after this task. These checks establish registration text and link-target existence, not automatic invocation or runtime enforcement.

### - [x] Task 3: Refresh the human catalog and prove adoption copies the new leaves `[AUTONOMOUS-SHIP]` — completed implementation slice

- **Scope — modify only:** `README.md`, `tests/adopt-acon-session-ledger.sh`.
- **Consumes:** Task 1 paths and Task 2 registration; current adoption fixture and observed recursive-copy behavior.
- **Produces:**
  1. In `README.md`, update exactly these two count strings, with no other count cleanup:
     - `# 2 Skills + 67 style presets + 17 craft references (interface-design, impeccable, 67 style presets, 17 craft references)` → `# 4 Skills + 67 style presets + 17 craft references (interface-design, impeccable, better-interface, find-animation-opportunities, 67 style presets, 17 craft references)`.
     - `### 🎨 1. Design & UI/UX (\`.agents/skills/design/\` - 2 Skills + 67 Presets + 17 Craft References)` → `### 🎨 1. Design & UI/UX (\`.agents/skills/design/\` - 4 Skills + 67 Presets + 17 Craft References)`.
     Keep 67 and 17 unchanged. In the catalog, add exactly these descriptions adjacent to the existing interface-design/impeccable entries:

     - **`better-interface`**: Read-only, evidence-led existing-interface audit across accessibility, layout, writing, typography, and polish.
     - **`find-animation-opportunities`**: Read-only motion-opportunity discovery; reject unsupported, decorative, high-frequency, or reduced-motion-incompatible candidates.

     Preserve the rest of the human guide, including existing provenance/notice material.
  2. In `tests/adopt-acon-session-ledger.sh`, after the initial adopted catalog assertions near the existing `Pane-pool policy...` check, add exactly these future assertions:

     ~~~bash
     for skill in better-interface find-animation-opportunities; do
       test -f "$TARGET/.agents/skills/design/$skill/SKILL.md"
     done
     grep -Fq 'name: better-interface' "$TARGET/.agents/skills/design/better-interface/SKILL.md"
     grep -Fq 'name: find-animation-opportunities' "$TARGET/.agents/skills/design/find-animation-opportunities/SKILL.md"
     grep -Fq 'Use when explicitly requesting a multi-domain, read-only audit' "$TARGET/.agents/skills/design/better-interface/SKILL.md"
     grep -Fq 'Use when explicitly asking to discover or audit motion opportunities' "$TARGET/.agents/skills/design/find-animation-opportunities/SKILL.md"
     grep -Fq '[anti-slop invariants](../craft/anti-ai-slop.md)' "$TARGET/.agents/skills/design/better-interface/SKILL.md"
     grep -Fq '[interactive-state coverage](../craft/state-coverage.md)' "$TARGET/.agents/skills/design/better-interface/SKILL.md"
     grep -Fq '[minimalism discipline](../craft/minimalism-discipline.md)' "$TARGET/.agents/skills/design/better-interface/SKILL.md"
     grep -Fq '[anti-slop invariants](../craft/anti-ai-slop.md)' "$TARGET/.agents/skills/design/find-animation-opportunities/SKILL.md"
     grep -Fq '[interactive-state coverage](../craft/state-coverage.md)' "$TARGET/.agents/skills/design/find-animation-opportunities/SKILL.md"
     grep -Fq '[minimalism discipline](../craft/minimalism-discipline.md)' "$TARGET/.agents/skills/design/find-animation-opportunities/SKILL.md"
     grep -Fq '[accessibility floor](../craft/accessibility-baseline.md)' "$TARGET/.agents/skills/design/better-interface/SKILL.md"
     grep -Fq '[canonical motion guide](../craft/motion.md)' "$TARGET/.agents/skills/design/find-animation-opportunities/SKILL.md"
     grep -Fq '[`better-interface`](better-interface/SKILL.md)' "$TARGET/.agents/skills/design/SKILL.md"
     grep -Fq '[`find-animation-opportunities`](find-animation-opportunities/SKILL.md)' "$TARGET/.agents/skills/design/SKILL.md"
     grep -Fq '4 Skills + 67 Presets + 17 Craft References' "$TARGET/.agents/INDEX.md"
     test "$(find "$TARGET/.agents/skills/design" -mindepth 2 -type f -name SKILL.md | wc -l | tr -d ' ')" -eq 4
     ~~~

     These additions assert copied documentation and the four-child catalog shape in the existing fixture. They do not parse/invoke skills, prove link semantics beyond the specified existing paths, or establish runtime/UI behavior. Do not add assertions for downloaded text, license rights, Figma, or application outcomes.
- **Verification:** Run `bash -n tests/adopt-acon-session-ledger.sh`, then `bash tests/adopt-acon-session-ledger.sh`; expected final line: `adoption fixture assertions passed`. Run `git diff --check -- README.md tests/adopt-acon-session-ledger.sh`. The fixture's own temporary directory cleanup is its existing behavior; do not add broad cleanup.

## 5. Positive and Negative Acceptance Cases

After separately approved implementation, verify both outcomes for each boundary:

| Case | Expected result |
|---|---|
| User explicitly requests multi-domain audit of existing UI | `better-interface` routes; it reads the three mandatory core references, covers all five domains for the named scope, shows evidence kind/coverage, assigns a supported `[CRITICAL, HIGH, MEDIUM, LOW]` severity without numeric score, and returns an advisory verdict. |
| User asks for a narrow craft/hierarchy review | Existing `design-review` path remains available; the new broad-audit skill does not replace its review bar. |
| User asks to build, style, or fix UI | Existing implementation route and craft floor remain; neither read-only discovery leaf is selected as an implementation procedure. |
| User requests explicit animation implementation | `find-animation-opportunities` does not implement; request a separate implementation assignment. |
| Source-only review without render/browser | Cite available `path:line` evidence, distinguish inference, mark rendered/runtime checks **Not verified**; no visual result is claimed. |
| Supplied screenshot with known/unknown provenance | Use it for direct observations only of its depicted visual state; mark unknown viewport/state provenance **Not verified**, and do not claim interactions, other states, timing, responsiveness, or runtime behavior. |
| Browser/render/keyboard capability unavailable | Continue only with available authorized evidence and report the specific gap **Not verified**; no tool is invented or installed. |
| Interaction is destructive, consequential, or authorization/safety is unclear | Do not perform it; report it **Not verified**. |
| Motion seam is decorative, high-frequency/repeatable, unsupported by evidence, or conflicts with reduced motion | Reject the candidate with the failed gate and evidence; no animation is proposed merely for polish. |
| Motion purpose/frequency or reduced-motion behavior is unknown | Mark the relevant gate **Not verified**; do not count the seam as a supported survivor. |
| Motion inventory exceeds report bounds or cannot be completed | List at most five prioritized survivors and five representative rejections; state screened/survivor/rejection counts and the unreviewed remainder or `unknown`; never claim omitted seams were assessed. |
| Adoption fixture copies ACON into its isolated target | Both leaves and index/router links are present and design leaf count is four; this proves copied text only, not automatic invocation or UI outcomes. |
| Existing behavior and unrelated files | Existing design-review, design/impeccable paths, adoption behavior, and all unrelated working-tree changes remain untouched. |

## 6. Acceptance Criteria and Verification Plan (historical)

This section preserves the original acceptance criteria and planned verifier; checks actually run are recorded in §8. It is not evidence of live invocation or UI outcomes.

1. Before implementation begins, run `test ! -e .agents/skills/design/better-interface/SKILL.md && test ! -e .agents/skills/design/find-animation-opportunities/SKILL.md`; stop if either destination already exists.
2. After implementation, run this Python standard-library-only static check from the repository root. It reads Markdown as text, verifies proposed identifiers/routing and resolves named relative links; it is not a production skill parser or runtime test.

   ~~~bash
   python3 - <<'PY'
   from pathlib import Path

   root = Path.cwd()
   design = root / ".agents/skills/design"
   better = design / "better-interface/SKILL.md"
   motion = design / "find-animation-opportunities/SKILL.md"
   router = design / "SKILL.md"
   index = root / ".agents/INDEX.md"
   suite_readme = design / "README.md"
   readme = root / "README.md"
   adoption_test = root / "tests/adopt-acon-session-ledger.sh"

   b, m = better.read_text(), motion.read_text()
   r, i = router.read_text(), index.read_text()
   sr, hr, at = suite_readme.read_text(), readme.read_text(), adoption_test.read_text()

   assert b.startswith("---\nname: better-interface\n")
   assert m.startswith("---\nname: find-animation-opportunities\n")
   assert 'description: "Use when explicitly requesting a multi-domain, read-only audit of an existing interface across accessibility, layout, writing, typography, and UI polish; not for routine building, styling, or fixing."' in b
   assert 'description: "Use when explicitly asking to discover or audit motion opportunities in an existing interface; read-only analysis, not animation implementation or routine UI work."' in m

   core = (
       "[anti-slop invariants](../craft/anti-ai-slop.md)",
       "[interactive-state coverage](../craft/state-coverage.md)",
       "[minimalism discipline](../craft/minimalism-discipline.md)",
   )
   for skill, text in (("better-interface", b), ("find-animation-opportunities", m)):
       assert "## Required core craft consultation" in text
       for link in core:
           assert link in text
           assert f"grep -Fq '{link}' " in at
           assert f'"$TARGET/.agents/skills/design/{skill}/SKILL.md"' in at
           target = link.split("](", 1)[1][:-1]
           assert (design / skill / target).resolve().is_file(), target

   better_links = (
       "../craft/accessibility-baseline.md", "../craft/typography.md",
       "../craft/copywriting.md", "../interface-design/commands/design-review.md",
       "../impeccable/SKILL.md",
   )
   motion_links = ("../craft/motion.md",)
   for file, text, links in ((better, b, better_links), (motion, m, motion_links)):
       for target in links:
           assert f"]({target})" in text
           assert (file.parent / target).resolve().is_file(), target

   assert "Supplied screenshot/image" in b
   assert "if unknown, mark that provenance **Not verified**" in b
   assert "`CRITICAL`, `HIGH`, `MEDIUM`, or `LOW`" in b
   assert "at most five principal findings" in b
   assert "[`better-interface`](better-interface/SKILL.md)" in r
   assert "[`find-animation-opportunities`](find-animation-opportunities/SKILL.md)" in r
   assert "at most five prioritized supported survivors and five representative rejected candidates" in m
   assert "unreviewed remainder (or `unknown` when it cannot be counted)" in m
   assert "`OPPORTUNITIES_FOUND`" in m and "`NO_SUPPORTED_OPPORTUNITY`" in m
   assert "grep -Fq 'Use when explicitly requesting a multi-domain, read-only audit'" in at
   assert "grep -Fq 'Use when explicitly asking to discover or audit motion opportunities'" in at

   assert "[`.agents/skills/design/better-interface/SKILL.md`](skills/design/better-interface/SKILL.md)" in i
   assert "[`.agents/skills/design/find-animation-opportunities/SKILL.md`](skills/design/find-animation-opportunities/SKILL.md)" in i
   assert "[`better-interface/`](better-interface/SKILL.md)" in sr
   assert "[`find-animation-opportunities/`](find-animation-opportunities/SKILL.md)" in sr
   assert "4 Skills + 67 Presets + 17 Craft References" in i
   assert "4 Skills + 67 style presets + 17 craft references" in hr
   assert "4 Skills + 67 Presets + 17 Craft References" in hr
   for route in (
       "[`better-interface`](better-interface/SKILL.md)",
       "[`find-animation-opportunities`](find-animation-opportunities/SKILL.md)",
   ):
       assert f"grep -Fq '{route}' " in at

   assert len(list(design.glob("*/SKILL.md"))) == 4
   assert len(list((design / "styles").glob("*/DESIGN.md"))) == 67
   assert len([p for p in (design / "craft").glob("*.md") if p.name != "README.md"]) == 17
   print("portable design skill static assertions passed")
   PY
   ~~~
3. Confirm assertions above match the complete proposed skill contents and the exact proposed router/index/catalog snippets. They check static text, relative path existence, and `4/67/17` counts only; no assertion implies a skill was actually invoked or that UI outcomes were observed.
4. Run the complete applicable shell fixture and whitespace check set:

   ~~~bash
   bash -n tests/adopt-acon-session-ledger.sh
   bash tests/adopt-acon-session-ledger.sh
   git diff --check -- \
     .agents/skills/design/better-interface/SKILL.md \
     .agents/skills/design/find-animation-opportunities/SKILL.md \
     .agents/INDEX.md \
     .agents/skills/design/SKILL.md \
     .agents/skills/design/README.md \
     README.md \
     tests/adopt-acon-session-ledger.sh
   ~~~

   Expected success strings: `portable design skill static assertions passed` and `adoption fixture assertions passed`. These deterministic checks prove syntax, whitespace, static content/routing/count assertions, relative path existence, and adoption-copy behavior only. They do not prove skill invocation, live UI accessibility, rendered layouts, keyboard behavior, animation quality, reduced-motion runtime behavior, or automatic enforcement. Any unavailable UI check remains **Not verified**.
5. Preserve unrelated pre-existing status entries identified in §2; future worker reports only the exact plan-authorized file changes. No license verification, commit, publication, adoption outside the existing fixture, or Davao update follows from this plan.

## 7. Scope, Risk, and Approval Boundary

This plan creates only two design leaves and makes the minimum routing/catalog/test adjustments justified by existing observed entry points. It does not claim to make tools or capabilities available. If implementation discovers a name conflict, changed catalog counts, a required file outside the listed scopes, or incompatible existing routing, stop and report the exact conflict before expanding scope. Captain approval of this plan gated implementation; the implementation also received its own bounded assignment. Independent release G8/G9 must still assess the refreshed final diff before any commit/push. No code, skill, adoption script, runtime hook, package, license asset, Davao content, or external source content was added by the tracking-only closeout.

## 8. Execution and Release Readiness

The three checkmarks record implementation-slice completion only—not independent review, publication, or skill invocation. Current catalog counts are four child skills, 67 presets, and 17 craft references.

- **Checks:** Approved-plan static verifier, `bash -n`, adoption fixture, and scoped whitespace check passed (exit 0); logs are in `/tmp/acon-design-skills-release-TSvMSG/preflight/`. These prove static content, syntax, adoption-copy behavior, and whitespace only.
- **Limits and release state:** No live invocation or rendered UI, keyboard behavior, animation quality, or reduced-motion runtime was verified. No commit/push or PM `.agents` / `AGENTS.md` replacement has occurred. Independent release G8/G9 remain pending.
- **Index history:** The earlier editing-task byte guard remains **FAILED/unproven** (recorded hashes `c422fda3ba1b2eddcf15de4435979f0d85ab7c306c0f8b072e7fceac58421c7f` and `35234c8c17b9e8fa013ec52d6eea73e7849627671406cfae5c7c63b27b9acdab`); cause is unknown, with no restoration or historical equivalence claimed. The new release baseline had an empty stage, unchanged HEAD, and stable index; it does not repair or waive that historical result. Refreshed evidence: `/tmp/acon-design-skills-release-TSvMSG/preflight/revision2/`.

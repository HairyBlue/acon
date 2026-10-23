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

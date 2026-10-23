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

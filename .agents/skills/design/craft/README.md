# Design Craft Reference Library

> *Reference materials for anti-slop, research-grounded UI design. Load per task domain — not all at once.*

---

## What This Directory Is

The `craft/` directory contains self-contained reference modules that encode the behavioral rules of high-craft product design. Each file is a domain-specific guide derived from primary research sources, shipped-product conventions, and anti-AI-slop enforcement patterns.

These references do **not** replace visual research — they constrain it. Every design decision must still trace to a real-world reference (product, brand, or screen), a user constraint, or a craft rule in this directory.

**The craft references eliminate the statistical average.** AI defaults converge on indigo, cards everywhere, dark mode, emoji icons, and "calm editorial" layouts because those are the safest centroid of training data. These files name those patterns explicitly and provide the specific rules that break from them.

---

## How to Use

Each file is a **self-contained reference**. Load only the ones relevant to your current task domain — do not load the entire directory on every task.

**Loading protocol:**
1. Always load `anti-ai-slop.md` and `state-coverage.md` for any UI work.
2. Load additional references based on the task domain (see table below).
3. Every major design decision must trace to: a reference, a user constraint, or a rule in these files.

---

## File Index

| File | Domain | When to Activate |
|---|---|---|
| `anti-ai-slop.md` | Anti-pattern detection | **Always** — every UI task |
| `state-coverage.md` | Required component states | **Always** — every interactive surface |
| `color.md` | Color systems, tokens, contrast | Color decisions, palette selection, dark mode |
| `typography.md` | Type scale, leading, weight, tracking | Any typographic decision, font pairing |
| `typography-hierarchy.md` | Hierarchy contracts, rhythm, tension | Multi-level type surfaces, hierarchy design |
| `typography-hierarchy-editorial.md` | Editorial type systems | Long-form content, magazine layouts, editorial pages |
| `motion.md` | Animation, timing, easing, spring physics | Adding or auditing motion and transitions |
| `icons.md` | Icon sizing, style, optical correction | Icon selection, placement, weight matching |
| `copywriting.md` | Microcopy, button labels, errors, hero copy | Writing or auditing any UI text |
| `accessibility-baseline.md` | WCAG 2.2, touch targets, focus, labels | All production UI; form work; compliance checks |
| `form-validation.md` | Validation timing, error wiring, schema | Any form design or input component work |
| `laws-of-ux.md` | Cognitive heuristics, composition rules | Complex layout decisions, information architecture |
| `rtl-and-bidi.md` | RTL layout, bidirectional text, logical properties | Internationalization, Arabic/Hebrew/RTL support |
| `craft-details.md` | Focus states, images, scroll, accessibility details | Final polish pass, production hardening |
| `visual-workflow.md` | Three Visual Directions protocol, visual QA | Visual exploration, new surface design, major redesigns |
| `example-workflow.md` | End-to-end design process walkthrough | Onboarding to the research-first workflow |

---

## Source Credits

These craft references are synthesized from two open-source design reference libraries:

- **[refero_skill](https://github.com/referodesign/refero_skill)** (referodesign, MIT license) — Research-first design methodology, anti-slop patterns, and bundled craft guides for typography, color, motion, icons, copywriting, and visual workflows.
- **[open-design](https://github.com/nexu-io/open-design)** (nexu-io) — Universal craft rules grounded in primary research sources (WCAG, W3C, Material 3, Apple HIG, Baymard Institute, academic research) for accessibility, animation discipline, form validation, state coverage, RTL, laws of UX, and typography hierarchy.

Both sources are adapted and merged here with OD-framework-specific references removed for portability across any agent or toolchain.

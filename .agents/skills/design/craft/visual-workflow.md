# Visual Workflow

Use this reference only when the task needs visual exploration, mockup directions,
or post-build visual QA. Keep the main design workflow research-first:
styles for taste, screens for product patterns, flows for journeys.

---

## Three Visual Directions

Use this only when exploration is useful: variants, a new visual language, major
redesigns, landing pages, or other high-visibility surfaces with several plausible
directions. Do not run it for small edits, obvious component work, or production fixes
with a clear source.

1. Use web search or manual screenshot references for visual inspiration research. [Search web for real product references in this category]
2. Create three distinct reference-locked directions with a primary source, traits to
   preserve, borrowed details, media strategy, and rejects, unless the user asks for a
   different count.
3. For each direction, provide a written direction spec with implementation-ready details.
4. Stop and ask the user to choose. The selected option becomes the visual target for
   build and QA.

**Direction format:**

```text
Direction Name: [Name]
Primary reference: [product/site/style the direction is grounded in]
Visual thesis: [one sentence that characterizes this direction]
Preserve: [3-5 traits from the primary reference]
Borrow: [specific details from secondary references]
Media strategy: [how imagery/illustration/screenshots are handled]
Rejects: [what this direction explicitly refuses from the reference pool]
Token commitments: [color, type, radius, shadow rules]
```

Example:

```text
Direction Name: Precision Canvas
Primary reference: data infrastructure website (editorial monochrome SaaS)
Visual thesis: Evidence-led product page — every element earns its place by communicating value.
Preserve: white canvas, compact sans typography, thin rule lines, product screenshots as evidence
Borrow: editorial type hierarchy from editorial SaaS; generous section spacing from productivity SaaS
Media strategy: real product screenshots framed as evidence, not decoration; fixed-ratio placeholders with labels if unavailable
Rejects: cream/ivory canvas, serif hero, muted clay accents, decorative card grids
Token commitments: white/charcoal canvas, sans-led UI, one muted accent for selected/value states, 8px max radius
```

---

## Visual Target Gate

Before any implementation begins, lock a visual target. You must have one of:

1. **User-provided visual source** — a mockup, screenshot, or design file the user has shared.
2. **Existing product/design-system target** — an agreed-upon component or screen to match.
3. **Selected generated direction** — the user has chosen one of the three directions above.
4. **Reference-locked direction approved for direct build** — written spec agreed upon.

**Never build without a locked target.** "It'll look good" is not a target.

---

## P0/P1/P2/P3 Severity Classification

Use this classification to triage visual QA findings:

| Severity | Description | Examples |
|----------|-------------|---------|
| **P0 — Blocker** | Deviation from the visual target that breaks the design intent or a craft rule | Wrong font family; indigo accent on a non-indigo design; missing state (loading/error/empty) |
| **P1 — Must Fix** | Clear regression from the locked direction; noticeable but not catastrophic | Wrong border radius; slightly off spacing; missing hover state |
| **P2 — Should Fix** | Craft quality issue that doesn't break the target | Tracking not applied to display heading; icon weight mismatch; color opacity slightly off |
| **P3 — Nice to Have** | Refinement opportunity; acceptable to defer | Micro-interaction polish; pixel-level optical adjustment; minor copy tweak |

---

## Asset Lock Format

When research identifies assets (screenshots, images, illustrations) required by the design:

```text
Asset: [name/identifier]
Role: [what this asset communicates — "product evidence", "brand illustration", "data visualization"]
Dimensions: [width × height or aspect ratio]
Content type: [screenshot, photograph, illustration, SVG, chart]
Source: [real asset from product / placeholder required]
Placeholder spec: [if no real asset: fixed ratio + background color + label text]
Art direction: [cropping intent, content focus, any specific framing requirements]
```

**Never leave assets as vague "image here" placeholders.** Every placeholder must have a content type, correct aspect ratio, and art direction.

---

## Visual QA Structured Check

After implementation, run this check against the locked target:

```markdown
## Visual QA Report

**Target:** [Name of the locked visual direction or reference]
**Surface:** [Component or page being QA'd]

### Color & Tokens
- [ ] Canvas color matches target (no unauthorized ivory/cream drift)
- [ ] Accent color matches locked token (no indigo substitution)
- [ ] Accent used ≤2 visible instances per screen
- [ ] No token role drift (accent not used as background/fill)

### Typography
- [ ] Font family matches DESIGN.md / locked direction
- [ ] Display/heading sizes in correct range
- [ ] Display tracking applied (negative for Latin at ≥40px)
- [ ] Body line-height correct; CJK override applied if applicable
- [ ] No ALL CAPS without tracking

### Layout & Structure
- [ ] Grid structure matches reference
- [ ] Spacing scale values on-grid (no 17px/23px values)
- [ ] Cards used only for interactive containers
- [ ] No rounded card + colored left-border combination

### States
- [ ] Loading state present and skeleton matches populated shape
- [ ] Empty state present with CTA
- [ ] Error state present with recovery action
- [ ] All interactive elements have hover/focus/active states

### Media
- [ ] Images have correct aspect ratios
- [ ] All images have width/height attributes set (no layout shift)
- [ ] Placeholder assets have correct content type and art direction
- [ ] Media role preserved — no text-only collapse where imagery was specified

### P0 Blockers Found
[ None ] / [ List here ]

### P1 Issues Found
[ None ] / [ List here ]

### Overall Assessment
[ PASS — Ready for handoff ] / [ BLOCKED — Fix P0s before proceeding ]
```

---

## Research First Protocol

Before visual exploration:

1. **Identify the research tier:**
   - Tier 1 (Quick visual improvement): Search 3–5 real-world references in the same UI category
   - Tier 2 (New surface/landing page): Search 8–12 references across styles, screens, and flows
   - Tier 3 (New product workflow): Full sweep, 15+ references

2. **Synthesize into 3 buckets:**
   - **Visual Direction** — color, type, density, motion character
   - **Product Pattern** — layout, information hierarchy, component conventions
   - **Journey Logic** — how the flow guides the user through the task

3. **[Search web for real product references in this category]** — use web search for live product pages, design showcases, or competitor analysis. No reference = no direction.

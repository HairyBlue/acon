# Example Workflow: SaaS Pricing Page

This walkthrough shows the expected shape of a design process. Replace the example
references with actual results from web research during real work.

Task: design a pricing page for **Northstar**, a B2B analytics product for operations teams.
The page must feel trustworthy, precise, and modern without looking like a generic AI SaaS
template.

---

## Phase 0: Discovery

Brief:

```text
Designing a web pricing page for operations leaders and finance stakeholders.
Goal: help qualified teams choose a plan or contact sales with confidence.
Tone: precise, calm, credible, quietly premium.
Main objection/risk: unclear ROI and fear of enterprise lock-in.
Must remember: pricing feels transparent and tied to operational value.
Constraints: existing product uses dense dashboards; avoid flashy gradients.
Research needed: styles for visual language, screens for pricing structure, flows for upgrade/billing sequence.
```

---

## Phase 1: Styles Research

Start with styles because this is a visual/brand task.

### Style Searches

[Search web for real product references in this category]

Search queries to use:
```text
editorial monochrome SaaS landing page
premium data infrastructure website restrained typography
developer tool website with product screenshots
productivity SaaS with airy spacing
enterprise analytics product marketing
```

Open 3-4 strong style references from real products; full styles are large, so split larger
research into multiple batches.

### Style Findings

| Reference | What It Contributes | What To Adapt |
|-----------|---------------------|---------------|
| Style A: editorial monochrome SaaS | Strong typographic hierarchy, low color, confidence through restraint | Use a mostly neutral palette and crisp type scale |
| Style B: data infrastructure website | Dense technical credibility, grid structure, product screenshot framing | Use structured comparison tables and screenshot panels |
| Style C: productivity SaaS | Airy spacing, friendly trust, softer supporting sections | Add breathing room around plan cards and proof sections |
| Style D: premium fintech/product marketing | Subtle accent discipline, numbers presented with authority | Use exact ROI metrics and restrained accent color |

### Visual Direction Synthesis

Primary foundation: data infrastructure website.

Borrowed details:

- From editorial SaaS: tighter type hierarchy and low color discipline.
- From productivity: more generous section spacing and softer proof blocks.
- From premium fintech: accent color reserved for value proof and selected plan state.

Reference lock:

```text
Primary reference/direction: data infrastructure website.
Preserve: precise grid, compact comparison table, screenshot framing, sans-led UI,
technical confidence, restrained neutral canvas.
Borrow only: editorial type hierarchy, productivity spacing, fintech proof treatment.
Role rules: green proof accent only for selected state/value proof; product screenshot
frames only for evidence; cards use pricing-screen interaction rules, not decoration.
Media strategy: real product screenshots when available; otherwise fixed-ratio screenshot
placeholders with labels and art direction, not fake decorative app mockups.
Reject: cream editorial canvas, serif hero, muted clay/orange accent, decorative cards.
Token commitments: white/charcoal/cool-neutral canvas, sans typography, green proof
accent, 8px max radius, thin borders, product screenshots as evidence.
```

Resulting direction:

```text
A precise, evidence-led pricing page: white canvas, deep charcoal text, compact sans-led
headlines, thin rule lines, quiet plan cards, and exact operational metrics. Use one
muted green accent for value proof and selected actions. Product screenshots should be
framed as evidence, not decoration.
```

---

## Phase 2: Screen Research

Use screens for concrete pricing decisions after visual direction is clear.

### Screen Searches

[Search web for real product references in this category]

Search queries:
```text
pricing page annual monthly toggle
feature comparison table SaaS pricing
usage based pricing enterprise
contact sales pricing page
pricing page ROI calculator
```

### Pricing Screen Decisions

From screen research, make these concrete decisions before coding:

**Decision Ledger:**

| Decision | Source | Rule Applied |
|----------|---------|--------------|
| 3 tiers (not 4) | Reference showing 3-tier converts better for enterprise | Hick's Law — reduce options |
| Annual/monthly toggle at top | Dominant pattern in 8/12 screens reviewed | Jakob's Law |
| "Most popular" badge on middle tier | Seen in 10/12 premium SaaS screens | Von Restorff Effect |
| Feature comparison table below fold | B2B audience is deliberate — needs comparison | Anchoring |
| Contact Sales CTA in enterprise tier | No self-serve for enterprise | User constraint |
| ROI metrics as numbers not percentages | Fintech reference used concrete $ | Copy rule: facts beat adjectives |

---

## Phase 3: Flow Research

Use flows for multi-step journeys — in this case, the upgrade and billing sequence.

[Search web for real product references in this category]

Search queries:
```text
SaaS plan upgrade flow
billing confirmation page
plan comparison to checkout
enterprise contact sales form flow
```

### Flow Decisions

| Step | Decision | Justification |
|------|----------|---------------|
| Click "Start trial" | Opens inline email capture, not redirect | Minimize friction |
| Enter email | Single field, no password at this step | Progressive commitment |
| Confirmation | Show plan summary + immediate next step | Peak-End Rule |
| Upgrade path | In-app upgrade matches pricing page token system | Consistency |

---

## Phase 4: Token Definitions

Before coding, define the complete token set for this page:

```text
Canvas: #ffffff (white)
Surface: #f8f8f8 (selected tier card background)
Border: rgba(0,0,0,0.08) (thin rule lines)
Text primary: #111111 (charcoal)
Text secondary: rgba(0,0,0,0.65) (descriptions)
Text tertiary: rgba(0,0,0,0.45) (metadata)
Accent: #16a34a (green — value proof and selected actions only)
Accent subtle: rgba(22,163,74,0.08) (selected card tint)
Radius: 8px (plan cards), 4px (table cells), 0 (comparison table)
Shadow: none on page; subtle inset on selected card
Typography: Inter, 400/500/600 weights
Display size: 48px / tight tracking (-0.02em)
Body: 16px / 1.6 line-height
Table: 14px / tabular-nums for pricing columns
```

---

## Phase 5: Page Structure

```
[Nav — logo + sign in + start trial CTA]
[Hero — headline + subhead + annual/monthly toggle]
[Pricing cards — 3 tiers, middle highlighted]
[Value proof — 3 metrics with green accent treatment]
[Feature comparison table]
[Customer proof — logos or quote strip]
[FAQ — 4-5 items, accordion]
[CTA — start trial or contact sales]
[Footer]
```

Each section maps to a screen reference. No section is invented without evidence.

---

## Quality Gate Checklist

Before declaring the page complete:

**Research grounding:**
- [ ] Every major visual decision traces to a reference (not model imagination)
- [ ] Primary direction preserved — no drift toward cream/serif/muted accents
- [ ] 3 tiers confirmed against pricing screen patterns

**Anti-slop:**
- [ ] No indigo accent (using green per token lock)
- [ ] No emoji in headings or feature lists
- [ ] Accent used ≤2 visible instances per screen section
- [ ] No invented metrics — all ROI numbers sourced or labeled as placeholder

**Craft:**
- [ ] ALL CAPS tier labels have tracking ≥ +0.08em
- [ ] Tabular-nums applied to all pricing figures
- [ ] Pricing card has loading + empty + error state (e.g., if billing API fails)
- [ ] Annual/monthly toggle has focus-visible state
- [ ] Contact Sales form has proper label + aria-describedby on fields

**Copy:**
- [ ] Hero headline names a specific outcome, not a category
- [ ] CTA labels are verb + object ("Start free trial", "Talk to sales")
- [ ] No "revolutionary", "seamless", "powerful" in any copy
- [ ] Feature comparison uses specific capabilities, not feature names alone

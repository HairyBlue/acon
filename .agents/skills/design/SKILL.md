---
name: design
description: Master design engineering and UI/UX suite. Eliminates generic AI slop by enforcing craft-first interface hierarchy, surface elevation, and design memory, paired with a curated library of 67 aesthetic presets (clean, sleek, bento, brutalism, editorial, etc.). Use whenever designing, building, auditing, or refining user interfaces.
---

# Master Design Suite & Intent Router

> *"AI does not generate bad UI because it lacks CSS knowledge; it generates bad UI because it defaults to statistical averages. Craft begins the moment you stop defaulting and start deciding."*

This suite provides the foundational craft engineering principles needed to make interfaces look deliberately designed by a top product team (Linear, Apple, Vercel, Stripe), combined with **67 pluggable aesthetic style presets** to give every product an intentional, distinctive visual identity.

---

## Architecture: The Three Pillars of Design

```
                     ┌─────────────────────────────────────────────────────────┐
                     │              Master Design Suite (design)               │
                     └────────────────────────────┬────────────────────────────┘
                                                  │
          ┌───────────────────────────────────────┼───────────────────────────────────────┐
          ▼                                       ▼                                       ▼
┌──────────────────────────────┐    ┌──────────────────────────────┐    ┌──────────────────────────────┐
│  Pillar 1: Craft Engineering │    │ Pillar 2: Aesthetic Presets  │    │ Pillar 3: Impeccable Engine  │
│      (interface-design)      │    │           (styles/)          │    │         (impeccable)         │
├──────────────────────────────┤    ├──────────────────────────────┤    ├──────────────────────────────┤
│ • 1 Focal Point Per View     │    │ • Clean (minimal, airy)      │    │ • Design Director Lifecycle  │
│ • Weight > Size Hierarchy    │    │ • Sleek (Linear/SaaS dark)   │    │ • Shape / Init / Critique    │
│ • 60/30/10 Color Rule        │    │ • Bento (modular cards)      │    │ • Audit / Polish / Harden    │
│ • Subtle Surface Elevation   │    │ • Editorial (warm serif)     │    │ • Typeset / Colorize / Animate│
│ • Anti-Slop Verification     │    │ • Ant / Enterprise (dense)   │    │ • Craft Floor Quality Floor  │
│ • Persistent System Memory   │    │ • 67 Curated Style Presets   │    │ • Mechanical Detector CLI    │
└──────────────────────────────┘    └──────────────────────────────┘    └──────────────────────────────┘
```

1. **Pillar 1: Foundational Craft Engineering ([`interface-design/`](interface-design/SKILL.md))**  
   The non-negotiable rules of visual hierarchy, optical sizing, spatial density, depth layering, interaction states, and anti-slop audits.
2. **Pillar 2: Aesthetic Style Presets ([`styles/`](styles/))**  
   The visual identities, color tokens, typography pairings, and component rules across 67 curated design systems.
3. **Pillar 3: The Impeccable Design Director & Engine ([`impeccable/`](impeccable/SKILL.md))**  
   Award-winning design direction, 23 surgical lifecycle sub-commands, mechanical anti-pattern detection CLI (`impeccable detect`), craft floor enforcement (`craft-floor.md`), and live browser steering.



---

## 🧭 Intent-to-Style Routing Guide

When the user or product specification expresses a desired aesthetic, route to the designated style skill:

### 1. "I want a CLEAN design" (Minimalist, Airy, Uncluttered)
- **Primary Preset**: **[`styles/clean/DESIGN.md`](styles/clean/DESIGN.md)**
- **Companions & Variations**:
  - **[`styles/minimal/`](styles/minimal/DESIGN.md)**: Extreme restraint, stark typography, zero ornamentation.
  - **[`styles/spacious/`](styles/spacious/DESIGN.md)**: Generous whitespace, relaxed reading pace, open layouts.
  - **[`styles/basic/`](styles/basic/DESIGN.md)**: Functional simplicity, predictable layouts, accessible defaults.
  - **[`styles/refined/`](styles/refined/DESIGN.md)**: Subtle luxury, understated typography, delicate borders.
- **Visual Hallmarks**: 8pt baseline grid, ample whitespace, limited palette (neutral surface + single focused accent), high legibility (Roboto/Poppins), low cognitive load.

### 2. "I want a SLICK design" (Modern Tech, High-Craft SaaS, Precision)
- **Primary Preset**: **[`styles/sleek/DESIGN.md`](styles/sleek/DESIGN.md)**
- **Companions & Variations**:
  - **[`styles/bento/`](styles/bento/DESIGN.md)**: Bento-grid card layouts, high-contrast badges, visual rhythm.
  - **[`styles/shadcn/`](styles/shadcn/DESIGN.md)**: Contemporary SaaS baseline, zinc/slate neutrals, subtle borders.
  - **[`styles/modern/`](styles/modern/DESIGN.md)**: Dynamic accents, layered surfaces, confident contrast.
  - **[`styles/impeccable/`](styles/impeccable/DESIGN.md)**: Pixel-perfect alignment, micro-interactions, dark elevation.
  - **[`styles/agentic/`](styles/agentic/DESIGN.md)**: AI-native ergonomics, streaming indicators, glowing pulses.
- **Visual Hallmarks**: Desktop-first expressive scale, Inter + JetBrains Mono, 60/30/10 color rule, subtle active press feedback (`scale(0.97)`), whisper-quiet surface steps (+7% lightness in dark mode), ambient drop shadows.

### 3. "I want an ENTERPRISE / DATA-HEAVY design" (High-Density, Pro Tools)
- **Primary Preset**: **[`styles/ant/DESIGN.md`](styles/ant/DESIGN.md)**
- **Companions & Variations**:
  - **[`styles/corporate/`](styles/corporate/DESIGN.md)**: Trustworthy, stable corporate identity, structured grids.
  - **[`styles/enterprise/`](styles/enterprise/DESIGN.md)**: High-scale data grids, bulk actions, clear status badges.
  - **[`styles/professional/`](styles/professional/DESIGN.md)**: Balanced business utility, neutral typography.
  - **[`styles/matrix/`](styles/matrix/DESIGN.md)** or **[`styles/mono/`](styles/mono/DESIGN.md)**: Code-first terminal aesthetic, monospace hierarchy, tabular data.
- **Visual Hallmarks**: Compact padding (12px–16px), dense tables, tabular figures (`tabular-nums`), high information throughput.

### 4. "I want a BOLD / NEO-BRUTALIST design" (High-Contrast, Expressive, Punchy)
- **Primary Preset**: **[`styles/neobrutalism/DESIGN.md`](styles/neobrutalism/DESIGN.md)**
- **Companions & Variations**:
  - **[`styles/bold/`](styles/bold/DESIGN.md)**: Heavy headline weights, saturated contrast, assertive layouts.
  - **[`styles/brutalism/`](styles/brutalism/DESIGN.md)**: Raw, unadorned HTML feel, mono fonts, harsh borders.
  - **[`styles/neon/`](styles/neon/DESIGN.md)**: Cyberpunk dark mode, saturated neon glows, high contrast.
  - **[`styles/power/`](styles/power/DESIGN.md)**: High-energy action branding, dynamic diagonal tensions.
- **Visual Hallmarks**: Thick 2px–3px solid black borders, hard unblurred drop shadows (`shadow-[4px_4px_0px_#000]`), saturated retro accents, bold display type.

### 5. "I want a WARM / EDITORIAL design" (Human, Literary, Thoughtful)
- **Primary Preset**: **[`styles/editorial/DESIGN.md`](styles/editorial/DESIGN.md)**
- **Companions & Variations**:
  - **[`styles/claude/`](styles/claude/DESIGN.md)**: Warm terracotta, calm editorial feel, serif headlines with clean body.
  - **[`styles/cafe/`](styles/cafe/DESIGN.md)**: Earthy tones, organic textures, cozy inviting layout.
  - **[`styles/paper/`](styles/paper/DESIGN.md)**: Print-like paper texture, subtle off-white parchment, ink contrast.
  - **[`styles/terracotta/`](styles/terracotta/DESIGN.md)**: Warm clay hues, Mediterranean terracotta warmth.
- **Visual Hallmarks**: Serif display type (Merriweather, Playfair, Georgia), warm parchment backgrounds (`#FBFBF9`), natural earth accents, generous line height (~1.6).

### 6. "I want a PLAYFUL / CREATIVE design" (Soft, 3D, Nostalgic)
- **Primary Preset**: **[`styles/claymorphism/DESIGN.md`](styles/claymorphism/DESIGN.md)**
- **Companions & Variations**:
  - **[`styles/glassmorphism/`](styles/glassmorphism/DESIGN.md)**: Frosted glass layers, `backdrop-blur`, translucent panels.
  - **[`styles/retro/`](styles/retro/DESIGN.md)**, **[`styles/sega/`](styles/sega/DESIGN.md)**, **[`styles/tetris/`](styles/tetris/DESIGN.md)**: 8-bit/16-bit arcade aesthetics, pixel fonts.
  - **[`styles/doodle/`](styles/doodle/DESIGN.md)**, **[`styles/sketch/`](styles/sketch/DESIGN.md)**: Hand-drawn outlines, whimsical organic asymmetry.
- **Visual Hallmarks**: Rounded pill geometry, multi-layered inset shadows for 3D depth, soft pastel tones.

---

## 💎 The Impeccable Design Director & Engine (`impeccable`)

For advanced UI/UX execution, full-spectrum product design, and rigorous craft polish, activate the **[`impeccable`](impeccable/SKILL.md)** director suite:

- **23 Surgical Lifecycle Sub-Commands:**
  - **Build:** `craft` · `shape` · `init` · `document` · `extract`
  - **Evaluate:** `critique` · `audit` (web & native)
  - **Refine:** `polish` · `bolder` · `quieter` · `distill` · `harden` · `onboard`
  - **Enhance:** `animate` · `colorize` · `typeset` · `layout` · `delight` · `overdrive`
  - **Fix & Iterate:** `clarify` · `adapt` (web & native) · `optimize` · `live`
- **Craft Floor Quality Floor:** Enforces the absolute quality floor and strict anti-pattern bans before every UI edit ([`reference/craft-floor.md`](impeccable/reference/craft-floor.md)).
- **Mechanical Detector CLI:**
  ```bash
  .agents/skills/design/impeccable/scripts/impeccable detect --json <target-files-or-dirs>
  ```
- **Context Bootstrapper:**
  ```bash
  .agents/skills/design/impeccable/scripts/impeccable context
  ```

---

## 🛠️ Mandatory 3-Phase Execution Workflow


Whenever building or refactoring frontend interfaces, follow this 3-phase cycle:

### Phase 1: Intent & Style Selection
1. **Identify the Human & Task**: Who is using this? What is their state of mind?
2. **Select Style Preset**: Choose from the routing matrix above (default to `clean` for productivity apps, `sleek` for developer/SaaS tools, `ant` for data dashboards).
3. **Declare the Single Focal Point**: State out loud what *one* element dominates this view. Demote everything else.

### Phase 2: Craft Construction
1. **Load Tokens**: Read the chosen preset’s `DESIGN.md` for font family, colors, and border radius.
2. **Apply Craft Foundations**:
   - **Weight > Size**: Create hierarchy using weight + color opacity rather than font size alone.
   - **60/30/10 Rule**: 60% dominant neutral canvas, 30% secondary structural surface, 10% intentional accent.
   - **Subtle Elevation**: Use whisper-quiet lightness shifts in dark mode, ambient multi-stop drop shadows in light mode. Avoid harsh, heavy 1px gray borders everywhere.
   - **States for Everything**: Include default, hover, active (`scale(0.97)`), focus ring, and disabled states.
   - **Concentric Radii**: When nesting containers, ensure `outer_radius = inner_radius + padding`.

### Phase 3: Anti-Slop Audit (The Deslop Pass)
Before declaring frontend work complete, run the anti-slop checklist from [`interface-design/commands/design-deslop.md`](interface-design/commands/design-deslop.md):
- [ ] **Squint Test**: Does one thing clearly lead? Or does every box compete equally?
- [ ] **No Monotone Grid**: Did we vary rhythm, grouping related controls tightly and putting air between sections?
- [ ] **No Floating Cards**: Are surfaces grounded and connected to the page layout?
- [ ] **No Template Accents**: Did we eliminate generic unmotivated purple/indigo gradients?
- [ ] **Tabular Numerals**: Are financial, countdown, and metric values set to `tabular-nums`?
- [ ] **Semantic Inputs**: Are form inputs styled and keyboard-accessible, avoiding hand-rolled `<div onClick>`?

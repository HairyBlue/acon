# Typography Guide

Typography is 90% of web design. Get it right and everything else falls into place. Get it wrong and no amount of polish will save you.

---

## 0. Context First

Before choosing fonts, answer these questions:

| Question | Why It Matters |
|----------|----------------|
| **Work tool or marketing?** | Work products need neutrality, not personality |
| **Long reading or scanning?** | Changes line-height and density decisions |
| **B2B, B2C, or Dev tool?** | Affects font character and weight choices |

**Default approach:**

> When in doubt — go denser, simpler, and more neutral. Clarity beats decoration in most product interfaces.

This mindset helps avoid over-designed typography in functional contexts. For branding, editorial, or creative products — different rules apply.

---

## 1. The Safe SaaS Preset

Before customizing anything, this works:

```css
:root {
  --font-family: 'Inter', system-ui, sans-serif;
  --text-base: 16px;
  --line-height: 1.55;
  --scale: 1.2;
  
  --font-weight-normal: 400;
  --font-weight-medium: 500;
  --font-weight-semibold: 600;
  
  --max-width: 65ch;
  
  --text-primary: #111;
  --text-secondary: rgba(0,0,0,0.7);
  --text-tertiary: rgba(0,0,0,0.5);
}
```

**If you use this preset as-is, your typography is already good.** Everything below is refinement.

---

## 2. Type Scale

A consistent scale creates visual rhythm. Pick a ratio, stick to it.

### Common Ratios

| Ratio | Multiplier | Best For |
|-------|------------|----------|
| Minor Second | 1.067 | Dense UI, dashboards |
| Major Second | 1.125 | Compact interfaces |
| **Minor Third** | **1.200** | **General purpose — default choice** |
| Major Third | 1.250 | Marketing, editorial |
| Perfect Fourth | 1.333 | Bold, expressive layouts |
| Golden Ratio | 1.618 | Rare: hero sections only |

> **Note:** Golden Ratio is dramatic. Use only for landing page heroes, not general UI.

| Role | Range |
|---|---|
| Display | 48–72 px |
| H1 | 32–48 px |
| H2 | 24–32 px |
| H3 | 20–24 px |
| Body | 15–18 px |
| Small | 13–14 px |
| Caption | 11–12 px |

### Practical Scale (Minor Third × 16px base)

```
11px  — Caption, footnote
13px  — Small text, metadata
16px  — Body (base)
19px  — Large body, lead
23px  — H4
28px  — H3
33px  — H2
40px  — H1
48px  — Display
57px  — Hero
```

### CSS Tokens

```css
:root {
  --text-xs: 0.6875rem;    /* 11px */
  --text-sm: 0.8125rem;    /* 13px */
  --text-base: 1rem;       /* 16px */
  --text-lg: 1.1875rem;    /* 19px */
  --text-xl: 1.4375rem;    /* 23px */
  --text-2xl: 1.75rem;     /* 28px */
  --text-3xl: 2.0625rem;   /* 33px */
  --text-4xl: 2.5rem;      /* 40px */
  --text-5xl: 3rem;        /* 48px */
  --text-6xl: 3.5625rem;   /* 57px */
}
```

**Rule:** Maximum 6-8 sizes in production. More = chaos.

---

## 3. Font Pairing

**Most successful SaaS products use one font family.** Two fonts adds complexity — make sure it's justified.

### The One-Font Rule

```
One font + multiple weights = professional
Two fonts = requires justification
Three fonts = almost never
```

**When you actually need a second font:**
- Marketing/landing pages (not the app itself)
- Content-heavy products (editorial, documentation)
- There's real art direction, not just "looks nice"

If you don't have a strong reason — one font, different weights.

### If You Must Pair

| Strategy | Example |
|----------|---------|
| Serif + Sans | Instrument Serif + Inter |
| Display + System | Cal Sans + system-ui |
| Mono accent | JetBrains Mono (code) + Inter (UI) |

**Pairing rules:**
1. Contrast in structure — serif with sans, not two serifs
2. Similar x-height — letters feel proportional
3. Intentional contrast — mixing eras (Didot + geometric) can work as a deliberate choice, not an accident

### Safe Font Choices by Product Type

| Product | Font |
|---------|------|
| **SaaS / Tech** | Inter, SF Pro, Geist |
| **Finance / Enterprise** | Inter, IBM Plex Sans |
| **Startup** | Inter, DM Sans, Plus Jakarta |
| **Dev tools** | Inter + JetBrains Mono (code) |

---

## 4. Text Color System

Typography in a vacuum doesn't exist. Most "bad" interfaces look bad because of color, not font choice.

### The System

```css
:root {
  --text-primary: #0B0B0B;      /* 100% — headlines, body */
  --text-secondary: rgba(0,0,0,0.65);  /* 65% — descriptions */
  --text-tertiary: rgba(0,0,0,0.45);   /* 45% — metadata, captions */
  --text-disabled: rgba(0,0,0,0.3);    /* 30% — disabled states (rare) */
}
```

### Rules That Actually Work

- **Never pure black** — Use `#0B0B0B` – `#111`, not `#000`
- **Body text minimum** — Never below 60% opacity for readable text
- **Fewer shades, stable usage** — 3-4 text colors max, used consistently
- **Disabled is rare** — If you have lots of disabled text, redesign

### Anti-pattern

> "Let's make the text lighter for an airy feel"

This almost always destroys readability. If it doesn't pass squint test, it's too light.

### Dark Mode Inversion

```css
[data-theme="dark"] {
  --text-primary: #F5F5F5;
  --text-secondary: rgba(255,255,255,0.7);
  --text-tertiary: rgba(255,255,255,0.5);
}
```

---

## 5. Font Weight

Weight creates hierarchy. Use it deliberately.

### Standard Weights

| Weight | Name | Use |
|--------|------|-----|
| 300 | Light | Large display text only |
| 400 | Regular | Body text, descriptions |
| 500 | Medium | UI labels, subtle emphasis |
| 600 | Semibold | Subheadings, buttons |
| 700 | Bold | Headlines, strong emphasis |

### Rules

- **Body text:** Always 400. Never bold entire paragraphs.
- **Headlines:** 400–700 depending on font. Serifs often look better at 400.
- **UI elements:** 500 for labels, 600 for buttons.
- **Small text:** 400 or 500. Light weights (300) become illegible below 16px.

### Weight + Size Relationship

```
Larger size  → can use lighter weight
Smaller size → needs heavier weight

64px heading → 400 weight looks elegant
12px caption → 400 minimum, 500 preferred
```

**Anti-pattern:** Using bold (700) for everything. It flattens hierarchy.

---

## 6. Line Height (Leading)

Line height (leading) affects readability more than any other property.

### Quick Reference

| Text Type | Line Height | Why |
|-----------|-------------|-----|
| **Body text** | 1.5 – 1.7 | Optimal for reading |
| **Short paragraphs** | 1.4 – 1.5 | Slightly tighter is fine |
| **Headlines** | 1.0 – 1.2 | Tight, impactful |
| **Large display** | 0.9 – 1.1 | Very tight, dramatic |
| **UI text** | 1.2 – 1.4 | Compact but readable |
| **Buttons** | 1 | Single line, centered |

| Text size | Line height |
|---|---|
| Display / H1 (≥32 px) | `1.0`–`1.2` (tight) |
| Body (15–18 px) | `1.5`–`1.6` |
| Small (≤14 px) | `1.5` |

### CSS Tokens

```css
:root {
  --leading-none: 1;
  --leading-tight: 1.15;
  --leading-snug: 1.3;
  --leading-normal: 1.5;
  --leading-relaxed: 1.7;
  --leading-loose: 2;
}
```

### Principles

1. **Longer lines need more leading** — 80+ characters? Use 1.6–1.7
2. **Shorter lines need less** — 40 characters? 1.4 is fine
3. **Headlines are tight** — Multi-line headlines at 1.5 look broken
4. **Sans-serif needs more** — Add 0.1 compared to serif

---

## 7. CJK Line-Height Overrides (Mandatory — Not Optional)

The table above is Latin leading. Latin display type can go to `1.0` because the ascender/descender slack inside the em box keeps lines apart. **CJK glyphs fill the em box**, so the same value makes consecutive lines touch, and multi-line Chinese headlines visibly collide.

| Text size | Latin | CJK |
|---|---|---|
| Display / H1 (≥32 px) | `1.0`–`1.2` | **`1.3`–`1.4`** |
| Body (15–18 px) | `1.5`–`1.6` | `1.7`–`1.8` |

The CJK floor has **no upper size tier**. It applies to every heading level, including the **cover / hero main title** — the single biggest headline on a page's or deck's first slide. A Chinese cover title at 72 px, 96 px, or larger, especially one split into multiple lines with `<br>`, is still CJK display text: set `line-height: 1.3`–`1.4` on it, never the Latin `1.0`–`1.2`. At 96 px a `1.05` leading makes the two lines of a Chinese cover headline visibly collide. **Check the cover main title first** — this is the single most common violation.

Negative tracking is Latin-only for the same reason: CJK is already set on a fixed em grid, so `-0.02em` on a Chinese headline crowds the glyphs instead of tightening the word. Use `0` for CJK display text.

When one artifact mixes both — an English kicker over a Chinese headline is the common case — set the tight Latin values on the Latin element only. Do not inherit them onto the CJK block from a shared parent rule.

---

## 8. Vertical Rhythm

AI-slop is almost always exposed by bad spacing between text blocks.

### The Simple Rule

```
Line-height × 0.5 = minimum vertical spacing step
```

### Example

```
Body: 16px / 1.5 → line-height = 24px
Minimum vertical step = 12px
Spacing scale: 12 / 24 / 48
```

### CSS Implementation

```css
:root {
  --space-xs: 12px;   /* 0.5 × line-height */
  --space-sm: 24px;   /* 1 × line-height */
  --space-md: 48px;   /* 2 × line-height */
  --space-lg: 72px;   /* 3 × line-height */
}
```

### Golden Rule

> **Spacing matters more than font size.**

Two designs with the same fonts but different spacing will feel completely different in quality.

---

## 9. Letter Spacing (Tracking)

The single most-skipped rule in typography.

| Size | Tracking |
|------|----------|
| Display / hero (≥48px) | `-0.02em` to `-0.04em` — tighten |
| H1 / H2 (32–48px) | `-0.01em` to `-0.02em` |
| Body (16–18px) | `0` — never touch |
| Small / caption (11–13px) | `+0.01em` to `+0.03em` — open slightly |
| ALL CAPS labels | `+0.05em` to `+0.12em` — mandatory |

**Rules:**
- Large type set too loose looks amateur
- Small type set too tight becomes illegible
- Body text tracking should never be touched
- ALL CAPS without tracking looks compressed and cheap

**CJK exception:** Do not apply negative tracking to CJK display text. CJK is set on a fixed em grid — negative letter-spacing crowds the glyphs rather than tightening the word.

---

## 10. Measure (Line Length)

| Context | Characters per line |
|---------|-------------------|
| Body copy (reading) | 55–75ch |
| UI labels, secondary text | 30–50ch |
| Short scannable items | 20–35ch |

**The max-width rule:** `max-width: 65ch` on body copy is the universal safe default.

Too wide: eye loses its place at line break.
Too narrow: too many line breaks, choppy reading rhythm.

---

## 11. Anti-Patterns

Common mistakes from OD research and Refero anti-slop work:

- **Size-only hierarchy** — Using font size as the only differentiator. Combine size + weight + color for real hierarchy.
- **Tracking on body text** — Never adjust letter-spacing on 16–18px body copy.
- **CJK at Latin line-height** — `line-height: 1.0–1.2` on Chinese/Japanese headlines causes visible collisions. See §7.
- **ALL CAPS without tracking** — Uppercase labels need `+0.08em` minimum or they look compressed.
- **Two serif/display fonts** — One is usually enough. Two competing display faces creates noise.
- **Regular weight for everything** — Flat hierarchy. Add weight contrast.
- **Bold for everything** — Also flat. Bold must signal emphasis, not be the default.
- **Light (300) below 16px** — Becomes illegible on non-Retina displays.
- **Mixing font families from different eras** without intent — Only works when the contrast is deliberate and references support it.

---

## 12. Responsive Typography

**Fluid type scales** using CSS clamp:

```css
/* Fluid heading — scales between 768px and 1440px viewport */
h1 {
  font-size: clamp(2rem, 4vw + 1rem, 3.5rem);
}
```

**Rules:**
- Use `clamp()` for display/hero headings
- Body text should not scale — 16px is 16px
- Minimum size: never below 15px for body, 11px for captions

---

## 13. Vertical Spacing Between Type Elements

| Between | Space |
|---------|-------|
| Headline → subheadline | 0.5 × headline line-height |
| Subheadline → body | 1 × body line-height |
| Body paragraph → paragraph | 1 × line-height |
| Section → section | 3–5 × line-height |

---

## 14. Accessibility Floor

- Body text: minimum 4.5:1 contrast ratio (WCAG AA)
- Large text (≥24px regular, ≥18.5px bold): minimum 3:1
- Never rely on text color alone to convey state — pair with weight, underline, or icon
- Minimum body size: 14px (15–16px preferred)
- Don't disable user font scaling (`user-scalable=no` on mobile viewport meta)

# Color Guide

Color is the emotional backbone of UI. Get it wrong and your product looks either amateur or AI-generated. Get it right and everything feels intentional.

---

## 0. Context First

Before touching palettes, answer these questions:

| Question | Why It Matters |
|----------|----------------|
| **Product UI or marketing?** | Product: fewer colors, more neutrals, strict semantics. Marketing: more emotion, gradients, contrast allowed. |
| **Data density?** | Dashboards need muted accents, high text contrast, no "glowing" colors. Content-focused UI can be softer. |
| **Is brand defined?** | No brand: use safe preset, refine later. Existing brand: translate brand color into system tokens, don't paint everything with it. |

**Hard rule:**

> When in doubt — fewer colors, more neutrals, stricter purpose. Restraint beats "colorful."

This single rule eliminates 50% of AI-slop before you start.

---

## 1. Color Space

Why most palettes "break" when you try to extend them.

### The Problem with HSL

HSL is intuitive but poorly represents perceptual brightness. A "50% lightness" yellow looks much brighter than "50% lightness" blue. This makes consistent scales nearly impossible.

### The Solution: OKLCH

OKLCH (or LCH) provides perceptually uniform lightness. Steps from 50→950 actually look even.

**Practical workflow:**
- Generate and adjust palettes in OKLCH
- Store production values as hex
- Keep OKLCH logic as source of truth

```css
/* OKLCH example */
--primary-500: oklch(0.55 0.2 250);  /* Base */
--primary-600: oklch(0.48 0.2 250);  /* Hover */
--primary-700: oklch(0.41 0.2 250);  /* Active */
```

**For MVP:** You can skip OKLCH. Use curated palettes (Tailwind, Radix, Open Color). But know why they work.

---

## 2. Palette Structure

You need 4 layers, not "30 beautiful colors."

| Layer | Share of pixels | Tokens |
|---|---|---|
| **Neutrals** | 70–90% | `--bg`, `--surface`, `--fg`, `--muted`, `--border` |
| **Accent** (one) | 5–10% | Primary brand color only — never invent a second accent |
| **Semantic** | 0–5% | `--success`, `--warn`, `--danger` |
| **Effect** | <1% | Gradients, glows; rarely justified |

### 2.1 Neutrals (Most Important)

Neutrals are 70–90% of your UI. This is where you win or lose.

**Requirements:**
- 10-12 steps: 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950
- Slight character (warm or cool), not colorful circus
- Consistent across light and dark themes

**Scale reference:**

| Step | Use | Example |
|------|-----|---------| 
| 50 | Near-white backgrounds | `#fafafa` |
| 100-200 | Surfaces, cards | `#f5f5f5`, `#e5e5e5` |
| 300-400 | Borders, dividers | `#d4d4d4`, `#a3a3a3` |
| 500 | Placeholder text | `#737373` |
| 600-700 | Secondary text | `#525252`, `#404040` |
| 800-900 | Primary text | `#262626`, `#171717` |
| 950 | Near-black | `#0a0a0a` |

**Hard rules:**
- Never use pure `#000` on white as body text
- Don't make text gray "for breathing room" — spacing creates breathing room, not faded text

### 2.2 Primary Accent

One brand color. It should:
- Have good contrast on both white and dark backgrounds
- Have a full scale (50–950), not just one hex
- Be used sparingly and purposefully

**Typical usage:**

| Step | Use |
|------|-----|
| 50-100 | Tinted backgrounds |
| 500-600 | Default state |
| 600-700 | Hover state |
| 700-800 | Active/pressed state |

### 2.3 Semantic Colors

Usually 3-4:
- **Success** — Green (confirmations, completion)
- **Warning** — Amber/Yellow (attention needed)
- **Danger** — Red (errors, destructive actions)
- **Info** — Blue (neutral information) — optional

**Important:** Semantics work through pairs, not single colors.

```css
/* Each semantic needs: */
--success: #16a34a;           /* Icon, text accent */
--success-bg: #f0fdf4;        /* Background */
--success-border: #86efac;    /* Border */
--on-success: #ffffff;        /* Text on solid success */
```

### 2.4 Effects (Only If Needed)

- Gradients
- Glows
- Illustration tints

**Rule:** In product UI, effects should be rare and localized. Save drama for marketing.

---

## 3. Accent Discipline

**Hard cap: max 2 visible uses of `--accent` (or your primary accent CSS variable) per screen.**

The single biggest readability failure in AI-generated UIs is accent overuse. Typical pair:
- one eyebrow / chip + one primary CTA, or
- one accent card + one tab pill.

Pick a pair, not a flood.

Additional rules:
- Links count as accent; demote to `--fg` underline if you also have a CTA on the same screen.
- Hover/focus rings count as accent. Ration accordingly.
- When the brand color clashes at low contrast on a light background, darken the accent to a `600`-level shade for text use; reserve the brand-bright variant for fills only.

---

## 4. The 60/30/10 Rule

Distribution that works for any interface:

| Percentage | Elements |
|------------|----------|
| 60-80% | Neutrals (backgrounds, surfaces, borders) |
| 10-20% | Text hierarchy (different gray levels) |
| 5-10% | Accents and semantics |

### Component Color Limit

**Maximum 2 colors per component.**

If a button has brand gradient + colored border + colored shadow + colored text, it's almost always garbage.

### State Changes: Structure, Not Circus

Hover and Active should be:
- Slightly darker/lighter
- Slightly more contrast
- Subtle shadow enhancement

**Don't** repaint every state with a new random color.

```css
/* Good */
.button {
  background: var(--primary);
}
.button:hover {
  background: var(--primary-hover);  /* Just darker */
}

/* Bad */
.button:hover {
  background: linear-gradient(135deg, #ff6b6b, #feca57);
  box-shadow: 0 0 20px #ff6b6b;
}
```

---

## 5. Contrast and Readability

Not about checking boxes — about actual readability.

### Minimum Requirements

| Text Type | WCAG AA Ratio |
|-----------|---------------|
| Body text (≤16px) | 4.5:1 |
| Large text (18px+ bold, 24px+ regular) | 3:1 |
| UI components, icons | 3:1 |

Run these as gates, not goals. Thresholds are inclusive — exactly 4.5:1 or 3:1 passes. Don't round up: 2.999:1 fails.

### Common Failures

1. **Secondary text too pale** — The #1 issue. If it looks fine on your Retina display at noon, it fails on cheap monitors at 9pm.

2. **Text on tinted backgrounds** — "Almost readable" text on colored backgrounds fails in real conditions (tired eyes, ambient light, older monitors).

### Practical Check

- Test secondary text on multiple devices
- If you squint and text disappears, it's too light
- Ask: "Would my parents read this easily?"

---

## 6. Light and Dark Themes

### The Wrong Way

Inverting colors mechanically: white → black, black → white.

Result: eye-burning contrast, amateur look.

### The Right Way

**Dark theme gets its own neutral scale.**

```css
/* Light */
:root {
  --bg: #ffffff;
  --surface: #f7f7f7;
  --text: #0b0b0b;
  --text-muted: #5f6368;
}

/* Dark — NOT just inverted */
[data-theme="dark"] {
  --bg: #0f0f0f;          /* Not #000 */
  --surface: #1a1a1a;
  --text: #f0f0f0;        /* Not #fff */
  --text-muted: #a1a1a1;
}
```

### Dark Theme Elevation

In dark UI, surfaces and layers communicate through:
- Slightly lighter backgrounds (not shadows alone)
- Subtle border on elevated surfaces
- `box-shadow` with low opacity, not harsh black

Each layer step: +3–5% lightness. Not dramatic, not invisible.

---

## 7. The Indigo/Violet Ban

**Never use indigo/violet as your accent unless the brand explicitly requires it.**

The banned hex values: `#6366f1`, `#4f46e5`, `#4338ca`, `#3730a3`, `#8b5cf6`, `#7c3aed`, `#a855f7`

Why: These are Tailwind's indigo/violet defaults. Every AI model produces them. They are the fingerprint of AI-generated design.

| Instead of | Try | Feeling |
|------------|-----|---------| 
| Indigo `#6366f1` | Blue `#2563eb` | Trust, professional |
| Violet `#8b5cf6` | Teal `#0d9488` | Fresh, distinctive |
| Purple `#7c3aed` | Brand color | Authentic, intentional |

---

## 8. CSS Token System

A production-ready token structure:

```css
:root {
  /* Backgrounds */
  --bg: #ffffff;
  --surface: #f7f7f7;
  --surface-raised: #f0f0f0;

  /* Borders */
  --border: rgba(0,0,0,0.1);
  --border-strong: rgba(0,0,0,0.2);

  /* Text */
  --fg: #0b0b0b;
  --fg-muted: rgba(0,0,0,0.65);
  --fg-subtle: rgba(0,0,0,0.45);

  /* Accent */
  --accent: #2563eb;
  --accent-hover: #1d4ed8;
  --accent-active: #1e40af;
  --accent-subtle: rgba(37,99,235,0.08);

  /* Semantic */
  --success: #16a34a;
  --success-bg: #f0fdf4;
  --warn: #d97706;
  --warn-bg: #fffbeb;
  --danger: #dc2626;
  --danger-bg: #fef2f2;
}
```

**Token discipline rules:**
- Assign each token one role. Never reuse `--accent` for both CTA and decorative fills.
- Semantic tokens (`--success`, `--danger`) are for meaning, not aesthetics.
- Never hardcode hex values in components — always consume tokens.

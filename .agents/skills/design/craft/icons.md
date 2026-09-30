# Icons & Glyphs Guide

In product UI, treat icons as typography — functional, not decorative.

---

## Two Contexts

| Context | Style | Rule |
|---------|-------|------|
| **Product UI** | Clean outline or solid, one consistent set | Predictable, scalable, themeable |
| **Marketing** | Duotone, gradients, illustrative allowed | Never leaks into product |

---

## Icon Sizing

**Canvas** = the bounding box icons are designed within. Most libraries use 24×24px as base, but this is convention, not law.

**Display sizes** depend on context:
- Small (16px): inline with body text, table cells, dense UI
- Medium (20–24px): buttons, nav items, form inputs
- Large (28–32px): feature cards, empty states, marketing

**Stroke weight** varies by library and style:
- Thinner (1.5px): lighter feel, works better at larger sizes
- Standard (2px): common default in Lucide, Heroicons
- Thicker (2.5px+): bolder presence, better at small sizes

**Round vs square caps/joins:** Round feels friendlier, modern. Square feels more technical, precise. Match your product's tone.

**Key principle:** Pick one library or define your own spec. Consistency matters more than specific values.

---

## Optical Corrections

What separates "adequate" from "premium."

**Centering:** Geometric center ≠ visual center.
- Play triangles → shift right 0.5–1px
- Chevrons/arrows → shift toward point
- **Test:** Put icon in a circle. Looks centered? If not, adjust.

**Weight:** Different shapes have different visual mass at same stroke.
- Circles appear lighter than squares
- Diagonals appear thinner than horizontals
- **Aim for equal visual mass**, not equal measurements

---

## Style Consistency

One language per product. No exceptions.

| Style | Best For |
|-------|----------|
| **Outline** | Dense UIs, data-heavy products |
| **Solid** | Consumer apps, clear actions |
| **Variable glyphs** | Design systems (SF Symbols, Material Symbols) |

**Don'ts:**
- ❌ Outline in nav + solid in buttons + duotone in cards
- ❌ Mixing libraries (Lucide + Heroicons = collage)
- ❌ Custom icons that ignore the system's grid/stroke

---

## Icon + Text Pairing

Starting point — adjust based on visual testing:

| Text Size | Icon Size |
|-----------|-----------|
| 14–16px | 16px |
| 16–18px | 18–20px |
| Headings | 20–24px |

**Alignment:** Icons need `align-items: center` + often 0.5–1px manual tweak.

**Weight harmony:** Semibold text + thin icon = mismatched mass. Match perceived visual weight:
- Thin icon (1.5px stroke) → works with regular weight text
- Standard icon (2px stroke) → works with medium/semibold text
- Heavy icon (2.5px+) → works with semibold/bold text

---

## What Counts as an Icon

**Use icons for:**
- Navigation items (when label alone isn't enough)
- Action triggers (especially repeated or dense UI)
- Status indicators (requires color + icon, not color alone)
- Form inputs that benefit from visual affordance (search, password)

**Don't use icons for:**
- Pure decoration (adds visual noise, no cognitive value)
- Replacing copy where copy is clearer
- Headings and section titles (usually unnecessary)
- Every list item regardless of whether it adds meaning

**Emoji are not icons.** Standard emoji (😀🚀💡) in product UI are an AI tell and a craft failure. Use SVG icons, Unicode symbols (→ • ◆ ✓), or nothing.

---

## Icon Libraries (Reference)

| Library | Style | Notes |
|---------|-------|-------|
| **Lucide** | Outline (2px) | Default for most SaaS/product work |
| **Heroicons** | Outline + Solid | Tailwind native, clean |
| **Phosphor** | Outline/Solid/Duotone/etc. | Most flexible weight system |
| **Radix Icons** | Outline, very thin | Pairs well with Radix UI |
| **SF Symbols** | Variable | iOS/macOS native only |
| **Material Symbols** | Variable | Material design native |

Pick one. Mixing is always worse than committing.

---

## Accessibility

- Icons that communicate meaning must have `aria-label` or adjacent text
- Decorative icons: `aria-hidden="true"`
- Icon-only buttons require `aria-label` on the button element
- Never rely on color alone to communicate icon meaning — pair with shape difference or text

```html
<!-- Actionable icon button -->
<button aria-label="Delete file">
  <svg aria-hidden="true">...</svg>
</button>

<!-- Icon + label (preferred when space allows) -->
<button>
  <svg aria-hidden="true">...</svg>
  Delete
</button>

<!-- Pure decoration -->
<svg aria-hidden="true" focusable="false">...</svg>
```

# Anti-AI-Slop Guide

Your design must NOT look AI-generated. AI interfaces converge on the same tired patterns because they optimize for "safe" and "average." Real designers make intentional, contextual choices.

---

## 🚨 THE #1 TELL: INDIGO/VIOLET

Every AI model defaults to indigo/violet (`#6366f1`, `#8b5cf6`, `#7c3aed`). It's the universal fingerprint of AI-generated design.

Why it happens: training data saturated with Tailwind's indigo. LLMs optimize for the average, and indigo IS the average.

**RULE: NEVER use indigo/violet unless the brand explicitly requires it.**

| Instead of | Try | Feeling |
|------------|-----|---------| 
| Indigo `#6366f1` | Blue `#2563eb` | Trust, professional |
| Violet `#8b5cf6` | Teal `#0d9488` | Fresh, distinctive |
| Purple `#7c3aed` | Brand color | Authentic, intentional |

> **Overlap with Cardinal Sins:** This is also Cardinal Sin #1 below. The linter blocks `#6366f1`, `#4f46e5`, `#4338ca`, `#3730a3`, `#8b5cf6`, `#7c3aed`, `#a855f7` as solid accents.

---

## 🚨 THE #2 TELL: CARDS EVERYWHERE

Cards are the second most common AI-slop pattern. AI models wrap everything in rounded-corner boxes with shadows because it feels "safe." Real designers use cards sparingly.

**RULE: Default is NO cards. Use sections, columns, dividers, or media blocks instead.**

Cards are only justified when they are the container for a user interaction (clickable item, form, expandable panel). If removing the border, shadow, background, or radius doesn't hurt interaction or understanding — it's not a card, remove it.

Ask: "Is this a card because the user needs to interact with this container, or because I couldn't think of another way to group things?" If the latter — remove the card.

> **Overlap with Cardinal Sins:** Cardinal Sin #5 specifically flags the "rounded card with a colored left-border accent" — the canonical AI dashboard tile. Drop either the radius or the left border.

---

## 🚨 THE #3 TELL: DARK MODE BY DEFAULT

AI models default to dark backgrounds. Dark-by-default is an AI fingerprint just like indigo.

**RULE: Unless the brief explicitly asks for dark — use light mode.**

Dark mode is a deliberate brand choice, not a default. When a brief says nothing about color mode, light mode is the professional baseline.

---

## 🚨 THE #4 TELL: CALM EDITORIAL SERIF ON AUTOPILOT

Newer models often avoid obvious indigo SaaS slop by switching to another safe template:
warm ivory/cream background, oversized high-contrast serif headline, one italic serif
word, muted olive/clay/terracotta accents, very airy spacing, and "calm editorial"
positioning regardless of the product.

This can be excellent for an editorial brand, cultural product, hospitality site, or
fashion/lifestyle page. It becomes AI slop when applied by default to browsers, dev
tools, enterprise SaaS, fintech, dashboards, or functional product UI without research.

**RULE: Do not use the calm editorial serif + earth-tone pattern unless the product context
and research justify it.**

Before using it, you must be able to explain:
1. Why this product needs an editorial or literary voice.
2. Why a serif display font communicates the brand better than a sans/system face.
3. Why warm ivory, olive, clay, terracotta, or other earth tones fit the audience.
4. Which references support this exact direction.

If you cannot answer those, choose a sharper product-specific direction: technical,
utilitarian, high-contrast, image-led, data-dense, playful, industrial, clinical,
luxury, or another style grounded in research.

Specific fingerprint to avoid: a headline where one word or short phrase is swapped into
a different display/serif/script face, italicized, and/or color-shifted only to create "taste."
The base headline can be serif or sans; the slop is the decorative one-word treatment.
This is now a common AI default. Use contrasting word treatment only when a strong
reference uses it and the content role justifies it: quotation, editorial voice, title
treatment, or a real brand/type-system rule. Otherwise create distinction through layout,
scale, weight, media, interaction, or a source-backed color role.

Serif fonts and earthy palettes are not banned. Autopilot "calm editorial" is.

---

## 🚨 THE #5 TELL: EMOJI AS ICONS

Standard emoji (😀🚀💡🎯) immediately signal "AI-generated." They're a shortcut that makes any design look cheap and unfinished.

**RULE: Never use emoji unless the user explicitly asks for them.**

Use instead: icon libraries (Lucide, Phosphor, Heroicons), Unicode symbols (→ • ◆), SVG graphics. Even a simple text character beats a yellow smiley in a professional UI.

> **Overlap with Cardinal Sins:** Cardinal Sin #3 specifically calls out `✨`, `🚀`, `🎯`, `⚡`, `🔥`, `💡` inside `<h*>`, `<button>`, `<li>`, or `class*="icon"`. Use 1.6–1.8px-stroke monoline SVG with `currentColor`.

---

## 🚨 THE #6 TELL: LEFT ACCENT STRIPE

The colored vertical bar on the left edge of a card (`border-left: 4px solid <accent>`). AI models add it for "visual interest" — but in shipped products this stripe is reserved for elements that carry meaning: callouts, alerts, active list items, status, priority.

**RULE: Only use a side accent stripe when it communicates something — status, priority, owner, or selection. Never as decoration.**

If you can't say in one word what the color means, remove the stripe.

---

## 🚨 THE #7 TELL: REFERENCE AVERAGING

AI models often do real research, then destroy it by averaging strong references into the
safest middle point. This is how a dark workbench, acid-yellow document site, saturated
orange product brand, and serif editorial page become the same warm cream canvas with
muted clay accents.

**RULE: Synthesis means choosing and adapting, not finding the least risky intersection.**

Red flags:
- Dark canvases become cream.
- Acid or saturated accents become muted clay/olive.
- Geometric sans systems become polite serif headlines.
- Sharp/zero-radius UI becomes soft rounded cards.
- Distinctive media or layout becomes generic hero + sections.

When references conflict, choose one primary direction and preserve its signature traits.
Secondary references may contribute 1-2 specific details, but they must not dilute the
primary direction. If you cannot maintain the primary direction's conviction, you have
averaged.

Each direction must hold a clear visual thesis. "Inspired by everything, committed to nothing" is averaging.

---

## 🚨 THE #8 TELL: TOKEN ROLE DRIFT

Using CTA-only accent colors as backgrounds, decorative fills, or hover states. Accents have one job: signal primary action.

**RULE: Check token usage discipline. If a color token assigned to CTA/primary-action appears as a background, decorative fill, or hover state elsewhere — that is token role drift.**

Token roles are contracts, not suggestions. When you assign a color to a role, it means something. Spreading it across unrelated elements destroys the signal and makes the interface feel generic.

---

## 🚨 THE #9 TELL: FAKE GRAPHICS / TEXT-ONLY COLLAPSE

Replacing media (images, charts, illustrations) with text-only layouts "for simplicity." This strips the visual weight that the design depends on.

**RULE: Preserve the media role. If no asset exists yet, use a placeholder with the correct content type — fixed ratio, labeled, art-directed. Do not fake complex imagery with text, decorative boxes, or weak CSS.**

If a reference lock calls for product screenshots, illustrations, or photography, the media presence is part of the design decision, not optional decoration. A text-only collapse destroys the evidence-led structure.

---

## Cardinal Sins (P0 Blockers)

These are the patterns that must be fixed before any UI ships:

1. **Default Tailwind indigo as accent** — exactly `#6366f1`, `#4f46e5`, `#4338ca`, `#3730a3`, `#8b5cf6`, `#7c3aed`, `#a855f7`. Use a brand-defined accent token instead. Indigo is the textbook AI tell.
2. **Two-stop "trust" gradient on the hero** — purple→blue, blue→cyan, indigo→pink. A flat surface + intentional type beats this every time.
3. **Emoji as feature icons** — `✨`, `🚀`, `🎯`, `⚡`, `🔥`, `💡` inside `<h*>`, `<button>`, `<li>`, or `class*="icon"`. Use 1.6–1.8px-stroke monoline SVG with `currentColor`.
4. **Sans-serif on display text when a serif is called for** — h1/h2 must use the design system's display font, not a hardcoded Inter/Roboto/`system-ui`.
5. **Rounded card with a colored left-border accent** — the canonical "AI dashboard tile" shape. Drop either the radius or the left border.
6. **Invented metrics** — "10× faster", "99.9% uptime", "3× more productive". Either pull from a real source or use a labeled placeholder.
7. **Filler copy** — `lorem ipsum`, `feature one / two / three`, `placeholder text`, `sample content`. An empty section is a design problem to solve with composition, not by inventing words.

---

## Soft Tells (P1 — Should Fix)

- **Standard "Hero → Features → Pricing → FAQ → CTA" sequence with no structural variation** — this is the default AI page structure. Break the sequence intentionally with layout disruption, or justify retaining it with a reference that confirms this structure fits the product.
- **Uniform card grid as the primary layout pattern** — every section a 3-column card grid signals that no layout thinking happened. Use grids where grid is the right answer, not as the default.
- **Accent color on links when a CTA also uses the same accent on the same screen** — demote links to `--fg` underline to preserve the CTA's signal.
- **Hero subheading that restates the headline** — one says what it is, the other says what it does. They must not overlap.

---

## Quick Litmus Tests

Run these five tests on any design before declaring it done:

- **Card Test:** Remove border + shadow + background + radius. Does the interaction still work? If yes → not a card, it's a row/section.
- **Image Test:** If every image were replaced with a solid rectangle, would the layout still communicate? If no → image-dependent design (fragile).
- **Brand Test:** Could this design belong to 3 different companies? If yes → not differentiated.
- **Copy Test:** Replace all copy with "Lorem ipsum." Does the hierarchy still hold? If not → hierarchy is copy-dependent.
- **Editorial Test:** Does this feel like it was designed or generated? Trust the gut check.

---

## Safe vs. Intentional Contrasts

| Safe (Slop) | Intentional (Craft) |
|-------------|---------------------|
| Indigo/violet accent | Brand-defined or research-backed hue |
| Cards everywhere | Cards only for interactive containers |
| Dark mode default | Dark mode as explicit brand choice |
| Calm editorial serif + ivory by default | Calm editorial only when research supports it |
| Emoji icons | Monoline SVG, Unicode symbols |
| Left accent stripe as decoration | Left accent stripe to signal status/priority |
| Reference averaging to cream/muted | One primary direction, preserved signature traits |
| Accent used for backgrounds/fills | Accent reserved for CTA/primary action only |
| Text-only collapse | Placeholder with correct content type and aspect ratio |

---

## AI Slop Detector Checklist (18-Point)

Run this before declaring any UI complete:

**Color & Tokens**
- [ ] No indigo/violet (`#6366f1`, `#8b5cf6`, `#7c3aed`) used as accent unless brand-required
- [ ] No two-stop "trust" gradient (purple→blue, blue→cyan, indigo→pink) on hero
- [ ] Accent used in ≤2 visible locations per screen (one eyebrow/chip + one CTA, or equivalent pair)
- [ ] No token role drift — CTA accent not used as background, fill, or hover state elsewhere

**Typography**
- [ ] No emoji in headings, buttons, list items, or icon slots
- [ ] Display font applied to h1/h2 where the design calls for it — not defaulted to Inter/Roboto
- [ ] No decorative one-word serif/italic swap in headlines without research justification

**Layout & Structure**
- [ ] Cards justified by interaction need — not used for grouping alone
- [ ] No rounded card + colored left-border accent combination
- [ ] No uniform card grid as default for every section
- [ ] Media role preserved — no text-only collapse in sections that require imagery

**Copy**
- [ ] No lorem ipsum, "feature one/two/three", or placeholder text in shipped UI
- [ ] No invented metrics without a real source or explicit placeholder label
- [ ] Hierarchy holds with copy replaced by Lorem ipsum

**Research Grounding**
- [ ] Every major visual direction traces to a real-world reference
- [ ] No reference averaging — primary direction preserves its conviction
- [ ] Light mode used unless dark is explicitly required by brief or brand

**Identity**
- [ ] Design cannot plausibly belong to 3 different companies (Brand Test passed)

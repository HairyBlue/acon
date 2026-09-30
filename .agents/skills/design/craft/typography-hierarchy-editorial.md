# Editorial typography hierarchy craft rules

Extends `typography.md` + `typography-hierarchy.md`. Defines hierarchy
behavior for editorial surfaces: long-form articles, magazine layouts,
digital guides, editorial landing pages, and blog posts.

---

## What "editorial" means here

Editorial hierarchy means the pacing is authored the way a print art director
paces a spread: entry point, tension, rest, disruption, resolution. The reader
is moved through content rather than given a uniform reading surface. SaaS
hierarchy is additive — elements stack and each gets its turn. Editorial
hierarchy is compositional — elements are weighted against each other and
some are deliberately suppressed so others can breathe.

---

## Editorial hierarchy principles

### 1. Dramatic scale jumps

Editorial type scales are not gradual. The gap between display and body
is large — often 3–5× — because the display element is not just a heading,
it is a visual event.

| Level | Typical range | Notes |
|---|---|---|
| Display / lede | 56–96 px | (editorial override) May intentionally exceed the default `typography.md` display range |
| Deck / standfirst | 18–24 px | Large jump down — intentional |
| Body | 16–18 px | Close to deck is fine; they're in the same reading register |
| Pull quote | 28–40 px | Disrupts body rhythm; treated as a visual break, not a heading |
| Caption / label | 11–13 px | Minimal — never competes with body |

The gap between display and deck is the editorial signature. A small step
here reads as SaaS, not editorial.

### 2. Whitespace carries hierarchy

Editorial hierarchy is not announced by a heavy heading. It is created by
the space that surrounds an element. An article title in a moderate weight
surrounded by generous whitespace outranks a bold heading crammed against
its content.

Rules:
- Above-the-fold display element: minimum 2× the line-height in space above
  and below before body begins.
- Pull quotes: full column margin on both sides, or break the grid entirely.
- Section breaks: use space as the default hierarchy signal. Separators (rules, dingbats,
  folios, chapter marks) are allowed only when they reinforce publication identity or
  distinguish unrelated content. For RTL layouts, mirror or adapt separators using
  logical directions (inline-start, inline-end) rather than physical (left, right).
- Caption clusters: tighter internal spacing, larger gap from the body above.

### 3. Restrained bold

Editorial systems use weight sparingly. The display element is often set in
a light or regular weight — hierarchy is carried by scale and space, not mass.

Bold in editorial context means: this word/phrase matters beyond the sentence.
It is not used for section labels, UI chrome, or navigation. One to two bold
phrases per 400 words of body copy is a working upper bound.

If everything important is bold, nothing is.

### 4. Display tracking

Negative tracking at large sizes is mandatory for Latin display. At editorial display sizes
(56 px+), tracking should be `-0.02em` to `-0.05em` (editorial override;
see `typography.md` §letter-spacing for the default range). Light display
weights may go tighter within this range.

**Script-aware exception:** For Arabic, Persian, and Urdu (cursive-joining scripts),
keep tracking at `0` — negative letter-spacing breaks cursive joining (see `rtl-and-bidi`).
Hebrew uses logical spacing rules but is not cursive-joining; consult `rtl-and-bidi`
for right-to-left baseline adjustments. Hierarchy in these scripts is carried by
weight contrast, scale, and spatial rhythm — not tracking.

---

## Editorial vs SaaS hierarchy — the key differences

| Property | SaaS / Product | Editorial |
|---|---|---|
| Scale steps | Gradual (1.2–1.25 multiplier) | Dramatic (3–5× gap between display and body) |
| Weight | Semibold/bold for headings | Regular or light for display; bold is rare |
| Spacing | Functional, consistent | Varies by pacing; generous around display element |
| Hierarchy signal | Size + weight (two vectors typical) | Space + scale (mass deliberately suppressed) |
| Grid adherence | Strict | Breaks are intentional hierarchy signals |

---

## Pull quote rules

Pull quotes are not quotation blocks. They are typographic pace breaks.

- Size: 28–40 px (disrupts body rhythm without competing with display)
- Weight: regular or medium — never bold
- Alignment: may break the column grid (full-width, indented, or offset)
- Tracking: `0` or very slightly positive — never negative at this size
- One per section maximum; more reads as visual noise

---

## Byline, date, and label treatment

These elements sit between the display and the body — they are the publication
voice, not the article voice. Keep them quiet:

- Size: 13–14 px
- Weight: regular or medium
- Tracking: +0.03em to +0.08em if using ALL CAPS; otherwise 0
- Color: muted (secondary text token)
- Never compete with the deck or the display element

---

## Multi-column editorial grids

For long-form articles rendered in a multi-column layout:

- Primary column: 55–65ch for the main body
- Pull quotes that span columns should use the full measure of both columns
- Captions: sit within the visual boundary of their image, not the text column
- Do not justify body text — ragged right for screen
- Hyphenation: allowed (`hyphens: auto`) for narrow columns (≤40ch) only

---

## Editorial rhythm checklist

- [ ] Display element has at least 2× its line-height in vertical breathing room
- [ ] Gap between display and deck is ≥ 3× the body font size
- [ ] Bold appears at most twice per 400-word block
- [ ] Display tracking is negative for Latin (−0.02em to −0.05em), zero for CJK/Arabic
- [ ] Pull quote breaks body rhythm visually without competing with display
- [ ] Section breaks use space as the primary signal — separator elements are justified
- [ ] Byline/label elements are visually quiet (secondary text color, 13–14px)

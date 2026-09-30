# RTL and bidirectional craft rules

Universal rules for right-to-left layout and bidirectional text. The
active design system decides brand visual language; this file decides
how that language behaves when the script reads from the right or
mixes direction within a line.

> Grounded in primary sources: Unicode UAX #9 revision 51 (Sept 2025)
> + Unicode 17.0, CSS Logical Properties Level 1, HTML Living Standard
> (`dir`, `<bdi>`), Tailwind v4.0/v4.2 changelogs, W3C alreq,
> Material 3 RTL guidance, Apple HIG internationalization.

## Base direction and language

Every full-page RTL artifact needs `<html dir="rtl" lang="ar">` (or
the matching `lang` for Hebrew, Persian, Urdu). The `lang` attribute
drives font-stack selection, hyphenation, locale-aware speech
synthesis, and search-engine indexing — `dir` alone isn't enough.
Three patterns cover the common cases:

- **Full-page RTL.** `<html dir="rtl" lang="ar">`. Everything inside inherits.
- **Mixed-language subtree.** Nest `<section dir="ltr" lang="en">…</section>` (or vice versa) when an embedded block uses a different script. Code samples, English citations, foreign brand names.
- **User-generated content of unknown direction.** `dir="auto"` on the paragraph. The browser resolves direction from the first strong directional character in the run.

Setting `lang` without `dir` is fine **at the document root in a
default-LTR page** — English doesn't need `dir="ltr"` there because
the bidi base direction is already LTR. Inside any opposite-direction
ancestor, `lang` does not reset the inherited base direction, so set
both `lang` and `dir` on the subtree (`<section dir="ltr" lang="en">`).
Setting `dir` without `lang` is rarely correct — at minimum drop the
appropriate ISO-639 tag in.

## Logical properties first

Hardcoded `left` / `right` is a bug for any layout that might render
RTL. Use logical properties on the inline axis. Use them on the block
axis when the writing-mode varies; physical otherwise.

| Logical | LTR resolves to | RTL resolves to |
|---|---|---|
| `margin-inline-start` / `padding-inline-start` / `inset-inline-start` | left | right |
| `margin-inline-end` / `padding-inline-end` / `inset-inline-end` | right | left |
| `border-inline-start` | border-left | border-right |
| `border-start-start-radius` | border-top-left-radius | border-top-right-radius |
| `text-align: start` / `text-align: end` | left / right | right / left |
| `inline-size` / `block-size` | width / height | width / height |

Browser support: core inline-axis logical properties are Baseline
Widely Available (Chrome 87, Safari 14.1, Firefox 66; ≥95% global as
of 2026-05).

**Tailwind v4 changes the answer for new projects.** v4.0 (2025-01-22)
folded inline-axis logical utilities into core (`ms-*`, `me-*`, `ps-*`,
`pe-*`, `start-*`, `end-*`). v4.2 (2026-02-18) added the block-axis
set (`mbs-*`, `mbe-*`, `pbs-*`, `pbe-*`) and renamed the inset
utilities: `start-*` / `end-*` are deprecated (still work) in favor
of `inset-s-*` / `inset-e-*`. The `tailwindcss-rtl` plugin is obsolete.
Don't write `[dir="rtl"]:` overrides for spacing on Tailwind v4.

## Bidirectional text

UAX #9 rev 51 (Sept 2025) is a version stamp for Unicode 17.0. No
algorithm change; `max_depth = 125` is permanently locked forward.

UAX #9 defines two distinct families of bidi formatting characters
that solve different problems:

- **Isolate controls** (modern, prefer these): U+2066 LRI, U+2067 RLI, U+2068 FSI — opened with these, all closed with U+2069 PDI. An isolated run does not affect, and is not affected by, the surrounding paragraph's bidi resolution. Use FSI when the embedded run's direction is unknown ahead of time.
- **Embedding / override controls** (legacy): U+202A LRE, U+202B RLE, U+202D LRO, U+202E RLO — all closed with U+202C PDF. These nest within the surrounding paragraph rather than isolating from it; LRO/RLO additionally force a direction onto neutral characters. Newer code should use isolates; touch embeddings only when interoperating with text from systems that emit them.

**Use `<bdi>` in HTML; in plain text, pick the isolate that matches
what you know about the run.** UAX #9 §2.7: *"where available, markup
should be used instead of the explicit formatting characters."*
`<bdi>` has been Baseline Widely Available since January 2020.
Reach for control characters only in plain-text contexts (logs,
plain-text emails, terminal output). When you do:

- **LRI U+2066 + PDI U+2069** for known-LTR runs (English name in an Arabic paragraph, code-style identifiers, phone numbers).
- **RLI U+2067 + PDI U+2069** for known-RTL runs (Arabic name in an English paragraph).
- **FSI U+2068 + PDI U+2069** for unknown direction (UGC where the author and language can vary).

Don't reach for FSI as the default — it auto-detects from the first
strong character, which is the wrong choice when you already know
what direction the run should be.

`dir="auto"` on a paragraph or `<bdi>` lets the browser detect
direction from the first strong directional character. Best for
user-generated content where direction isn't known at author time.

## What mirrors and what doesn't

Mirroring isn't universal. The rules below are unanimous across
Material 3 RTL guidance and Apple HIG internationalization.

**Must mirror:**

- Directional arrows (back / forward / next / previous), navigation rail position, tab order, calendar
- Reading-order-dependent icons: text-align icons, paragraph direction icons, list indent/outdent, media controls (play/pause/rewind in a language-dependent player)
- Layout flow: sidebar moves from left to right, primary content from right to left, card leading-edge is now the right edge

**Must NOT mirror:**

- Clocks and clock-face icons (time direction is universal)
- Media playback controls where the content is not language-dependent (a music player's seek bar represents time, not text direction)
- Brand logos and wordmarks
- Numbers, prices, percentages — these render LTR even inside RTL text
- Mathematical expressions
- Phone numbers and codes
- Maps and geographic elements

**Script-specific type notes:**

- Arabic and Persian are cursive-joining scripts. Do not apply negative letter-spacing — it breaks the cursive join between letters. Use `letter-spacing: 0` on Arabic/Persian display text.
- Hebrew is not cursive-joining. Normal letter-spacing rules apply; consult `typography.md` for tracking values.
- CJK characters, while not RTL, fill the em box the same way as Arabic in the block axis. See `typography.md` §CJK.

## Flexbox and Grid in RTL

Flexbox and Grid automatically flip when `dir="rtl"` is on a parent:

- `flex-direction: row` becomes right-to-left flow
- Grid column 1 starts at the right edge
- `justify-content: flex-start` aligns to the right

Use this behavior — don't fight it with physical `left`/`right` values.
When a specific element must stay LTR inside an RTL parent, wrap it in a
`<div dir="ltr">` subtree.

## Icon mirroring

SVG icons that indicate direction (back arrow, next arrow, indent) must mirror in RTL. Use CSS transform:

```css
[dir="rtl"] .icon-directional {
  transform: scaleX(-1);
}
```

Or in Tailwind v4:

```html
<svg class="rtl:scale-x-[-1]">...</svg>
```

Do not mirror non-directional icons (search, settings, notifications).

## Testing RTL

Before shipping any internationalized surface:

- [ ] `<html dir="rtl" lang="ar">` (or appropriate language code) set on full-page RTL artifacts
- [ ] All spacing, padding, margin uses logical properties (`inline-start`, `inline-end`) — no hardcoded `left`/`right`
- [ ] Navigation rail, sidebar, and tab order flipped to right-to-left
- [ ] Directional arrow icons mirrored; non-directional icons unchanged
- [ ] Numbers, prices, phone numbers render LTR inside RTL text
- [ ] Arabic/Persian display text has `letter-spacing: 0`
- [ ] CJK display text (if mixed) uses `line-height: 1.3–1.4` — see `typography.md`
- [ ] `<bdi>` wraps user-generated content of unknown direction
- [ ] Test with: Arabic (RTL cursive-joining), Hebrew (RTL non-joining), mixed Arabic+English inline content

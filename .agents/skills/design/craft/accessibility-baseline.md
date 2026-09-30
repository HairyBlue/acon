# Accessibility baseline craft rules

Universal rules for the legal floor of accessibility plus the craft
commitments that go beyond it. The active design system decides brand
appearance; this file decides which rules an artifact has to clear
before it ships.

> Grounded in primary sources: WCAG 2.2 Understanding pages,
> ISO/IEC 40500:2025, ADA Title II 2024 + 2026 IFR, EN 301 549 v3.2.1,
> WAI-ARIA 1.3 + AccName 1.2 + Core AAM 1.2, WebAIM Million 2026
> (February 2026 crawl), A11yn (arXiv 2510.13914), APCA W3C silver branch.

## Prior art and scope

Existing OSS a11y guidance for AI agents tends to inline a checklist of
WCAG SCs without versioning the legal floor or specifying which
constraints survive on iOS / Android / Flutter. This file scopes
narrower: the compliance floor an artifact must clear, with
jurisdiction notes and native-mobile parity. Heuristic rules and
linter-checked items live in sibling craft files
(`anti-ai-slop.md`, `state-coverage.md`); WCAG SC numbers map to
specific rules below rather than being re-listed.

## The legal floor changes by jurisdiction

- **EU (EAA, enforcement live 2025-06-28):** EN 301 549 v3.2.1 is the OJ-cited harmonised standard; it references **WCAG 2.1 AA**. EN 301 549 v4.1.1 (which incorporates WCAG 2.2's nine new SCs) is OJ-citation-targeted late 2026 / 2027. Until then, EAA references WCAG 2.1. The Web Accessibility Directive (WAD, EU 2016/2102) covers public-sector bodies separately and also points at EN 301 549.
- **US public sector — ADA Title II 2024 final rule:** **WCAG 2.1 AA**. The 2026-04-20 IFR slipped deadlines: 2027-04-26 for jurisdictions with population ≥ 50,000; 2028-04-26 for sub-50,000 and special districts.
- **US federal procurement — Section 508 (Revised 508 Standards):** harmonised with EN 301 549 → references **WCAG 2.0 AA** in the current published rev. The Access Board has WCAG 2.x updates in flight; until they ship, federal IT procurement floor is WCAG 2.0.
- **US private sector — ADA Title III:** no federal regulation specifies a technical standard. Settlements and DOJ guidance routinely cite **WCAG 2.1 AA** as the de-facto target, but the legal mechanism is case-by-case, not rule-based.
- **ISO/IEC 40500:2025** (October 2025) ratified WCAG 2.2 verbatim. Does not by itself change EU or US legal floors.

**Practical rule for craft:** target **WCAG 2.2 AA** as the working
ceiling. It clears the WCAG 2.1 AA legal floor in both jurisdictions
and prepares for v4.1.1. Anything below 2.2 AA is craft debt.

## Color contrast

| Pair | WCAG 2.x AA minimum |
|---|---|
| Normal text below 18 pt regular / 14 pt bold (covers most body and UI text) | 4.5:1 |
| Large text (≥18 *pt* regular ≈24 px, or ≥14 *pt* bold ≈18.5 px) | 3:1 |
| Non-text UI components and graphical objects | 3:1 |
| Focus indicator vs adjacent and unfocused state | 3:1 |

Thresholds are **inclusive** — exactly 4.5:1 or 3:1 passes. Don't round
up: 2.999:1 fails because rounding is not a permitted mechanism.

"Large text" means **18 pt** regular, not 18 px. 18 px regular needs
4.5:1; 14 pt bold (≈18.5 px) qualifies for 3:1, 14 px bold does not.

**APCA as a parallel design check.** APCA's Lc value catches font-weight
and stem-thickness effects that WCAG 2.x luminance ratios miss. Body
copy at Lc ≥60 is a reasonable parallel pass; APCA's actual lookup
table is size- and weight-dependent (heavier weights at larger sizes
clear at lower Lc, thin small text needs Lc ≥75+). APCA is not part
of WCAG, EN 301 549, ADA, or Section 508 compliance as of 2026-05 —
keep WCAG 2.2 AA as the compliance floor and treat APCA as
design-review only.

## Touch targets

| Bar | SC | Size |
|---|---|---|
| AA (legal floor) | 2.5.8 Target Size (Minimum) | **24×24 CSS px** |
| AAA (craft commitment) | 2.5.5 Target Size (Enhanced) | 44×44 CSS px |
| iOS HIG | — | 44×44 pt |
| Material 3 | — | 48×48 dp |

WCAG 2.5.8 lists five exceptions where the 24×24 minimum doesn't
apply: **Spacing** (a 24-CSS-px exclusion circle around the target
doesn't intersect adjacent ones), **Equivalent** (an alternative
control of sufficient size achieves the same function), **Inline**
(target sits inside a sentence, e.g. links in body copy), **User
agent control** (browser default like a native scrollbar), and
**Essential** (the smaller size is required to convey information,
e.g. a map pin). The Spacing exception is the one icon-button
toolbars rely on; the others are narrower than they read and
shouldn't be used to justify undersized primary actions.

## Focus visibility

Removing the focus outline via CSS is a **triple failure**: 1.4.11
Non-text Contrast, 2.4.7 Focus Visible, and 2.4.13 Focus Appearance
(AAA). Use `:focus-visible` for keyboard users; suppress the outline
for mouse clicks only when an alternative non-color affordance exists.

For AAA (2.4.13): indicator area must equal at least a 2 CSS px
perimeter of the component, contrast ≥3:1 between focused and
unfocused states. A 1-px outline at 3:1 doesn't qualify.

## Form input labels

WebAIM Million 2026: **51% of top 1M home pages have at least one missing form-input label; 33.1% of all 6.9M inputs are unlabeled**. The page-level rate moved from 48.2% (2025) to 51% (2026) — missing-label prevalence is one of the few categories explicitly called out as rising in 2026.

Default form-error wiring (WCAG 2.2 + ARIA APG):

```html
<label for="email">Email</label>
<input id="email" type="email" required
       aria-describedby="email-hint email-error"
       aria-invalid="true">
<span id="email-hint">Used for receipts only.</span>
<span id="email-error" role="alert">Email must include @ and a domain.</span>
```

Rules:
- Every `<input>`, `<select>`, `<textarea>` must have a `<label>` (explicit `for`/`id` pair or implicit wrapping).
- `placeholder` is not a label. Screen readers may not announce it; it disappears on focus.
- `aria-label` and `aria-labelledby` are valid when a visible label is not possible, but prefer visible labels.
- `aria-describedby` links additional context (hint text, error messages) to the field.
- `aria-invalid="true"` signals the error state to assistive tech; pair with the visible error.

## Alternative text

- Every meaningful `<img>` needs `alt` text that conveys the image's purpose in context, not just a description.
- Decorative images: `alt=""` (empty string) — never omit the attribute.
- Icon-only buttons: `aria-label` on the button, `aria-hidden="true"` on the SVG.
- Complex images (charts, graphs): `alt` gives a brief summary; a longer description is provided in adjacent text or via `aria-describedby`.

```html
<!-- Meaningful image -->
<img src="dashboard.png" alt="Weekly active users chart showing 12% growth in Q3">

<!-- Decorative -->
<img src="divider.png" alt="">

<!-- Icon-only button -->
<button aria-label="Delete file">
  <svg aria-hidden="true" focusable="false">...</svg>
</button>
```

## Keyboard navigation

- All interactive elements must be reachable and operable with keyboard alone.
- Tab order must follow visual/logical reading order. `tabindex` values greater than 0 are almost always an error.
- Custom interactive widgets (comboboxes, datepickers, sliders, trees) must implement the ARIA Authoring Practices Guide (APG) keyboard patterns.
- Modal dialogs must trap focus inside when open, and return focus to the trigger on close.
- No keyboard trap: users must always be able to move focus away from any element.

## Heading structure

- One `<h1>` per page — it is the page title.
- Heading levels must not skip: `<h2>` follows `<h1>`, `<h3>` follows `<h2>`. An `<h4>` appearing without an `<h3>` is a structure failure.
- Headings are for document structure, not for visual styling. Use CSS for size/weight.
- Screen readers use heading structure as the primary navigation mechanism for the page.

## Color alone

WCAG 1.4.1 (Level A): information conveyed by color alone is a failure. Always pair color with a second signal:
- Error states: red color + error icon + error text
- Required fields: asterisk or "(required)" text, not red label color alone
- Selected/active states: color + underline, border change, icon, or text label

## ARIA landmarks

```html
<header role="banner">...</header>
<nav aria-label="Primary navigation">...</nav>
<main>...</main>
<aside aria-label="Related content">...</aside>
<footer role="contentinfo">...</footer>
```

- Every page must have a `<main>` landmark — screen reader users navigate directly to it.
- Use native HTML elements first: `<nav>`, `<main>`, `<aside>`, `<header>`, `<footer>` carry implicit ARIA roles.
- `aria-label` distinguishes multiple instances of the same landmark type (two `<nav>` elements, two `<section>` elements).

## Checklist

- [ ] Body text ≥4.5:1 contrast; large text ≥3:1; UI components ≥3:1
- [ ] Focus indicator visible on all interactive elements; never removed without replacement
- [ ] Touch targets ≥44×44 CSS px for primary actions (24×24 minimum absolute floor)
- [ ] Every form input has a visible `<label>` (not placeholder-only)
- [ ] `aria-invalid` + `role="alert"` error messages wired on all form fields
- [ ] All `<img>` elements have `alt` attribute (empty string for decorative)
- [ ] Icon-only buttons have `aria-label`
- [ ] All interactive elements keyboard-reachable in logical tab order
- [ ] Modal dialogs trap and return focus
- [ ] Heading levels do not skip
- [ ] Information never conveyed by color alone
- [ ] ARIA landmarks present: `<main>`, `<nav>`, `<header>`, `<footer>`

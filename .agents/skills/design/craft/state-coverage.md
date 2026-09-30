# State coverage craft rules

Universal rules for what every interactive surface must render. The active
design system decides how each state looks; this file decides which states must
exist and what they must contain. The single most reliable AI-design failure
is shipping only the populated state.

> Distilled from WCAG 2.2, NN/g, Material Design 3, Apple HIG, and Baymard
> Institute checkout research.

## The five required states

Every surface that fetches, transforms, or accepts data must render all five.

| State | Triggered when | Must contain |
|---|---|---|
| **Loading** | Data is in flight | Skeleton, spinner, or shell — plus a 15 s "taking longer than expected" fallback |
| **Empty** | No records yet, or query returned nothing | Headline, plain explanation, primary CTA |
| **Error** | Fetch failed, server failure, validation rejection | Plain-language cause, recovery action, preserved user input |
| **Populated** | Data present, primary case | The state the design was actually drawn for |
| **Edge** | Extreme volume, long strings, missing optional fields, RTL or long-word content, partial network | Layout that does not break |

Render-and-screenshot test: every list, table, card, form, and panel in the
artifact has all five. Missing states are the most common silent failure of
AI-generated UI.

**Test matrix.** Concrete edge scenarios the surface must survive:

| Skill type | Edge scenario |
|---|---|
| Dashboard / table | 10,000+ rows, all numeric columns, sort + filter applied |
| Mobile card / list | 200-char title, missing avatar, missing secondary CTA |
| Form | All optional fields empty, all required fields at max length |
| Search results | Single-character query, query with only special chars, 1,000+ result count |
| Detail view | Missing all optional metadata, RTL primary content with LTR embeds |

## Form-specific states

Forms add three states on top of the five.

| State | Triggered when | Behavior |
|---|---|---|
| **Untouched** | Field has not yet had focus | Default styling; no validation messages |
| **Dirty (valid)** | User typed and field passes validation | Persistent helper text remains; no success-coloring |
| **Submitted-pending** | Submit clicked, awaiting server | Submit button enters loading state; fields lock against re-submission |

Validation timing: validate **on blur**, not on first keystroke. For password
and similar live fields, validate on each keystroke *only after the first
blur*. Remove the error message the instant input becomes valid.

## Empty state composition

Empty is not the absence of state. It is its own state with a job.

- **First-use empty** — illustration + headline + value sentence + primary CTA. The empty is the onboarding moment.
- **No-results empty** — echo the query, suggest alternatives, never leave a true blank.
- **Cleared empty** — celebratory phrasing, optional next-action.
- **Error-as-empty** — never. An error is its own state with recovery information; do not collapse error into empty.

**Server-driven vs client-driven.** When a search or query API can return fallback content in the empty payload (suggestions, related categories, popular results), prefer that over a client-side echo. Algolia, Elastic, and most modern search backends support this — the server has more context about what's relevant than the client does.

## Loading state requirements

Loading is not a spinner alone.

- **Skeleton screens** for content that has a predictable shape (cards, rows, text blocks). Match the shape of the populated state — the skeleton is a spatial reservation, not a random grey rectangle.
- **Progressive loading** — show the shell, headers, and navigation immediately; load the data content separately. Don't blank the entire viewport.
- **15-second fallback** — if data hasn't arrived in 15 seconds, show a "taking longer than expected" message with a retry option and preserved context. Never leave the user watching an infinite spinner.
- **Optimistic updates** — for mutations (create, update, delete), apply the change to the UI immediately and roll back on error. Eliminates perceived latency for high-confidence operations.

## Error state requirements

Errors must enable recovery. Every error state must include:

1. **Plain-language cause** — not "Error 500" or "Something went wrong." Say what specifically couldn't complete.
2. **Recovery action** — a button or link for the next step: "Try again", "Go back", "Check your connection".
3. **Preserved user input** — never discard a form on error. The user must be able to correct and resubmit without re-entering everything.
4. **Scoped error placement** — field errors live next to the field; form-level errors live at the top of the form; page-level errors live in a banner or toast. Do not mix scopes.

## Loading time thresholds

| Elapsed | Required response |
|---|---|
| 0–100ms | Instant — no indicator needed |
| 100–300ms | Acceptable — consider a subtle indicator for user confidence |
| 300ms–1s | Spinner or skeleton required |
| 1–2s | Progress indicator if known, otherwise spinner + "Loading..." |
| 2–10s | Skeleton + estimated time if possible |
| >10s | "Taking longer than expected" + retry option + preserved context |

## Interactive state coverage

Every interactive element must define all applicable states. Missing states are craft failures:

| Element | Required states |
|---|---|
| Button (primary) | default, hover, focus-visible, active/pressed, loading, disabled |
| Button (destructive) | default, hover, focus-visible, active, confirmation step |
| Input / textarea | default, focused, filled, error, disabled, read-only |
| Checkbox / radio | unchecked, checked, indeterminate (checkbox only), focus-visible, disabled |
| Toggle | off, on, focus-visible, disabled |
| Link | default, hover, visited, focus-visible, active |
| Card (clickable) | default, hover, focus-visible, active, selected (if applicable) |
| Dropdown / select | default, open, focused option, selected, disabled |

## Checklist

- [ ] Every list, table, card, form, and panel has all five required states
- [ ] Loading state uses skeleton matching the populated shape (not just a spinner)
- [ ] Empty state has headline + explanation + primary CTA
- [ ] Error state has cause + recovery action + preserved input
- [ ] Edge state tested with 200-char strings, missing optional data, RTL content
- [ ] Validation fires on blur — not on first keystroke
- [ ] Error clears the moment input becomes valid
- [ ] 15-second loading fallback exists for all async data fetches
- [ ] Every interactive element has all states defined (hover, focus, active, disabled)

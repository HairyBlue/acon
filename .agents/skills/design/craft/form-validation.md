# Form validation craft rules

Universal rules for form validation lifecycle, error wiring beyond the
accessibility baseline, and the schema-as-contract layer that makes
the same validation work on the server and the client. The active
design system decides how the field looks; this file decides *when* the
field tells the user it's wrong, *how* the error reaches assistive
tech, and *where* the rule lives.

> Grounded in primary sources: WHATWG HTML Living Standard
> (Constraint Validation section under "Form control infrastructure"),
> CSS Selectors L4 (`:user-invalid`), WCAG 2.2 SC 3.3.x
> Understanding pages, ARIA APG forms patterns, Standard Schema spec
> (`@standard-schema/spec`), Baymard 2024 inline-validation research
> checkout-UX benchmark, WebAIM Million 2026 forms findings.

## Prior art and scope

Existing OSS forms guidance for AI agents pins to one layer at a time.
This file connects the four layers a real form spans: **WHATWG Constraint Validation as the platform floor, validation timing as a state machine on the input, WCAG 3.3.x as the announcement and recovery contract, schema as the cross-stack truth.** A11y wiring lives in `accessibility-baseline.md` (label + describedby + invalid + `role="alert"` for inline errors); this file picks up where that ends.

## The input state machine

Every input passes through these states. The names trace back to RHF /
Formik vocabulary on web; the *shape* applies regardless of stack.
Drive error chrome off the state, not off raw `:invalid` or
focus/blur booleans.

| State | Meaning | UI |
|---|---|---|
| `pristine` | User has not interacted | No error chrome, no green check |
| `dirty` | User has typed but not committed (still focused) | No error chrome yet |
| `touched` | User has blurred at least once after editing | Field-level constraint runs |
| `invalid-after-touched` | Constraint failed after blur | Show error, link via `aria-describedby` |
| `invalid-after-submit` | Submit attempted, field still invalid | Same plus focus management to summary or first invalid field |
| `recovering` | User editing an already-invalid field | Re-validate on `input`, not on next blur |
| `submitting` | Action in flight | Disable submit, announce status via a polite live region |
| `server-error` | Server returned an error for this field | Use server's message text; treat as `invalid-after-submit` |

Decision rule that collapses validation-timing debates: errors appear
on transition into `invalid-after-touched`, clear on transition out
of any invalid state, and never appear from `pristine` or plain
`dirty`. CSS `:user-invalid` matches the `invalid-after-touched` /
`invalid-after-submit` states for free.

## Validation timing

Baymard's checkout-UX benchmark (2024 inline-validation article):
**31% of sites have no inline validation, and most of the rest fire
too early.** The participant quote that anchors the research: *"Why
are you telling me my email address is wrong, I haven't had a chance
to fill it all out yet?"* Premature firing is the loudest UX failure
in this space.

The four rules:

1. **First blur after edit** runs the field-level constraint. Not on focus, not on first keystroke, not on every keystroke.
2. **Once a field is invalid, switch to `input`-event re-validation** so the error clears the moment input becomes valid. Don't make the user blur again to dismiss it.
3. **On submit**, run the schema parse. Move focus to the error summary at the top of the form (a heading-led container with `tabindex="-1"`, no `role="alert"` — see the wiring section), or to the first invalid field if no summary exists. Don't move focus on every keystroke.
4. **Async checks** split into two paths. *Background preflight* (uniqueness while typing, address lookup) debounces 250-500 ms, announces via a polite live region, and never gates typing or keeps the submit button disabled indefinitely. *Authoritative server validation on submit* is different: the submit path must await the server's response and surface field errors from it, since the server is the truth. Don't conflate the two — the rule is "don't let a slow background check freeze the form," not "don't ever wait for the server."

CSS gets you most of timing rule 1 for free: style off `:user-invalid`
not `:invalid`. The `:user-invalid` selector is Baseline Newly
available 2023 (Chrome 119, Firefox 88, Safari 16.5) and matches only
after the user has either submitted the form or blurred the field with
bad input.

## Constraint Validation API as the platform floor

Native HTML constraints are not an alternative to JS validation; they
are the substrate the rest of the layers run on. They survive JS
failure, they integrate with autofill, and they are what
`reportValidity()` and screen-reader native announcements key off.

```html
<input type="email" name="email" required>
```

Use these declaratively for every field that has them: `required`,
`type` (email, url, number, tel), `pattern`, `min`/`max`,
`minlength`/`maxlength`, `step`. Cross-field rules and dynamic
constraints go through `setCustomValidity()` on both `input` and
`change` events — autofill flows historically fired one without the
other on some browsers, so listening on both is the cheap defense.

Rules of the API:

- **Empty string clears `setCustomValidity`.** Not `null`, not no-arg.
- **`form.requestSubmit()` honors validation; `form.submit()` skips it.** Never call the second.
- `disabled` controls are barred from validation and not submitted.
- `inputmode` is a virtual-keyboard hint, **not** validation. `<input type="text" inputmode="numeric" pattern="[0-9]*">` is the recommended shape for ZIPs / OTPs / card numbers; `pattern="[0-9]*"` is the historical iOS-Safari trigger for the numeric keypad on top of `inputmode`. `type="number"` adds spinners, strips leading zeros, applies locale-decimal handling, and varies field width across browsers — wrong for any of these.

## Error wiring beyond the baseline

The default error pattern in `accessibility-baseline.md` (`<label>` +
`aria-describedby` + `aria-invalid` + `role="alert"`) covers WCAG
3.3.1 / 3.3.2. Three additions matter for real forms:

**Adaptive error messages.** Baymard 2023: 98% of audited sites use
generic catch-all errors ("Provide a valid phone number") rather than
the specific error ("Phone number must be 10 digits — no spaces or
dashes"). The constraint violation type is available from the
`ValidityState` object; branch on it:

```js
function getEmailError(input) {
  if (input.validity.valueMissing) return 'Email is required.';
  if (input.validity.typeMismatch) return 'Enter a valid email address (e.g. you@example.com).';
  if (input.validity.tooLong) return `Email must be under ${input.maxLength} characters.`;
  return 'Check your email address.';
}
```

**Error summary on submit.** When a form has multiple fields and the
user submits with errors, render a summary at the top of the form:

```html
<div role="group" aria-labelledby="error-heading" tabindex="-1">
  <h2 id="error-heading">There are 2 errors in this form</h2>
  <ul>
    <li><a href="#email">Email: Enter a valid email address</a></li>
    <li><a href="#phone">Phone: Must be 10 digits</a></li>
  </ul>
</div>
```

Move focus to this container after submit. The `tabindex="-1"` makes it focusable programmatically without putting it in the tab order.

**Server error surfacing.** Server errors returned after submit must be
wired back to their fields, not just shown in a toast. Use the same
`aria-describedby` + `aria-invalid` pattern. Treat server errors as
`invalid-after-submit` state — the field re-enables but stays invalid
until the user corrects it.

## Schema as cross-stack truth

The same validation rule should not exist twice — once in JS for the UI
and once on the server. Use a shared schema library:

```ts
// Zod example — shared between client and server
const emailSchema = z.string().email('Enter a valid email address');

// Client: run on blur
const result = emailSchema.safeParse(inputValue);
if (!result.success) showError(result.error.issues[0].message);

// Server: run on request body
const parsed = emailSchema.safeParse(req.body.email);
if (!parsed.success) return res.status(400).json({ errors: parsed.error.flatten() });
```

**Standard Schema** (`@standard-schema/spec`) provides a framework-agnostic interface so Zod, Valibot, ArkType, and other schema libraries can be swapped without rewriting the validation consumer.

## Password fields

- Never show password strength meters before the user has typed anything.
- Show strength as the user types, after the first character.
- Strength meter: use a visual bar + text label ("Weak", "Fair", "Strong") — not color alone.
- Allow paste into password fields (WCAG 1.3.5, also basic usability).
- `autocomplete="new-password"` for signup; `autocomplete="current-password"` for login.
- Show/hide toggle: `<button type="button" aria-label="Show password">` that toggles `type` between `"password"` and `"text"`.

## Checklist

- [ ] Validation fires on first blur — not on first keystroke, not on every keystroke
- [ ] Invalid fields switch to `input`-event re-validation immediately (error clears as user corrects)
- [ ] On submit: focus moved to error summary or first invalid field
- [ ] Error messages are field-specific, not generic catch-all text
- [ ] `aria-invalid="true"` + `aria-describedby` wired on all invalid fields
- [ ] Error summary rendered at top of form with `tabindex="-1"` on submit with multiple errors
- [ ] Server errors surfaced back to their fields (not toast-only)
- [ ] Native HTML constraints used declaratively (type, required, pattern, min, max, minlength, maxlength)
- [ ] `setCustomValidity()` called on both `input` and `change` events for custom rules
- [ ] `form.requestSubmit()` used — never `form.submit()`
- [ ] Password fields: allow paste, have show/hide toggle, strength shown after first character
- [ ] Async background checks debounced ≥250ms; don't gate typing or disable submit indefinitely

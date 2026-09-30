# Craft Details Guide

Implementation details that separate polished products from rough ones. Most AI models miss these.

---

## 1. Focus States

Focus states are for keyboard navigation. Get them wrong and your app feels broken.

### The Rule: `:focus-visible`, Not `:focus`

```css
/* ❌ Shows focus ring on mouse click — annoying */
.button:focus {
  outline: 2px solid var(--primary);
}

/* ✅ Shows focus ring only on keyboard navigation */
.button:focus-visible {
  outline: 2px solid var(--primary);
  outline-offset: 2px;
}
```

**Why:** `:focus` triggers on any focus (including mouse click). `:focus-visible` only triggers when user is navigating with keyboard.

### Never Remove Focus Without Replacement

```css
/* ❌ NEVER — breaks keyboard navigation */
.button:focus {
  outline: none;
}

/* ✅ Replace default with custom visible focus */
.button:focus-visible {
  outline: none;
  box-shadow: 0 0 0 2px var(--bg), 0 0 0 4px var(--primary);
}
```

### Compound Controls: `:focus-within`

For groups where focus on any child should highlight the parent:

```css
/* Search input with icon */
.search-wrapper:focus-within {
  border-color: var(--primary);
  box-shadow: 0 0 0 3px var(--primary-tint);
}
```

---

## 2. Forms

Forms are where users struggle most. These details reduce friction.

### Input Types and Attributes

```html
<!-- ✅ Correct types trigger right keyboard on mobile -->
<input type="email" inputmode="email" autocomplete="email">
<input type="tel" inputmode="tel" autocomplete="tel">
<input type="url" inputmode="url">
<input type="number" inputmode="numeric">

<!-- ✅ Meaningful names help password managers -->
<input name="email" type="email" autocomplete="email">
<input name="password" type="password" autocomplete="current-password">
<input name="new-password" type="password" autocomplete="new-password">
```

### Autocomplete Matters

| Field | `autocomplete` value |
|-------|---------------------|
| Email | `email` |
| Password (login) | `current-password` |
| Password (signup) | `new-password` |
| Name | `name` |
| Phone | `tel` |
| Address | `street-address` |
| Credit card | `cc-number`, `cc-exp`, `cc-csc` |
| Non-auth fields | `off` (prevents password manager triggers) |

### Never Block Paste

```jsx
/* ❌ NEVER — accessibility violation, user hostile */
<input onPaste={(e) => e.preventDefault()} />

/* ✅ Let users paste */
<input />
```

### Disable Spellcheck Where Appropriate

```html
<!-- Spellcheck off for: emails, codes, usernames, URLs -->
<input type="email" spellcheck="false">
<input name="username" spellcheck="false">
<input name="verification-code" spellcheck="false">
```

### Labels and Hit Targets

```html
<!-- ✅ Clickable label (explicit) -->
<label for="email">Email</label>
<input id="email" type="email">

<!-- ✅ Clickable label (implicit) -->
<label>
  Email
  <input type="email">
</label>

<!-- ✅ Checkbox: label + control share single hit target -->
<label class="checkbox-wrapper">
  <input type="checkbox">
  <span>Accept terms</span>
</label>
```

```css
/* No dead zones between checkbox and label */
.checkbox-wrapper {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
}
```

### Placeholder Formatting

```html
<!-- ✅ Placeholders end with … and show format -->
<input placeholder="name@company.com…">
<input placeholder="(555) 123-4567…">
<input placeholder="Search products…">
```

### Submit Button States

```jsx
/* ✅ Button enabled until request starts, then shows spinner */
<button 
  type="submit" 
  disabled={isSubmitting}
>
  {isSubmitting ? <Spinner /> : 'Save Changes'}
</button>
```

### Error Handling

```jsx
/* ✅ Errors inline, focus first error on submit */
<form onSubmit={handleSubmit}>
  <input 
    ref={emailRef}
    aria-invalid={errors.email ? 'true' : 'false'}
    aria-describedby={errors.email ? 'email-error' : undefined}
  />
  {errors.email && (
    <span id="email-error" role="alert">
      {errors.email}
    </span>
  )}
</form>
```

### Unsaved Changes Warning

```js
// Warn before leaving with unsaved changes
useEffect(() => {
  const handleBeforeUnload = (e) => {
    if (hasUnsavedChanges) {
      e.preventDefault();
      e.returnValue = '';
    }
  };
  window.addEventListener('beforeunload', handleBeforeUnload);
  return () => window.removeEventListener('beforeunload', handleBeforeUnload);
}, [hasUnsavedChanges]);
```

---

## 3. Images

Images are the #1 cause of layout shift (CLS). Fix them.

### Always Set Dimensions

```html
<!-- ❌ Causes layout shift as image loads -->
<img src="photo.jpg" alt="Product">

<!-- ✅ Reserves space, no layout shift -->
<img src="photo.jpg" alt="Product" width="400" height="300">
```

### Loading Strategy

```html
<!-- Above the fold: load immediately -->
<img src="hero.jpg" fetchpriority="high" alt="Hero">

<!-- Below the fold: lazy load -->
<img src="feature.jpg" loading="lazy" alt="Feature">
```

### In React/Next.js

```jsx
// Critical hero image
<Image
  src="/hero.jpg"
  alt="Hero"
  width={1200}
  height={600}
  priority
/>

// Below the fold
<Image
  src="/feature.jpg"
  alt="Feature"
  width={400}
  height={300}
/>
```

### Aspect Ratio Containers

```css
/* Prevents layout shift for dynamically sized images */
.image-container {
  aspect-ratio: 16 / 9;
  overflow: hidden;
}

.image-container img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
```

---

## 4. Scroll

Scroll details that most interfaces get wrong.

### Scroll-Based State

```js
// Attach header shadow on scroll
useEffect(() => {
  const handleScroll = () => {
    setIsScrolled(window.scrollY > 10);
  };
  window.addEventListener('scroll', handleScroll, { passive: true });
  return () => window.removeEventListener('scroll', handleScroll);
}, []);
```

### Smooth Scroll

```css
/* Only if user hasn't requested reduced motion */
@media (prefers-reduced-motion: no-preference) {
  html {
    scroll-behavior: smooth;
  }
}
```

### Scroll to Error

```js
// On form submit error, scroll first error into view
const firstError = document.querySelector('[aria-invalid="true"]');
firstError?.scrollIntoView({ behavior: 'smooth', block: 'center' });
firstError?.focus();
```

---

## 5. Overflow and Text

### Text Overflow

```css
/* Single line truncation */
.truncate {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* Multi-line clamp */
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
```

### Long Words

```css
/* Prevent layout break from long URLs or words */
.content {
  overflow-wrap: break-word;
  word-break: break-word;
}
```

---

## 6. Numerical Displays

### Tabular Numerals (Critical)

Always use `font-variant-numeric: tabular-nums` for:
- Financial data and prices
- Metrics and counters
- Timers and countdowns
- Any column of numbers that should align vertically

```css
.price, .metric, .counter, .timer {
  font-variant-numeric: tabular-nums;
}
```

**Why:** Proportional numerals (the default) have variable widths. "1" is narrower than "8." In a column of prices, this causes misalignment even when the decimal points are CSS-aligned. Tabular numerals are fixed-width, so columns align naturally.

---

## 7. Touch and Mobile

### Prevent Tap Highlight on Custom Elements

```css
/* Remove default tap flash on mobile */
button, a, [role="button"] {
  -webkit-tap-highlight-color: transparent;
}
```

### Safe Area Insets (Notch Support)

```css
/* Respect notch/island on iOS */
.bottom-nav {
  padding-bottom: env(safe-area-inset-bottom);
}

.header {
  padding-top: env(safe-area-inset-top);
}
```

---

## 8. Tooltips

Tooltips that actually work:

```jsx
// ✅ Tooltip with delay and keyboard support
<Tooltip
  content="Delete this file permanently"
  delay={300}
>
  <button aria-label="Delete file">
    <TrashIcon />
  </button>
</Tooltip>
```

**Rules:**
- Delay 200–400ms on hover (prevents tooltip spam during mouse movement)
- Always visible on keyboard focus (no delay)
- Never required for interaction — always supplementary
- Content: one sentence max, no HTML formatting

---

## 9. Loading States

Details that make loading feel fast:

```jsx
// ✅ Skeleton that matches the loaded content shape
function UserCardSkeleton() {
  return (
    <div className="animate-pulse">
      <div className="h-10 w-10 rounded-full bg-gray-200" />
      <div className="mt-2 h-4 w-32 rounded bg-gray-200" />
      <div className="mt-1 h-3 w-24 rounded bg-gray-200" />
    </div>
  );
}
```

**Rules:**
- Skeleton shape must match the loaded content
- Use `animate-pulse` or similar gentle animation
- Never just a spinner for content with a known shape
- Show skeleton immediately (no delay before skeleton appears)

---

## 10. Error Boundaries

```jsx
// ✅ React error boundary for graceful degradation
class ErrorBoundary extends React.Component {
  state = { hasError: false };
  
  static getDerivedStateFromError() {
    return { hasError: true };
  }
  
  render() {
    if (this.state.hasError) {
      return (
        <div role="alert">
          <h2>Something went wrong</h2>
          <button onClick={() => this.setState({ hasError: false })}>
            Try again
          </button>
        </div>
      );
    }
    return this.props.children;
  }
}
```

---

## 11. Semantic HTML Quick Reference

AI slop frequently uses `<div>` for everything. The correct element:

| Use case | Element |
|----------|---------|
| Navigation menus | `<nav>` |
| Page sections | `<section>`, `<article>`, `<aside>` |
| Page header/footer | `<header>`, `<footer>` |
| Main content area | `<main>` |
| Clickable actions | `<button>` |
| Navigation links | `<a href>` |
| Data tables | `<table>`, `<th>`, `<td>` |
| Form groups | `<fieldset>` + `<legend>` |
| Definition lists | `<dl>`, `<dt>`, `<dd>` |
| Code | `<code>`, `<pre>` |
| Quotes | `<blockquote>`, `<q>` |
| Time | `<time datetime="...">` |
| Keyboard input | `<kbd>` |

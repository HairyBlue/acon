# Motion & Micro-interactions Guide

Motion in product UI serves three purposes. If an animation doesn't do at least one—remove it.

1. **Feedback** — "I pressed this and it worked"
2. **Continuity** — "Here's where the element went and where it came from"
3. **Hierarchy** — "Look here, this is important"

---

## 0. Context First

Before adding motion, answer these questions:

| Question | Why It Matters |
|----------|----------------|
| **Product UI or marketing?** | Product: subtle, fast, functional. Marketing: more expressive allowed. |
| **How often is this triggered?** | High-frequency (hover, typing): faster. Low-frequency (modal open): can be slower. |
| **Does this help or distract?** | If you can't justify the animation's purpose—don't add it. |

**Hard rule:**

> When in doubt — shorter, subtler, or none. Motion that doesn't serve function is noise.

---

## 1. When Motion Earns Its Place (Research Basis)

Tversky/Morrison/Bétrancourt's 2002 meta-analysis (IJHCS 57, pp. 247–262) found that every study claiming animation aids comprehension had a broken control — the static version had less information, different procedures, or hidden interactivity. When equalised, animation does **not** beat static for teaching complex systems. The single use case the paper endorses is real-time spatial or temporal reorientation: page transitions, container morphs, viewpoint changes, progress indicators (p. 257).

A follow-on hazard: Palmiter & Elkerton found animation-trained users *declined* one week after training, while text-trained users *improved*. Animation's apparent short-term parity hides worse retention.

**So animate when the user is moving through space, time, or state** — navigation, container expansion, progress feedback, gesture follow-through. Don't animate to teach, decorate, signal "premium", or fill silence.

---

## 2. The Motion Pyramid

From essential to risky. Start at Level 1, add higher levels only when justified.

### Level 1: Micro Feedback (Most Important)

- Hover, press, focus states
- Toggles, checkboxes, radio buttons
- Inline validation indicators

**Goal:** Feeling of responsiveness without noticeable animation.

### Level 2: State Transitions

- Expand/collapse (accordions, details)
- Tab switches
- Modal, drawer, popover appearance

**Goal:** "Movement" instead of "teleportation."

### Level 3: Layout Continuity

- Elements resize/reposition while maintaining context
- Reorder, filter chips, drag-and-drop
- List item add/remove

**Goal:** Cognitive economy—less "what just happened?"

### Level 4: Expressive (Rare in Product)

- Hero animations, illustrations
- Onboarding sequences
- Marketing pages

**Risk zone:** Easily becomes noise. Use sparingly in product UI.

---

## 3. Duration Taxonomy

Forget "500ms for everything." Use purpose-based categories.

The cross-design-system convergence is **150 ms** — Material 3 `short3`, IBM Carbon `moderate-01`, Shopify Polaris `150`, Tailwind default, SLDS `duration-fast` all land here. Use it as the default duration for state-confirmation feedback.

| Duration | Use |
|---|---|
| 50–100 ms | Instant feedback (button press, toggle commit, hover) |
| 150 ms | Default for state-confirmation |
| 200–300 ms | Entering UI (modals, sheets, dropdowns) |
| 300–500 ms | Cross-screen transitions, container morphs |
| > 500 ms | Reserved for cross-screen, staged, or platform-native transitions |

### Duration Reference (Refero categories)

| Category | Duration | Examples |
|----------|----------|----------|
| **Instant** | 90–150ms | Hover, press, toggle, focus |
| **State change** | 160–240ms | Accordion, tabs, small panels |
| **Page/large** | 240–360ms | Modal, drawer, route transition |
| **Complex** | 360–500ms | Large layout reflow (rare, optimize if possible) |

### Practical Preset (Copy-Paste Ready)

```css
:root {
  --duration-fast: 120ms;
  --duration-default: 200ms;
  --duration-slow: 320ms;
}
```

### Rules

- **Smaller distance/amplitude → shorter duration**
- **Higher frequency action → shorter duration**
- **500ms+ in product UI almost always feels slow**
- **If users do it 100x/day, make it instant**
- **Mobile animations should run 20–30% shorter than desktop** — travel distances are shorter
- **Frequent hover effects (50+ times per session) must stay ≤200ms**

---

## 4. Easing: Native Feel Without Cringe

### Basic Principle

| Action | Easing | Why |
|--------|--------|-----|
| **Enter** (appear) | ease-out | Fast start, soft landing |
| **Exit** (disappear) | ease-in | Soft start, fast exit |
| **State change** | ease-in-out | Smooth both ways |

### CSS Tokens

```css
:root {
  --ease-out: cubic-bezier(0.0, 0.0, 0.2, 1);    /* Enter */
  --ease-in: cubic-bezier(0.4, 0.0, 1, 1);       /* Exit */
  --ease-in-out: cubic-bezier(0.4, 0.0, 0.2, 1); /* Change */
  
  /* Alternative: slightly more "alive" */
  --ease-emphasized: cubic-bezier(0.2, 0.0, 0, 1);
}
```

### Curve vs Spring — Choosing the Right Tool

**Use a curve (cubic-bezier)** for:
- Opacity, color, and any property that changes value between two known points
- UI transitions where the end state is always known ahead of time

**Use a spring** for:
- Position, scale, rotation, and gesture-driven motion — anything that should feel physical
- Drag, swipe, gesture responses
- Small "bounce" feedback (use sparingly)
- Elements that feel physical

**Spring precision notes:**
- Material 3 standard easing is `cubic-bezier(0.2, 0, 0, 1)` — front-loaded; the trailing zero makes the curve hit its target instantly and settle. M2 standard was the symmetric `cubic-bezier(0.4, 0, 0.2, 1)`, preserved in M3 under the name `legacy`.
- Apple's published SwiftUI default spring is `(response: 0.5, dampingFraction: 0.825, blendDuration: 0)`.
- Spring framework defaults disagree: motion.dev's physics-mode default is ζ ≈ 0.5 (bouncy). React Spring's `default` is ζ = 0.997 (critically damped). Same word "default", opposite feel. Pick consciously.

```js
// Framer Motion / Motion example
{ type: "spring", stiffness: 400, damping: 30 }  // Snappy
{ type: "spring", stiffness: 200, damping: 20 }  // Smooth
```

**Critical:** Spring must decay quickly. No prolonged "jello" effect.

---

## 5. Micro-interactions That Work

Maximum effect, minimum risk.

### Buttons and Controls

| State | Animation | Duration |
|-------|-----------|----------|
| **Hover** | Background color shift | 120ms |
| **Press** | `scale: 0.98` | 90–120ms |
| **Focus** | Ring/outline appears | 120ms |
| **Disabled** | No animation, just visual degradation | — |
| **Loading** | Clear state indicator, not just spinner | — |

```css
.button {
  transition: background-color 120ms var(--ease-out),
              transform 90ms var(--ease-out);
}
.button:hover {
  background-color: var(--primary-hover);
}
.button:active {
  transform: scale(0.98);
}
```

### Inputs

| State | Animation | Notes |
|-------|-----------|-------|
| **Focus** | Border/underline highlight | No layout shift |
| **Error** | Light shake on submit only | Short (200ms), not on every keystroke |
| **Success** | Subtle checkmark or color | Don't overdo it |

### Lists and Tables

| Action | Animation | Notes |
|--------|-----------|-------|
| **Add row** | Fade in + slide 4–8px | 200ms |
| **Remove row** | Fade out + collapse | 180ms |
| **Reorder** | Layout animation | Only if performant |

```css
.list-item-enter {
  opacity: 0;
  transform: translateY(-8px);
}
.list-item-enter-active {
  opacity: 1;
  transform: translateY(0);
  transition: all 200ms var(--ease-out);
}
```

### Modals and Drawers

| Element | Enter | Exit |
|---------|-------|------|
| **Overlay** | Fade in (200ms) | Fade out (150ms) |
| **Modal** | Fade + scale from 0.97 (220ms) | Fade + scale to 0.97 (160ms) |
| **Drawer** | Slide from edge (240ms) | Slide to edge (180ms) |

---

## 6. Cross-Platform Handoff

When handing motion specs to engineers across platforms:

| Platform | Default animation primitive |
|---|---|
| Web (CSS) | `transition` + `animation` + CSS `linear()` for multi-segment curves |
| Web (JS) | Framer Motion, Motion One, or Web Animations API |
| iOS | SwiftUI `.animation()` with spring or `.easeInOut` |
| Android | Material 3 Motion tokens + Compose `animateAsState` |
| React Native | Reanimated 3 — use spring physics for gesture-driven motion |

**Handoff spec format** for engineer delivery:

```
Component: [name]
State: [from → to]
Property: [what changes]
Duration: [ms]
Easing: [cubic-bezier or spring params]
Delay: [ms, if any]
Reduced-motion fallback: [instant / opacity-only / none]
```

---

## 7. Reduced Motion

Every animation that translates, scales, rotates, or parallaxes must respect `@media (prefers-reduced-motion: reduce)`. WebKit shipped this in 2017 to address vestibular triggers.

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

**What to preserve under reduced motion:**
- Opacity changes for show/hide (not a vestibular trigger)
- Color transitions on hover/focus (safe)
- State indicators (spinner, progress)

**What to eliminate under reduced motion:**
- Translate, scale, rotate, skew animations
- Parallax effects
- Continuous/looping animations

---

## 8. Common Mistakes

- **Animating everything** — Motion budget is finite. When every element moves, nothing stands out.
- **Slow modals** — Modal open >300ms feels broken. Use 220–240ms max.
- **`ease-in` for enters** — Ease-in starts slow, making the entrance feel sluggish. Use `ease-out`.
- **`transition: all`** — Catches properties you didn't intend to animate. Specify only what changes.
- **Spring on opacity/color** — Springs are for physical properties. Use a curve for color and opacity.
- **No exit animation** — Disappearing elements with no exit feel abrupt. Even 150ms opacity fade helps.
- **Animating keyboard-repeated actions** — If a user can hold a key and trigger the action 20x/second, the animation will stack. Use `will-change` carefully and verify performance.
- **Ignoring `prefers-reduced-motion`** — A vestibular disorder trigger that's also a WCAG 2.2 violation.
- **Using the M2 cubic-bezier curve and calling it M3** — They're different. M3 standard is `cubic-bezier(0.2, 0, 0, 1)`.

---

## 9. Pre-Ship Motion Checklist

- [ ] Every animation serves Feedback, Continuity, or Hierarchy — not decoration
- [ ] Duration under 500ms for all non-transition animations
- [ ] Hover/focus effects are ≤120ms
- [ ] Modal enter is ≤240ms, exit ≤180ms
- [ ] `ease-out` on enters, `ease-in` on exits
- [ ] Springs used only for position/scale/rotation — not opacity or color
- [ ] `transition: all` replaced with specific property transitions
- [ ] `@media (prefers-reduced-motion: reduce)` applied to all translate/scale/rotate animations
- [ ] No animation on keyboard-repeatable actions (tested by holding key)
- [ ] Mobile animations are 20–30% shorter than desktop equivalents
- [ ] Handoff spec includes: property, duration, easing, reduced-motion fallback

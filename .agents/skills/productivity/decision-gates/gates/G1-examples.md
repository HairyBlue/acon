## Case G1-1 — ASK (grill-me fires)

**Captain's message:**
> "Make the dashboard faster."

**Signal check:**

| Signal | Present? | Evidence |
| :--- | :--- | :--- |
| Target scope | ❌ | No files, modules, or components specified |
| Technology/framework | ❌ | No language or framework mentioned |
| Acceptance criteria | ❌ | No definition of "faster" (metric, threshold, perceived vs measured) |
| Scope boundary | ❌ | No indication of what should remain unchanged |

**Missing signals:** 4
**Mandatory triggers matched:** Message is fewer than 20 words

**Verdict:** `ASK`

**Grill-me questions (1–3 targeted):**
1. Which dashboard page or component feels slow — the initial load, a specific widget, or navigation between views?
2. Is there a target metric (e.g., < 2 s first contentful paint, < 500 ms API response)?
3. Are there parts of the dashboard we should leave untouched during this optimization?

---

## Case G1-2 — SKIP (no grill needed)

**Captain's message:**
> "In `src/components/UserTable.tsx`, replace the current client-side sorting with TanStack Table's built-in column sort. Keep the existing row-selection checkboxes and pagination unchanged. Done means clicking any column header toggles asc/desc sort with a visible indicator arrow."

**Signal check:**

| Signal | Present? | Evidence |
| :--- | :--- | :--- |
| Target scope | ✅ | `src/components/UserTable.tsx` |
| Technology/framework | ✅ | React, TanStack Table |
| Acceptance criteria | ✅ | Column header click toggles asc/desc with visible indicator arrow |
| Scope boundary | ✅ | Row-selection checkboxes and pagination must remain unchanged |

**Missing signals:** 0

**Verdict:** `SKIP` — All 4 signals present. Proceed to prompt-master extraction then task shaping.

---

## Case G1-3 — CONTEXT (infer the missing signal)

**Captain's message:**
> "Add a dark-mode toggle to the settings page in `src/pages/Settings.vue`. It should persist the user's choice in localStorage and apply instantly without a page reload."

**Signal check:**

| Signal | Present? | Evidence |
| :--- | :--- | :--- |
| Target scope | ✅ | `src/pages/Settings.vue` |
| Technology/framework | ✅ | Vue (implied by `.vue` file), localStorage |
| Acceptance criteria | ✅ | Persists in localStorage, applies instantly, no reload |
| Scope boundary | ❌ | No mention of what should remain unchanged |

**Missing signals:** 1

**Verdict:** `CONTEXT` — The Control Plane inspects the codebase and finds `Settings.vue` contains only a preferences form with no other interactive components. Inference: blast radius is inherently limited to the toggle addition. Confidence is sufficient — proceed without grilling.

*If the settings page had contained complex state (e.g., account deletion, billing), inference confidence would be low and the verdict would escalate to `ASK`.*

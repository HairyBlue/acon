---
name: frontend-conventions
description: "Frontend engineering conventions enforcing modular file structure, thin controllers, service-layer logic isolation, and zero-reinvention of UI primitives. Activate whenever writing or reviewing frontend code."
license: MIT
metadata:
  author: acon
---

# Frontend Conventions

Three enforced invariants for every frontend `SHIP` task:

```
┌─────────────────────────────────────────────────────────┐
│  1. ZERO REINVENTION  │  2. MODULAR FILES  │  3. THIN CONTROLLERS  │
│  Use what exists      │  ≤ 300 lines/file  │  Logic lives in services │
└─────────────────────────────────────────────────────────┘
```

---

## Invariant 1 — Zero Reinvention of UI Primitives

**Rule:** Never author a custom implementation of a UI primitive that already exists in the project's component library or a declared dependency.

**Covered primitives (non-exhaustive):**
- Badges, pills, tags, chips
- Icons (use the installed icon library — Heroicons, Lucide, FontAwesome, etc.)
- Buttons, toggles, checkboxes, radios
- Modals, dialogs, drawers
- Tooltips, popovers, dropdowns
- Toasts, alerts, banners
- Spinners, skeletons, progress bars
- Avatars, initials placeholders

**Enforcement Protocol:**
1. Before writing any UI element, scan the project's component library imports and `package.json` for an existing match.
2. If a match exists → use it, even if customization requires a thin wrapper.
3. If no match exists → use the installed icon/UI library's primitive. If no library is installed, flag this in the task diff (do NOT silently install a new dependency — escalate per ponytail Rule 4: Zero New Dependencies).
4. Zero hand-rolled SVG icons. Zero inline `<svg>` paths unless the icon is provably absent from all installed icon libraries.

**Anti-patterns (BLOCKED):**
```tsx
// ❌ BLOCKED — custom badge when a Badge component exists
<span className="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100">
  Active
</span>

// ✅ CORRECT
<Badge variant="blue">Active</Badge>

// ❌ BLOCKED — hand-rolled icon
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M5 13l4 4L19 7"/></svg>

// ✅ CORRECT (Heroicons example)
import { CheckIcon } from '@heroicons/react/24/outline'
<CheckIcon className="h-5 w-5" />
```

---

## Invariant 2 — Modular File Structure

**Rule:** No file may exceed **300 lines**. If a file approaches this limit during authoring, extract before committing.

**Extraction Decision Tree:**
```
File approaching 300 lines?
├── Multiple unrelated concerns? → Split by concern (one component/hook/util per file)
├── One large component with sub-sections? → Extract sub-components into co-located files
├── Repeated logic blocks? → Extract to a shared hook or utility
└── Large constant/config data? → Extract to a dedicated constants or config file
```

**Naming conventions for extracted units:**

| Unit Type | File Pattern | Example |
|---|---|---|
| Component | `ComponentName.tsx` | `UserCard.tsx` |
| Sub-component | `ComponentName.Part.tsx` | `UserCard.Avatar.tsx` |
| Custom hook | `useFeatureName.ts` | `useUserProfile.ts` |
| Service | `featureName.service.ts` | `userProfile.service.ts` |
| Constants | `featureName.constants.ts` | `userProfile.constants.ts` |
| Types | `featureName.types.ts` | `userProfile.types.ts` |

**Anti-patterns (BLOCKED):**
- A single 1,200-line component file with 6 sub-sections — extract each section
- A `utils.ts` file that accumulates all utility functions — scope utils to feature domain
- Barrel files that re-export 40+ things — split barrel by domain

---

## Invariant 3 — Thin Controllers, Fat Services

**Rule:** Controllers/handlers/route handlers contain **zero business logic**. All computation, transformation, validation, and orchestration live in service layer files.

**Controller responsibilities (ONLY these):**
1. Parse and validate request shape (schema validation only — not business rules)
2. Call one service method
3. Map the service result to a response shape
4. Return the response

**Service responsibilities:**
- Business rule enforcement
- Data fetching and transformation
- Cross-cutting orchestration (calling multiple repositories/APIs)
- Error classification and domain error creation
- Caching logic

**Layering contract:**
```
Controller / Handler
    │  (receives request, calls one service method, returns response)
    ▼
Service
    │  (business rules, orchestration, transformations)
    ▼
Repository / API Client / Store
    │  (raw data access — no business logic)
    ▼
External (DB, API, Cache)
```

**Anti-patterns (BLOCKED):**
```ts
// ❌ BLOCKED — business logic in controller
async function handleCreateOrder(req: Request, res: Response) {
  const { items, userId } = req.body
  const user = await db.users.findById(userId)
  if (!user.isActive) throw new Error('User inactive')
  const total = items.reduce((sum, i) => sum + i.price * i.qty, 0)
  if (total > user.creditLimit) throw new Error('Credit exceeded')
  const order = await db.orders.create({ userId, items, total })
  await emailService.send(user.email, 'order-confirmation', { order })
  res.json(order)
}

// ✅ CORRECT — thin controller delegates entirely
async function handleCreateOrder(req: Request, res: Response) {
  const dto = createOrderSchema.parse(req.body)
  const order = await orderService.createOrder(dto)
  res.status(201).json(order)
}
```

**Naming convention for services:**
- File: `<domain>.service.ts` (e.g., `order.service.ts`, `auth.service.ts`)
- Class/object export: `<Domain>Service` or a plain exported function per operation
- No service may import another service directly — use dependency injection or pass as parameter to avoid circular coupling

---

## Verification Checklist (Pre-Diff Submission)

Before submitting any frontend SHIP diff, confirm all:

- [ ] No custom-authored UI primitive that already exists in the component library or icon library
- [ ] No file exceeds 300 lines
- [ ] No controller/handler contains business logic — all delegated to service
- [ ] Services contain no HTTP parsing, no `req`/`res` references
- [ ] New file names follow the naming convention table (Invariant 2)
- [ ] No new UI dependency added without escalation

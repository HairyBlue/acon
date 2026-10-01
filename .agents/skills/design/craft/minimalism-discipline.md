# Minimalism Discipline & Improvement Scope Constraint

Every UI output defaults to minimal. Improvement means subtraction and
refinement, not addition. Adding elements requires explicit justification.

---

## 1. The Minimalism Default

All UI work starts from zero ornamentation and adds only what the user's task
demands. Every element on screen must earn its place.

**RULE: No unnecessary badges, pills, tags, or status indicators.** Status
decoration is only justified when it communicates actionable meaning — a state
the user needs to see to decide what to do next. If the badge doesn't change
the user's behavior, remove it.

**RULE: No decorative icons.** Icons serve exactly three roles: navigation,
identification, or status. If removing the icon doesn't hurt comprehension,
remove it. An icon that merely "looks nice next to the label" is decoration —
cut it.

**RULE: No gratuitous detail.** Tooltips, info badges, secondary labels, subtle
decorative borders, ornamental dividers, micro-embellishments — if it doesn't
serve the user's task, it doesn't ship. Every detail adds cognitive load. The
cost is real even when the detail is small.

**RULE: No feature creep in components.** A card doesn't need an avatar, a
badge, a timestamp, a subtitle, AND an action menu if the task only calls for
a title and an action. Build the component to the task, not to a kitchen-sink
template. Every prop/slot you add is an invitation to over-decorate.

**RULE: Every element must answer: "What does this help the user DO?"** If the
answer is "it looks nice" or "it fills space" — remove it. Aesthetic quality
comes from proportion, spacing, and typography, not from adding more things.

---

## 2. The Improvement Scope Constraint

When the user asks to **improve**, **refine**, **polish**, or **clean up** an
existing page or component, the scope is strictly what was asked for.

**RULE: Do not add new elements that weren't in the original and weren't
requested.** No new badges, icons, sections, cards, containers, or visual
details. The brief said "improve," not "add things."

**RULE: "Improve" means make what exists better.** Alignment, spacing,
hierarchy, contrast, interactive states, responsiveness, accessibility — these
are improvement. Adding a status pill that didn't exist before is not
improvement; it's feature addition.

**RULE: Do not interpret "improve" as "enrich" or "enhance with more content."**
Improvement is subtraction and refinement, not addition. If you can make it
better by removing something, that is the correct move.

**RULE: Element count must not grow.** If a page has 5 elements and the user
says "improve this page," the output should have ≤5 elements, each one better —
not 12 elements with badges and icons that didn't exist before. Count the
elements before and after. If the number went up and you can't point to a user
request that explains why, you've violated scope.

**The only exception:** Adding something that is structurally REQUIRED for the
existing elements to function correctly. Examples: a missing focus state, a
broken label association, an ARIA attribute for accessibility, a required form
field indicator. These are not additions — they are completions of incomplete
existing elements.

---

## 3. The Addition Gate

Before adding ANY new visual element to an existing interface, pass it through
this gate in order:

1. **Was it explicitly requested by the user?** → Add it.
2. **Is it structurally required for accessibility or functionality of existing elements?** → Add it.
3. **Does removing it break the user's stated task?** → Add it.
4. **None of the above?** → Do NOT add it.

If an element fails the gate, it does not ship — regardless of how good it
looks, how common it is in similar interfaces, or how "incomplete" the design
feels without it. The user didn't ask for it. The function doesn't need it.
Leave it out.

**RULE: When in doubt, leave it out.** The cost of a missing element the user
actually wants is one follow-up request. The cost of an added element the user
didn't want is distrust in every future output.

---

## Checklist

Run before delivering any UI work:

- [ ] No badges/pills added unless user requested or data demands status indication
- [ ] No icons added unless they serve navigation, identification, or status
- [ ] No new sections, cards, or containers added beyond what exists (for improvement tasks)
- [ ] No decorative borders, dividers, or ornamental elements added
- [ ] No tooltips, info badges, or secondary metadata added unless explicitly requested
- [ ] Element count in output ≤ element count in input (for improvement tasks)
- [ ] Every added element passes the Addition Gate (Section 3)

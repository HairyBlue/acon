# Typography hierarchy craft rules

Shared hierarchy contracts that layer on top of `typography.md`. This file does
not repeat scale ranges or tracking values — those live in `typography.md`.
This file defines how hierarchy *behaves*: entry points, rhythm, tension, and
the conditions under which controlled violations are allowed. This contract
applies per-surface (a page with multiple pacing resets may establish new
primaries at intentional intervals), not globally.

> Aesthetic-specific variants (e.g. `typography-hierarchy-editorial`) extend this.

---

## The core contract

Every typographic surface must satisfy all three:

1. **One dominant entry point.** The eye needs a place to start. One element
   wins the hierarchy — not two, not three. If everything competes, nothing leads.
2. **Intentional rhythm between levels.** Hierarchy is not a list of sizes.
   It is the *contrast* between them. Adjacent levels that are too close
   in scale, weight, or spacing produce a flat, undifferentiated surface.
3. **Recoverable information flow.** Hierarchy may be inverted, collapsed,
   or disrupted — but a reader must still be able to reconstruct the content
   structure without re-reading. If they can't, it's chaos, not tension.

---

## Hierarchy vectors

Scale is one lever. Use all five.

| Vector | What it controls | Hierarchy direction |
|---|---|---|
| Scale | Size contrast between levels | Large → small reads as primary → secondary |
| Weight | Mass contrast between levels | Heavier reads as primary (see Controlled violations for weight inversion) |
| Spacing | Breathing room around an element | More space = more visual importance |
| Tracking | Tension and velocity | Tighter = faster; wider = ceremonial, slower |
| Alignment | Relationship to the grid/edge | Breaking alignment signals importance |

No single vector is required. A heading may lead through spacing alone if
scale is deliberately suppressed. A pull quote may lead through alignment
break. Identify which vectors are active and make sure at least two are
working in the same direction for the dominant element.

---

## Semantic role ≠ visual role

Allowed. Not an error. Not a lint violation.

An `<h1>` may render visually quieter than a nearby `<p>` if the
composition requires it. Body copy may behave like display typography.
A label may visually outrank a heading.

**The condition:** information flow must remain intact. A user who reads
linearly must still understand what is important, what supports it, and
what is incidental — regardless of which element "wins" visually.

---

## Hierarchy rhythm — the two failure modes

### Flat hierarchy

Everything lands at roughly the same visual weight. The surface reads as
a wall. Usually caused by:
- Scale steps that are too close (e.g. 18 / 20 / 22 px for three levels)
- Weight used only once (everything is regular, or everything is medium)
- Uniform spacing between all elements

Fix: increase contrast between levels. Use at least two vectors simultaneously.

### Noise hierarchy

Too many elements fight for attention. The dominant entry point is unclear
because everything is treated as important. Usually caused by:
- Bold applied to all headings and all emphasized text and all CTAs
- Four or more type sizes within a single card
- Tracking applied inconsistently (some caps labels tracked, some not)

Fix: suppress. Most hierarchy problems are solved by quieting elements, not
amplifying the primary.

---

## Controlled violations

The hierarchy contract permits intentional rule-breaking under two conditions:

1. **The violation is traceable.** You can name the reference or the
   compositional reason ("the pull quote breaks the column grid to create
   a pace break between sections").
2. **The violation is singular.** One element per surface may break the
   primary rule. Two breaks compete; three breaks produce a surface with no rules.

Common intentional violations that work:

- **Weight inversion.** A large-scale element set in a lighter weight (300–400)
  while body copy sits at 500. Works when scale is so large that mass would
  overwhelm. Requires the scale gap to be significant (≥2× difference).
- **Alignment break.** A centered element in a left-aligned composition.
  Effective for pull quotes, feature callouts, or chapter breaks. Fails when
  more than one element breaks alignment — then it's just inconsistency.
- **Scale suppression.** Making an `<h1>` visually quiet (small, light,
  widely tracked) while a decorative element or image leads. Common in
  editorial systems. The page still needs a clear entry point — just not
  the heading.

---

## Entry point rules

Every surface has exactly one dominant entry point. This is not the `<h1>` by
default — it is whatever element the eye lands on first. On most surfaces
that will be a heading; on others it may be an image, a large number, or
an icon cluster.

To establish a clear entry point:
- Ensure at least two hierarchy vectors point to it
- Give it more space than any neighboring element
- If it competes with something else for visual dominance, suppress the
  competitor (reduce size, weight, or contrast — don't amplify the primary)

---

## Rhythm checkpoints

Before declaring a typographic surface done, verify:

- [ ] One element visually leads — nothing else is at the same or higher visual weight
- [ ] Adjacent levels have contrast in at least two vectors (not just size)
- [ ] Uniform spacing does not exist between all elements — grouping is visible
- [ ] ALL CAPS elements have tracking ≥ `+0.05em`
- [ ] No more than one controlled violation per surface
- [ ] Information flow is recoverable by a linear reader

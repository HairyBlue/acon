# Laws of UX craft rules

Universal cognitive, perceptual, and behavioral heuristics that decide
what a UI composes — how many pricing tiers fit on a screen, where a
primary action anchors in scanning order, when a progress indicator
earns its place, why a settings list needs grouping. The active
design system decides brand visual language; the existing craft files
decide rendering rules (color, typography, motion, states, ARIA, RTL,
forms); this file decides composition rules grounded in named research.

> Distilled from primary sources: Hick (1952) + Hyman (1953), Miller
> (1956) for chunking / `7±2` channel capacity, Cowan (2001) for the
> modern ~4 working-memory bound, Fitts (1954), Wertheimer (1923) for
> proximity / similarity / Prägnanz, Palmer (1992) for Common Region,
> Palmer & Rock (1994) for Uniform Connectedness, Kahneman /
> Fredrickson / Schreiber / Redelmeier (1993) for Peak-End, Zeigarnik
> (1927), Csíkszentmihályi (1975), Hull (1932), von Restorff (1933),
> Broadbent (1958), Sweller (1988), Postel (RFC 760, 1980), Carroll &
> Rosson (1987), Tversky & Kahneman (1974) for Anchoring, Kurosu &
> Kashimura (1995), Iyengar & Lepper (2000), Toffler (1970), Pareto
> (c.1906) / Juran (*Quality Control Handbook*, 1951), Ebbinghaus
> (1885), Ockham (14th c.), Tesler at Apple (1980s), Nielsen (2000),
> Norman *POET* (1988), Parkinson (1955).

## Prior art and scope

Existing public catalogs of UX heuristics (Yablonski's lawsofux.com,
NN/g's 10 usability heuristics, Material 3 motion + interaction
guidance, Apple HIG, Baymard Institute checkout research) inventory the
laws but rarely tie each one to a concrete code-gen directive. This
file does the translation: every entry ends with one actionable move
for an HTML / Tailwind / React-emitting agent. Sibling craft files
(`accessibility-baseline.md`, `state-coverage.md`, `typography.md`,
`anti-ai-slop.md`, `color.md`, `motion.md`,
`form-validation.md`) own the auto-checked rules; this file names the
underlying law and surfaces the folklore.

The rules below are guidance. Reviewers and the agent apply them.

Where a law has a sibling rule already covered elsewhere — touch-target floor in
`accessibility-baseline.md`, the 300 ms / 2 s / 10 s / 30 s / 60 s
loading thresholds in `state-coverage.md`, ALL CAPS letter-spacing in
`typography.md`, the indigo / gradient / emoji-icon list in
`anti-ai-slop.md` — the entry below cross-references rather than
duplicates.

## Perception and visual grouping

Five Gestalt laws plus three attention-and-recognition laws govern how
the eye groups elements before the brain reads them.

- **Law of Proximity** (Wertheimer, 1923). Objects near each other read
  as a group. Cheapest grouping signal — cheaper than borders or shared
  color. Apply variable vertical rhythm: 8–12 px within a group,
  32–48 px between groups. Uniform spacing reads as nothing being
  grouped.
- **Law of Similarity** (Wertheimer, 1923). Visually similar elements
  read as a group. Equivalent affordances must share treatment — every
  list row identical class set, every secondary button identical, every
  destructive action identical. Visible deviation is reserved for the
  one item meant to draw attention (the recommended pricing tier, the
  selected nav item).
- **Law of Common Region** (Palmer, 1992). A shared bounded area binds
  enclosed elements. Use enclosure when proximity is not enough — and
  reserve it. Concrete numbers: padding ≥16 px inside the region,
  distinct surface (border + tinted background, or card chrome at
  ≥1 px hairline). A page where every section is bordered destroys the
  signal.
- **Law of Prägnanz / Good Figure** (Wertheimer, 1923). The eye
  resolves complex layouts into the simplest underlying form. Designs
  that align with a clear underlying grid (12-column, F-pattern,
  4-quadrant) feel inevitable; ornate breaks that add nothing semantic
  feel arbitrary.
- **Law of Uniform Connectedness** (Palmer & Rock, 1994). The
  strongest grouping signal in the Gestalt hierarchy: connected lines,
  shared toolbars, or bracketing containers tie items together more
  strongly than proximity or similarity. Use for wizard steps,
  comparison sets, and explicit navigation flows.
- **Selective Attention** (Broadbent, *Perception and Communication*,
  1958). Cognitive bandwidth is finite. Users filter aggressively and
  ignore anything that looks irrelevant to their goal — banner blindness
  comes from this. Reserve the strongest visual contrast for the single
  goal-relevant action; let supporting content recede in weight.
- **Von Restorff Effect** (von Restorff, 1933). The item that differs
  from a uniform field is the one most likely to be remembered. Make
  the recommended pricing tier, the active nav item, the warning state
  visually distinct. Pair contrast with a non-color signal (icon, text
  label, position) — `accessibility-baseline.md` rules out color-alone
  signaling.
- **Aesthetic-Usability Effect** (Kurosu & Kashimura, Hitachi Design
  Center, 1995). Visual polish biases perceived usability. Refined
  typography, generous whitespace, and a calm palette earn the benefit
  of the doubt for minor friction. Never substitutes for measurable
  usability or for `state-coverage.md`'s required-states rule.

## Decision-making

Six laws govern how fast and how well users decide when an interface
offers a choice.

- **Hick's Law** (Hick, 1952; Hyman, 1953 replication). Decision time
  grows roughly log(n+1) with the number of equivalent options. Cap any
  single decision-screen to 3–5 visible primary options; collapse the
  rest behind a "More" / progressive disclosure pattern; visually
  distinguish the recommended choice. Aggressive truncation that hides
  the path forward is the opposite failure mode — surface the full
  option set, just don't render every option at the same visual weight.
- **Choice Overload** (Iyengar & Lepper, *Journal of Personality and
  Social Psychology*, 2000; framing dates to Toffler, *Future Shock*,
  1970). Too many roughly-equivalent options stall or abandon the
  decision. Pricing pages: 3–4 tiers, exactly one marked recommended.
  Product grids: 6–9 hero cards above the fold. Settings panels: ≤5
  named groups. Never emit a flat wall of equivalents.
- **Anchoring** (Tversky & Kahneman, *Science* 185:1124–1131, 1974).
  The first number a user sees re-weights every subsequent number.
  Place the recommended pricing tier where it anchors the comparison;
  render yearly-billing savings as concrete dollar deltas, not just
  percentage badges; pre-select the safer default in radio groups.
  Visual weight matches intended decision weight.
- **Pareto Principle / 80-20** (Pareto, c.1906; Juran, *Quality Control
  Handbook*, 1951 — popularized the management-application framing). A
  small share of features drives most of the value. Identify the 2–3 actions
  that drive the dominant journey for the target persona; emphasize
  those visually; demote the long tail to overflow menus, footer
  surfaces, or settings.
- **Tesler's Law / Conservation of Complexity** (Tesler, Apple, 1980s).
  Every product has an irreducible amount of complexity. The design
  choice is *where* it lives — engineering team, interface, user — not
  whether to eliminate it. When complexity reaches the user, surface
  contextual guidance (tooltips, smart defaults, inline empty-state
  coaching, progressive disclosure) at the exact step where it
  surfaces. Hiding it is not the same as removing it.
- **Occam's Razor** (Ockham, 14th c.). Among options that explain the
  data equally well, prefer the one with the fewest assumptions. Specify
  a minimal element inventory; forbid decorative chrome that doesn't
  reduce cognitive load; delete any UI element whose absence doesn't
  hurt the task.

## Memory and cognitive load

Four laws govern working memory limits and the conditions under which
users retain and recall information.

- **Miller's Law** (Miller, *Psychological Review*, 1956; Cowan, 2001
  revision). Working memory holds roughly 7±2 chunks (Miller); the
  modern bound is ~4 (Cowan). Chunk related items into groups of ≤4;
  use `state-coverage.md`'s edge-case rules for long lists; never
  display raw paginated data without grouping or search. The number
  "7" from Miller is frequently misapplied as an item-count cap — the
  paper is about channel capacity, not UI element limits. The
  actionable move: group first, count second.
- **Cognitive Load Theory** (Sweller, *Cognition and Instruction*, 1988).
  Extraneous cognitive load — load from poor UI design, not from the
  task itself — is the designer's responsibility to eliminate.
  Decorative elements, inconsistent patterns, and non-obvious affordances
  all add extraneous load. The 80% of screens that don't need an
  animation (see `motion.md`) are also adding cognitive load through
  motion distraction.
- **Zeigarnik Effect** (Zeigarnik, *Psychologische Forschung*, 1927).
  Incomplete tasks linger in memory better than complete ones. Progress
  indicators, step counts, and "3 of 5 steps complete" labels reduce
  anxiety and maintain task continuity across interruptions. Don't use
  this to artificially create unfinished feelings — use it to honestly
  surface progress.
- **Ebbinghaus Forgetting Curve** (Ebbinghaus, *Memory*, 1885). Without
  reinforcement, retention degrades rapidly. Onboarding cannot be a
  single first-run modal — surface relevant guidance at the point of
  first use, not before.

## Feedback and response time

Three laws govern the required speed of system feedback.

- **Doherty Threshold** (Doherty & Thadani, *IBM Systems Journal*, 1982).
  Productivity increases when response time is under 400 ms; above that,
  users context-switch. The practical motion target is 150 ms for
  state confirmation (see `motion.md`). The 400 ms threshold is for
  system responses, not animations.
- **Jakob's Law** (Nielsen, 2000). Users spend most of their time on
  *other* sites and expect your site to work the same way. Use platform
  conventions for navigation, form layouts, and interactive controls;
  break convention only when the deviation has a measurable benefit and
  the product context supports it.
- **Postel's Law / Robustness Principle** (Postel, RFC 760, 1980; Carroll
  & Rosson "minimal manual", 1987 application to UX). Be conservative in
  what you send, liberal in what you accept. Forms should accept flexible
  input (phone numbers with or without dashes, emails with aliasing) and
  format on blur. Never silently corrupt input; preserve what the user
  gave you.

## Motivation and engagement

- **Goal Gradient Effect** (Hull, 1932). Effort increases as the goal
  gets closer. Show progress at every step of a multi-step flow; make
  the last step shorter than the first; surface a "you're almost done"
  signal before the final action.
- **Flow Theory** (Csíkszentmihályi, 1975). Engagement peaks when
  challenge matches skill. Onboarding that drops users into a cold empty
  state is too hard; onboarding that walks them through every obvious
  step is too easy. Aim for the minimal scaffolding that keeps them moving.
- **Peak-End Rule** (Kahneman, Fredrickson et al., *Psychological Science*,
  1993). Users remember an experience primarily by its emotional peak and
  its ending, not the average. Invest disproportionately in the highest-stakes
  moment (checkout confirmation, empty-state recovery, first meaningful
  output) and the final state the user sees before leaving.
- **Parkinson's Law** (Parkinson, *The Economist*, 1955). Work expands to
  fill the time available. Constrain the time and space given to secondary
  tasks (form fields, optional settings) to prevent them from growing
  into primary tasks. Time-box multi-step flows; surface the minimum viable
  form; defer optional enrichment to later sessions.

## Fitts's Law

(Fitts, *Journal of Experimental Psychology*, 1954). Movement time to a
target is a function of distance and target size: `T = a + b × log₂(2D/W)`.
Larger targets and shorter travel distances reduce acquisition time.

Actionable moves:
- Primary CTAs must be the largest interactive element on the screen (or very close to it).
- Destructive actions (Delete, Remove, Cancel subscription) must be smaller and further from the primary CTA.
- Navigation items used dozens of times per session (tabs, sidebar items) must meet the 44×44 craft commitment from `accessibility-baseline.md`.
- Corner and edge targets (Mac menu bar, browser chrome) have infinite edge depth — use them for frequent global actions.
- Don't make users travel across the screen to reach common actions. Contextual menus and proximity-first layout reduce travel distance.

## Composition quick-reference

| Decision | Law | Actionable rule |
|---|---|---|
| How many pricing tiers? | Hick + Choice Overload | 3–4 tiers, one marked recommended |
| Where does the primary CTA go? | Fitts + Anchoring | Largest element; anchors the comparison |
| How to group settings? | Proximity + Miller | ≤4 items per group, ≤5 named groups |
| When to add a progress bar? | Zeigarnik + Goal Gradient | Whenever the task has ≥3 steps |
| How much decoration is justified? | Cognitive Load + Occam | Zero decorative chrome without function |
| How to handle complex input? | Postel + Tesler | Accept flexible formats; complexity lives in the system |
| When to break platform conventions? | Jakob's Law | Only with measurable benefit and context support |

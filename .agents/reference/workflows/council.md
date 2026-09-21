# council

**Trigger:** `/council` · "Convene advisors" · "Debate this decision"

## Purpose

Structured multi-perspective debate on a high-stakes decision. Three Oracle-role advisors
argue from different positions. Control Plane synthesizes. Captain decides.

## Structure

Three advisor Oracles run concurrently, each with a distinct assigned perspective:

| Advisor | Perspective |
|---------|------------|
| `pragmatist` | What is the fastest path that doesn't create long-term debt? |
| `skeptic` | What are we getting wrong, missing, or over-engineering? |
| `idealist` | What would the best-possible version of this look like? |

## Steps

1. **Control Plane** dispatches all three advisors concurrently with:
   - The decision or plan under debate
   - Their assigned perspective (they argue from it, not objectively)
   - Instruction: produce a 200-word position statement + top 3 concerns

2. Each advisor returns its position.

3. **Cross-examination round** (optional, triggered by Control Plane if positions conflict sharply):
   - Each advisor gets the other two positions and responds to the strongest objection.

4. **Control Plane synthesizes:**
   - Points of consensus across all three
   - Irresolvable disagreements that require Captain decision
   - Recommended path with rationale

5. **Control Plane presents** the synthesis to the Captain as a Bearings item under
   "Captain's Call" — not as a decision already made.

## Guard rails

- Advisors are read-only. No file edits during council.
- Council is for decisions, not implementations. If the outcome is "build X", dispatch
  Worker after Captain signs off.
- Cap at one cross-examination round. Infinite debate is not a council.

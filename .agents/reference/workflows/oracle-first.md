# oracle-first

**Trigger:** "Get oracle's opinion first" · "Challenge this before we build" · "Second opinion on the plan"

## Purpose

Pre-dispatch risk check. Oracle interrogates the plan independently before any Worker
touches a file. Use when the decision feels risky, the design has multiple valid paths,
or the Captain wants a sanity check.

## Steps

1. **Control Plane** dispatches **Oracle** with:
   - The full plan or decision being considered
   - The objective and constraints
   - Any alternatives already considered

2. **Oracle** returns its report: assumptions, risks, unconsidered paths, and a verdict.

3. **Control Plane** reads the verdict:
   - `PROCEED` → dispatch Worker as planned.
   - `PROCEED_WITH_CAUTION` → adjust the plan based on Oracle's notes, then dispatch.
   - `RECONSIDER` → surface Oracle's findings to Captain before proceeding.

4. Captain decides if Oracle raises a `RECONSIDER`. Control Plane does not override Oracle
   silently.

## When to use

- Architectural decisions with long-term consequences.
- Anything touching monetary logic, auth, or data integrity.
- When the Captain says "does this feel right to you?"
- When the Control Plane's confidence gate scores below 0.6.

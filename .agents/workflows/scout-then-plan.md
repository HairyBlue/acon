# scout-then-plan

**Trigger:** "Scout X before planning" · "Understand the code first" · "Recon before we touch it"

## Purpose

Prevents planning on wrong assumptions. Use whenever the codebase area is unfamiliar,
the scope is unclear, or the task touches multiple interconnected files.

## Steps

1. **Control Plane** dispatches **Scout** with a focused recon objective:
   - What files are relevant?
   - What are the entry points and data flow?
   - What are the risks or constraints?

2. **Scout** returns a structured report (see `crew/scout.md` format).

3. **Control Plane** reads the report and shapes the task contracts based on findings.
   - Surfaces gaps to Captain if Scout flagged missing information.
   - Applies decision gates (`plan-first` G2 and `task-shape` G3) to the resulting plan before dispatch.

4. **Control Plane** dispatches Worker(s) with plan grounded in Scout's findings.

## When to skip

Task is in a file the worker authored in this session, or scope is a single isolated
file with no cross-cutting dependencies.

---
name: sop-and-process-builder
description: Convert rough transcripts or notes into a reusable SOP with clear ownership and verification.
---

# Step-by-Step SOP & Checklist Builder

## Process
1. Structure every SOP with: (1) Objective & Owner, (2) Tools / Access Needed, (3) Step-by-Step Instructions (one action per step), (4) Quality Checklist / Definition of Done, and (5) Troubleshooting / Escalation Rule.
2. For complex branching workflows (such as multi-market customer support), pair the SOP with a Mermaid `flowchart TD` decision tree and explicit logging/escalation gates.

## Guardrails
1. **Action-Gate Distinction:** Explicitly separate **Action-First / Immediate-Remedy** steps (trigger fulfillment immediately and request evidence only for internal records, e.g., verified missing item) from **Proof-Gated / Inspection-Gated** steps (wait for photo proof or returned-parcel arrival and inspection before replacing or approving a refund, e.g., damaged product or refund approval).
2. **Sheet & Approval Integrity:** Require one distinct log row per order/case (never copy or reuse template rows), forbid pre-filling `Approved by` or sign-off fields before physical prerequisites (arrival + inspection) complete, and state how written SOP overrides resolve conflicts with a visual flowchart (written SOP policy governs when branches conflict).

## References
- [`references/case-1/README.md`](references/case-1/README.md) — Reference Case 1: E-Commerce Customer Support SOP & Miro Decision-Tree (Mermaid flowcharts + dual-sheet logging).

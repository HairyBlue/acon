# Capability Profiles: Reasoning and Foundation Models

Durable prompting profiles for reasoning, structured output, long-context and multimodal tasks. These profiles express task needs, not fixed providers, model IDs, API payloads or guaranteed tooling.

The [portable fleet contract](../../../../../reference/crew/README.md) owns capability discovery, authorized role routing and unsupported modes. In ACON, Firstmate delegates inspection and execution to bounded workers and retains synthesis; a model's apparent competence never permits primary-thread implementation.

This capability reconciliation is informed by Fleet `docs/PHILOSOPHY.md` and `.pi/agents/model-profiles.yaml` (ideas only), revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`; see the [local provenance and full MIT notice](../../../../../reference/crew/README.md#provenance-and-mit-notice). No source runtime, provider payload or fixed model hierarchy is adopted.

---

## 0. Dynamic Documentation & Model Recency Gate

> [!IMPORTANT]
> Model availability, controls and context limits evolve rapidly:
> 1. **Check Installed Capabilities:** Record task-local discovery and authorization evidence. Official version-matched documentation, when retrieval is available, may explain a control; it does not prove installed support or grant access.
> 2. **Separate Surfaces:** Interactive UI labels are not API parameters. The active installed harness alone owns actual tool, model, effort and sampling translation; this catalog supplies no parameter matrix or adapter.
> 3. **Prefer Durable Patterns:** Use clear context/task/output envelopes, grounded examples and explicit stop conditions rather than assumed family defaults.
> 4. **Keep Unknowns Explicit:** Never invent identities, context limits, pricing or tools. Required `UNAVAILABLE` or `UNKNOWN` capabilities mean `BLOCKED`, not permission to use another model, execute on the primary thread or weaken review.

---

## 1. Context-Rich Task Briefs

Use explicit structure for nuanced instructions, multi-step work and reference-heavy tasks without assuming family-specific competence.

- **Durable Core Behaviors:**
  - Be explicit, direct, and outcome-oriented. Explain *why* a constraint exists when judgment is required.
  - Structure complex prompts using descriptive XML tags (`<context>`, `<task>`, `<constraints>`, `<output_format>`, `<examples>`).
  - For long documents, place reference texts and data before the instruction query; wrap documents with metadata in XML containers.
  - Prefer positive directives detailing the target result over exhaustive negative prohibitions.
  - Never ask for hidden reasoning traces or verbatim chain-of-thought. Request conclusions, assumptions, evidence, and validation checks.
  - Express abstract effort `none | low | medium | high | max` only when supported by discovered capabilities. It is intent, not a fixed token budget, enforced task-tier mapping or reproducibility guarantee.
- **Scope and Evidence:** Add: *"Deliver what was asked. Do not add features, refactors, or abstractions beyond the task."* Require progress claims to cite actual tool results, not private reasoning. State when a constraint applies globally.
- **Review Boundary:** Self-verification never replaces mandatory independent G8/G9 after SHIP and before a commit proposal. Record actual writer/reviewer identities and separate read-only context evidence; shared identity requires `CORRELATED_REVIEW`. Missing/unknown required identity, authorization, availability or review isolation is `BLOCKED`, not a passing gate.
- **Templates:** Use [Template M — Bounded Agent Task Brief](../templates.md#template-m--bounded-agent-task-brief) for agentic and multi-step briefs.

---

## 2. Authorized Role and Effort Selection

Task requirements guide role assignment; availability alone never authorizes a choice or additional spending.

- **Durable Structure:** Structure prompts into four lean blocks: `Goal`, `Context`, `Constraints`, and `Done`. State instructions once with high signal.
- **Default:** Abstract `INHERIT` means the current Captain-authorized harness/model for all roles, not necessarily the writer's model. One subscription suffices when required capabilities are available; there is no required provider hierarchy.
- **Role Needs:** `MAIN_LEAD` retains constraints, decomposes and synthesizes evidence; `HEAVY_CODER` needs repository/tool competence and compiler/test-backed editing; `REVIEWER` assesses standards in an independent read-only context on the current authorized default.
- **Temporary Selection:** Only `MAIN_LEAD` and `HEAVY_CODER` may use `AUTHORIZED_TEMPORARY`: task-bound Captain approval, an available choice, explicit expiry and time/cost ceiling are required. Recheck authorization/availability at dispatch, resume and before accepting completion. On expiry record `AUTHORIZATION_EXPIRED` and pause `BLOCKED`; unavailable choices also stop work. Resume only under a still-valid separately approved `APPROVED_DEFAULT` fallback, recording it and rechecking capabilities/acceptance. No silent switching, purchases or automatic extensions.
- **Autonomy & Boundaries:** Define exclusive paths, allowed actions and approval gates. Destructive actions, new dependencies, git mutations and external writes require applicable explicit Captain authorization; a profile cannot broaden worker permissions.
- **Output Controls:** Specify output length and format in the task contract. Request conclusions, assumptions and verification evidence instead of hidden reasoning; actual parameter translation stays with the installed harness.

---

## 3. Reasoning-Oriented Tasks

State the problem, input invariants and acceptance criteria without inferring quality from a reasoning label.

- **Evidence over Traces:** Do not request private chain-of-thought or pseudo-reasoning transcripts. Require conclusions, assumptions, falsifiers and observable checks; extra reasoning does not establish correctness.
- **Zero Conversational Filler:** Deliver short, clean, declarative instructions. Focus purely on constraints, input invariants, and acceptance criteria.
- **Examples:** Start with clear requirements; add grounded examples when they clarify output or edge cases. Examples do not replace the complete constraint set.
- **Brevity Rule:** Keep instructions concise without omitting applicable guardrails, skill content or acceptance evidence. No universal word-count or model-performance guarantee applies.

---

## 4. Retrieval-Grounded Tasks

Search, image handling and code execution are separate capabilities; none is guaranteed by the underlying model.

- **Prompt Structure:** Outcome-focused framework: `Goal`, `Context/Input`, `Constraints`, `Tools/Permissions`, and `Done`.
- **Realtime Grounding:** For current facts, specify retrieval/citation requirements and source boundaries. Record source dates, locators and unresolved conflicts; if required retrieval is unavailable or unknown, report `BLOCKED` rather than fabricate current figures.
- **Session Boundaries:** Define stop conditions and evidence checkpoints. Caching, continuation and compaction depend on discovered host capabilities, not prescribed API headers or guaranteed persistent sessions. Acknowledgment is not terminal completion.

---

## 5. Long-Context and Multimodal Tasks

Verify supported context and input modalities from installed-host evidence; do not assume unlimited repository or media ingestion.

- **Context Selection:** Provide the smallest relevant reference slice, file anchors and task query. Keep exclusive scope and required skill injection; large context never authorizes whole-codebase archaeology.
- **Citation & Hallucination Guard:** Bind claims to supplied or authorized retrieved evidence. Distinguish confirmed facts, uncertainty and missing evidence rather than invent citations.
- **Format Locking:** Supply the output schema and, when useful, a labeled example. Validate the resulting artifact; a format instruction is not proof of compliance.

---

## 6. Clean Evidence Output

Keep conclusions and public verification separate from private reasoning, regardless of deployment.

- **Task Envelope:** Deliver concise objectives, allowed actions and acceptance criteria.
- **Output Boundary:** For pure data, request only the contracted artifact. Do not assume a tag, prompt or runtime option exposes, suppresses or preserves internal reasoning; the installed host owns its output handling.

---

## 7. Structured and Multilingual Tasks

Output fidelity must be observed rather than assumed from a model family or mode toggle.

- **Contract:** Specify the assigned role, language, input boundary, required keys and closed enums.
- **Validation:** Use applicable schema/compiler checks and named evidence. A correctly shaped result can still be factually wrong; preserve semantic acceptance criteria.
- **Controls:** Do not inject family-specific thinking toggles. Supported abstract effort belongs to capability evidence and actual translation to the installed harness.

---

## 8. Constrained-Context Deployments

Local or remote deployment does not change authority, evidence or independent review requirements.

- **Pre-Flight:** Record the actual authorized choice and supported capabilities without credentials. Context size, tool support and instruction fidelity must not be guessed.
- **Bounded Slices:** Use smaller verified tasks when competence is unknown on an otherwise supported harness; no task slice lowers acceptance or full skill-injection requirements.
- **Flat Hierarchies:** Prefer clear numbered constraints when that improves readability, preserving every binding rule.
- **Sampling:** No universal temperature or determinism prescription applies. Verify results with deterministic checks; installed-host controls do not guarantee reproducibility.

---

## 9. Deployment-Neutral Prompting

Deployment labels neither prove capability nor select a provider/model.

- **Directness & Role Calibrations:** Provide the existing assigned role's mandate, lens, scope/non-goals and required output; do not invent new personas or tool permissions.
- **Simplicity:** Use plain Markdown headers and bullet points, concise without removing constraints.
- **Grounding:** Bind responses directly to provided input data to mitigate hallucination.

---

## 10. Compatibility and Completion Boundaries

Reading a prompt or accepting an API shape does not certify delegated SHIP compatibility.

- **Required Support:** Evidence delegation, isolated contexts, applicable workspace isolation, supervision/communication, terminal completion and separate read-only review under the canonical contract. Receipt is not completion; no automatic wake, polling or scheduling is assumed.
- **Sequential Execution:** Lack of concurrency alone permits supported sequential isolated roles, never writer-context independent review.
- **Unsupported Modes:** Remain `BLOCKED` until a Captain-approved execution-host change or separately assigned manual worker/reviewer handoff demonstrates required capabilities while preserving Firstmate separation, exclusive scope and G8/G9. No optional/required adapter, invented tooling, primary execution or weaker review fills the gap.

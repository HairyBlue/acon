# Capability Profiles: Coding Agents & IDEs

Reference profiles and prompting protocols for bounded coding tasks, editor assistance, generation, research, and interaction. Profiles describe task needs, not guaranteed installed tools or selected personas.

For ACON, the [portable fleet contract](../../../../../reference/crew/README.md) governs capability discovery, authorization and unsupported modes. When acting as ORCHESTRATOR, Firstmate delegates project inspection, editing, tests and git operations to assigned workers and never executes them on the primary thread. A Normal Agent may perform its Captain-authorized bounded task directly, without crew authority. Required `UNAVAILABLE` or `UNKNOWN` capabilities mean `BLOCKED`. Reading this catalog does not demonstrate delegated execution support.

Resolve actual execution surface and task-local capabilities, not provider brand. Terminal/agent-CLI ORCHESTRATORS use separately opened persona-equipped peers only, never native subagents; desktop/IDE native-subagent fallback requires inability to open peers, all required capabilities AVAILABLE and separate assignment approval; unknown is BLOCKED. Establish Normal Agent versus ORCHESTRATOR before role-dependent action when unknown; approved handoff/existing verified role is sufficient. See the canonical [surface route and lifecycle](../../../../../reference/crew/README.md#host-neutral-orchestration).

Before any capability discovery or launch, ask the Captain which CLIs/subscriptions are permitted and obtain approval for choices and quota/time/cost notice. Verify only approved task-local capabilities; discovery grants no launch, spending, or switching authority. Terminal/agent-CLI ORCHESTRATORS use separately opened peers for bounded work, and peer failure pauses without native fallback. A Captain-established Normal Agent may perform only its bounded authorized task or join by approved assignment; it never spawns crew or assumes orchestrator authority. The ORCHESTRATOR only dispatches, supervises, and synthesizes, and never inspects, edits, tests, or performs git operations itself. Required capability `UNKNOWN` or `UNAVAILABLE` is `BLOCKED`; do not promise capabilities based on a host label. Route each role, including `REVIEWER`, only to an available Captain-approved choice and supported effort; obtain approval before launch. Record actual writer/reviewer identities and current authorization/availability evidence. Use separate read-only review contexts, never the writer context; mark shared underlying model identity `CORRELATED_REVIEW`. Limit to four live crew panes per tab excluding the orchestrator, with bounded nesting that cannot expand scope, authority, budget, or pane limits.

This routing reconciliation is informed by Fleet `docs/PHILOSOPHY.md` and `.pi/agents/model-profiles.yaml` (ideas only), revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`; see the [local provenance and full MIT notice](../../../../../reference/crew/README.md#provenance-and-mit-notice). No source runtime or provider payload is adopted.

---

## 1. Bounded Repository Worker

An assigned worker uses evidenced inspection, mutation and verification capabilities within exclusive paths; a profile does not grant tool or git permissions.

- **Durable Core Pattern:** Front-load intent, target paths, constraints, acceptance criteria, and verification commands. Require tool-backed inspection before modifications.
- **Specification Envelope:** Starting State + Target State + Allowed Actions + Forbidden Actions + Stop Conditions + Checkpoints.
- **Scope Locks:** Always lock execution to specific files and directories (e.g., `Only work within /src/components/auth`). Never supply open-ended global tasks without path anchors.
- **Stop Conditions (Mandatory Circuit Breakers):** Unbounded loops cause token exhaustion and regressions. Always instruct:
  > *"Stop and ask before: deleting any file, adding any external package or dependency, modifying database migrations, or executing destructive terminal commands."*
- **Scope and Review:**
  - Add: *"Only make changes directly requested. Do not add features, refactors, or abstractions beyond what was asked."*
  - Require progress and completion claims to cite concrete tool results. Self-verification never substitutes for mandatory independent G8/G9 after SHIP and before a commit proposal. Record actual writer/reviewer identities and separate read-only context evidence; shared identity requires `CORRELATED_REVIEW`. Unknown required identity, authorization, availability or review isolation means `BLOCKED`.
- **Interoperability & Delivery:**
  - For Ship deliverables, calibrate with [Template H](../templates.md#template-h--react--stop-conditions) and use the readable canonical [`ship-diff.md`](../../../../../reference/schemas/ship-diff.md).
  - For Scout audits and architecture discovery, calibrate with [Template M — Bounded Agent Task Brief](../templates.md#template-m--bounded-agent-task-brief) and use the readable canonical [`scout-report.md`](../../../../../reference/schemas/scout-report.md).
  - Enforce code minimalism via [`ponytail`](../../../ponytail/SKILL.md).

---

## 2. Task and Effort Calibration

Match a bounded task to evidenced capabilities under the current authorization, not to a fixed model hierarchy.

- **Core Structure:** Organize prompts into six compact sections: `Goal`, `Context`, `Scope`, `Constraints`, `Approval Boundaries`, and `Done`.
- **Role Needs:** Leads retain constraints and synthesize evidence; coders inspect/edit assigned repository paths and verify changes; reviewers assess standards read-only in separate contexts. These needs do not select providers or create new roles.
- **Reasoning Controls:** Express abstract effort `none | low | medium | high | max` only when supported by discovered capabilities. The active installed harness owns actual parameter translation; no fixed API syntax, token budget, sampling rule or quality guarantee follows from this profile.
- **Orchestration & Hygiene:**
  - Maintain a single primary orchestrator for synthesis. Use concurrency only when evidenced with applicable workspace isolation; supported sequential isolated roles are valid, never writer-session review.
  - Require evidence and verification results (command outputs, test suites) rather than private chain-of-thought traces.

---

## 3. File-Anchored Editor Assistance

Use editor assistance only through an assigned worker and evidenced capabilities; indexing or inline edits are not assumed.

- **Anchor Formula:** `File path` + `Function/Symbol` + `Current behavior` + `Desired change` + `Do-not-touch scope` + `Language/Runtime version`.
- **File Anchoring:** Require an explicit file path and symbol before edits; the installed harness owns how anchors are represented.
- **Done When Criteria:** Every prompt must conclude with an explicit binary completion check:
  > *"Done when: all tests in `tests/test_auth.py` pass and `uv run ruff check` exits with 0."*
- **Decomposition:** Split multi-file refactors into bounded, atomic tasks with exclusive ownership. Do not expand an editor prompt into an unapproved application migration.
- **Minimal Working Diff:** Instruct the agent to modify only the targeted lines, preserving surrounding formatting, docstrings, and imports via [ponytail](../../../ponytail/SKILL.md). Use [Template G](../templates.md#template-g--file-scope).

---

## 4. Approval-Bounded Execution

Terminal, filesystem and browser capabilities must be evidenced and authorized, not inferred from a host label.

- **Operational Boundary:** Starting State + Target State + File Scope + Stop Conditions + Approval Gates.
- **Safety Prompts:**
  > *"Ask before running any terminal commands. Ask before installing dependencies. Never modify files outside `[target_directory]`."*
- **Workflow Decomposition:** Apply required plan/approval gates before delegated execution. Break multi-step features into discrete checkpoints; a prompt is not permission to run tools.
- **Calibration:** Use concise task requirements and observed results rather than assumed model-family behavior.

---

## 5. Runtime UI Verification

UI observations require evidenced runtime/browser access and named artifacts; a successful build alone does not prove layout or interaction.

- **Outcome-First Prompting:** Specify the end deliverable and behavioral outcome rather than micromanaging low-level steps.
- **Plan Pre-Flight:** Supply a bounded task list or implementation contract and satisfy applicable Captain approval gates before edits.
- **Browser Verification:** When the task requires responsive evidence, specify target viewports (for example, 375px and 1440px), behavior and artifact locators. Do not assume built-in browser tooling. If required observation capability is unavailable or unknown, report `BLOCKED`, not a static-inspection substitute.
- **Autonomy Scope:** Strictly define write permissions: *"Ask before running destructive terminal commands. Scope edits strictly to one deliverable per session."*

---

## 6. Signature-Anchored Completion

Completion assistance supplies a candidate within the assigned worker's scope; it grants no independent execution authority.

- **Comment & Signature Priming:** Write the exact function signature, return type annotations, and descriptive docstring immediately before triggering autocompletion.
- **Explicit Boundary Framing:** Specify edge cases, input invariants, and what the function must *not* do directly in the docstring.
- **Prediction Alignment:** Remove ambiguity from the preceding context lines. Inspect and verify generated candidates against the task; plausible completion is not evidence of correctness.

---

## 7. Bounded Application Generation

Generation requests remain subject to approved scope, stack/version and dependencies; they do not authorize new systems or tools.

- **Anti-Boilerplate Directives:** Full-stack generators aggressively inject bloated dependencies, mock stores, and boilerplate. Always specify:
  > *"Use stack: [framework + version]. Do NOT scaffold authentication, dark mode, mock backends, or unrequested styling libraries."*
- **Task Specializations:** Describe visual hierarchy and existing design tokens for UI work. Delineate frontend components from backend routes and database boundaries for application work. Name the approved framework/version rather than accepting a generator's default stack; new system/schema work still requires applicable plan and approval gates.

---

## 8. Multi-Step Implementation

Build/debug tasks require evidenced execution and bounded checkpoints; long sessions do not expand permissions.

- **Comprehensive Starting & Target States:** Document repository conventions, package managers, and exact target behavior before dispatching.
- **Filesystem Scoping:** Restrict filesystem access explicitly:
  > *"Work strictly within `/src`. Do not modify CI/CD pipelines, Dockerfiles, or infrastructure configuration."*
- **Forbidden Actions List:** List explicit boundaries regarding external network requests, database migrations, and library additions.

---

## 9. Read-Only Research and Synthesis

Assign retrieval, comparative analysis or document synthesis explicitly. Retrieval and citation support must be evidenced, not presumed.

- **Search vs Synthesis Mode:** Specify whether the task is information retrieval, comparative analysis, or deep document synthesis.
- **Grounding & Citation Requirements:** Cite primary sources with locators; distinguish confirmed observations, conflicting evidence and unresolved gaps. Do not replace evidence with an invented confidence score.
- **Delivery:** Specify the approved report format and source boundary. Firstmate owns decomposition and exclusive task assignment; intermediate checkpoints require concrete evidence, not acknowledgment alone.

---

## 10. Approval-Bounded Computer Interaction

Desktop/browser actions require task-local capability and permission evidence. Do not assume navigation, account access or form submission is available.

- **Outcome over Navigation:** State the goal and criteria, not the sequence of clicks:
  > *"Locate round-trip flights from SFO to HND under $1,200 departing between Oct 10-15 with zero overnight layovers."*
- **Irreversible Action Circuit Breakers:**
  > *"Do not make purchases, submit financial information, or send communications. Pause and request human confirmation before submitting any final form."*
- **Task Boundaries:** Distinguish read-only research from transactional actions; neither a recommendation nor a completed report authorizes a purchase, account change or external communication. No optional or required adapter is prescribed to fill capability gaps.

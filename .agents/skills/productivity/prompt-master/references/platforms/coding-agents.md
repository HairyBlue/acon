# Platform Catalog: Coding Agents & IDEs

Reference profiles and prompting protocols for autonomous coding agents, IDE assistants, full-stack generators, and execution harnesses. Read this guide when targeting developer tooling, terminal agents, or agentic workflows.

---

## 1. Claude Code

Autonomous agentic CLI that executes shell commands, inspects repositories, edits files, and manages git state.

- **Durable Core Pattern:** Front-load intent, target paths, constraints, acceptance criteria, and verification commands. Require tool-backed inspection before modifications.
- **Specification Envelope:** Starting State + Target State + Allowed Actions + Forbidden Actions + Stop Conditions + Checkpoints.
- **Scope Locks:** Always lock execution to specific files and directories (e.g., `Only work within /src/components/auth`). Never supply open-ended global tasks without path anchors.
- **Stop Conditions (Mandatory Circuit Breakers):** Unbounded loops cause token exhaustion and regressions. Always instruct:
  > *"Stop and ask before: deleting any file, adding any external package or dependency, modifying database migrations, or executing destructive terminal commands."*
- **Model Behavior & Over-Scoping:**
  - Modern frontier Claude models (Fable/Opus) can over-scope or eagerly delegate. Add: *"Only make changes directly requested. Do not add features, refactors, or abstractions beyond what was asked."*
  - Opus self-verifies effectively; avoid redundant verifier subagents for routine edits. For Fable long runs, require all progress claims to cite concrete tool results.
- **Interoperability & Delivery:**
  - For Ship deliverables, calibrate with [Template H](../templates.md#template-h--react--stop-conditions) and lock output to canonical [`ship-diff.yaml`](../../../../../schemas/ship-diff.yaml).
  - For Scout audits and architecture discovery, calibrate with [Template M](../templates.md#template-m--current-claude-task-brief) and lock output to canonical [`scout-report.yaml`](../../../../../schemas/scout-report.yaml).
  - Enforce code minimalism via [`ponytail`](../../../ponytail/SKILL.md).

---

## 2. Codex CLI / ChatGPT Work / Codex IDE

OpenAI-powered terminal agent and IDE surfaces (GPT-5.6 family: Sol, Terra, Luna).

- **Core Structure:** Organize prompts into five compact sections: `Goal`, `Context`, `Scope`, `Constraints`, `Approval Boundaries`, and `Done`.
- **Model Routing:**
  - `gpt-5.6-sol`: Capability-first default for complex refactoring, multi-file edits, and subtle bugfixes.
  - `gpt-5.6-terra`: Fast, economical engine for routine everyday programming.
  - `gpt-5.6-luna`: Deterministic, high-volume tasks with rigid formatting.
- **Reasoning Controls:**
  - Start with default reasoning effort. Elevate to `high` or API `reasoning.mode: "pro"` only when task complexity justifies latency.
  - Sol Pro and Max apply to difficult single-agent investigations; Ultra applies only when splitting into clean, independent tracks.
- **Orchestration & Hygiene:**
  - Maintain a single primary orchestrator for synthesis. Cap subagent concurrency.
  - Require evidence and verification results (command outputs, test suites) rather than private chain-of-thought traces.

---

## 3. Cursor & Windsurf

In-editor AI assistants with codebase indexing, composer capabilities, and inline file edits.

- **Anchor Formula:** `File path` + `Function/Symbol` + `Current behavior` + `Desired change` + `Do-not-touch scope` + `Language/Runtime version`.
- **File Anchoring:** Never invoke composer or inline edits without an explicit file path anchor (`@path/to/file`).
- **Done When Criteria:** Every prompt must conclude with an explicit binary completion check:
  > *"Done when: all tests in `tests/test_auth.py` pass and `uv run ruff check` exits with 0."*
- **Decomposition:** Split multi-file refactors into sequential, atomic prompts. Never ask for full application migrations in a single composer prompt.
- **Minimal Working Diff:** Instruct the agent to modify only the targeted lines, preserving surrounding formatting, docstrings, and imports via [ponytail](../../../ponytail/SKILL.md). Use [Template G](../templates.md#template-g--file-scope).

---

## 4. Cline (formerly Claude Dev)

Autonomous VS Code extension with direct terminal, filesystem, and browser automation tools.

- **Operational Boundary:** Starting State + Target State + File Scope + Stop Conditions + Approval Gates.
- **Safety Prompts:**
  > *"Ask before running any terminal commands. Ask before installing dependencies. Never modify files outside `[target_directory]`."*
- **Workflow Decomposition:** Review Cline's proposed task plan before granting terminal execution permissions. Break multi-step features into discrete checkpoints.
- **Underlying Model Calibration:** Adapt prompt directness to the configured model (match Claude, OpenAI, or local model guidelines).

---

## 5. Antigravity IDE

Google's agent-first IDE powered by Gemini 3 Pro with integrated workspace analysis and browser testing.

- **Outcome-First Prompting:** Specify the end deliverable and behavioral outcome rather than micromanaging low-level steps.
- **Plan Pre-Flight:** Request an Artifact (task list or implementation contract) for human review prior to autonomous codebase edits.
- **Browser Automation Verification:** Exploit built-in browser agents for UI verification:
  > *"After frontend build, verify responsive layout at 375px mobile and 1440px desktop viewports using browser agent."*
- **Autonomy Scope:** Strictly define write permissions: *"Ask before running destructive terminal commands. Scope edits strictly to one deliverable per session."*

---

## 6. GitHub Copilot

Inline code autocompletion and conversational IDE companion.

- **Comment & Signature Priming:** Write the exact function signature, return type annotations, and descriptive docstring immediately before triggering autocompletion.
- **Explicit Boundary Framing:** Specify edge cases, input invariants, and what the function must *not* do directly in the docstring.
- **Prediction Alignment:** Copilot completes statistical likelihoods, not unstated intentions. Remove all ambiguity from the preceding context lines.

---

## 7. Full-Stack Generators (Bolt, v0, Lovable, Figma Make, Google Stitch)

Prompt-to-application generators and visual scaffolding engines.

- **Anti-Boilerplate Directives:** Full-stack generators aggressively inject bloated dependencies, mock stores, and boilerplate. Always specify:
  > *"Use stack: [framework + version]. Do NOT scaffold authentication, dark mode, mock backends, or unrequested styling libraries."*
- **Platform Specializations:**
  - **Lovable:** Design-forward descriptions with visual UX hierarchy and Tailwind classes.
  - **v0:** Vercel/Next.js-native. Explicitly request plain React or Vite if Next.js is not desired.
  - **Bolt:** Full-stack architecture; clearly delineate frontend components from backend routes and database schemas.
  - **Figma Make:** Reference Figma component names, autolayout variables, and design tokens directly.
  - **Google Stitch:** Focus on user interface intent; specify *"match Material Design 3 guidelines"*.

---

## 8. Devin & SWE-agent

Fully autonomous software engineering agents capable of running builds, debugging failures, and navigating repositories.

- **Comprehensive Starting & Target States:** Document repository conventions, package managers, and exact target behavior before dispatching.
- **Filesystem Scoping:** Restrict filesystem access explicitly:
  > *"Work strictly within `/src`. Do not modify CI/CD pipelines, Dockerfiles, or infrastructure configuration."*
- **Forbidden Actions List:** List explicit boundaries regarding external network requests, database migrations, and library additions.

---

## 9. Research & Orchestration AI (Perplexity, Manus AI)

Multi-agent orchestrators and grounded search synthesis engines.

- **Search vs Synthesis Mode:** Specify whether the task is information retrieval, comparative analysis, or deep document synthesis.
- **Grounding & Citation Requirements:** Enforce source attribution: *"Cite all primary sources. Flag any data point where confidence is below 90%."*
- **Manus AI / Perplexity Computer:** Describe the final deliverable format (Markdown report, CSV spreadsheet, executable script). Allow the orchestrator to handle sub-task decomposition while enforcing verification checkpoints on intermediate outputs.

---

## 10. Computer-Use & Browser Agents (Perplexity Comet, OpenAI Atlas, Claude in Chrome, OpenClaw)

Autonomous agents that control desktop environments or web browsers (clicking, typing, form submission).

- **Outcome over Navigation:** State the goal and criteria, not the sequence of clicks:
  > *"Locate round-trip flights from SFO to HND under $1,200 departing between Oct 10-15 with zero overnight layovers."*
- **Irreversible Action Circuit Breakers:**
  > *"Do not make purchases, submit financial information, or send communications. Pause and request human confirmation before submitting any final form."*
- **Agent Roles:** Use Perplexity Comet for research, data scraping, and comparison; use OpenAI Atlas for multi-step transactional flows and account navigation.

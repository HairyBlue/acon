# Agentic Conventions & Control Plane Network (ACON)

> **Firstmate Architectural Standard:** *"Talk to one agent. Ship with a crew."*

**ACON** is an agent-conventions and multi-agent orchestration guide. When the Captain establishes an agent as **ORCHESTRATOR**, that agent acts as the **Agent Control Plane** (the *First Mate*) and may delegate bounded work to specialized crewmates. A **Normal Agent** performs only its Captain-authorized bounded task and does not spawn crew or assume orchestration authority.

ACON supplies conventions, not a runtime integration. Reading `AGENTS.md` / `CLAUDE.md` does not establish delegated SHIP compatibility. The [portable fleet reference](.agents/reference/crew/README.md) defines capability discovery, authorized role routing and unsupported modes for the active installed harness.

---

## 🚀 Quick Start

1. **Clone the repo**
   ```bash
   git clone https://github.com/HairyBlue/acon.git
   ```

2. **Open the ACON repo** with your AI coding assistant.

3. **Tell your agent** where your project is:
   > "Adopt ACON into my project at ~/my-project"

4. **Your agent handles the rest** — it reads the adoption protocol, detects your project's framework, copies the constitution and skills, and scaffolds a local Workshop Manual tailored to your stack.

### Requirements

- A reader of `AGENTS.md` / `CLAUDE.md` can consume the conventions; delegated execution additionally requires evidenced child delegation, isolated contexts, applicable workspace isolation, supervision/communication, terminal completion delivery and separate read-only review.
- One current Captain-authorized model/subscription is sufficient when those capabilities are available. Demonstrated sequential isolated roles may replace concurrency, never independent review. A required `UNAVAILABLE` or `UNKNOWN` capability means `BLOCKED`; seek a Captain-approved supported operating-mode change, not primary-thread implementation or weaker review.
- Standard Unix utilities (`bash`, `rsync`) for `./scripts/adopt.sh`

---

## 🏛️ Core Architecture: Bridge vs. Workshop

ACON resolves the tension between project-level rules and multi-agent coordination by separating concerns into two distinct layers:

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        THE COMMAND BRIDGE                               │
│                         (ACON / AGENTS.md)                              │
│  • One Captain, One Liaison                                             │
│  • Zero-Execution & Zero-Archaeology Mandate (Single-Turn Dispatch)     │
│  • Task Shaping: SHIP (code/tests) vs. SCOUT (read-only spikes)         │
│  • Mutually Exclusive File Scopes (Zero Write Collisions)               │
│  • Evidenced Supervision & Completion (No Assumed Scheduling)           │
│  • On-Demand Fleet Bearings Status Reporting                            │
└────────────────────────────────────┬────────────────────────────────────┘
                                     │
                    [Dispatches Specialist Subagents]
                                     │
                                     ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                        THE WORKSHOP MANUAL                              │
│              (Target Repo AGENTS.md / CLAUDE.md)                        │
│  • Local build, test, and lint commands                                 │
│  • Framework architecture and directory conventions                     │
│  • Team coding styles and language standards                            │
└─────────────────────────────────────────────────────────────────────────┘
```

1. **The Command Bridge (`AGENTS.md`)**: Governs *who commands, how work is partitioned, boundary safety, and status reporting*.
2. **The Workshop Manual (Target Repo `AGENTS.md` / `CLAUDE.md`)**: Governs *local codebase rules*. Dispatched specialists automatically inspect and follow the target repo's local manual without polluting it.

---

## 🔄 Operating Modes & Workflow

ACON defaults to **Normal Agent** mode for solo and small-team velocity:
- **Normal Agent (Default):** Executes your bounded tasks directly—reading files, making minimal working edits (`ponytail`), and verifying via **compiler, typecheck, and linter** checks.
  - **No Unrequested Tests:** Does not write new frontend, UI, database, CRUD, or refactor tests unless you explicitly ask for tests.
  - **Direct Execution (No Unrequested Plans):** Does not generate `docs/plans/` files for everyday features, refactors, or schema changes unless you explicitly request `/plan` or a major multi-system architectural rewrite.
- **ORCHESTRATOR Mode (Opt-In Fleet Mode):** When you explicitly request multi-agent execution (`/teamwork`, *"use a crew"*), the agent coordinates specialized crewmates (`scout`, `worker`, `reviewer`, `oracle`) through a 4-phase lifecycle:
  1. **Phase I: Alignment** — Clarify genuine ambiguities via [`grill-me`](.agents/skills/productivity/grill-me/SKILL.md).
  2. **Phase II: Task Shaping (Parallel Partitioning)** — Partition the project into non-overlapping file scopes so independent tracks can be built simultaneously.
  3. **Phase III: Parallel Crew Flight** — Whenever tasks do not conflict on the same files—both across layers (backend + frontend) and within the same layer (2+ frontend workers on separate pages/components, 2+ backend workers on separate endpoints/services, or parallel scouts)—**hire and dispatch multiple crew members concurrently** rather than bottlenecking on a single worker, per the [portable fleet reference](.agents/reference/crew/README.md#host-neutral-orchestration).
  4. **Phase IV: Synthesis & Gatekeeping** — Verify diffs via build/typecheck/lint and independent read-only review (`crew/code-reviewer.md`, `crew/security-reviewer.md`), then present the 4-section Fleet Bearings Digest. Git commits/pushes remain strictly gated on Captain approval.

### Terminal fleet lifecycle (normative detail)

If acting role is unknown, ask whether you are a Normal Agent or ORCHESTRATOR before role-dependent action; verified role or approved crew handoff establishes it. A Normal Agent performs only its Captain-authorized bounded task and never spawns crew. The user manually opens/resumes the ORCHESTRATOR; ledger data does not launch it.

For terminal orchestration, use only the local, ignored `.acon/sessions.json` and exact sibling `.acon/sessions.json.tmp`. Before launch or resume, safely initialize the existing minimal schema when absent, validate it against the active workspace, and reconcile owned live conversations. The ORCHESTRATOR owns ledger writes; one bounded delegated writer may perform one exact update only while the ORCHESTRATOR suspends its own writes, validates the result, and resumes sole ownership. Never allow concurrent writers. Register each verified launch/join before another; completed crew CLIs remain alive, idle and registered. Retirement requires a separate explicit Captain instruction naming or unambiguously identifying targets; remove a ledger entry only after actual retirement is confirmed. Preserve saved conversations and panes unless separately authorized for deletion/closure. Unknown, failed or unreachable sessions remain pending and are never duplicated or guessed-recreated. Count idle live CLIs against the approved mission ceiling; queue or pause when full—never auto-quit or recycle. Reuse an idle same-role conversation only for currently authorized work after refreshing its bounded brief/skills and verifying role, context, model, workspace and capabilities; no silent persona/model change and never reuse a writer context for reviewer work. See the [canonical retained-crew lifecycle](.agents/reference/crew/README.md#manual-orchestrator-session-ledger). Adopt an existing normal-agent session only with explicit Captain opt-in and verified identity, workspace, role/persona and model/effort; preserve the live conversation and change role/model only with consent and supported controls.

Move only a verified owned joining session, and only when supported and approved: keep the ORCHESTRATOR alone on the left and distribute fleet panes on the right within approved ceilings, ownership, readability and host-attested geometry. If safe movement or layout support is unknown, preserve the current layout and pause/queue. These instructions are a documentation contract, not automation, runtime or host-compatibility certification. The [portable fleet reference](.agents/reference/crew/README.md#host-neutral-orchestration) is canonical for routing; its [manual ledger lifecycle](.agents/reference/crew/README.md#manual-orchestrator-session-ledger) governs safe I/O and roster operations. Captain spend/Git authority and independent reviews remain required.

---

## 🚀 How to Utilize the Control Plane

### Pattern 1: Central Command Hub (Firstmate Style — Recommended)
Run your primary agent directly inside the **ACON** workspace. You can direct it to work on any local repository without adding extra files to that repository:

```text
Captain: "Inspect /path/to/billing-app. Decompose the Stripe webhook refactor
          into backend service and feature tests, and dispatch specialists."
```

* The Control Plane scopes any required investigation and obtains launch approval before assigning a `Codebase Scout` through the route supported by the actual execution surface.
* After the findings, it shapes bounded specialist tasks and proceeds only when required capabilities and approvals are in place.
* Specialists follow the target project's local instructions and verification commands.
* The Control Plane synthesizes results and briefs you; a capability gap blocks execution rather than authorizing fallback.

---

### Integrating ACON into Existing Projects
To adopt ACON into an existing project while preserving all local conventions verbatim, run the adoption script:
```bash
./scripts/adopt.sh /path/to/my-project
```
Alternatively, invoke our built-in [`adopt-acon`](.agents/skills/productivity/adopt-acon/SKILL.md) skill to inspect, onboard, and configure any existing repository automatically.

---

## ⚓ Fleet Status Protocol (The Bearings Digest)

Whenever you ask:
> *"What is the status?"*, *"Give me bearings"*, *"Where are we at?"*, or *"Recap"*

The Control Plane renders the canonical **4-section Bearings digest**:

```markdown
### ⚓ Fleet Bearings Digest

#### 1. Captain's Call
*ONLY unsuppressed items needing the Captain's action now: decisions, blockers, PR approvals.*
- **[Decision #1]**: Choose between Redis vs. Database cache locks for Stripe webhook idempotency.
  - *Option A (Recommended):* Redis Cache Locks (`Cache::lock`) — atomic and high-throughput.
  - *Option B:* Database transactions — higher latency but zero external dependencies.
*(Empty-state: "Nothing needs your action right now.")*

#### 2. Recently Landed
*Bounded recent completions: verified code, merged PRs, or completed scout reports.*
- **[Stripe Webhook Idempotency]** (`Ship`): Implemented `app/Services/Billing/WebhookHandler.php`, 8 Pest tests passing.
*(Empty-state: "No recent completions are in the current baseline.")*

#### 3. Underway
*Live work progressing on its own: one line of current state per active specialist.*
- **[Test Engineer]** (`Ship`): Authoring concurrency tests in `tests/Feature/Billing/` [In flight]
*(Empty-state: "Nothing is underway.")*

#### 4. Charted Next
*Queued work waiting on active dependencies.*
- **[Frontend UI Notification]**: Blocked on backend webhook payload finalization.
*(Empty-state: "Nothing is queued.")*
```

---

## 📁 Repository Structure

```
acon/
├── AGENTS.md                                     # The Control Plane Constitution (Master Rules)
├── CLAUDE.md                                     # Existing compatibility entry point -> same AGENTS.md constitution; not a runtime requirement
├── README.md                                     # Human-facing guide and operational instructions
├── scripts/                                      # Control Plane automation scripts
│   └── adopt.sh                                  # Repository adoption & synchronization script
└── .agents/                                      # Central Physical Source of Truth (Pure Conventions)
    ├── INDEX.md                                  # Fast symptom, task, and skill lookup matrix
    ├── README.md                                 # Internal catalog
    ├── rules/                                    # Non-Negotiable Agent Rules
    │   ├── agent-control-plane.md                # Delegation, Bearings, and task contracts
    │   ├── security-secrets-guard.md             # Zero-leakage policy for credentials and secrets
    │   ├── git-conventional-commits.md           # Conventional Commits v1.0.0
    │   └── progress-reporting.md                 # Markdown-first daily reporting standards
    ├── skills/                                   # Curated Modular Agent Skills
        ├── design/                               # 4 Skills + 67 style presets + 17 craft references
        ├── engineering/                          # 14 Skills (refactoring, api-design, frontend-conventions, diagnosing-bugs...)
        ├── productivity/                         # 11 Skills (ponytail, mpor-report, daily-progress-report, grill-me, adopt-acon...)
        └── security-devops/                      # 6 Skills (security-audit, git-worktrees, shell-scripting, setup-pre-commit...)
    └── reference/                                # Reference Catalog, Contracts & Subagent Briefs
        ├── crew/                                 # Specialist Subagent Persona Briefs (scout, worker, reviewer...)
        ├── schemas/                              # 7 normative Markdown contract specifications (not executable validators)
        ├── workflows/                            # Repeatable Multi-Agent Workflows (council, review-loop...)
        └── fowler-smells.md                      # Code smell reference guide
```

---

### Contract specifications

The seven canonical Markdown contract specifications document required fields, types, enums, bounds, and conditional rules in readable tables. They are normative documentation, not executable validation schemas:

- [ScoutReport](.agents/reference/schemas/scout-report.md)
- [ShipDiff](.agents/reference/schemas/ship-diff.md)
- [GrillInterview](.agents/reference/schemas/grill-interview.md)
- [TaskContract](.agents/reference/schemas/task-contract.md)
- [HandoffState](.agents/reference/schemas/handoff-state.md)
- [BearingsDigest](.agents/reference/schemas/bearings-digest.md)
- [ReviewReport](.agents/reference/schemas/review-report.md)

## 📖 Dynamic Documentation Standard

ACON intentionally ships **zero bundled framework tutorials or static library manuals**. Bundled framework documentation rapidly becomes outdated, adds maintenance overhead, and causes version drift against target codebases.

Instead, ACON enforces the **Dynamic Documentation Standard**:
1. **Manifest Inspection:** When an agent operates on a specific framework or library, it inspects the target project's dependency manifest (`package.json`, `composer.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`) to determine the exact pinned version.
2. **On-Demand Consultation:** The agent consults the framework's official documentation, releases, or repository matching that specific version on demand.
3. **Workshop Manual Alignment:** Local framework conventions, project quirks, or architecture standards are maintained in the target repository's Tier 2 [Workshop Manual](AGENTS.md#3-command-bridge-vs-workshop-manuals-multi-repo-interoperability).

---

## 🛠️ Curated Specialist Skills (`.agents/skills/`)

When the Control Plane dispatches specialists, it equips them with targeted domain skills on demand:

### 🎨 1. Design & UI/UX (`.agents/skills/design/` - 4 Skills + 67 Presets + 17 Craft References)
- **`craft/` (17 Design Craft References)**: Primary design craft and anti-slop foundation adopted from **`referodesign/refero_skill`** and **`nexu-io/open-design`**. Specialized deep-dive modules covering anti-slop invariants, mandatory 5-state interactive UI coverage, cognitive UX laws, typography rhythm contracts, spring physics motion science, WCAG 2.2 accessibility baselines, form validation UX, semantic color tokens, RTL/BiDi layout, and reference research methodology. Craft rules take strict precedence over generic aesthetic presets or framework boilerplates.
- **`interface-design`**: Foundational craft engineering to eradicate generic AI slop. Enforces single focal points, weight > size hierarchy, 60/30/10 color rule, subtle surface elevation, persistent design memory (`system.md`), and anti-slop audits (`design-deslop`).
- **`better-interface`**: Read-only, evidence-led existing-interface audit across accessibility, layout, writing, typography, and polish.
- **`find-animation-opportunities`**: Read-only motion-opportunity discovery; reject unsupported, decorative, high-frequency, or reduced-motion-incompatible candidates.
- **`impeccable`**: Design Director and visual quality floor engine with 23 lifecycle commands, craft floor quality checks, and mechanical anti-pattern detection.
- **`styles/` (67 Aesthetic Style Presets)** with explicit intent-to-style routing:
  - **Clean & Minimal**: [`styles/clean`](.agents/skills/design/styles/clean/DESIGN.md), [`styles/minimal`](.agents/skills/design/styles/minimal/DESIGN.md), [`styles/spacious`](.agents/skills/design/styles/spacious/DESIGN.md) (ample whitespace, 8pt grid, low cognitive load).
  - **Slick & Modern Tech**: [`styles/sleek`](.agents/skills/design/styles/sleek/DESIGN.md), [`styles/bento`](.agents/skills/design/styles/bento/DESIGN.md), [`styles/shadcn`](.agents/skills/design/styles/shadcn/DESIGN.md), [`styles/modern`](.agents/skills/design/styles/modern/DESIGN.md) (Inter + JetBrains Mono, dark elevation, subtle borders).
  - **Enterprise & Dense**: [`styles/ant`](.agents/skills/design/styles/ant/DESIGN.md), [`styles/corporate`](.agents/skills/design/styles/corporate/DESIGN.md), [`styles/enterprise`](.agents/skills/design/styles/enterprise/DESIGN.md), [`styles/matrix`](.agents/skills/design/styles/matrix/DESIGN.md) (compact tables, tabular numerals).
  - **Bold & Expressive**: [`styles/neobrutalism`](.agents/skills/design/styles/neobrutalism/DESIGN.md), [`styles/bold`](.agents/skills/design/styles/bold/DESIGN.md), [`styles/neon`](.agents/skills/design/styles/neon/DESIGN.md) (hard shadows, black outlines, saturated contrast).
  - **Warm & Editorial**: [`styles/editorial`](.agents/skills/design/styles/editorial/DESIGN.md), [`styles/claude`](.agents/skills/design/styles/claude/DESIGN.md), [`styles/paper`](.agents/skills/design/styles/paper/DESIGN.md) (serif headlines, parchment warmth, natural earth tones).
  - **Playful & Retro**: [`styles/claymorphism`](.agents/skills/design/styles/claymorphism/DESIGN.md), [`styles/glassmorphism`](.agents/skills/design/styles/glassmorphism/DESIGN.md), [`styles/retro`](.agents/skills/design/styles/retro/DESIGN.md) (3D pill depth, frosted glass, 8-bit nostalgia).

### ⚙️ 2. Engineering (`.agents/skills/engineering/` - 14 Skills)
- **`refactoring`**: Fowler refactoring catalog, Two-Hats rule, guard clauses, extract/inline method, polymorphism, and strangler fig.
- **`api-design`**: RESTful modeling, RFC 7807 problem details, idempotency keys, keyset/cursor pagination, and HMAC webhooks.
- **`frontend-conventions`**: Modular file structure (≤300 lines), pragmatic logic separation, and zero reinvention of UI primitives.
- **`diagnosing-bugs`**: Fast-path direct fixes for obvious bugs; systematic feedback loop for elusive bugs.
- **`code-review`**: Parallel two-axis review (Standards adherence + Spec conformance).
- **`domain-modeling`**: Ubiquitous language definition, scenario testing, and ADR tracking.
- **`codebase-design`** & **`improve-codebase-architecture`**: Deep module design principles (small interfaces, clean seams).
- **`tdd`**: Opt-in red-green-refactor test-driven development loop (only when explicitly requested).
- **`zero-downtime-migrations`**: 5-phase Expand/Contract pattern and online index creation (high-traffic production only).
- **`to-spec`**, **`prototype`**, **`wizard`**, **`setup-ts-deep-modules`**: Opt-in spec synthesis, UI/logic prototyping, CLI setup wizards, and TS boundary enforcement.

### 🧠 3. Productivity (`.agents/skills/productivity/` - 11 Skills)
- **`ponytail`**: Pragmatically lazy senior engineer persona, 7-Rung Decision Ladder (YAGNI, stdlib, platform natives, zero-deps, inline clarity), anti-overengineering reviews, and debt ledger.
- **`mpor-report`**: MPOR Efficiency counts/totals with an approved accomplishment narrative and optional copy-ready card text.
- **`daily-progress-report`**: Daily, weekly, monthly, or custom work progress reports.
- **`grill-me`**: Design & plan interrogation across the decision frontier when requirements have genuine ambiguity.
- **`handoff`**: Compacts conversation context into a structured handoff document.
- **`prompt-master`**: 9-dimension intent extraction, model-specific prompt calibration, and airtight agent task briefs.
- **`adopt-acon`**: Universal repository adoption and synchronization suite enforcing physical catalog deployment, CLAUDE.md symlink to AGENTS.md, and Two-Tier AGENTS.md merge standard.
- **`writing-plans`**: Opt-in implementation planning (`docs/plans/`) when explicitly requested (`/plan`) or for major architectural rewrites.
- **`developer-story`**: Authentic developer stories, builder journeys, personal dispatches, and CASI portfolio case studies.
- **`writing-for-agents`**: Guidelines and mechanics for authoring effective skills and agent rules.
- **[`technical-writing-for-engineers`](.agents/skills/productivity/technical-writing-for-engineers/SKILL.md)**: Technical RFCs, architecture decisions, and post-mortems.

### 🔒 4. Security & DevOps (`.agents/skills/security-devops/` - 6 Skills)
- **`security-audit`**: Universal, language-agnostic static security audit engine (OWASP Top 10 (2021), OWASP API Security Top 10 (2023), D1-D10 matrix, taint analysis, AST triage, closed-loop remediation).
- **`shell-scripting`**: Production bash scripting, `set -euo pipefail`, cleanup traps, safe quoting, and option parsing.
- **`git-worktrees`**: Multi-agent git worktree isolation topology, lifecycle management, and branch collision avoidance.
- **`conventional-commits`**: Conventional Commits v1.0.0 specification enforcement.
- **`git-guardrails`**: Universal pre-execution hooks blocking destructive git operations.
- **`setup-pre-commit`**: Husky + lint-staged + Prettier / typecheck pre-commit hooks.

---

## 🔍 Central Lookup Matrix

Refer to **[`.agents/INDEX.md`](.agents/INDEX.md)** for a fast symptom, task, and skill lookup matrix.

---

## Provenance and MIT notice

Capability/discovery and optional-learning wording is informed by Fleet `docs/PHILOSOPHY.md`, `.pi/agents/model-profiles.yaml` (ideas only) and `skills/compound-learning/SKILL.md`, revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`. See the [local provenance and full MIT notice](.agents/reference/crew/README.md#provenance-and-mit-notice). No source runtime configuration is adopted.

## End provenance and MIT notice

## 📚 References & Prior Art

ACON builds upon and draws architectural inspiration from pioneering patterns in the AI agent and developer tooling ecosystem:

- **[Firstmate](https://github.com/kunchenguid/firstmate)**: Architectural standard for the Agent Control Plane (*"Talk to one agent. Ship with a crew."*), First Mate liaison model, Ship vs. Scout task shaping, non-overlapping file boundary isolation, and Fleet Bearings status digests.
- **[nidhinjs / prompt-master](https://github.com/nidhinjs/prompt-master)**: 9-dimension intent extraction, model-specific prompt calibration, and airtight agent task briefing templates.
- **[Dammyjay93 / interface-design](https://github.com/Dammyjay93/interface-design)**: Craft-first interface design engineering, anti-slop rules, subtle surface elevation, and persistent design memory.
- **[bergside / awesome-design-skills](https://github.com/bergside/awesome-design-skills)**: Curated registry of 67 design system skill presets and token specifications.
- **[Matt Pocock's Skills](https://github.com/mattpocock/skills)**: Modular agent skill conventions, disciplined engineering workflows, specification synthesis, and reproducible agent interactions.
- **[Cal.diy Repository](https://github.com/calcom/cal.diy/tree/main)**: Structural pattern for `.claude`, `.cursor`, and `.agents` symlinks, centralized rules, and cross-IDE agent tooling configuration.
- **[3stoneBrother / code-audit](https://github.com/3stoneBrother/code-audit)**: Static code security analysis methodology, vulnerability checklists (PHP, JS, Python, C#), taint tracking, and verification techniques.
- **[marcelorodrigo / agent-skills](https://github.com/marcelorodrigo/agent-skills)**: Curated agent skills ecosystem, engineering workflows, and prompt architecture.
- **[dietrichgebert / ponytail](https://github.com/dietrichgebert/ponytail)**: Pragmatically lazy senior developer persona, 7-Rung Decision Ladder (YAGNI, stdlib, platform natives, zero-deps, inline clarity), and code-level anti-overengineering reviews.
- **[referodesign / refero_skill](https://github.com/referodesign/refero_skill)**: Upstream foundation for ACON's design craft reference library (`craft/`). Adopted the reference research methodology (Tier 1–3 research sweeps across Styles → Screens → Flows with decision ledger traceability), anti-slop patterns, typography scale & rhythm contracts, semantic color tokens, spring physics motion science, icons, copywriting, and visual workflow triage.
- **[nexu-io / open-design](https://github.com/nexu-io/open-design)**: Upstream foundation for ACON's design craft reference library (`craft/`). Adopted universal craft invariants grounded in primary research (WCAG 2.2, W3C, Material 3, Apple HIG, Baymard Institute), including core anti-slop invariants, mandatory 5-state interactive UI coverage, cognitive UX laws, accessibility baselines, form validation timing & error UX, and RTL/BiDi layouts.

> **Heartfelt Acknowledgement:** Immense gratitude to the countless open-source developers, researchers, and community builders whose gists, discussions, and experiments have quietly advanced modern agentic conventions and developer tooling. Even where not cited individually by name, your work and shared knowledge form the collective bedrock of this project. Thank you!


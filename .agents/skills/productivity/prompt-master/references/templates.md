# Prompt Templates Reference

Full template library for Prompt Master. Read the relevant template when the user's task type matches. Do not load all templates at once — only the one you need.

For ACON tasks, G/H/M consume the [portable fleet contract](../../../../reference/crew/README.md) and assigned [TaskContract](../../../../reference/schemas/task-contract.md). Required delegation, isolated contexts/workspaces, supervision/communication, terminal completion delivery and separate read-only review must be `AVAILABLE`; `UNAVAILABLE` or `UNKNOWN` means `BLOCKED`. Firstmate delegates inspection and implementation; it never executes on the primary thread. Supported sequential isolated roles may replace concurrency, never independent G8/G9 or writer/reviewer separation. Receipt is not completion.

For each role, including reviewers, propose an available Captain-permitted choice and supported effort, and obtain approval before launch. Temporary role choices require explicit approval, available-choice evidence, expiry and a time/cost ceiling. Recheck authorization and availability at dispatch, resume and completion; pause expired/unavailable work and resume only under a still-valid explicitly approved fallback. Do not probe or launch before permitted discovery, choice approval and quota/time/cost notice; discovery grants no spending authority. Actual shared model identity requires `CORRELATED_REVIEW` while retaining separate read-only contexts.

## Table of Contents

| Template | Best For |
|----------|----------|
| [A — RTF](#template-a--rtf) | Simple one-shot tasks |
| [B — CO-STAR](#template-b--co-star) | Professional documents, business writing |
| [C — RISEN](#template-c--risen) | Complex multi-step projects |
| [D — CRISPE](#template-d--crispe) | Creative work, brand voice |
| [E — Auditable Reasoning](#template-e--auditable-reasoning) | Logic, math, analysis, debugging |
| [F — Few-Shot](#template-f--few-shot) | Consistent structured output, pattern replication |
| [G — File-Scope](#template-g--file-scope) | Assigned code edits with exact path and section ownership |
| [H — ReAct + Stop Conditions](#template-h--react--stop-conditions) | Bounded Ship worker with evidenced execution and review capabilities |
| [I — Visual Descriptor](#template-i--visual-descriptor) | Midjourney, DALL-E, Stable Diffusion, Sora |
| [J — Reference Image Editing](#template-j--reference-image-editing) | Editing an existing image with a reference |
| [K — ComfyUI](#template-k--comfyui) | ComfyUI node-based image workflows |
| [L — Prompt Decompiler](#template-l--prompt-decompiler) | Breaking down, adapting, or splitting existing prompts |
| [M — Bounded Agent Task Brief](#template-m--bounded-agent-task-brief) | Scoped task for any assigned role with current requirement evidence |

---

## Template A — RTF

*Role, Task, Format. Use for fast one-shot tasks where the request is clear and simple.*

```
Role: [One sentence defining who the AI is]
Task: [Precise verb + what to produce]
Format: [Exact output format and length]
```

**Example:**
```
Role: You are a senior technical writer.
Task: Write a one-paragraph description of what a REST API is.
Format: Plain prose, 3 sentences maximum, no jargon, suitable for a non-technical audience.
```

---

## Template B — CO-STAR

*Context, Objective, Style, Tone, Audience, Response. Use for professional documents, business writing, reports, and marketing content where full context control matters.*

```
Context: [Background the AI needs to understand the situation]
Objective: [Exact goal — what success looks like]
Style: [Writing style: formal / conversational / technical / narrative]
Tone: [Emotional register: authoritative / empathetic / urgent / neutral]
Audience: [Who reads this — their knowledge level and expectations]
Response: [Format, length, and structure of the output]
```

**Example:**
```
Context: I am a founder pitching a B2B SaaS tool that automates expense reporting for mid-size companies.
Objective: Write a cold email that gets a reply from a CFO.
Style: Direct and conversational, not salesy.
Tone: Confident but not pushy.
Audience: CFO at a 200-person company, busy, skeptical of vendor emails.
Response: 5 sentences max. Subject line included. No bullet points.
```

---

## Template C — RISEN

*Role, Instructions, Steps, End Goal, Narrowing. Use for complex projects, multi-step tasks, and any output that requires a clear sequence of actions.*

```
Role: [Expert identity the AI should adopt]
Instructions: [Overall task in plain terms]
Steps:
  1. [First action]
  2. [Second action]
  3. [Continue as needed]
End Goal: [What the final output must achieve]
Narrowing: [Constraints, scope limits, what to exclude]
```

**Example:**
```
Role: You are a product manager with 10 years of experience in mobile apps.
Instructions: Write a product requirements document for a habit tracking feature.
Steps:
  1. Define the problem statement in one paragraph
  2. List user stories in the format "As a [user], I want [goal] so that [reason]"
  3. Define acceptance criteria for each story
  4. List out-of-scope items explicitly
End Goal: A PRD that an engineering team can begin sprint planning from immediately.
Narrowing: No technical implementation details. No wireframes. Under 600 words total.
```

---

## Template D — CRISPE

*Capacity, Role, Insight, Statement, Personality, Experiment. Use for creative work, brand voice writing, and any task where personality, tone, and iteration matter.*

```
Capacity: [What capability or expertise the AI should have]
Role: [Specific persona to adopt]
Insight: [Key background insight that shapes the response]
Statement: [The core task or question]
Personality: [Tone and style — witty / authoritative / casual / sharp]
Experiment: [Request variants or alternatives to explore]
```

**Example:**
```
Capacity: Expert copywriter specializing in SaaS product launches.
Role: Brand voice for a productivity tool aimed at developers.
Insight: Developers hate marketing speak and respond to honesty and specificity.
Statement: Write the hero headline and sub-headline for the landing page.
Personality: Sharp, dry, confident — no adjectives, no exclamation marks.
Experiment: Give 3 variants ranging from minimal to bold.
```

---

## Template E — Auditable Reasoning

*Use for logic-heavy tasks, math, debugging, and multi-factor analysis where the result must be checkable without requesting private reasoning.*

```
[Task statement]

Return:
1. Conclusion
2. Assumptions
3. Evidence or intermediate results needed to audit the conclusion
4. Verification checks performed
5. Remaining uncertainty, if any

Do not reveal hidden chain-of-thought or private reasoning. Keep the rationale concise and decision-relevant.
```

**When to use:**
- Debugging where the cause is not obvious
- Comparing technical approaches
- Math or calculation requiring verification
- Analysis where evidence and assumptions must be inspectable

**When NOT to use:**
- Simple tasks where the answer is clear
- Creative tasks where an audit trail adds noise

---

## Template F — Few-Shot

*Use when the output format is easier to show than describe. Examples outperform written instructions for format-sensitive tasks every time.*

```
[Task instruction]

Here are examples of the exact format needed:

<examples>
  <example>
    <input>[example input 1]</input>
    <output>[example output 1]</output>
  </example>
  <example>
    <input>[example input 2]</input>
    <output>[example output 2]</output>
  </example>
</examples>

Now apply this exact pattern to: [actual input]
```

**Rules:**
- 2 to 5 examples is the sweet spot. More rarely helps and wastes tokens.
- Examples must include edge cases, not just easy cases.
- Use XML tags to wrap examples when the target system demonstrably supports that structure.
- If you have been re-prompting for the same formatting correction twice, switch to few-shot instead of rewriting instructions.

---

## Template G — File-Scope

*Use for an assigned coding worker or IDE assistant with evidenced editing capabilities. Exact file and section ownership bounds the change; verification and independent review remain required for ACON tasks.*

```
File: [exact/path/to/file.ext]
Function/Component: [exact name]

Current Behavior:
[What this code does right now — be specific]

Desired Change:
[What it should do after the edit — be specific]

Scope:
Only modify [function / component / section].
Do NOT touch: [list everything to leave unchanged]

Constraints:
- Language/framework: [specify version]
- Do not add dependencies not in [package.json / requirements.txt]
- Preserve existing [type signatures / API contracts / variable names]

Done When:
[Exact condition that confirms the change worked correctly]
[TaskContract requirement IDs, exact assertions/revisions, applicable parity inventory and proof commands]
Report current evidence and unproven results; a changed file alone is not proof.
```

---

<a id="template-h--react--stop-conditions"></a>
## Template H — ReAct + Stop Conditions (Ship)

*Use for a bounded Ship worker under installed-harness capability and authorization evidence. Stop conditions, assigned path ownership and current proof bound execution; no template grants additional authority.*

```
Objective:
[Single, unambiguous goal in one sentence]

Starting State:
[Current file structure / codebase state / environment]

Target State:
[What should exist when the agent is done]

Allowed Actions:
- [Explicitly authorized inspection, edits and verification in exact assigned paths]

Forbidden Actions:
- Do NOT modify files outside [directory/scope]
- Do NOT run the dev server or deploy unless explicitly authorized
- Do NOT stage, commit, push, create branches or mutate remotes without explicit Captain approval
- Do NOT delete files, install dependencies or change schemas without explicit Captain approval
- Do NOT make architecture decisions without human approval

Code Minimalism & Diff Constraints:
Enforce [ponytail](../../ponytail/SKILL.md) 7-Rung Ladder: deliver the minimum working diff, eliminate dead code, prefer existing codebase utilities and standard libraries over new dependencies, and avoid speculative abstractions.

Stop Conditions:
Pause and ask for human review when:
- A file would be permanently deleted
- A new external service or API needs to be integrated
- Two valid implementation paths exist and the choice affects architecture
- An error cannot be resolved in 2 attempts
- The task requires changes outside the stated scope

Checkpoints:
Report changed state or verification results at assigned checkpoints; distinguish receipt from completion.

Requirement Evidence:
Carry exact TaskContract requirement IDs, assertions/revisions and applicable parity inventory.
Record current assertion_evidence, command exits and artifact locators; missing or stale proof is UNPROVEN, not completion.

Grammar Envelope (Constrained Sampling):
Enforce grammars-and-constrained-sampling. Deliver the final summary strictly conforming to the canonical [ship-diff.md](../../../../reference/schemas/ship-diff.md) contract:
- Zero Conversational Preamble (forbid "Sure!", "Here is...", pleasantries; start directly with the YAML envelope).
- Schema-locked output must follow [ship-diff.md](../../../../reference/schemas/ship-diff.md).
- Zero markdown prose or filler outside the envelope.
- Mandatory independent G8/G9 follow worker verification; self-verification cannot replace them.
```

---

## Template I — Visual Descriptor

*Use for Midjourney, DALL-E 3, Stable Diffusion, Sora, Runway, and any image or video generation tool.*

```
Subject: [Main subject — specific, not vague]
Action/Pose: [What the subject is doing]
Setting: [Where the scene takes place]
Style: [photorealistic / cinematic / anime / oil painting / vector / etc.]
Mood: [dramatic / serene / eerie / joyful / etc.]
Lighting: [golden hour / studio / neon / overcast / candlelight / etc.]
Color Palette: [dominant colors or named palette]
Composition: [wide shot / close-up / aerial / Dutch angle / etc.]
Aspect Ratio: [16:9 / 1:1 / 9:16 / 4:3]
Negative Prompts: [blurry, watermark, extra fingers, distortion, low quality]
Style Reference: [artist / film / aesthetic reference if applicable]
```

**Tool-specific syntax:**
- **Midjourney**: Comma-separated descriptors, not prose. Add `--ar`, `--style`, `--v 6` at the end.
- **Stable Diffusion**: Use `(word:1.3)` weight syntax. CFG scale 7 to 12. Negative prompt is mandatory.
- **DALL-E 3**: Prose works well. Add "do not include any text in the image" unless text is needed.
- **Sora / video**: Add camera movement (slow dolly, static shot, crane up), duration in seconds, and cut style.

---

## Template J — Reference Image Editing

*Use when the user has an existing image they want to modify. Completely different from generation — never describe the whole scene from scratch, only describe the change.*

**Before writing the prompt, always tell the user:**
"Attach your reference image to [tool name] before sending this prompt."

**Detect the tool's editing capability:**
- Midjourney: use `--cref [image URL]` for character reference or `--sref` for style reference
- DALL-E 3: use the Edit endpoint, not the Generate endpoint. User must be in ChatGPT with image editing enabled
- Stable Diffusion: use img2img mode, not txt2img. Set denoising strength 0.3-0.6 to preserve the original

```
Reference image: [attached / URL]
What to keep exactly the same: [list everything that must not change]
What to change: [specific edit only — be precise]
How much to change: [subtle / moderate / significant]
Style consistency: maintain the exact style, lighting, and mood of the reference
Negative prompt: [what to avoid introducing]
```

**Example:**
```
Reference image: [attached portrait photo]
What to keep exactly the same: face, hair, clothing, background, lighting
What to change: head angle — rotate from facing left to facing straight forward
How much to change: subtle, preserve all facial features exactly
Style consistency: maintain photorealistic style, same lighting direction
Negative prompt: no new elements, no style changes, no background changes
```

---

## Template K — ComfyUI

*Use for ComfyUI node-based workflows. Always output Positive and Negative prompts as separate blocks. Ask for the checkpoint model before writing — syntax and token limits differ per model.*

**Ask first if not stated:**
"Which checkpoint model are you using? (SD 1.5, SDXL, Flux, or other)"

**Model-specific notes:**
- SD 1.5: shorter prompts work better, under 75 tokens per block, use (word:weight) syntax
- SDXL: handles longer prompts, supports more natural language alongside weighted syntax
- Flux: natural language works well, less reliance on weighted syntax, very responsive to style descriptions

```
POSITIVE PROMPT:
[subject], [style], [mood], [lighting], [composition], [quality boosters: highly detailed, sharp focus, 8k]

NEGATIVE PROMPT:
[what to exclude: blurry, low quality, watermark, extra limbs, bad anatomy, distorted, oversaturated]

CHECKPOINT: [model name]
SAMPLER: Euler a (recommended starting point)
CFG SCALE: 7 (increase for stricter prompt adherence)
STEPS: 20-30
RESOLUTION: [width x height — must be divisible by 64]
```

---

## Template L — Prompt Decompiler

*Use when the user pastes an existing prompt and wants to break it down, adapt it for a different tool, simplify it, or understand its structure. This is analysis and adaptation, not building from scratch.*

**Detect which Decompiler task is needed:**
- **Break down** — explain what each part of the prompt does
- **Adapt** — rewrite for a different tool while preserving intent
- **Simplify** — remove redundancy and tighten without losing meaning
- **Split** — divide a complex one-shot prompt into a cleaner sequence

**For Adapt tasks, always ask:**
"What tool is the original prompt from, and what tool are you adapting it for?"

**Break down output format:**
```
Original prompt: [paste]

Structure analysis:
- Role/Identity: [what role is assigned and why]
- Task: [what action is being requested]
- Constraints: [what limits are set]
- Format: [what output shape is expected]
- Weaknesses: [what is missing or could cause wrong output]

Recommended fix: [rewritten version with gaps filled]
```

**Adapt output format:**
```
Original ([source tool]): [original prompt]

Adapted for [target tool]:
[rewritten prompt using target tool syntax and best practices]

Key changes made:
- [change 1 and why]
- [change 2 and why]
```

**Split output format:**
```
Original prompt: [paste]

This prompt is doing [N] things. Split into [N] sequential prompts:

Prompt 1 — [what it handles]:
[prompt block]

Prompt 2 — [what it handles]:
[prompt block]

Run these in order. Each output feeds the next.
```
---

<!-- Legacy fragment retained only for link compatibility, not runtime selection. -->
<a id="template-m--current-claude-task-brief"></a>
<a id="template-m--bounded-agent-task-brief"></a>
## Template M — Bounded Agent Task Brief

*Use for any assigned role's scoped task. Front-load outcome, context, scope, action boundaries and evidence without private-reasoning requests. Scout/Oracle/reviewer tasks remain read-only; only an assigned writer may implement within its exclusive paths.*

```
## Objective
[What needs to be built, fixed, or produced — one clear sentence. Add WHY if it affects approach.]

## Context
[What exists now — relevant files, current behavior, stack already in place, what was tried and failed]

## Target State
[What done looks like — specific files changed, behavior produced, tests passing. Binary where possible.]

## Scope
- Work only in: [specific files and directories]
- Do NOT touch: [forbidden files — .env, package-lock.json, configs, anything outside scope]

## Constraints
- [Stack version, naming conventions, no new dependencies without asking]
- Only make changes directly requested. Do not add features, abstractions, or files beyond what was asked.
- Enforce [ponytail](../../ponytail/SKILL.md) minimalism: prefer minimum working diff, eliminate dead code, and avoid speculative architecture.

## Acceptance Criteria
[Exact TaskContract requirement IDs, assertion text, revisions and proof kinds]
[Applicable parity inventory or explicit non-applicability reason]
[Verification commands, expected exits and required artifact locators]

## Action Boundaries
- Assigned role: [role]; read-only or writer authority: [explicit permission].
- Proceed only with authorized in-scope inspection and validation; edits require assigned writer authority.
- Stop and ask before destructive actions, dependency installation, schema changes, staging/commits/pushes/branches, external writes, purchases, material scope expansion or Captain-only decisions.
- Required unavailable/unknown capabilities mean BLOCKED; no fabricated tools, primary execution or writer-context independent review.

## Progress Evidence
For long-running work, report progress only when it changes or when a checkpoint is reached. Ground every completion claim in a tool result, changed artifact, or verification output.

## Grammar Envelope (Constrained Sampling)
Enforce grammars-and-constrained-sampling and the assigned role's canonical output schema.
Use [scout-report.md](../../../../reference/schemas/scout-report.md) for Scout findings,
[ship-diff.md](../../../../reference/schemas/ship-diff.md) for writer deliverables, or the explicitly assigned review/council/gate envelope.
- Zero Conversational Preamble (start directly with the schema envelope).
- Preserve requirement revisions and current evidence; missing, failed or stale proof is not completion.
- Zero conversational padding or pleasantries outside the envelope.
- Independent G8/G9 remain mandatory after SHIP; writer self-review is not independent acceptance.
```

**Effort** — specify abstract intent `none | low | medium | high | max` only when supported and authorized. The installed harness owns actual model/effort translation; task difficulty or a profile grants no spending or switching authority.

**Context strategy — add only when supported by installed-harness evidence:**
```
## Session Strategy
[Select an evidenced capability, not a named session API:]
- Fresh context — unrelated to prior work; supply the current task contract
- Continuation — prior context still needed; recheck assertions and evidence
- Bounded delegation — supervisor-assigned isolated task with exclusive scope and terminal completion evidence
- Compaction — retain decisions, constraints, requirement revisions, parity inventory and current proof before continuing
```

**When to use:** A scoped investigation, implementation or review that needs explicit context, authority and proof. Do not expand scope or assume runtime support from task complexity.

## Provenance and MIT notice

Neutral fleet templates are an ACON reconciliation informed by Fleet `docs/PHILOSOPHY.md` and `.pi/agents/model-profiles.yaml` (ideas only), revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`. See the [local provenance and full MIT notice](../../../../reference/crew/README.md#provenance-and-mit-notice). No source runtime configuration or persona is imported.

## End provenance and MIT notice

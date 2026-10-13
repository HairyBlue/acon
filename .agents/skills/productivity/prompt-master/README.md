![](https://i.postimg.cc/kG03s7tk/prompt-banner.png)

<br/>

A prompt-engineering skill for task-specific, bounded prompts. It makes objectives, context, constraints and verification explicit without assuming runtime support from a tool or model name.

**Prompting domains:** reasoning, structured output, bounded coding, search, multimodal generation and workflow automation. Actual support must be evidenced in the target system.

---

## Fleet prerequisites

Use the active installed harness's evidenced skill-loading capabilities; this document supplies no installer, adapter or session recipe. For ACON tasks, follow the [portable fleet contract](../../../reference/crew/README.md): required delegation, isolated contexts/workspaces, supervision/communication, terminal completion delivery and separate read-only review must be `AVAILABLE`. `UNAVAILABLE` or `UNKNOWN` means `BLOCKED`, not primary-thread execution.

Firstmate delegates inspection and implementation to bounded workers. Supported sequential isolated roles may replace concurrency, never mandatory independent G8/G9. Default `INHERIT` means the current Captain-authorized harness/model; temporary lead/coder selection needs task-bound approval, available-choice evidence, expiry and a time/cost ceiling. Reviewer remains the authorized default. Check authorization/availability at dispatch, resume and completion; expired/unavailable work pauses until a still-valid explicitly approved default fallback permits resumption. Discovery grants no spending authority. Shared model identity requires `CORRELATED_REVIEW` while retaining separate read-only reviewer contexts.

## 🔥 The Problem This Solves

Every AI user wastes credits the same way:

> Write vague prompt → get wrong output → re-prompt → get closer → re-prompt again → finally get what you wanted on attempt 4

That's 3 wasted API calls. Multiply by 50 prompts a day. That's real money and real time gone.

### The key insight

> "The best prompt is not the longest. It's the one where every word is load-bearing."

Most "prompt generators" make prompts longer. This skill makes them sharper.

---

## 🎯 Usage

Ask for a prompt with a confirmed target and its evidenced capabilities:

```
Write a prompt for my authorized coding worker to refactor only the assigned module
```

```
I need a bounded coding-agent prompt for a REST API — ask me what you need to know
```

```
Here's a bad prompt for a structured-output engine, fix it: [paste prompt]
```

```
Generate a Midjourney prompt for a cyberpunk city at night
```

```
I have a reference image — help me write a prompt to edit just the head angle
```

```
Break this prompt down and adapt it for Stable Diffusion
```

Where installed-harness evidence supports explicit skill invocation, select `prompt-master` and provide the task, scope and acceptance criteria. Fresh context, continuation, bounded delegation and compaction are capability choices, not named API requirements.

---

## How It Works

Prompt Master runs a structured pipeline on every request:

1. **Detects the target tool** — figures out which AI system the prompt is for and routes silently to the right approach
2. **Extracts 9 dimensions of intent** — task, input, output, constraints, context, audience, memory, success criteria, examples
3. **Asks targeted clarifying questions** — max 3 questions if critical info is missing, never more
4. **Routes to the right framework** — picks and applies the correct prompt architecture automatically, never shown to the user
5. **Applies safe techniques only** — role assignment, few-shot examples, XML structure, grounding anchors, memory block as needed
6. **Checks model recency** — verifies exact models and controls against official provider docs when the request depends on "latest"
7. **Runs a token efficiency audit** — strips every word that doesn't change the output
8. **Delivers the prompt** — one clean copyable block with a one-line strategy note

---
## Full Example #1: Generating Prompts for Images

### User Input
```
Write me a midjourney prompt for a realistic samurai standing in the rain at night
```

### Generated Prompt
```
lone samurai standing in heavy rain at night, traditional armor, 
neon reflections on wet cobblestone street, cinematic lighting, 
dramatic shadows, fog, ultra detailed, photorealistic, 
shallow depth of field --ar 16:9 --v 6 --style raw

negative: blurry, low quality, watermark, cartoon, anime, extra limbs
```
**🎯 Target:** Midjourney · **⚡ Framework:** Visual Descriptor · **💰 Tokens:** Light (~60) · **💡 Strategy:** Comma-separated descriptors over prose, lighting and mood anchored early, aspect ratio and version locked, negative prompt prevents style drift.

---
## Full Example #2: Generating Prompts for Coding

### User Input
```
Build a bounded coding-worker prompt for a landing page for a business
dashboard that looks and feels exactly like notion - smooth animations, 
clean ui
```


### Generated Prompt
```
Objective:
Build a fully detailed, production-quality static landing page for a 
business dashboard product. Design must match Notion's exact aesthetic — 
clean, minimal, typographic, with smooth animations throughout.

Stack:
Single HTML file with embedded CSS and vanilla JS. No frameworks. 
No external dependencies except Google Fonts (Inter).

Design Spec — match these exactly:
- Background: #ffffff
- Primary text: #1a1a1a
- Secondary text: #6b7280
- Border color: #e5e7eb
- Accent: #000000
- Font: Inter, weights 400 / 500 / 600 / 700
- Base spacing unit: 8px
- Border radius: 6px on cards, 4px on buttons
- Box shadows: 0 1px 3px rgba(0,0,0,0.08) only — no dramatic shadows
- Buttons: black fill, white text, no border radius above 6px

Sections to build in order:
1. Navbar — logo left, nav links center, "Get started free" CTA right. 
   Sticky on scroll, adds subtle border-bottom on scroll with JS.
2. Hero — large left-aligned heading (max 3 lines), subtext, two CTAs 
   (primary black + secondary outlined), hero screenshot mockup 
   placeholder (gray rounded card, 16:9 ratio).
3. Logos bar — "Trusted by teams at..." with 5 placeholder company names 
   in muted gray, centered.
4. Features — 3-column grid. Each card: icon (use emoji), bold title, 
   2-line description. Hover state: border darkens to #d1d5db, 
   translateY(-2px), transition 200ms ease.
5. How it works — alternating left/right layout, 3 steps. Number badge, 
   heading, description, placeholder screenshot card.
6. Pricing — 2 tiers side by side. Free tier: outlined card. Pro tier: 
   black background, white text, "Most popular" badge. List 4 features 
   each with checkmarks.
7. CTA banner — full-width dark section, centered heading, subtext, 
   single CTA button.
8. Footer — 4-column links, copyright line, minimal.

Animations — implement all of these:
- Fade-in + translateY(20px) to translateY(0) on scroll for every section, 
  using IntersectionObserver. Threshold 0.15. Duration 500ms ease-out.
- Staggered animation on feature cards: 100ms delay between each card.
- Navbar CTA button: background transitions from black to #333 on hover, 
  200ms ease.
- Hero CTA primary: same hover transition. Secondary: background goes from 
  transparent to #f3f4f6 on hover.
- Smooth scroll on all anchor links.
- Navbar border-bottom fades in on scroll past 60px using JS scroll event.

Constraints:
- Single file only — all CSS and JS embedded, no external files
- No dependencies except Google Fonts via CDN link tag
- All placeholder images replaced with styled gray div elements
- Must be pixel-perfect at 375px mobile and 1440px desktop
- No CSS frameworks, no utility classes from external sources

Done When:
- All 8 sections render correctly at both breakpoints
- All animations trigger on scroll without layout shift
- Navbar sticks and border appears on scroll
- Hover states work on all interactive elements
- Opens in browser with zero console errors
```
**🎯 Target:** Authorized coding worker · **💰 Tokens:** Medium (~380) · **💡 Strategy:** Aesthetic cues translated into exact values and specs. For ACON, carry the assigned scope and requirement evidence with Template M; observed behavior and mandatory independent G8/G9 remain necessary.

---

## 🤝 Works With Any AI Tool

Select [coding-agent](references/platforms/coding-agents.md) or [reasoning/structured-output](references/platforms/frontier-llms.md) profiles by task and observed capability, not a fixed brand/model default. For an unfamiliar system, confirm its input, output, context and action limits; a profile is not a support certification.

<details>
<summary><h3> Task and capability profiles </h3></summary>

| Task / Capability | Category | What Prompt Master Fixes |
|------|----------|--------------------------|
| **Reasoning-capable engine** | Reasoning | Concise constraints, auditable evidence, no private reasoning requests |
| **Structured-output engine** | Instruction following | Grounding, schema envelopes, representative examples |
| **Context-limited engine** | Bounded context | Focused inputs, simple structure, explicit carry-forward state |
| **Assigned coding worker** | Repository editing | Exact file scope, approval boundaries, verification, stop conditions |
| **IDE assistant / autocomplete** | Code assistance | Function contracts, do-not-touch lists, bounded changes |
| **Interface / full-stack generator** | Code generation | Confirmed stack/version, reference components, what NOT to scaffold |
| **Runtime / computer-use observer** | Runtime evidence | Observed state, scoped permissions, saved artifacts; no assumed tooling |
| **Search / research engine** | Grounded research | Search vs analyze vs compare, verified citations, uncertainty |
| **Midjourney** | Image AI | Comma-separated descriptors, parameters, negative prompts |
| **DALL-E 3** | Image AI | Prose description, text exclusion — edit vs generate detection |
| **Stable Diffusion** | Image AI | Weight syntax `(word:1.3)`, CFG guidance, mandatory negative prompt |
| **SeeDream** | Image AI | Art style first, mood and atmosphere descriptors, negative prompt |
| **ComfyUI** | Image AI | Positive/negative node split, checkpoint-specific syntax |
| **Meshy / Tripo / Rodin** | 3D AI | Style + export format + polygon budget + rig requirements |
| **BlenderGPT** | 3D AI | Python script output, Blender version, scene context |
| **Unity AI** | 3D / Game AI | Game genre, platform target, mechanic description over code |
| **Sora / Runway** | Video AI | Camera movement, duration, cut style |
| **LTX / Dream Machine / Kling** | Video AI | Cinematic language, motion intensity, style reference |
| **ElevenLabs** | Voice AI | Emotion, pacing, emphasis, speech rate |
| **Zapier / Make / n8n** | Workflow automation | Trigger app + event, action app + field mapping |

</details>

---

## 📐 13 Prompt Templates (Auto-Selected)

Prompt Master picks the right architecture for every task automatically and routes silently — you never see the framework name, just the prompt.

<details>
<summary><h3> Click to view all 13 templates</h3></summary>

| Template | Best For |
|----------|----------|
| **RTF** (Role, Task, Format) | Fast one-shot tasks |
| **CO-STAR** (Context, Objective, Style, Tone, Audience, Response) | Professional documents, reports, business writing |
| **RISEN** (Role, Instructions, Steps, End Goal, Narrowing) | Complex multi-step projects |
| **CRISPE** (Capacity, Role, Insight, Statement, Personality, Experiment) | Creative work, brand voice, iterative content |
| **Auditable Reasoning** | Checkable math, logic, debugging, and analysis without hidden reasoning requests |
| **Few-Shot** | Consistent structured output, pattern replication |
| **File-Scope Template** | Bounded code edits with exact path and section ownership |
| **ReAct + Stop Conditions** | Assigned Ship worker with evidenced execution and review capabilities |
| **Visual Descriptor** | Midjourney, DALL-E, Stable Diffusion, Sora — generation |
| **Reference Image Editing** | Editing an existing image — detects edit vs generate automatically |
| **ComfyUI** | Node-based image workflows — positive/negative split per checkpoint |
| **Prompt Decompiler** | Breaking down, adapting, simplifying, or splitting existing prompts |
| **[Bounded Agent Task Brief](references/templates.md#template-m--bounded-agent-task-brief)** | Scoped tasks for any assigned role under installed-harness and evidence contracts |

</details>

---

## 🛡️ 5 Safe Techniques, Applied When Needed

Prompt Master only uses techniques with reliable, bounded effects. Methods known to produce hallucinations or unpredictable output (Tree of Thought, Graph of Thought, Universal Self-Consistency, prompt chaining) are explicitly excluded.

| Technique | What It Does |
|-----------|-------------|
| **Role Assignment** | Assigns a specific expert identity to calibrate depth and vocabulary |
| **Few-Shot Examples** | Adds 2-5 examples when format consistency matters more than instructions |
| **XML Structural Tags** | Wraps sections where the target system demonstrably supports that structure |
| **Grounding Anchors** | Adds anti-hallucination rules for factual and citation tasks |
| **Auditable Reasoning** | Requests conclusions, assumptions, evidence, and verification without hidden reasoning |

---

## 🚫 37 Credit-Killing Patterns Detected (with Before/After Examples)

<details>
<summary><h3> Task Patterns (7)</h3></summary>

| # | Pattern | Before | After |
|---|---------|--------|-------|
| 1 | **Vague task verb** | "help me with my code" | "Refactor `getUserData()` to use async/await and handle null returns" |
| 2 | **Two tasks in one prompt** | "explain AND rewrite this function" | Split: explain first, rewrite second |
| 3 | **No success criteria** | "make it better" | "Done when function passes existing unit tests and handles null input" |
| 4 | **Over-permissive agent** | "do whatever it takes" | Explicit allowed + forbidden actions list |
| 5 | **Emotional task description** | "it's totally broken, fix everything" | "Throws uncaught TypeError on line 43 when `user` is null" |
| 6 | **Build-the-whole-thing** | "build my entire app" | Break into Prompt 1 (scaffold), Prompt 2 (feature), Prompt 3 (polish) |
| 7 | **Implicit reference** | "now add the other thing we discussed" | Always restate the full task, never reference "the thing we discussed" |

</details>

<details>
<summary><h3> Context Patterns (6)</h3></summary>

### Context Patterns

| # | Pattern | Before | After |
|---|---------|--------|-------|
| 8 | **Assumed prior knowledge** | "continue where we left off" | Include Memory Block with all prior decisions |
| 9 | **No project context** | "write a cover letter" | "PM role at B2B fintech, 2yr SWE experience, shipped 3 features as tech lead" |
| 10 | **Forgotten stack** | New prompt contradicts prior tech choice | Always include Memory Block |
| 11 | **Hallucination invite** | "what do experts say about X?" | "Cite only sources you are certain of. If uncertain, say so." |
| 12 | **Undefined audience** | "write something for users" | "Non-technical B2B buyers, no coding knowledge, decision-maker level" |
| 13 | **No mention of prior failures** | (blank) | "I already tried X and it failed because Y. Do not suggest X." |

</details>


<details>
<summary><h3> Format Patterns (6)</h3></summary>

| # | Pattern | Before | After |
|---|---------|--------|-------|
| 14 | **Missing output format** | "explain this concept" | "3 bullet points, each under 20 words, one-sentence summary at top" |
| 15 | **Implicit length** | "write a summary" | "Write a summary in exactly 3 sentences" |
| 16 | **No role assignment** | (blank) | "You are a senior backend engineer specializing in Node.js and PostgreSQL" |
| 17 | **Vague aesthetic adjectives** | "make it look professional" | "Monochrome palette, 16px base font, 24px line height, no decorative elements" |
| 18 | **No negative prompts (image AI)** | "a portrait of a woman" | Add: "no watermark, no blur, no extra fingers, no distortion, no text" |
| 19 | **Prose prompt for Midjourney** | Full descriptive sentence | "subject, style, mood, lighting, --ar 16:9 --v 6" |

</details>


<details>
<summary><h3> Scope Patterns (6)</h3></summary>

| # | Pattern | Before | After |
|---|---------|--------|-------|
| 20 | **No scope boundary** | "fix my app" | "Fix only login form validation in `src/auth.js`. Touch nothing else." |
| 21 | **No stack constraints** | "build a React component" | "React 18, TypeScript strict, no external libraries, Tailwind only" |
| 22 | **No stop condition for agents** | "build the whole feature" | Explicit stop conditions + checkpoint after each step |
| 23 | **No file path for IDE AI** | "update the login function" | "Update `handleLogin()` in `src/pages/Login.tsx` only" |
| 24 | **Wrong template for tool** | Generic prose used for a bounded editing task | Adapted to File-Scope Template with path + scope |
| 25 | **Pasting entire codebase** | Full repo context every prompt | Scoped to relevant function and file only |

</details>


<details>
<summary><h3> Reasoning Patterns (5)</h3></summary>

| # | Pattern | Before | After |
|---|---------|--------|-------|
| 26 | **No audit contract for logic task** | "which approach is better?" | Request the recommendation, assumptions, criteria, evidence, and checks |
| 27 | **Requesting hidden reasoning** | "show your chain of thought" | Ask for a concise rationale, evidence, and verification instead |
| 28 | **Expecting inter-session memory** | "you already know my project" | Re-provide the Memory Block in every new session |
| 29 | **Contradicting prior work** | New prompt ignores earlier architecture | Include established decisions in the Memory Block |
| 30 | **No grounding rule for factual tasks** | "summarize what experts say about X" | Require verifiable sources and explicit uncertainty |

</details>

<details>
<summary><h3> Agentic Patterns (7)</h3></summary>

| # | Pattern | Before | After |
|---|---------|--------|-------|
| 31 | **No starting state** | "build me a REST API" | "Empty Node.js project, Express installed, `src/app.js` exists" |
| 32 | **No target state** | "add authentication" | "`/src/middleware/auth.js` with JWT verify. `POST /login` and `POST /register` in `/src/routes/auth.js`" |
| 33 | **Silent agent** | No progress output | "After each step output: ✅ [what was completed]" |
| 34 | **Unlocked filesystem** | No file restrictions | "Only edit files inside `src/`. Do not touch `package.json`, `.env`, or any config file." |
| 35 | **No human review trigger** | Agent decides everything | "Stop and ask before: deleting any file, adding any dependency, or touching the database schema" |
| 36 | **Vague first turn for an agentic model** | "fix the auth bug" with no scope, files, or criteria | Front-load outcome, context, scope, boundaries, and acceptance criteria |
| 37 | **Context rot on long sessions** | Repeated corrections leave stale assumptions in context | Start fresh for unrelated work or compact around current decisions and state |

</details>

---

## 🧠 Memory Block System

When your conversation has history, Prompt Master pulls out prior decisions and prepends a Memory Block so the AI never contradicts earlier work:

```
## Memory (Carry Forward from Previous Context)
- Stack: React 18 + TypeScript + Supabase
- Auth uses JWT stored in httpOnly cookies, not localStorage
- Component naming convention: PascalCase, no default exports
- Design system: Tailwind only, no custom CSS files
- Architecture: no Redux, context API only
```

This is the single biggest fix for long sessions. Most wasted re-prompts come from the AI forgetting what you already decided.

---

## Historical source notes (non-normative)

Retained upstream release notes are provenance only, not active routing, defaults, setup requirements or support claims.

### ℹ️ Version History

- **1.8.0** — Current-model refresh. Added Claude Fable 5, Opus 5, Sonnet 5, GPT-5.6 Sol/Terra/Luna, Codex, and Grok 4.6 routing. Replaced hidden chain-of-thought requests with auditable reasoning and generalized the Claude task brief for current adaptive-thinking models.
- **1.7.0** — Opus 4.8 compatibility. Made Claude 4.x routing version-aware: durable advice generalized across 4.6/4.7/4.8, added Opus 4.8 (current default) profile, kept Opus 4.7 labeled. De-hardcoded the effort-level note (now harness-managed). Template M and pattern 36 cover 4.7 and 4.8. Fixed a stray fragment in patterns.md.
- **1.6.0** — Opus 4.7 update. Added Template M (Opus 4.7 Task Brief). Updated Claude and Claude Code routing for literalism, adaptive thinking, xhigh effort, and session hygiene. Added patterns 36–37.
- **1.5.0** — Added more tool routing. New Agentic AI and 3D Model AI routing added. Fixed description to 189 chars. Removed token estimate from output. Added instruction layer and copywriting placeholders
- **1.4.0** — Added reference image editing detection, ComfyUI support, Prompt Decompiler mode. Fixed trigger description to invoke correctly in Claude Code. 3 new templates added to references folder
- **1.3.0** — Rebuilt around PAC2026 positional structure (30/55/15). Silent routing replaces user-facing framework selection. References folder introduced
- **1.2.0** — Restructured for attention architecture. Removed fabrication-prone techniques (ToT, GoT, USC, prompt chaining). Templates and patterns moved to references folder
- **1.1.0** — Expanded tool coverage, added memory block system, 35 credit killing patterns
- **1.0.0** — Initial release

## End historical source notes

---

## Provenance and MIT notice

Neutral fleet routing is an ACON reconciliation informed by Fleet `docs/PHILOSOPHY.md` and `.pi/agents/model-profiles.yaml` (ideas only), revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995`. See the [local provenance and full MIT notice](../../../reference/crew/README.md#provenance-and-mit-notice). No source runtime configuration or persona is imported.

## End provenance and MIT notice

## 📄 License

MIT: See [LICENSE](LICENSE) for details.

---

## ⭐ Star History

[![Star History Chart](https://star-history.dera.page/svg?repos=nidhinjs/prompt-master&type=Date)](https://star-history.dera.page/#nidhinjs/prompt-master&Date)

---

# Platform Catalog: Frontier LLMs & Foundational Models

Reference profiles and model-specific prompting parameters across major frontier and open-weight foundation models.

---

## 0. Dynamic Documentation & Model Recency Gate

> [!IMPORTANT]
> Model names, API parameters, reasoning controls, and picker options evolve rapidly. When prompting for frontier LLMs:
> 1. **Check Official Provider Documentation:** When browsing or retrieval tools are available, verify current model slugs, context windows, and supported controls in provider documentation rather than relying on static memory.
> 2. **Differentiate Consumer vs API Surfaces:** Consumer chat apps (ChatGPT, Claude.ai, Grok.com) expose different sliders, tools, and picker tiers than API/developer endpoints. Do not translate UI labels directly into API parameters.
> 3. **Prefer Durable Family Patterns:** Favor durable architectural behaviors (e.g., XML envelopes, few-shot grounding, explicit stop conditions) over brittle assumptions about specific model defaults.
> 4. **Acknowledge Unverified Models:** If official documentation cannot be confirmed, state that model-specific nuances are unverified and apply the nearest durable family archetype. Never hallucinate model slugs, pricing, or token limits.

---

## 1. Claude (claude.ai, Claude API, Claude 5 Family)

Claude models excel at nuanced reasoning, complex instruction following, agentic tool workflows, and long-context processing.

- **Durable Core Behaviors:**
  - Be explicit, direct, and outcome-oriented. Explain *why* a constraint exists when judgment is required.
  - Structure complex prompts using descriptive XML tags (`<context>`, `<task>`, `<constraints>`, `<output_format>`, `<examples>`).
  - For long documents, place reference texts and data before the instruction query; wrap documents with metadata in XML containers.
  - Prefer positive directives detailing the target result over exhaustive negative prohibitions.
  - Never ask for hidden reasoning traces or verbatim chain-of-thought. Request conclusions, assumptions, evidence, and validation checks.
  - Calibrate adaptive thinking via the `effort` control in API harnesses rather than injecting manual thinking token budgets.
- **Model Tiers:**
  - **Claude Opus (e.g., Opus 5):** Recommended starting point for complex agentic coding, deep refactoring, and enterprise reasoning. Opus self-verifies effectively; avoid redundant verifier subagents for routine tasks. Add: *"Deliver what was asked. Do not add features, refactors, or abstractions beyond the task."*
  - **Claude Fable (e.g., Fable 5):** Specialized for high-capability, long-horizon autonomous tasks. Provide exhaustive outcome specifications and action boundaries. Require all progress updates to cite actual tool execution results.
  - **Claude Sonnet (e.g., Sonnet 5):** Frontier intelligence paired with high throughput. Interprets instructions literally, especially at lower effort. State clearly when a rule applies globally across every section.
  - **Claude Haiku:** Fast, economical engine for high-volume extraction, tagging, and routine classification.
  - **Claude 4.8 / Legacy Models:** Compatible with front-loaded explicit structure. For models 4.7+, prefer effort controls over fixed token budgets.
- **Templates:** Use [Template M](../templates.md#template-m--current-claude-task-brief) for agentic and multi-step briefs.

---

## 2. OpenAI / ChatGPT / GPT-5.6 Family

OpenAI models feature strong intent inference, broad ecosystem tool integration, and configurable reasoning effort.

- **Durable Structure:** Structure prompts into four lean blocks: `Goal`, `Context`, `Constraints`, and `Done`. State instructions once with high signal.
- **Model Tiers:**
  - **GPT-5.6 Sol (`gpt-5.6-sol` / `gpt-5.6`):** Flagship capability for complex problem-solving, architectural design, and subtle reasoning.
  - **GPT-5.6 Terra (`gpt-5.6-terra`):** Balanced workhorse for everyday developer workflows and content generation.
  - **GPT-5.6 Luna (`gpt-5.6-luna`):** High-speed, cost-efficient model for structured extraction, transformation, and high-volume tasks.
- **Autonomy & Boundaries:** GPT-5.6 infers context readily. Clearly define autonomy limits: permit safe local inspection and edits; require explicit human confirmation for external network writes, deletions, and scope expansions.
- **Reasoning Controls:**
  - Choose the lowest reasoning effort that meets the quality threshold.
  - In the API, use `reasoning.mode: "pro"` or multi-agent Responses beta only when verified quality gains justify added latency.
  - Control output length via output contracts and `text.verbosity`, not by asking for less reasoning.
  - Request conclusions, assumptions, and verification evidence instead of hidden reasoning.

---

## 3. Reasoning-Native Engines (o3, o4-mini)

Specialized models that perform extensive internal reasoning before emitting output tokens.

- **Zero Scaffolding:** NEVER provide "think step by step", chain-of-thought prompts, or pseudo-reasoning templates. Scaffolding interferes with internal search and actively degrades output quality.
- **Zero Conversational Filler:** Deliver short, clean, declarative instructions. Focus purely on constraints, input invariants, and acceptance criteria.
- **Zero-Shot Priority:** Rely on zero-shot formulations first. Introduce few-shot examples only when output format is highly idiosyncratic.
- **Brevity Rule:** Keep system instructions concise (<200 words). Overly long system prompts degrade reasoning performance.

---

## 4. Grok / Grok 4.6 / xAI

Multimodal frontier model with native function calling, web search, X search, and code execution.

- **Model Slug & Capabilities:** Use `grok-4.6` for general chat, coding, and agentic workflows. Supports text, image, search tools, and code interpreters.
- **Prompt Structure:** Outcome-focused framework: `Goal`, `Context/Input`, `Constraints`, `Tools/Permissions`, and `Done`.
- **Reasoning Calibration:** Select reasoning effort intentionally: `low` for low-latency tasks, `medium` for balanced workloads, `high` (default) for complex logic, and `xhigh` for deep analysis. Grok 4.6 reasoning cannot be disabled; never prompt for chain-of-thought.
- **Search & Realtime Grounding:** For real-time factual questions, explicitly require Web Search or X Search with citations:
  > *"Use Web Search to verify current figures. Provide inline markdown citations for all factual claims."*
- **Agent Loops & Caching:** Define clear stop conditions and compaction checkpoints. Recommend `prompt_cache_key` on the Responses API or `x-grok-conv-id` on Chat Completions for stable prompt caching. Keep fixed instructions front-loaded.

---

## 5. Gemini 2.x / Gemini 3 Pro (Google)

Frontier long-context and multimodal powerhouse supporting massive token contexts and media analysis.

- **Context Exploitation:** Leverage large context windows (1M–2M+ tokens) by providing full source codebases, technical manuals, or video transcripts. Place reference material before task instructions.
- **Citation & Hallucination Guard:** Gemini models can drift into fabricated citations when context is thin. Always inject:
  > *"Cite only sources you are certain of. If uncertain, write [uncertain]. Base your response strictly on the provided context; do not extrapolate."*
- **Format Locking:** Gemini can stray from rigid structural outputs. Enforce format compliance with explicit schema blocks and a labeled example.

---

## 6. DeepSeek-R1

Open-weight and hosted reasoning-native model with transparent thinking tags.

- **Reasoning-Native Rule:** Do NOT add chain-of-thought instructions or reasoning prompts. Deliver concise objectives and acceptance criteria.
- **Thinking Tag Suppression:** By default, DeepSeek-R1 emits reasoning within `<think>` tags. When pure data or clean output is needed, instruct:
  > *"Output only the final answer. Do not include <think> tags or internal reasoning."*

---

## 7. Qwen 2.5 & Qwen 3 (Alibaba)

Instruction-tuned and reasoning models with exceptional multilingual, structured data, and code proficiency.

- **Qwen 2.5 (Instruct variants):**
  - Excels at structured JSON generation and strict schema compliance.
  - Provide a clear system prompt defining the technical role and domain.
  - Keep prompts tightly scoped; concise prompts outperform heavily nested ones.
- **Qwen 3 (Thinking Mode vs Standard):**
  - **Thinking Mode (`/think` or `enable_thinking=True`):** Treat identically to o3/DeepSeek-R1—minimalist instructions, zero CoT scaffolding, strict done conditions.
  - **Non-Thinking Mode:** Treat like Qwen 2.5 Instruct—structured schema, role assignment, and explicit formatting envelopes.

---

## 8. Ollama & Local Models

Local model runtimes hosting open-weight models on user hardware.

- **Pre-Flight Model Identification:** Always determine the active model (e.g., Llama 3, Qwen 2.5-Coder, Mistral, DeepSeek) before crafting prompts. Local models vary widely in context size and instruction fidelity.
- **System Prompt Lever:** The system prompt is the most impactful control in local models. Format prompts so the system directive can be embedded directly in a `Modelfile`.
- **Flat Hierarchies:** Avoid deeply nested or multi-tier instructions. Local models lose coherence with recursive rules; use flat, numbered constraints.
- **Sampling Temperature:** Recommend `temperature 0.1` for deterministic code/JSON extraction, and `0.7–0.8` for creative prose.

---

## 9. Llama / Mistral / General Open-Weight LLMs

Open-weight foundation models deployed via vLLM, Hugging Face TGI, or cloud inference.

- **Directness & Role Calibrations:** Provide clear, explicit role definitions in the system prompt. Instruction following is less forgiving than frontier closed models.
- **Simplicity:** Keep prompts under 500 words when possible. Use plain markdown headers and bullet points.
- **Grounding:** Bind responses directly to provided input data to mitigate hallucination.

---

## 10. MiniMax (M3 / M2.7)

OpenAI-compatible models with long context support (up to 1M tokens) and fast generation variants.

- **OpenAI Compatibility:** Prompts developed for GPT models transfer with minimal modification. Include tool definitions directly as OpenAI-style schemas.
- **Speed Variants:** Recommend `M2.7-highspeed` for latency-sensitive tasks.
- **Temperature Guardrail:** MiniMax APIs strictly enforce temperature between `0` and `1` (inclusive); values exceeding 1 cause API errors.
- **Reasoning Control:** If reasoning tokens appear in `<think>` tags, instruct: *"Output only the final answer without reasoning tags."*

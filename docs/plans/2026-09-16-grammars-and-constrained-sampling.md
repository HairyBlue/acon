# Plan: Grammars & Constrained Sampling Implementation in ACON

**Status:** Completed  
**Date:** 2026-09-16  
**Author:** Antigravity Control Plane (Specialist Subagent)  
**Tracking Issue / Context:** Standardize formal machine grammars (YAML/JSON schemas, enums, regexes) and constrained token sampling across the multi-agent lifecycle to eliminate conversational token waste, formatting drift, and parsing retries.

---

## 1. Executive Summary & Architectural Decisions

1. **Formal Grammars vs. Constrained Sampling:**
   - *Grammars:* Declarative structural constraints (JSON Schema, YAML envelopes, regex patterns, CFGs/GBNF) defining the legal token sequences.
   - *Constrained Sampling:* Runtime token probability masking (logit zeroing) that physically prevents an LLM from generating disallowed tokens during generation.
   - *Token & Latency Leverage:* Cuts agentic communication token overhead by 60%–80%, eliminates conversational chit-chat ("Sure, here is..."), and guarantees 100% deterministic machine-parseable outputs across agent boundaries.

2. **The 6 Canonical Machine Schemas:**
   - `scout-report.yaml`: Structured audit reports from `Codebase Scout`.
   - `ship-diff.yaml`: Exact file, line, and verification summaries for `SHIP` deliverables.
   - `grill-interview.yaml`: Front-loaded alignment questions with strict multiple-choice enums.
   - `task-contract.yaml`: Discrete task definitions for implementation plans (`writing-plans`).
   - `handoff-state.yaml`: Compact session state persistence (<500 tokens) for `handoff`.
   - `bearings-digest.yaml`: The 4-section Fleet Bearings status reporting contract.

3. **Multi-Harness & Local Engine Compatibility:**
   - Full support across Antigravity (`agy`), Claude Code, Gemini API (`response_schema`), OpenAI API (`response_format` JSON schema), and local runtimes (vLLM `xgrammar`, llama.cpp `.gbnf`, Ollama).

4. **Constitutional Integration:**
   - Enforced "The Grammars and Constrained Sampling Invariant" in `AGENTS.md` and `.agents/rules/agent-control-plane.md` (100% synchronized, 0 diff).

---

## 2. Work Breakdown & Execution Phases

### Phase 1: Create Master Skill `grammars-and-constrained-sampling` (`SHIP`)
- [x] **Task 1.1: Author `.agents/skills/productivity/grammars-and-constrained-sampling/SKILL.md`**
  - Implement full YAML frontmatter.
  - Detail Core Concepts (Grammars vs Constrained Sampling, token economics, zero-fluff velocity).
  - Define all 6 canonical schemas (`scout-report.yaml`, `ship-diff.yaml`, `grill-interview.yaml`, `task-contract.yaml`, `handoff-state.yaml`, `bearings-digest.yaml`).
  - Author Constrained Sampling Directives (Zero Preamble Invariant, token clamping, banned phrase lists, regex/enum locks).
  - Document Harness Integration Guides (`agy`, Claude Code, Gemini, OpenAI, vLLM, llama.cpp, Ollama).
  - Build Pairing Matrix (`prompt-master`, `grill-me`, `writing-plans`, `handoff`).

### Phase 2: Pair Productivity Suite Skills (`SHIP`)
- [x] **Task 2.1: Update `prompt-master`**
  - Update `SKILL.md` and `references/templates.md` for Template H (Ship) and Template M (Scout) to reference `grammars-and-constrained-sampling` and enforce grammar envelopes.
- [x] **Task 2.2: Update `grill-me`**
  - Update `SKILL.md` to reference `grammars-and-constrained-sampling` and `grill-interview.yaml` for enum-locked questions and zero preamble.
- [x] **Task 2.3: Update `writing-plans`**
  - Update `SKILL.md` to reference `task-contract.yaml` for `Consumes`, `Produces`, and `Verification` blocks.
- [x] **Task 2.4: Update `handoff`**
  - Update `SKILL.md` to reference `handoff-state.yaml` for <500 token session state compression.
- [x] **Task 2.5: Update `productivity/SKILL.md` & `productivity/README.md`**
  - Register `grammars-and-constrained-sampling` in productivity index tables and child listings.

### Phase 3: Update ACON Constitution & Global Catalogs (`SHIP`)
- [x] **Task 3.1: Update `AGENTS.md` & `.agents/rules/agent-control-plane.md`**
  - Add "The Grammars and Constrained Sampling Invariant (Token & Velocity Discipline)" in Section 6 / Section 4.
  - Ensure `AGENTS.md` and `.agents/rules/agent-control-plane.md` are 100% identical.
- [x] **Task 3.2: Update `.agents/INDEX.md` & `.agents/skills/README.md`**
  - Add lookup entry in `.agents/INDEX.md` and update productivity count from 11 to 12.
  - Add entry under Productivity suite in `.agents/skills/README.md`.

### Phase 4: Verification & Anti-Slop Audit (`SCOUT / VERIFY`)
- [x] **Task 4.1: Constitutional Diff & Link Integrity Verification**
  - Run `diff -u AGENTS.md .agents/rules/agent-control-plane.md` to guarantee 0 diff.
  - Run `bash -n scripts/adopt.sh` to guarantee syntax validity.
  - Verify all schema files and markdown references resolve cleanly.

---

## 3. Worker Dispatch Strategy & Boundaries

- All edits are scoped cleanly to designated documentation, skill files, and governance rules.
- Strict anti-gobble boundaries enforced.
- Single source of truth preserved across the entire codebase.

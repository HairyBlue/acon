# Multi-Agent Subagent Delegation Policy

When executing multi-file tasks, code refactoring, or large-scale generation, AI agents MUST follow these mandatory subagent delegation rules:

---

## 1. Batch Threshold & Delegation Criteria

- **5+ Independent Files**: Whenever a task requires creating, modifying, or refactoring 5 or more independent files, the primary agent **MUST** decompose the work and spawn concurrent subagents via `invoke_subagent`.
- **Domain Separation**: Separate tasks across distinct directory boundaries (e.g. Subagent A handles `components/`, Subagent B handles `services/`, Subagent C handles `tests/`).
- **Sequential Exemption**: If Step 2 strictly depends on the line-by-line output of Step 1, or if only 1 to 3 files are being edited, execute sequentially within the primary agent context.

---

## 2. Strict File Boundary Scoping

- **No Overlapping Targets**: Every subagent MUST be assigned an explicit, mutually exclusive list of target files or directories.
- **Race Condition Prevention**: Two concurrent subagents MUST NEVER edit the exact same file simultaneously.

---

## 3. Communication & Execution Control

- **Self-Contained Prompts**: Include complete context, interface specifications, and target file lists in each subagent prompt.
- **No Polling**: Primary agents MUST NOT poll subagent status in a loop after calling `invoke_subagent`. Rely on reactive system notifications upon subagent completion.
- **No Direct Git Push**: Subagents MUST NOT run `git commit` or `git push` directly.

---

## 4. Post-Delegation Integration & Verification

- **Automated Verification**: After subagents complete, the primary agent MUST execute project compilation and test suites (`npm run build`, `composer test`, `pytest`, etc.) to verify overall system integration.
- **Consolidated Summary**: Provide a unified, clear summary of changes made across all subagent workers.

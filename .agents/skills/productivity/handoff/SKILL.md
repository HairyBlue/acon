---
name: handoff
description: Compact the current conversation into a handoff document for another agent to pick up.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

Write a handoff document summarising the current conversation so a fresh agent can continue the work. Save to the temporary directory of the user's OS - not the current workspace.

Include a "suggested skills" section in the document, naming which skills the next agent should call the Skill tool for.

Do not duplicate content already captured in other artifacts (specs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead.

Redact any sensitive information, such as API keys, passwords, or personally identifiable information.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly.

---

## Machine Grammar: `handoff-state.yaml` (<500 Tokens)

`handoff` pairs directly with [`grammars-and-constrained-sampling`](../grammars-and-constrained-sampling/SKILL.md) to eliminate token bloat and enable clean-slate session resumption:

1. **Zero Conversational Preamble:** The handoff document opens directly with metadata or structured YAML without conversational introductions or sign-offs.
2. **Dense Machine State:** Rather than a verbose multi-page summary, structure active state using the `handoff-state.yaml` schema:
   ```yaml
   session_id: "<id>"
   timestamp: "YYYY-MM-DDTHH:MM:SSZ"
   plan_file: "docs/plans/YYYY-MM-DD-<feature>.md"
   baseline_status: CLEAN
   invariants_preserved: true
   completed_tasks: ["TASK-01", "TASK-02"]
   modified_files: ["path/to/file1", "path/to/file2"]
   active_blockers: []
   exact_next_step:
     action: DISPATCH_WORKER
     target_task: "TASK-03"
     prompt_brief: "<calibrated brief for worker>"
   ```
3. **Reference Over Reproduction:** Point to disk artifacts (`docs/plans/`) instead of copying file contents or large transcripts. This guarantees the handoff payload remains strictly under 500 tokens.


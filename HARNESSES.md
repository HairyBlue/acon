# ACON — Harness Verb Map

Maps ACON verbs to each harness's native tools.

| ACON verb          | Claude Code          | Cursor / Windsurf    | pi / AGY             |
|--------------------|----------------------|----------------------|----------------------|
| `invoke_subagent`  | `Task`               | `run_agent`          | `subagent`           |
| `send_message`     | `Task` (follow-up)   | —                    | `subagent steer`     |
| `manage_subagents` | `Task` status        | —                    | `subagent status`    |
| `write_to_file`    | `Write`              | `edit_file`          | `write`              |
| `replace_content`  | `Edit`               | `edit_file`          | `edit`               |

---

## Decision Gates Protocol

| Skill            | Trigger                                              | Location                                       |
|------------------|------------------------------------------------------|------------------------------------------------|
| `decision-gates` | Lifecycle gates G1–G7, pre/post flight verification   | `.agents/skills/productivity/decision-gates/`  |

**Seven Lifecycle Gates:**
- `G1-grill-trigger`: Phase I upfront alignment trigger.
- `G2-plan-first`: §4 Rule 10 implementation plan gate.
- `G3-task-shape`: Task classification (`SHIP` vs `SCOUT`) & tiering.
- `G4-anti-slop`: Pre-flight task brief validation checklist.
- `G5-skill-route`: Crew & modular skill dispatch lookup.
- `G6-bearings-triage`: Status event & blocker escalation.
- `G7-deliverable-audit`: Post-flight worker diff universal verification.

---

## Linking skills to your harness

**Claude Code** — symlink `.agents/skills/` into `.claude/`:
```bash
ln -s ../.agents/skills .claude/skills
```

**Cursor** — add to `.cursorrules`:
```
Skills directory: .agents/skills/
```

**pi / AGY** — skills are loaded via the `skill` key in subagent dispatch or listed in project instructions.

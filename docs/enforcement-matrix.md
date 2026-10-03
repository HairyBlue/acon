# Enforcement Matrix

ACON is harness-agnostic. Rules and gates can be enforced in two ways:
*   **HARD**: Tool-enforced (e.g., hooks, scripts, mandatory permissions).
*   **SOFT**: Prompt-enforced (e.g., instructions in system prompts).

## Matrix Table

| Rule/Gate ID | Description | Generic | Claude Code | Gemini CLI | Cursor | Codex | Local Models |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Rule 1 | Do not act on unverified assumptions | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| Rule 2 | Read before writing | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| Rule 3 | Minimal changes (YAGNI) | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| Rule 4 | Follow existing patterns | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| Rule 5 | No placeholder content | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| Rule 6 | Verify output locally | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| Rule 7 | Report failures | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| Rule 8 | Clear communication | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| Rule 9 | Security first | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| Rule 10 | Respect boundaries | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| Rule 11 | Handle context limits | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| Rule 12 | No dangerous git operations | PARTIAL | HARD | SOFT | SOFT | SOFT | SOFT |
| G1 | Understanding | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| G2 | Strategy | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| G3 | Design | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| G4 | Implementation | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| G5 | Testing | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| G6 | Documentation | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| G7 | Review | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| G8 | Security | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |
| G9 | Handover | SOFT | SOFT | SOFT | SOFT | SOFT | SOFT |

*Note: For Rule 12, `block-dangerous-git.sh` exists. It is HARD enforced on Claude Code via `pre_tool_use_hook`, but SOFT elsewhere.*

## Per-Harness Snippets

### Claude Code
Can use `pre_tool_use_hook` for hard enforcement.
```json
{
  "pre_tool_use_hook": "./block-dangerous-git.sh"
}
```

### Gemini CLI
*   Custom rules/skills
*   Timer configuration

### Cursor
*   Mechanism: UNVERIFIED

### Codex
*   Mechanism: UNVERIFIED

### Local Models
*   Mechanism: UNVERIFIED

## Cheap Wins
1.  **Install `block-dangerous-git.sh` as pre-commit**: Hardens git operations globally.
2.  **CI template for quality-check**: Automated validation before merging.
3.  **Claude Code settings block**: Pre-configure hooks for local usage.

---
name: git-guardrails
description: Universal pre-execution hooks and safety guardrails blocking destructive git commands (push, reset --hard, clean, branch -D, checkout/restore .) across AI agent harnesses and developer shells.
---

# Universal Git Guardrails (`git-guardrails`)

Universal pre-execution safety interceptor that blocks destructive git operations before autonomous agents or shell sessions can execute them. Enforces Section 7 of the ACON Constitution: *Exclusive Captain Authority over Git Mutations*.

## What Gets Blocked

- `git push` (all variants including `--force`)
- `git reset --hard`
- `git clean -f` / `git clean -fd`
- `git branch -D`
- `git checkout .` / `git restore .`
- Destructive branch deletes, forced pushes, and untracked file wipes

When blocked, the interceptor exits with code 2 and displays an explicit rejection message indicating lack of mutation authority.

---

## 1. The Core Interceptor Script

The canonical interception script is bundled at: [scripts/block-dangerous-git.sh](scripts/block-dangerous-git.sh)

Supports both structured JSON tool input (`{"tool_input":{"command":"..."}}`) and raw piped shell strings.

```bash
#!/bin/bash
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)
if [ -z "$COMMAND" ]; then
  COMMAND="$INPUT"
fi

DANGEROUS_PATTERNS=(
  "git push"
  "git reset --hard"
  "git clean -fd"
  "git clean -f"
  "git branch -D"
  "git checkout \."
  "git restore \."
  "push --force"
  "reset --hard"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    echo "BLOCKED: '$COMMAND' matches dangerous pattern '$pattern'. Captain authorization required." >&2
    exit 2
  fi
done

exit 0
```

---

## 2. Implementation Configurations

### Reference Implementation A: Claude Code (`PreToolUse` Hook)

1. **Ask scope**: Install for **this project only** (`.claude/settings.json`) or **all projects** (`~/.claude/settings.json`)?
2. **Copy script**:
   - Project: `.claude/hooks/block-dangerous-git.sh`
   - Global: `~/.claude/hooks/block-dangerous-git.sh`
   - Make executable: `chmod +x <path>`
3. **Register Hook in Settings**:

   **Project** (`.claude/settings.json`):
   ```json
   {
     "hooks": {
       "PreToolUse": [
         {
           "matcher": "Bash",
           "hooks": [
             {
               "type": "command",
               "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh"
             }
           ]
         }
       ]
     }
   }
   ```

   **Global** (`~/.claude/settings.json`):
   ```json
   {
     "hooks": {
       "PreToolUse": [
         {
           "matcher": "Bash",
           "hooks": [
             {
               "type": "command",
               "command": "~/.claude/hooks/block-dangerous-git.sh"
             }
           ]
         }
       ]
     }
   }
   ```

### Reference Implementation B: Universal Shell & Agentic CLI Hook

For general CLI harnesses (Antigravity CLI, custom agent wrappers, Git hooks):

```bash
# Direct piped verification:
echo '{"tool_input":{"command":"git push origin main"}}' | ./scripts/block-dangerous-git.sh
# Exit code: 2, Output: BLOCKED: 'git push origin main' matches dangerous pattern 'git push'...

# Raw string verification:
echo "git reset --hard HEAD~1" | ./scripts/block-dangerous-git.sh
# Exit code: 2
```

---

## 3. Verification & Customization

1. **Pattern Customization:** Ask if the user wants to add or remove patterns from `DANGEROUS_PATTERNS`.
2. **Deterministic Verification:**
   ```bash
   echo '{"tool_input":{"command":"git push origin main"}}' | <path-to-script>
   ```
   Must exit with code 2 and print a `BLOCKED` message to stderr.

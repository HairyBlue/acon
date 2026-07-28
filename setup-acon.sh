#!/usr/bin/env bash
# ==============================================================================
# ACON Integration Script
# Automatically integrates ACON skills & rules into any target project
# without git pollution or naming conflicts.
# ==============================================================================

set -e

# Resolve the absolute path to this ACON repository directory
ACON_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$PWD}"

cd "$TARGET_DIR"
echo "[ACON] Integrating ACON from $ACON_ROOT into $PWD..."

# 1. Symlink .acon into the target project root if not present
if [ ! -d ".acon" ] && [ ! -L ".acon" ]; then
    ln -s "$ACON_ROOT/.acon" .acon
    echo "[ACON] Created .acon symlink."
fi

# Ensure .git/info/exclude exists before appending
mkdir -p .git/info
if ! grep -q "^\.acon$" .git/info/exclude 2>/dev/null; then
    echo ".acon" >> .git/info/exclude
    echo "[ACON] Added .acon to .git/info/exclude."
fi

# 2. Configure platform folders (.claude, .cursor, .agents)
for TOOL in .claude .cursor .agents; do
    if [ -d "$TOOL" ]; then
        # Folder exists in target project -> add built-in reference symlink
        mkdir -p "$TOOL/skills"
        ln -sf "$ACON_ROOT/.acon/skills/acon-reference.md" "$TOOL/skills/acon-reference.md"
        if ! grep -q "^\${TOOL}/skills/acon-reference\.md$" .git/info/exclude 2>/dev/null; then
            echo "$TOOL/skills/acon-reference.md" >> .git/info/exclude
        fi
        echo "[ACON] Linked acon-reference.md inside existing $TOOL/skills/."
    else
        # Folder does not exist -> create standard relative symlinks
        mkdir -p "$TOOL"
        ln -sf "../.acon/skills" "$TOOL/skills"
        ln -sf "../.acon/rules" "$TOOL/rules"
        if ! grep -q "^\${TOOL}$" .git/info/exclude 2>/dev/null; then
            echo "$TOOL" >> .git/info/exclude
        fi
        echo "[ACON] Created $TOOL with relative symlinks to .acon."
    fi
done

echo "[ACON] Integration complete! All additions excluded from Git."

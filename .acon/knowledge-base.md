# Global Agent Architecture Knowledge Base

## Core Architecture Principles

1. **Central `.acon/` folder**: Contains `README.md`, `commands.md`, `knowledge-base.md`, `rules/`, and `skills/`.
2. **Platform Symlinks**: Tool-specific folders (`.claude`, `.cursor`, `.agents`) maintain relative symlinks pointing to `.acon/skills` and `.acon/rules`.
3. **No Duplicate Code**: Maintain single sources of truth inside `.acon/skills/` and `.acon/rules/`.
4. **Target Project Integration**: To integrate `acon` into any project without naming collisions, symlink `.acon` to the central repository and exclude it in `.git/info/exclude`.

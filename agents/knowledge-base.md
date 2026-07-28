# Agent Collection Architecture Knowledge Base

## Overview

`acon` (Agent Collections) stores reusable agent skills, coding standards, commands, and framework documentation. It mimics the **Cal.diy** agent architecture:

1. **Central `agents/` folder**: Contains `README.md`, `commands.md`, `knowledge-base.md`, `rules/`, and `skills/`.
2. **Platform Symlinks**: Tool-specific folders (`.claude`, `.cursor`, `.agents`) maintain relative symlinks pointing to `agents/skills` and `agents/rules`.
3. **Modular Collections**: Standalone collections such as `laravel-projects` and `conventional-commit` provide dedicated framework and tool context.

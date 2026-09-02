# Global Agent Architecture Knowledge Base

## Core Architecture Principles

1. **Central `.agents/` folder**: Contains all direct skill implementations (`skills/`), categorization rules (`rules/`), and indexing matrix (`INDEX.md`).
2. **Platform Symlinks**: Tool-specific folders (`.claude/`, `.cursor/`) maintain relative symlinks pointing directly to `../.agents/skills` and `../.agents/rules`.
3. **`memory-files/` Templates**: Houses pre-configured, stack-specific `AGENTS.md` memory files (e.g. Laravel, Filament, Node/Express, Python/FastAPI, .NET, Fullstack) ready to be copied into target projects.
4. **Decoupled Tooling**: Framework tooling (such as Laravel Boost MCP) is modularized as standalone skills (`laravel-boost`) rather than baked into mandatory rules.

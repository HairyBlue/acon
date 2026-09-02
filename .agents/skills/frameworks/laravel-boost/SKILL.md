---
name: laravel-boost
description: "Leverage Laravel Boost MCP tooling, search-docs workflows, and .ai/rules persistence for Laravel applications. Activates when using database-query, database-schema, search-docs, browser-logs, get-absolute-url, or recording durable project rules."
license: MIT
metadata:
  author: acon
---

# Laravel Boost Skill

## Overview

Laravel Boost is an MCP (Model Context Protocol) server and ecosystem integration designed specifically for modern Laravel applications. This skill provides guidelines for effectively leveraging Boost tools, querying package documentation, and recording durable project rules.

---

## When to Apply

Activate this skill when:
- Working in a Laravel project equipped with Laravel Boost MCP server
- Searching official Laravel ecosystem documentation (`search-docs`)
- Inspecting database schemas or querying database state (`database-query`, `database-schema`)
- Resolving full application URLs or inspecting client browser logs (`get-absolute-url`, `browser-logs`)
- Recording shared project rules and architectural decisions in `.ai/rules` (`record-rule`)

---

## Boost MCP Tools Reference

Prefer Boost MCP tools over manual alternatives (such as raw shell commands or ad-hoc tinker scripts):

### 1. Database Operations
- **`database-query`**: Run read-only queries directly against the database instead of writing raw SQL in tinker.
- **`database-schema`**: Inspect table structures, columns, indexes, and foreign keys before writing migrations or models.

### 2. Application & Diagnostics
- **`get-absolute-url`**: Resolve the exact scheme, domain, and port for project URLs before sharing them with the user.
- **`browser-logs`**: Read browser console logs, JavaScript errors, and exceptions. Only recent logs are relevant.

### 3. Documentation Search (`search-docs`)
Use `search-docs` prior to making changes that depend on Laravel ecosystem APIs, configurations, or version-specific syntax.

#### Search Query Rules:
- Pass a `packages` array to scope results when relevant (e.g., `packages: ["laravel", "inertia", "filament"]`).
- Use multiple broad, topic-based queries: `['rate limiting', 'routing rate limiting', 'routing']`.
- Do not add package names inside query strings if package info is already scoped (use `test resource table`, not `filament 4 test resource table`).

#### Search Syntax:
1. **Auto-stemmed AND logic**: `rate limit` matches both "rate" AND "limit".
2. **Exact phrase matching**: `"infinite scroll"` requires adjacent words in order.
3. **Mixed queries**: `middleware "rate limit"`.
4. **OR logic**: Pass an array `queries: ["authentication", "middleware"]`.

---

## Project Rules Persistence (`.ai/rules`)

When a project utilizes `.ai/rules`:

### 1. Reading Project Rules
- Open `@.ai/rules/index.md` (maps file globs to rule files).
- Read every rule file whose globs cover the paths in scope.
- Run `grep -rin 'keyword' .ai/rules` to catch relevant guidelines across all rule files.

### 2. Recording Durable Rules
- Use `record-rule` whenever a durable decision, trap, or constraint is discovered.
- Provide a `glob` pattern (e.g. `app/Http/Controllers/**`), a concise `title`, and a short explanatory `note`.
- **Note**: Always use `record-rule` rather than session-scoped memory so the entire team and subsequent agent sessions inherit the rule.

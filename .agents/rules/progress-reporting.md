---
paths:
  - "**/*"
title: Daily Progress Reporting Specification
impact: MEDIUM
tags: progress-report, daily-logs, notion, obsidian, documentation
---

# Daily Progress Reporting Specification

Standardizes daily activity harvesting, local Markdown archival (Obsidian-ready), and content exclusions.

## 1. Mandatory Local File Generation (Markdown-First)
When asked to summarize, log, or report daily progress:
- **Canonical Local Storage:** ALWAYS create or update a local Markdown report at `docs/progress-reports/YYYY/MM/YYYY-MM-DD.md` (or custom vault directory specified by the Captain) BEFORE contacting any external tool or MCP.
- **Obsidian Frontmatter:** The generated Markdown file MUST begin with frontmatter metadata:
  ```yaml
  ---
  date: YYYY-MM-DD
  day: DayOfWeek
  workspace: <Project Name>
  tags: [daily-report, progress]
  status: completed
  ---
  ```

## 2. Opportunistic Multi-MCP Synchronization
- **Notion MCP:** If Notion MCP is connected, sync the formatted report to the target hierarchy (`PROGRESS REPORT > YYYY > MONTH > Week-N`).
- **Obsidian MCP / Local Vault:** If an Obsidian vault path or MCP is active, sync/link the markdown file.
- **Pure Local Mode:** If no external MCP is active, output the saved file path and present the high-level summary directly in chat without throwing errors.

## 3. Strict Content Exclusions
1. **No Meta / AI Conversation Inclusions:** NEVER include conversation history or assistant interactions about creating/publishing reports (e.g. "asked assistant to generate report", "talked with AI agent", "executed progress report skill").
2. **No MCP / Tooling Execution Logs:** NEVER include MCP tool calls, server connections, or background execution steps used by the AI to build or upload the report.
3. **Project Deliverables Only:** Reports MUST focus strictly on real engineering accomplishments — code features, bug fixes, refactoring, architecture design, VPS/infrastructure deployments, UI enhancements, and security audit results.

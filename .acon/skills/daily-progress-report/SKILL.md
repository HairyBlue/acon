---
name: daily-progress-report
description: Automated daily progress report generator and Notion publisher. Gathers git commits, conversation history, and infrastructure updates, formats them into a structured report, and uploads to Notion via Notion MCP server.
license: MIT
metadata:
  version: "1.0.0"
---

# Daily Progress Report Skill

This skill automates collecting code changes, session history, and deployment activities, formatting them into a high-level daily progress summary, and publishing it directly to Notion under **`PROGRESS REPORT` > `YYYY` > `<MONTH>` > `Week-<N>`**.

---

## 1. Critical Rules & Content Exclusions

> [!IMPORTANT]
> **Strict Content Exclusions**:
> 1. **No Meta/Self-Referential Activity**: NEVER include activities related to generating the progress report itself (e.g., asking the AI assistant to create a report, conversing about daily logs, or running report automation skills).
> 2. **No MCP Automation Overhead**: NEVER list MCP server invocations or tool usage done by the AI to create/publish reports (e.g., Notion MCP tool calls, GitHub MCP searches).
> 3. **Project Achievements Only**: Reports MUST focus strictly on actual project deliverables — codebase features, bug fixes, refactoring, architecture design, infrastructure/vps deployment, and UI/security enhancements for the target project.

---

## 2. Trigger & Usage

Activate this skill when asked to:
- "Make a progress report of what I did today and upload to Notion."
- "Generate daily summary from commits and conversation history."
- "Publish today's progress report."

---

## 2. Information Gathering Workflow

### Step 1: Collect Local & Remote Git Commits
Run shell commands to retrieve commits made on the target day (`YYYY-MM-DD`):

```bash
# Get commits made today with one-line summaries
git log --since="YYYY-MM-DD 00:00:00" --until="YYYY-MM-DD 23:59:59" --oneline

# Inspect commit statistics and file changes
git show <commit-hash> --stat
```

### Step 2: Extract Conversation & Task Context
Review the active session and recent conversation transcripts (`.system_generated/logs/transcript.jsonl` or conversation summaries) for non-commit activities:
- Architecture & Infrastructure design
- VPS setup & deployment planning
- Debugging & security auditing

---

## 3. Notion MCP Publishing Workflow

### Step 1: Locate Target Parent Page
Search Notion for the `PROGRESS REPORT` root page, year subpage (`YYYY`), uppercase month subpage (e.g. `AUGUST`), and target week subpage (`Week-1`, `Week-2`, `Week-3`, or `Week-4`):
- Call Notion MCP tool `API-post-search` with query `"PROGRESS REPORT"` or `"2026"`.
- Obtain the parent page ID for `YYYY` (e.g. `3b43ba44-9377-80df-86e4-cf303ce04881`).
- Locate or create the uppercase month subpage (`AUGUST`, `SEPTEMBER`, `OCTOBER`, `NOVEMBER`, `DECEMBER`).
- Locate or create the target week subpage (`Week-1`, `Week-2`, `Week-3`, `Week-4`) under the target month.
- Obtain the week page ID (e.g. `3b43ba44-9377-81dd-bfe6-c8a2e8af546e`).

### Step 2: Create Daily Page
Call Notion MCP tool `API-post-page`:
- `parent`: `{"type": "page_id", "page_id": "<WEEK_PAGE_ID>"}`
- `properties`: `{"title": {"title": [{"text": {"content": "YYYY-MM-DD (DayOfWeek)"}}]}}`

### Step 3: Populate Markdown Content
Call Notion MCP tool `API-update-page-markdown`:
- `page_id`: `<NEW_PAGE_ID>`
- `type`: `"replace_content"`
- `replace_content`:
  - `allow_deleting_content`: `true`
  - `new_str`: Full Markdown content formatted according to the template below.

---

## 4. Markdown Report Template

```markdown
# Daily Progress Report — YYYY-MM-DD (DayOfWeek)

**Date**: Month DD, YYYY  
**Workspace**: `<Repository/Project Name>`  
**Status**: Completed  

---

## 📌 Executive Summary

- **Primary Achievement 1**: Brief high-level summary.
- **Primary Achievement 2**: Infrastructure / deployment updates.
- **Primary Achievement 3**: Key feature / refactoring updates.

---

## 💻 Code Commits & Feature Implementation

### Commit `<hash>` — `<commit title>`
- **Stat Summary**: X files modified (+additions / -deletions)
- **Key Changes**:
  - `path/to/file1.ext`: Specific functionality added/modified.
  - `path/to/file2.ext`: Specific functionality added/modified.

---

## 🛠️ Infrastructure & VPS Planning

- **Task 1**: Hardware / server environment analysis.
- **Task 2**: Architecture design and documentation.

---

## 📋 Next Priorities
- [ ] Next step 1
- [ ] Next step 2

---

## 🏷️ Trello Card Summary

**Card Title**: <Max 1 sentence high-level title for Trello card>

**Description**:
- <Bullet point 1 (max 5 bullet points total)>
- <Bullet point 2>
- <Bullet point 3>
- <Bullet point 4>
- <Bullet point 5>
```

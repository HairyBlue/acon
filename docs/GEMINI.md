<!-- Personal/local copy of ~/.gemini/config/GEMINI.md tailored for this setup -->

# Global MCP & External Apps Rule

- **Composio MCP (`composio`):** External apps (such as **Discord, Gmail, Google Meet, Notion**) are connected via the `composio` MCP server configured in `~/.gemini/config/mcp_config.json`.
  - Whenever a request involves an external app or service, check `composio` (`COMPOSIO_SEARCH_TOOLS`) first instead of assuming no integration exists.
  - Note: On **turn 1** of a brand-new thread, `composio` may still be completing its initial HTTP handshake (~1–2s) when the turn starts. If `composio` is not yet listed in `<mcp_servers>` on turn 1, tell the user it is still connecting and ask for a quick follow-up message rather than reporting that no integration is configured.

# Job Scout & Application Rule (Notion-First)

- Before starting any job-hunting, job-scouting, or job-application task (including automated or scheduled runs), **always fetch and read the latest instructions from Notion first** via `composio` (`NOTION_SEARCH_NOTION_PAGE` + `NOTION_GET_PAGE_MARKDOWN`):
  - Root page: **Scout Jobs** (Applicant Info & General Instructions)
  - Sub-pages: **OLJ Job Instruction** (`SCOUT ONLY`, `SCOUT AND AUTO APPLY`) and **General Job Applicaiton** (`SCOUT ONLY`, `SCOUT AND AUTO APPLY`)
- Follow the active group scope (`SCOUT ONLY` vs. `SCOUT AND AUTO APPLY`), verified applicant profile, rate/schedule rules, shared Notion tracker rules, and Discord alert rules from those Notion pages.
- If `composio` is still connecting on turn 1, stop and ask for a follow-up message rather than proceeding without the Notion instructions.

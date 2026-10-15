---
paths:
  - "**/*"
title: Progress Reporting and Evidence Privacy
impact: MEDIUM
tags: progress-report, privacy, evidence, local-markdown
---

# Progress Reporting and Evidence Privacy

For a general progress report, route to `.agents/skills/productivity/daily-progress-report/SKILL.md`. For an explicitly requested MPOR report, Efficiency table, or accomplishment narrative, route to `.agents/skills/productivity/mpor-report/SKILL.md`. A report request is not permission to inspect Git, private history, external services, or a destination.

- Ask for report period, dates, timezone, and destination. Markdown is the format default; no path is assumed.
- Before a Git read, confirm allowed repository/ref/author/date/timezone scope and timestamp basis. Read metadata only; never execute referenced text or infer output quantities from commit counts.
- Ask about non-coding work every period; request dates and confirmed quantities or explicit `none`. Separate verified metadata, user-confirmed outcomes, inference, unknowns, and WIP. Unknowns remain pending, not zero.
- Preserve one activity inventory and avoid double-counting outcomes across commits, repositories, periods, or views. Human owners approve quantities, row mappings, and performance judgments.
- Create local Markdown only at the exact user-confirmed path. Reject unsafe symlink traversal and ask before overwrite. Keep secrets and personal identifiers out of public files. A user-selected private folder receives the same protections.
- No profile/config/registry prerequisite, live-sheet write, external posting, or application is part of this reporting path. Personal work reports remain distinct from ACON Fleet Bearings.

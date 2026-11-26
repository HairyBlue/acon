---
name: job-hunt-onlinejobs
description: Scout OnlineJobs.ph and remote job listings, catch hidden attention checks and red flags, and draft tailored proposals.
---

# OnlineJobs.ph & Remote Job Scout + Proposal Drafter

## Use this when

The user asks to look for job postings on OnlineJobs.ph (or Upwork, LinkedIn, WeWorkRemotely, etc.), evaluate a job description, or write a tailored cover letter/application.

## Process

1. **Confirm Target Criteria:** Match listings against the user's target roles (Full-Stack, Backend, Frontend, AI/Automation, DevOps, and strictly technical/operational VA roles), tech stack, minimum hourly/monthly rate (USD/PHP), weekly hours (part-time, full-time, gig), timezone overlap, and communication constraints (e.g., non-voice / no cold calls if specified).
2. **Tracker-First Deduplication:** Check any active job tracker first to deduplicate cross-posted listings across platforms (OnlineJobs.ph, Indeed, JobStreet, LinkedIn, Wellfound, company ATS) before evaluating or drafting.
3. **Job Evaluation & Fit Table:** Extract Job Title, Employer/Company name, Offered Rate & Hours, Required Stack, Match Score (`Strong Match` / `Worth Considering` / `Skip` / `NOT SUITABLE`), and Source URL.
4. **Hard Role Exclusions, VA Scope Limit & Skill-Mismatch Stop:**
   - **Strict NO Marketing, Sales, or Community Roles:** Immediately mark `NOT SUITABLE` / `Skip` and NEVER auto-apply to ALL marketing, sales, creator/affiliate management, social media management, ad/SEO outreach, email/SMS marketing, funnel building, cold/warm outreach, lead-gen, appointment setting, and community manager/moderator roles (including Discord/Slack "Community Superstar", hype, or member engagement roles)—even if the listing mentions Discord, Slack, Google Sheets, KPIs, or CRM.
   - **Strict VA Scope Limit (Transferable Technical/Ops Only):** Limit VA roles strictly to duties backed by verified technical/operational transferable skills: Technical VA, Automation/Webhook VA, Data/SQL/Reporting/Sheet-ops VA, Internal Portal/System Admin VA, and QA/Bug-Triage VA. Exclude generic VA, executive/personal VA, creator/community VA, e-commerce store-hype VA, and marketing/sales-ops VA. Daily Discord, Slack, or Google Sheets usage does NOT make community or marketing VA roles transferable. Borderline VA or marketing-adjacent roles must be marked `Skip` / `NOT SUITABLE` (or at most `NEEDS REVIEW`, NEVER `AUTO-APPLY ELIGIBLE`).
   - **Specialized Skill-Mismatch Hard Stop:** Flag and skip (or block auto-apply on) roles whose core requirement is an unrelated specialty outside the candidate's verified stack; never inflate tenure or fabricate skills.
5. **Hidden Attention-Check Detector:** Scan the full listing text for secret screening instructions buried by employers (e.g., *"Put the word MANGO in your subject line"* or *"Answer these 3 questions in the first line"*) and call them out at the top.
6. **Red-Flag & Exploitation Filter:** Flag lowball rates for one-person-team / 5-in-1 roles, unpaid "trial projects" that build real production features, requests to move immediately to Telegram/WhatsApp, or invasive screen-monitoring demands.
7. **Anti-AI-Slop Proposal Drafter:** Write a short, direct, human-sounding subject line and message that obeys any attention-check keyword first, maps 2–3 concrete past outcomes to their stack, asks one smart technical/workflow question, and avoids generic AI openings.

## Output

Use: Job Match Table, Hidden Attention-Check Alert, Red-Flag Assessment, and Copy-Ready Subject Line + Proposal Draft.

## Guardrails

- **Zero Auto-Apply on Excluded or Borderline Roles:** Never draft an application pitch for or auto-apply to marketing, sales, community-mod/hype, generic VA, or marketing-adjacent VA roles. Mark excluded roles `NOT SUITABLE` / `Skip`; borderline cases are at most `NEEDS REVIEW` and NEVER `AUTO-APPLY ELIGIBLE`.
- **Scout-Only vs. Draft/Apply Separation:** Default to read-only scouting and draft preparation. Never spend limited platform apply credits/points or submit an application without meeting the user's fit threshold and explicit authorization.
- **Human-Only Blocker Stop:** External application forms, video/Loom requests, CAPTCHA/OTP gates, or binding commitments must be marked `NEEDS REVIEW` / `NEEDS HUMAN ACTION` rather than bypassed or guessed.
- Never bypass logins, CAPTCHAs, or anti-bot gates.

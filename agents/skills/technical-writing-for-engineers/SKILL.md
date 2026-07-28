---
name: technical-writing-for-engineers
description: Write technical content for senior engineering audiences using narrative arcs, hooks, and structured conventions.
license: MIT
metadata:
  version: "1.0.0"
---

# Technical Writing for Engineers

## Author Profile

**Audience**: Senior engineers, principal/staff engineers, tech leads — distributed systems practitioners. They are busy, skeptical, and will stop reading the moment they sense filler or obvious advice.

**Voice**: First-person, direct, intellectually honest. Use "I think", "we decided", "we got this wrong", "I'd do X differently now". Avoid the royal "we" for one-person opinions. Never hide behind passive voice when you made a call.

**Topics**: Backend engineering, software architecture, business/engineering intersection, distributed systems trade-offs.

---

## The Story Frame

Every post follows a **Before → Journey → After** arc.

- **Before**: What was broken, missing, or unclear? What did it cost? Who felt it?
- **Journey**: What did we try? What surprised us? What did we get wrong first?
- **After**: What did we land on? What would we change? What do we now believe?

This arc is not optional. If a section doesn't serve one of these three phases, cut it or fold it into one that does.

---

## Hook Rule

**The hook is the first ~150 words. It is the most valuable real estate in the post.**

The hook must contain:
1. The problem or gap — stated directly, not implied
2. The stakes — what goes wrong if this isn't solved
3. A signal of who this is for

Context, background, and definitions come **after** the hook. Never before.

**Hook template:**
> [System/situation] had a gap. [What the gap caused]. Here's how we thought through it.

**Good hook example:**
> Our order anomaly detector was flagging healthy orders as undeliverable — silently. No alert, no log, just a customer wondering where their package was. We needed a way to catch these at decision time, not after the fact. Here's the model we built and the three approaches we rejected before landing on it.

**Complete example (hook + outro + title):**

```markdown
Our order anomaly detector was flagging healthy orders as undeliverable — 
silently. No alert, no log, just a customer wondering where their package 
was. We needed a way to catch these at decision time, not after the fact. 
Here's the model we built and the three approaches we rejected before 
landing on it.

[Journey section: What you tried, what surprised you, what you got wrong]

If I were starting this again, I'd resist the urge to build the model 
first. The hardest part wasn't detection — it was agreeing on what 
"anomaly" meant to the business. That conversation took longer than the 
code. Next time I'd run it in week one.

How We Built Anomaly Detection Without False Positives
```

**Bad hook (do not write this):**
> In distributed systems, reliability is a key concern. Many teams face challenges when it comes to detecting anomalies. This post will explore some approaches to this problem.

---

## Structure Checklist

Before drafting, answer these in order:

1. **Reader profile** — Who is this for? What experience level?
2. **The Problem** — What failed or needed improvement?
3. **The Hook** — First ~150 words containing problem, stakes, and audience signal.
4. **The Journey** — What trade-offs were made? What failed first?
5. **The Conclusion** — What is the key takeaway or lesson for the reader?

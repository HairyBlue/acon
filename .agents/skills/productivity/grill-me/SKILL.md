---
name: grill-me
description: Grill the user relentlessly about a plan, decision, or idea to stress-test thinking and sharpen architecture.
license: MIT
metadata:
  author: acon
---

# Grill Me (`grill-me`)

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Format a round like so:

```markdown
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

---

## Machine Grammar & Constrained Sampling (`grill-interview.md`)

`grill-me` pairs directly with [`grammars-and-constrained-sampling`](../grammars-and-constrained-sampling/SKILL.md) to eliminate conversational preamble and enforce structured multiple-choice rounds:

1. **Zero Conversational Chit-Chat:** Never preface a round with conversational pleasantries (*"Thanks for your answers!", "Let's explore the next set of questions..."*). The output opens directly with the question round or interactive prompt.
2. **Constrained Multiple-Choice Enums:** Every question in the frontier MUST provide 2–4 discrete options with clear trade-offs and an explicit recommended default option.
3. **Structured Interview Contract:** When producing structured interview state or programmatic rounds for interactive CLI wizards (`ask_question`), follow the canonical readable [GrillInterview contract](../../../reference/schemas/grill-interview.md). Its Markdown tables and rules are normative documentation, not executable schema validation:
   ```yaml
   round: 1
   frontier_status: ACTIVE
   questions:
     - id: "Q1"
       title: "<question title>"
       context: "<context summary>"
       options:
         - key: "OPT_A"
           label: "<Option A Label>"
           trade_off: "<Consequence / Trade-off>"
         - key: "OPT_B"
           label: "<Option B Label>"
           trade_off: "<Consequence / Trade-off>"
       recommended_option: "OPT_A"
       rationale: "<Why OPT_A is the recommended path>"
   ```

---

Finding _facts_ is the assigned worker's job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), the ORCHESTRATOR does not explore or execute project work.

Terminal/agent-CLI ORCHESTRATORS use separately opened persona-equipped peers, never native subagents, including after peer failure. Desktop/IDE surfaces unable to open pane-plus-agent-CLI peers may use isolated native subagents only when every required capability is evidenced AVAILABLE and the exact assignment is separately approved. Route by actual surface and task-local evidence, never brand; UNKNOWN is BLOCKED.

If role is unestablished, ask Normal Agent versus ORCHESTRATOR before role-dependent action. Verified role or approved handoff establishes it; do not ask assigned workers again. A Normal Agent never spawns crew or assumes orchestrator authority; it may perform its Captain-authorized bounded task or join by approved assignment. For orchestration startup, reuse or completion, completed crew stay alive, idle and registered; only a separate explicit Captain removal instruction identifying targets permits retirement. Follow the [canonical retained-crew lifecycle](../../../reference/crew/README.md#manual-orchestrator-session-ledger); capacity pressure queues/pauses rather than retiring crew or merging writer/reviewer roles.

Keep the remaining decision frontier distinct, and do not assume a running exploration or report delivery. The _decisions_ are the user's: put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.


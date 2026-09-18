# Platform Catalog: Workflow Automation & Deterministic AI

Reference specifications and prompting structures for workflow orchestrators, integration platforms, and programmatic agent hooks (Zapier, Make, n8n).

---

## 1. Core Architecture Pattern

Deterministic workflow systems do not tolerate ambiguous conversational prose. Prompts targeting automation platforms must follow a strict input-trigger-action sequence:

1. **Trigger Definition:** Specific source application, polling or webhook event, and input payload structure.
2. **Intermediate Transformations:** Data filtering, JSON reshaping, path branching, and conditional router rules.
3. **Action Mapping:** Target application, specific API endpoint or operation, and exact field-to-field mappings.
4. **Error Handling & Fallbacks:** Dead-letter queues, failure notifications, and retry limits.

---

## 2. Platform Specifics

### Zapier (Zaps & Central AI)
- **Step-by-Step Sequence:** Number every action explicitly (`Step 1: Trigger`, `Step 2: Filter`, `Step 3: Action`).
- **Field Mapping Syntax:** Name fields in bracketed syntax:
  > *"Map Step 1 `raw_email_body` to Step 2 AI Parser, then map Step 2 `extracted_lead_score` to HubSpot Contact property `lead_score`."*
- **Auth Assumption:** Always declare: *"Assumes [App X] and [App Y] connections are already authorized in workspace."*

### Make (formerly Integromat)
- **Module Graphing:** Specify modular operations and bundle handling (iterators, aggregators, routers).
- **Data Bundle Paths:** Reference exact bundle keys (`1.data.customer.id`).
- **Router Directives:** Define conditional filter routes:
  > *"Route A (Condition: `status = 'active'`): Send Slack webhook; Route B (Condition: fallback): Append row to Google Sheets audit log."*

### n8n (Node-Based Self-Hosted Automation)
- **Node Type & Version:** State exact node types (e.g., `Webhook Node`, `Code (JavaScript) Node`, `OpenAI / LangChain Node`, `Postgres Node`).
- **Execution Mode:** Specify trigger frequency (polling cron vs immediate webhook listener).
- **Code Nodes:** Provide explicit JavaScript or Python transformation snippets to handle JSON arrays or item splitting.
- **Credential Scoping:** Specify environment credentials or credential IDs without exposing raw secrets.

---

## 3. Automation Prompt Template Structure

```
Workflow Objective:
[One-sentence description of the end-to-end integration goal]

Trigger:
- App: [e.g., Stripe]
- Event: [e.g., charge.dispute.created (Webhook)]
- Payload Keys Needed: [dispute.id, customer.email, amount]

Transformations / Logic:
1. Filter: Proceed only if amount > 5000 (cents)
2. Formatter / Code: Extract customer domain from email
3. AI Classification: Classify dispute severity as [LOW, MEDIUM, HIGH]

Actions:
- Step A: [Slack] Post block-kit alert to #billing-alerts
- Step B: [Linear/Jira] Create ticket assigned to Finance on-call

Authentication / Prerequisite:
Assumes Stripe, Slack, and Linear connectors are authenticated.

Done When:
Webhook test event routes through filter and creates ticket within 5 seconds.
```

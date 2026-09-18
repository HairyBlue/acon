---
name: webhooks-and-event-integrity
title: Vendor-Agnostic Webhooks & Event Integrity Security
version: 1.0.0
domain: event-driven-architecture
criticality: High
---

# Vendor-Agnostic Webhooks & Event Integrity Security

In event-driven, microservices, and third-party integration architectures (e.g., payment gateways, SaaS webhooks, queue consumers), HTTP webhooks and message queues transport high-value state mutations across trust boundaries.

Because webhook endpoints are exposed over the public Internet without traditional user sessions, they are prime targets for spoofing, replay attacks, timing attacks, and race conditions resulting in double-processing.

---

## 1. Scope & Domain Invariants

- **The Cryptographic Authenticity Invariant**: Every incoming event payload must be cryptographically verified using an HMAC signature generated with a pre-shared secret across the exact raw bytes received over the wire.
- **The Constant-Time Verification Invariant**: Signature validation must execute in constant time to prevent side-channel timing attacks from leaking valid signature bytes.
- **The Replay Tolerance Invariant**: Every event must include a verifiable timestamp that falls within a narrow validity window (e.g., $\le 300$ seconds) relative to server time.
- **The Exactly-Once State Transition Invariant (Idempotency)**: Receiving duplicate or re-delivered event payloads must produce identical system state without double-executing side effects (e.g., duplicate billing, duplicate account crediting).

---

## 2. Threat Vectors & Attack Surfaces

```text
               EXTERNAL EVENT SENDER (Webhook / Message Publisher)
                                     │
                 [ Public HTTP Request with HMAC Signature ]
                                     │
                                     ▼
        ┌────────────────────────────────────────────────────────┐
        │                 WEBHOOK RECEIVER ENDPOINT              │
        ├────────────────────────────┬───────────────────────────┤
        │ ❌ Insecure Pattern        │ ✅ Secure Invariant       │
        ├────────────────────────────┼───────────────────────────┤
        │ Parsed JSON Reserialization│ Raw Byte Stream Capture   │
        │ String `===` Equality      │ Constant-Time Comparison  │
        │ Missing Timestamp Window   │ Freshness Enforced (<300s)│
        │ No Idempotency Tracking    │ Atomic DB ID Check & Lock │
        └────────────────────────────┴───────────────────────────┘
```

### Key Failure Modes:
1. **Raw Body Deserialization Trap**: Verifying HMAC signatures over re-serialized JSON (e.g., `JSON.stringify(req.body)`) instead of verbatim raw HTTP request bytes. JSON key ordering, whitespace differences, and Unicode encoding differences will either cause valid webhooks to fail or allow crafted payloads to bypass validation.
2. **Timing Side-Channel Attacks**: Using standard string comparison operators (`==` or `===`) to compare incoming signatures with computed HMACs. Standard string comparisons return early on the first mismatched byte, allowing an attacker to determine the signature byte-by-byte via high-resolution timing measurements.
3. **Replay Attacks**: Capturing a valid historic webhook payload and re-submitting it repeatedly when timestamp validation is missing or excessively lenient.
4. **Duplicate Processing / Race Conditions**: Processing side effects (such as crediting an account balance or provisioning a license) without checking whether the `event_id` has already been processed in a transactional database record.

---

## 3. Invariant Sinks & Source Boundaries

| Component | Source / Boundary | Invariant Sink Requirement |
|---|---|---|
| **Raw Request Capture** | Ingress HTTP request stream | Middleware must retain unmodified raw buffer (`req.rawBody`) before any JSON or form parsing occurs. |
| **HMAC Computation** | Shared secret + Raw body buffer | Cryptographic HMAC function (SHA-256 or SHA-512) computed strictly over verbatim raw buffer. |
| **Signature Comparison** | Incoming header signature | Cryptographically secure constant-time comparator (e.g., `crypto.timingSafeEqual()`, `hash_equals()`). |
| **Timestamp Validation** | Header timestamp (`X-Signature-Timestamp` or Stripe `t=`) | Absolute time difference `|now - event_time|` strictly bounded by maximum tolerance (e.g., 300s). |
| **Idempotency Store** | Event identifier (`event_id` or `idempotency_key`) | Unique database constraint or atomic lock acquired *before* executing business logic. |

---

## 4. Two-Tier Audit Procedure

### Tier 1: Fast Heuristic Discovery (Regex / Scanning)
1. **Identify Webhook Route Handlers**: Scan route files for patterns matching `/webhook`, `/events`, `/callback`, `/ipn`, or methods with `WebhookController`.
2. **Scan for Insecure String Equality**: Search within webhook controllers for standard equality operators comparing signatures (`===`, `==`, `strcmp`).
3. **Scan for Missing Raw Body Configuration**: Check middleware configurations (`bodyParser.json()`, `express.json()`, framework body parsers) for `verify` options or raw body preservation.
4. **Scan for Idempotency Checks**: Grep for queries against an `events`, `processed_webhooks`, or `idempotency_keys` table.

### Tier 2: AST & Structural Confirmation
1. **Inspect Signature Comparison Node**:
   - Verify that signature comparison AST node invokes a constant-time method (`crypto.timingSafeEqual`, `sodium_memcmp`, `hash_equals`).
   - Flag any standard comparison (`if (computedSignature === headerSignature)`) as a `[VERIFIED STATIC FLAW]`.
2. **Verify Raw Body Flow**:
   - Trace the buffer argument passed to `crypto.createHmac().update(buf)`:
   - Does `buf` originate from raw request stream or is it a re-serialized object (`JSON.stringify(req.body)`)? Flag re-serialization as a flaw.
3. **Timestamp Freshness & Replay Checks**:
   - Check AST for explicit numerical comparison of header timestamp against system time:
   - Verify that drift calculation rejects timestamps older than tolerance window.
4. **Atomic Deduplication Verification**:
   - Inspect the database interaction in the webhook handler: Is there an atomic insert or unique constraint on the event ID inside a transaction, or is it a vulnerable non-atomic `find -> then -> process` pattern susceptible to race conditions?

---

## 5. Defensive Remediation & Invariant Enforcement

### 1. Preserve Verbatim Raw Body
Configure HTTP middleware to preserve raw request bytes:
```typescript
// Express / Node.js example
app.use(express.json({
  verify: (req: any, _res, buf) => {
    req.rawBody = buf; // Unmodified Buffer preserved for HMAC
  }
}));
```

### 2. Constant-Time HMAC Verification
Validate signature using constant-time equality:
```typescript
import crypto from 'node:crypto';

export function verifyWebhookSignature(
  rawBody: Buffer,
  signatureHeader: string,
  secret: string,
  timestampHeader: string,
  toleranceSeconds: number = 300
): boolean {
  // 1. Freshness check
  const eventTimestamp = parseInt(timestampHeader, 10);
  const currentTimestamp = Math.floor(Date.now() / 1000);
  if (isNaN(eventTimestamp) || Math.abs(currentTimestamp - eventTimestamp) > toleranceSeconds) {
    return false;
  }

  // 2. Compute expected HMAC
  const payloadToSign = `${eventTimestamp}.${rawBody.toString('utf8')}`;
  const hmac = crypto.createHmac('sha256', secret);
  const expectedSignature = hmac.update(payloadToSign).digest('hex');

  // 3. Constant-time comparison
  const sigBuffer = Buffer.from(signatureHeader, 'hex');
  const expectedBuffer = Buffer.from(expectedSignature, 'hex');

  if (sigBuffer.length !== expectedBuffer.length) {
    return false;
  }

  return crypto.timingSafeEqual(sigBuffer, expectedBuffer);
}
```

### 3. Atomic Database Idempotency
Enforce deduplication with database transactions and unique constraints:
```sql
CREATE TABLE processed_webhooks (
  event_id VARCHAR(255) PRIMARY KEY,
  provider VARCHAR(64) NOT NULL,
  processed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

---

## 6. Closed-Loop Test Verification Criteria

Author tests in the project's native test framework using structural boundary inputs:

1. **Replay Window Test**:
   - Submit a test webhook request with a valid HMAC signature but an expired timestamp (e.g., $now - 301$ seconds).
   - Assert endpoint rejects the request with `400 Bad Request` or `401 Unauthorized`.
2. **Tampered Body Test**:
   - Submit a test webhook where the payload body has a single byte altered relative to the computed HMAC header.
   - Assert endpoint rejects the request deterministically.
3. **Idempotency Deduplication Test**:
   - Submit the identical valid webhook request twice sequentially.
   - Assert first request returns `200 OK` and processes the event.
   - Assert second request returns `200 OK` (or `204 No Content`) and does not duplicate the downstream database records.

---
name: refactoring
description: "Discipline and recipes for behavior-preserving code restructuring: automated test prerequisites, concrete Fowler transformations, strangler fig patterns, and the strict revert-on-red loop. Use when reducing technical debt, cleaning up code smells, or preparing code for features without changing observable behavior."
---

# Refactoring

Refactoring is the disciplined process of restructuring existing code—changing its internal structure without altering its external observable behavior.

This skill governs code restructuring sessions. It provides the core invariants, test seam prerequisites, concrete Fowler recipes, and the strict revert-on-red micro-step loop.

---

## 1. Core Discipline & Invariants

### The Golden Invariant
> **Refactoring NEVER changes observable external behavior.**

If external behavior changes, it is not refactoring—it is a feature addition, a bug fix, or a regression.

### The "Two Hats" Principle (Kent Beck)
When working on software, you must wear only one hat at a time:
- **The Refactoring Hat:** You restructure code to improve readability, maintainability, and extensibility. You write zero new features and fix zero bugs. Tests must start green and stay green on every micro-step.
- **The Feature / Bugfix Hat:** You add new capabilities or correct defective behavior. You write new tests and modify interfaces to satisfy new requirements. You do not redesign surrounding architecture while in this mode.

**Rule:** Never wear both hats at once.
- If you find a bug while refactoring, **do not fix it**. Record the bug, document it with a failing characterization test marked skipped/todo, finish or revert your refactoring step, and switch hats under an explicit, separate cycle.
- If you need to add a feature to poorly structured code, **make the change easy first (warning: this may be hard), then make the easy change** (Kent Beck). Refactor first under green tests, commit, then wear the feature hat.

### The Green-to-Green Invariant
Every refactoring micro-step must begin with passing tests and end with passing tests. Code must compile and all existing test suites must remain green across every single transformation.

---

## 2. Pre-condition: Test Harness & Seam Verification

Before editing a single line of production code during a refactoring cycle, verify the following prerequisites:

### 1. Test Coverage at the Target Seam
A **seam** is a place where you can alter behavior or inspect outcomes without editing that place itself (Michael Feathers).
- Automated tests covering the target seam **MUST exist and pass** before touching implementation code.
- If tests only cover private implementation details, they will break during refactoring even if external behavior is preserved. Ensure tests verify public contracts, inputs, and outputs at the module boundary.

### 2. Fast Feedback Cycle
- The test suite covering the target seam must run in seconds (ideally < 3s).
- If the full suite takes minutes, configure a targeted test runner command that executes only the tests covering the affected module or subsystem during the micro-step loop.

### 3. Pinning (Characterization) Tests
When refactoring legacy code lacking tests:
1. Do not touch production code yet.
2. Write **Characterization Tests** (Golden Master tests) that exercise the existing boundary.
3. Assert against the *actual current output* of the system across typical and edge-case inputs—even if the current output contains known quirks.
4. Verify that these tests pass reliably.
5. Only once behavior is securely pinned do you proceed to refactoring.

---

## 3. Concrete Fowler Recipes

Apply these atomic transformations to address common code smells:

### Recipe 1: Guard Clauses & Decompose Conditional

**Smell:** Deeply nested `if/else` ladders (Arrow Anti-pattern) or monolithic compound boolean expressions obscuring the happy path.

**Transformation:**
1. Invert negative conditions and return or throw immediately (Guard Clauses).
2. Decompose complex compound booleans into dedicated, well-named predicate functions.

#### Before:
```typescript
function processPayment(order: Order, user: User): PaymentResult {
  if (order.items.length > 0) {
    if (user.isActive && !user.isSuspended) {
      if (order.totalAmount > 0) {
        if (user.walletBalance >= order.totalAmount) {
          // core logic deeply buried
          user.walletBalance -= order.totalAmount;
          order.markPaid();
          return PaymentResult.success();
        } else {
          return PaymentResult.failure("Insufficient funds");
        }
      } else {
        return PaymentResult.failure("Invalid order total");
      }
    } else {
      return PaymentResult.failure("User inactive or suspended");
    }
  } else {
    return PaymentResult.failure("Order is empty");
  }
}
```

#### After:
```typescript
function processPayment(order: Order, user: User): PaymentResult {
  if (order.isEmpty()) {
    return PaymentResult.failure("Order is empty");
  }
  if (!isEligibleUser(user)) {
    return PaymentResult.failure("User inactive or suspended");
  }
  if (order.totalAmount <= 0) {
    return PaymentResult.failure("Invalid order total");
  }
  if (user.walletBalance < order.totalAmount) {
    return PaymentResult.failure("Insufficient funds");
  }

  // Clear, unnested happy path
  user.walletBalance -= order.totalAmount;
  order.markPaid();
  return PaymentResult.success();
}

function isEligibleUser(user: User): boolean {
  return user.isActive && !user.isSuspended;
}
```

---

### Recipe 2: Extract Function / Method & Inline Function

**Smell:** Long method doing multiple things; code comments explaining "what this next block does"; or conversely, pointless single-line helper functions that obscure clear, direct code.

**Principles:**
- **Composed Method Pattern (Kent Beck):** Every operation in a method should be at the same level of abstraction.
- **Rule of Thumb:** If you feel the urge to write a code comment explaining what a 5-line block does, extract that block into a private function named after the comment.
- **Inline Function:** If a function's body is as clear as its name or adds gratuitous indirection without reuse, inline it back to where it is called.

#### Before:
```typescript
function printOwing(invoice: Invoice): void {
  let outstanding = 0;

  console.log("***********************");
  console.log("**** Customer Owes ****");
  console.log("***********************");

  // calculate outstanding
  for (const order of invoice.orders) {
    outstanding += order.amount;
  }

  // record due date
  const today = new Date();
  invoice.dueDate = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 30);

  // print details
  console.log(`name: ${invoice.customer}`);
  console.log(`amount: ${outstanding}`);
  console.log(`due: ${invoice.dueDate.toLocaleDateString()}`);
}
```

#### After:
```typescript
function printOwing(invoice: Invoice): void {
  printBanner();
  const outstanding = calculateOutstanding(invoice.orders);
  recordDueDate(invoice);
  printDetails(invoice, outstanding);
}

function printBanner(): void {
  console.log("***********************");
  console.log("**** Customer Owes ****");
  console.log("***********************");
}

function calculateOutstanding(orders: readonly Order[]): number {
  return orders.reduce((sum, order) => sum + order.amount, 0);
}

function recordDueDate(invoice: Invoice): void {
  const today = new Date();
  invoice.dueDate = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 30);
}

function printDetails(invoice: Invoice, outstanding: number): void {
  console.log(`name: ${invoice.customer}`);
  console.log(`amount: ${outstanding}`);
  console.log(`due: ${invoice.dueDate.toLocaleDateString()}`);
}
```

---

### Recipe 3: Replace Conditional with Polymorphism / Strategy

**Smell:** `switch`, `match`, or chained `if/else` statements inspecting a type code or discriminator that recur across multiple methods. Adding a new type requires modifying all switch statements (violates Open/Closed Principle).

**Transformation:**
1. Define a shared interface or strategy contract representing the operation.
2. Implement concrete classes or strategy handlers for each case.
3. Replace the conditional with polymorphic dispatch or a lookup registry.

#### Before:
```typescript
class ShippingCalculator {
  calculateCost(order: Order, carrier: string): number {
    switch (carrier) {
      case "FEDEX":
        return order.weight * 1.5 + 5.0;
      case "UPS":
        return order.weight * 1.2 + 8.0;
      case "DHL":
        return order.weight * 2.0 + 12.0;
      default:
        throw new Error(`Unsupported carrier: ${carrier}`);
    }
  }
}
```

#### After:
```typescript
interface ShippingCarrierStrategy {
  calculate(order: Order): number;
}

class FedExStrategy implements ShippingCarrierStrategy {
  calculate(order: Order): number {
    return order.weight * 1.5 + 5.0;
  }
}

class UPSStrategy implements ShippingCarrierStrategy {
  calculate(order: Order): number {
    return order.weight * 1.2 + 8.0;
  }
}

class DHLStrategy implements ShippingCarrierStrategy {
  calculate(order: Order): number {
    return order.weight * 2.0 + 12.0;
  }
}

class ShippingCalculator {
  private strategies = new Map<string, ShippingCarrierStrategy>([
    ["FEDEX", new FedExStrategy()],
    ["UPS", new UPSStrategy()],
    ["DHL", new DHLStrategy()],
  ]);

  calculateCost(order: Order, carrier: string): number {
    const strategy = this.strategies.get(carrier);
    if (!strategy) {
      throw new Error(`Unsupported carrier: ${carrier}`);
    }
    return strategy.calculate(order);
  }
}
```

---

### Recipe 4: Introduce Parameter Object / Value Object

**Smell:** Primitive Obsession and Data Clumps. Multiple parameters repeatedly travel together (e.g. `start_date`, `end_date`; `lat`, `lng`; `amount`, `currency`). Validation logic for these primitives is scattered across callers.

**Transformation:**
1. Bundle the grouped primitives into a dedicated class or record.
2. Make the Value Object immutable.
3. Encapsulate validation rules and domain invariants directly within its constructor/factory.
4. Move operations that operate primarily on those fields into the new Value Object.

#### Before:
```typescript
function searchTransactions(
  userId: string,
  startDate: Date,
  endDate: Date,
  minAmount: number,
  currency: string
): Transaction[] {
  if (startDate > endDate) {
    throw new Error("Start date must be before end date");
  }
  if (minAmount < 0) {
    throw new Error("Amount cannot be negative");
  }
  // search query execution...
}
```

#### After:
```typescript
class DateRange {
  constructor(public readonly start: Date, public readonly end: Date) {
    if (start > end) {
      throw new Error("Start date must be before end date");
    }
  }

  includes(date: Date): boolean {
    return date >= this.start && date <= this.end;
  }
}

class Money {
  constructor(public readonly amount: number, public readonly currency: string) {
    if (amount < 0) {
      throw new Error("Amount cannot be negative");
    }
    if (!/^[A-Z]{3}$/.test(currency)) {
      throw new Error("Currency must be a 3-letter ISO code");
    }
  }
}

function searchTransactions(
  userId: string,
  range: DateRange,
  threshold: Money
): Transaction[] {
  // Search logic receives validated, cohesive domain objects
}
```

---

### Recipe 5: Strangler Fig Pattern

**Smell:** A massive legacy class, subsystem, or service that is too risky to rewrite in a single pass.

**Transformation:**
Incrementally migrate callers to a new implementation behind an interface facade until the old subsystem can be safely deleted.

```
       [Client Callers]
              │
              ▼
    ┌───────────────────┐
    │  Strangler Facade │
    └─────────┬─────────┘
              │
      ┌───────┴───────┐
      ▼               ▼
┌───────────┐   ┌───────────┐
│ Old Logic │   │ New Logic │ (Feature-flagged or by domain entity)
└───────────┘   └───────────┘
```

1. **Step 1: Intercept (Facade)**
   Introduce a boundary interface or facade between clients and the legacy subsystem. Callers invoke the facade, which initially delegates 100% to the legacy implementation.
2. **Step 2: Coexist (Parallel Run / Canary Cutover)**
   Implement the new module for a specific subset of operations or entity types.
   Use a feature flag or routing policy in the facade to route requests:
   - Run parallel executions (execute both old and new, compare results, log discrepancies, return old result).
   - Once parity is proven, shift write/read traffic to the new module for 1%, 10%, 100% of users.
3. **Step 3: Cutover & Prune**
   When 100% of traffic flows through the new implementation without error, remove the feature flag and delete the legacy code and old tests.

---

## 4. The Revert-on-Red Loop (Micro-Step Workflow)

The fundamental discipline of refactoring is taking tiny, verifiable steps. Never accumulate multiple edits before running tests.

```
┌───────────────────────────────┐
│ 1. Identify smell & pick seam │
└───────────────┬───────────────┘
                ▼
┌───────────────────────────────┐
│ 2. Run tests (Must be GREEN)  │
└───────────────┬───────────────┘
                ▼
┌───────────────────────────────┐
│ 3. Apply SINGLE micro-step    │
└───────────────┬───────────────┘
                ▼
┌───────────────────────────────┐
│ 4. Run test suite             │
└───────┬───────────────┬───────┘
        │ GREEN         │ RED
        ▼               ▼
┌───────────────┐ ┌──────────────────────────────────────────────┐
│ Commit / save │ │ REVERT IMMEDIATELY (git checkout / undo)     │
│ Next micro-step│ │ DO NOT FIX FORWARD!                         │
└───────────────┘ │ Halve the step size and try again            │
                  └──────────────────────────────────────────────┘
```

### The Strict Invariant: Never Fix Forward
- When a refactoring edit turns the test suite **RED**, your immediate and only reaction is to **revert the change immediately**.
- **Why?** "Fixing forward" while in refactoring mode almost always introduces subtle behavioral changes or hides unexpected couplings. Reverting takes 2 seconds and brings you back to a verified, guaranteed working state.
- After reverting:
  1. Ask: *"Why did that step break tests? What hidden assumption was violated?"*
  2. Break the step into two smaller micro-steps.
  3. Re-apply using smaller increments.

---

## 5. Code Smells Reference Catalog

Code restructuring in ACON evaluates code smells against the canonical Fowler catalog centralized at [`.agents/reference/fowler-smells.md`](../../../reference/fowler-smells.md).

Refer to [`.agents/reference/fowler-smells.md`](../../../reference/fowler-smells.md) for the consolidated matrix of 24 code smells, diagnostic criteria (*what it is* → *how to fix*), and mapping to target Fowler recipes (Guard Clauses, Extract Function, Replace Conditional with Polymorphism, Value Objects, and Strangler Fig).

# Two-Tier AST Triage Methodology

Security auditing over large codebases requires balancing speed and precision. Relying solely on pattern-matching (regex) generates excessive false positives, while performing exhaustive manual AST analysis on every line is prohibitively slow.

This document defines the **Two-Tier AST Triage Methodology**: a deterministic, language-agnostic auditing pipeline that combines high-recall heuristic discovery with surgical syntax tree verification.

---

## 1. Overview of the Two-Tier Pipeline

```text
┌─────────────────────────────────────────────────────────────┐
│                    TIER 1: FAST HEURISTIC                   │
│   Pattern Scanning (Ripgrep / Regex / Lexical Signatures)   │
│   • Goal: Maximize Recall (100% target coverage)            │
│   • Output: Candidate Sinks & Suspicious Flow Boundaries    │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                 TIER 2: SURGICAL AST TRIAGE                 │
│ Syntax Tree & Structural Analysis (AST / Scope / Types)     │
│   • Goal: Maximize Precision (Eliminate False Positives)    │
│   • Confirm Argument Types, Scope Binding, Node Semantics   │
└──────────────────────────────┬──────────────────────────────┘
                               │
            ┌──────────────────┴──────────────────┐
            ▼                                     ▼
┌───────────────────────────┐         ┌───────────────────────────┐
│     CONFIRMED SINK        │         │   DISMISSED / CLEARED     │
│  Proceed to Taint Trace   │         │ Document False Positive   │
└───────────────────────────┘         └───────────────────────────┘
```

---

## 2. Tier 1: Fast Heuristic Discovery

Tier 1 casts a wide net across the target codebase using fast pattern matching (e.g., `ripgrep`). It scans for candidate sink identifiers, dynamic evaluation keywords, and interface boundaries.

### Heuristic Search Categories:
1. **Candidate Persistence Sinks**: Patterns matching raw query invocation, dynamic SQL fragments, or unparameterized database calls.
2. **Candidate Execution Sinks**: OS process spawning, shell execution, eval statements, or dynamic code compilation.
3. **Candidate Serialization Sinks**: Binary, YAML, or native object deserialization calls.
4. **Candidate Network / Redirect Sinks**: Outbound HTTP client calls with variable destinations, unvalidated redirect headers.
5. **Candidate Client Rendering Sinks**: Raw HTML rendering functions, direct DOM manipulation, or unescaped template tags.

### Characteristics of Tier 1:
- **High Recall, Low Precision**: Yields many matches that are actually safe (e.g., hardcoded constant queries, parameterized calls with matching names, internal utility functions).
- **Zero Definitive Findings**: A Tier 1 match is NEVER reported as a confirmed vulnerability. It is solely an index of candidates for Tier 2 evaluation.

---

## 3. Tier 2: Surgical AST Confirmation

Tier 2 takes every candidate location identified in Tier 1 and inspects its syntax tree structure, scope hierarchy, and argument node types.

```text
Candidate Match (Tier 1)
         │
         ▼
[Inspect CallExpression Node in AST]
         ├── Argument Node is StringLiteral? ───────► SAFE (Constant query / string)
         ├── Argument Node is ParameterizedTuple? ──► SAFE (Parameters bound separately)
         ├── Argument Node is BinaryExpression (+) ─► SUSPICIOUS (Dynamic concatenation)
         │       └── Check Operands:
         │             ├── All operands are Compile-Time Constants? ─► SAFE
         │             └── Any operand is Variable / Parameter? ────► CANDIDATE TAINT SINK
         └── Argument Node is Identifier? ──────────► TRACE TO DECLARATION
                 └── Trace backwards to initializer / assignment node.
```

### Key AST Verification Invariants:

#### A. Literal vs. Dynamic Argument Distinction
- **Regex Trap**: `db.query("SELECT * FROM users WHERE active = 1")` matches regex `db\.query\(.*\)`.
- **AST Resolution**: The argument node is an atomic `StringLiteral`. No dynamic data is interpolated. **Verdict: DISMISSED (Safe).**

#### B. Parameterized Call Form
- **Regex Trap**: `db.query("SELECT * FROM users WHERE id = ?", [userId])` matches regex `db\.query\(.*userId.*\)`.
- **AST Resolution**: The call expression has two arguments: an invariant SQL template (`StringLiteral`) and a parameterized binding array (`ArrayExpression`). The database driver handles parameters out-of-band. **Verdict: DISMISSED (Safe).**

#### C. Variable Scope & Declaration Resolution
- When a candidate sink takes a variable identifier (e.g., `execute(stmt)`), AST triage traces the identifier node back through its lexical scope to its assignment or declaration:
  - If `stmt` was initialized from a pure constant or sanitized transform, the sink is safe.
  - If `stmt` was constructed via string concatenation or template interpolation involving function arguments or external input, the sink is confirmed as dangerous.

#### D. Guarded Branch Pruning
- Inspect the parent AST nodes: Is the call enclosed in a conditional statement (`IfStatement`) that checks validity or authorization?
- Does an early `ReturnStatement` or `ThrowStatement` terminate execution when input does not conform to required bounds?

---

## 4. Operational Checklist for Auditors

When examining candidate matches:

1. **Locate AST Context**: Inspect 10–20 lines around the match or use language-specific AST tooling (tree-sitter, compiler ASTs, or language server symbols).
2. **Classify Node Type**: Determine if the argument passed to the sink is a constant literal, a parameterized tuple, or a concatenated expression.
3. **Verify Scope**: Follow variable declarations up to their origin within the function or class.
4. **Filter Framework Wrappers**: Verify whether the method being invoked is a framework-provided safe wrapper that automatically parameterizes inputs despite its method name.
5. **Advance Only Confirmed Sinks**: Only proceed to full taint flow analysis (`taint-analysis.md`) if Tier 2 confirms that an unsafe dynamic node is being evaluated.

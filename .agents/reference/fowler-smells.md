# Fowler Code Smells Reference Catalog

> Reference catalog based on Martin Fowler's *Refactoring: Improving the Design of Existing Code* (2nd Edition, Chapter 3).

This reference provides a consolidated baseline of code smells, their diagnostic definitions, and their target Fowler refactoring recipes. It is used across code reviews (`code-review`) and behavior-preserving restructuring sessions (`refactoring`).

---

## 1. Governance & Evaluation Rules

When auditing a diff or evaluating existing code against this catalog:

1. **The Repo Overrides:** A documented repository standard (`CODING_STANDARDS.md`, `CONTRIBUTING.md`, architectural guidelines) always wins. Where a repo standard explicitly endorses a pattern that this baseline flags, suppress the smell.
2. **Always a Judgement Call:** Every smell is a heuristic indicator (*"possible Feature Envy"*, *"potential Primitive Obsession"*), never an absolute violation. Distinguish hard violations from trade-offs.
3. **Skip Tooling-Enforced Issues:** Do not duplicate work performed by linters, typecheckers, formatters, or static analysis tools (e.g. ESLint, PHPStan, Clippy, mypy).

---

## 2. Consolidated Code Smells Matrix

| Smell | Definition / Symptom | Target Fowler Recipe |
| :--- | :--- | :--- |
| **Mysterious Name** | Names of functions, variables, or types do not reveal intent or domain concept. | Rename Variable / Function / Class |
| **Duplicated Code** | Similar logic shapes or identical structures appear in more than one hunk or file. | Extract Function / Form Template Method / Pull Up Method |
| **Long Function** | Function contains multiple levels of abstraction or exceeds clear single-purpose scope. | Extract Function / Decompose Conditional / Replace Temp with Query |
| **Long Parameter List** | More than 3–4 arguments passed to a function; parameters travel together. | Introduce Parameter Object / Preserve Whole Object / Combine Functions into Class |
| **Global Data** | Mutable global or package-level state accessible from arbitrary modules. | Encapsulate Variable / Introduce Parameter Object |
| **Mutable Data** | Uncontrolled mutations across shared references leading to race conditions or side effects. | Separate Query from Modifier / Remove Setting Method / Change Reference to Value |
| **Feature Envy** | Method queries or manipulates another object's data more than its own. | Move Function / Extract Function onto target data holder |
| **Data Clumps** | Identical cluster of fields or parameters repeatedly travel together across interfaces. | Extract Class / Introduce Parameter Object |
| **Primitive Obsession** | Basic primitives (strings, ints, arrays) represent domain concepts needing invariants. | Replace Primitive with Object / Introduce Value Object |
| **Repeated Switches** | Chained `switch` or `if/else` ladders inspecting type discriminators recur across call sites. | Replace Conditional with Polymorphism / Strategy Pattern |
| **Loops** | Procedural `for`/`while` loops performing filtering, mapping, and aggregation. | Replace Loop with Pipeline (`map`, `filter`, `reduce`) |
| **Lazy Element / Dead Code** | Functions, classes, or abstractions that carry negligible responsibility or no callers. | Inline Function / Inline Class / Remove Dead Code |
| **Speculative Generality** | Abstraction, generic hooks, or parameters added for hypothetical future needs. | Collapse Hierarchy / Inline Function / Remove Dead Code |
| **Temporary Field** | Instance variables that are set and used only during specific algorithms or edge cases. | Extract Class / Introduce Null Object |
| **Message Chains** | Long client navigation walks (`a.getB().getC().getD()`) coupling callers to internal topologies. | Hide Delegate / Extract Method on primary object |
| **Middle Man** | A class or function that primarily delegates work without adding domain value. | Remove Middle Man / Inline Function / Call target direct |
| **Insider Trading** | Modules reaching into each other's private boundaries or tightly coupled implementation details. | Move Function / Hide Delegate / Extract Class |
| **Large Class** | Monolithic class handling too many responsibilities (violates Single Responsibility Principle). | Extract Class / Extract Superclass / Replace Type Code with Subclasses |
| **Alternative Classes** | Different classes with identical behavior but divergent method names or signatures. | Change Function Declaration / Extract Superclass / Unify Interfaces |
| **Data Class** | Class containing only public properties or getters/setters with zero behavior. | Move Function / Encapsulate Record |
| **Refused Bequest** | Subclass or implementer that ignores, throws on, or overrides most inherited capabilities. | Replace Subclass with Delegate / Use Composition |
| **Comments (Deodorant)** | Code blocks accompanied by prose comments explaining "what this complex code is doing". | Extract Function (named after the comment) / Introduce Explaining Variable |
| **Divergent Change** | One module is edited for several unrelated reasons or distinct business drivers. | Single Responsibility Principle / Split Class |
| **Shotgun Surgery** | One single business change forces scattered, synchronized edits across many files. | Move Field / Move Function / Inline Class to gather cohesive units |

---

## 3. Diagnostic Checklist: *What It Is* → *How To Fix*

Use this diagnostic rubric when conducting code reviews or identifying refactoring candidates:

- **Mysterious Name:** A function, variable, or type whose name doesn't reveal what it does or holds.  
  $\rightarrow$ *Remedy:* Rename it. If no honest, clear name comes to mind, the design itself is murky.
- **Duplicated Code:** The same logic shape appears in more than one hunk or file in the change.  
  $\rightarrow$ *Remedy:* Extract the shared shape into a single reusable function or helper, and call it from both sites.
- **Feature Envy:** A method reaches into another object's data and helpers more than its own.  
  $\rightarrow$ *Remedy:* Move the method onto the data object it envies, or extract the envy portion into a method on the target.
- **Data Clumps:** The same few fields or parameters keep travelling together (a cohesive domain type wanting to be born).  
  $\rightarrow$ *Remedy:* Bundle them into a dedicated type or Value Object, and pass that single object instead.
- **Primitive Obsession:** A primitive string, number, or array stands in for a domain concept that deserves validation and invariants (e.g. raw string for currency, email, or coordinate).  
  $\rightarrow$ *Remedy:* Give the concept its own small, immutable Value Object or domain type.
- **Repeated Switches:** The same `switch` or `if/else` cascade on a discriminator or type code recurs across multiple call sites.  
  $\rightarrow$ *Remedy:* Replace with polymorphism (Strategy Pattern or class hierarchy) or a single shared dispatch table.
- **Shotgun Surgery:** One single logical requirement forces scattered micro-edits across dozens of separate files in the diff.  
  $\rightarrow$ *Remedy:* Gather what changes together into a single module or service.
- **Divergent Change:** One file or module is constantly modified for multiple unrelated business reasons.  
  $\rightarrow$ *Remedy:* Split the module so each distinct responsibility changes for only one reason (Single Responsibility Principle).
- **Speculative Generality:** Abstractions, generic type parameters, plugin hooks, or options added for hypothetical future needs.  
  $\rightarrow$ *Remedy:* Delete the unneeded flexibility; inline back to simple, concrete code until real necessity emerges (YAGNI).
- **Message Chains:** Long traversal chains (`a.b().c().d()`) that bind the caller to internal object hierarchies.  
  $\rightarrow$ *Remedy:* Hide the walk behind a single expressive method on the root object (Law of Demeter).
- **Middle Man:** A class or method that does nothing beyond delegating calls to another collaborator.  
  $\rightarrow$ *Remedy:* Cut the middle man; have callers interact with the real target directly.
- **Refused Bequest:** A subclass or implementer that ignores or overrides most of what it inherits from its parent.  
  $\rightarrow$ *Remedy:* Drop the inheritance relationship; favor composition and interface delegation instead.

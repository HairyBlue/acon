---
paths:
  - "**/*"
title: Feature Branching & Conventional Commit Specification
impact: MEDIUM
impactDescription: Standardizes commit history and enables automated changelog & versioning generation.
tags: git, commits, branching, workflow, conventional-commits
---

# Feature Branching & Conventional Commit Specification

Enforce Conventional Commits v1.0.0, pre-flight safety checks, and strict separation of authority for all git mutations.

## 1. Authority & Execution Policy
- **Mandatory Captain Authorization:** Agents must **NEVER** execute `git commit` or `git push` without prior explicit approval.
- **Worker-Only Git Execution:** Git commits and pushes must NEVER run in the primary command thread. The Control Plane delegates execution to a dedicated `Git Ops & Release Specialist` subagent via `invoke_subagent` to keep the bridge reactive.
- **Pre-Flight Secrets Check:** Verify that zero `.env` files, API tokens, private keys (`*.pem`, `id_rsa`), or `.worktrees/` folders are staged.

## 2. Conventional Commit Format (v1.0.0)

### Single-line format:
```text
<type>(<optional-scope>): <subject line in imperative present tense>
```

### Multi-line format (for multi-file / architectural releases):
```text
<type>(<optional-scope>): <subject line>

- <Component / Scope>: <high-level summary of change>
- <Component / Scope>: <high-level summary of change>
```

### Types:
- `feat`: A new user-facing feature or capability
- `fix`: A bug fix
- `docs`: Documentation changes only
- `style`: Formatting, whitespace, missing semicolons (no code behavior change)
- `refactor`: Code refactoring without behavioral change or bug fix
- `perf`: Performance improvements
- `test`: Adding or correcting test suites
- `build`: Build system, package dependencies, or tool configurations
- `ci`: CI/CD workflow configurations
- `chore`: Routine maintenance tasks

### Breaking Changes:
Append an exclamation mark before the colon: `feat(api)!: break legacy endpoint contract` or include a `BREAKING CHANGE: <explanation>` footer.

## 3. Branching Conventions
- **Solo Workflow:** Direct commits to `main`/`master` are permitted when authorized by the Captain.
- **Feature Branches:** Use `<type>/<short-description>` (e.g. `feat/user-avatar`, `fix/null-pointer`).
- **Concurrent Isolation:** Use `.worktrees/<branch>` when running parallel workers against the same repository.

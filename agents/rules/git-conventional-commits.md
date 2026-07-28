---
paths:
  - "**/*"
title: Feature Branching & Conventional Commit Specification
impact: MEDIUM
impactDescription: Standardizes commit history and enables automated changelog & versioning generation.
tags: git, commits, branching, workflow
---

# Feature Branching & Conventional Commit Specification

**Impact: MEDIUM**

Enforce clean branch naming and Conventional Commits v1.0.0 for all code changes.

## Branching Conventions:
- Do not commit directly to `main` or `master`.
- Naming format: `<type>/<short-description>` (e.g., `feat/add-user-avatar`, `fix/null-address-pointer`).

## Conventional Commit Header Format:
```text
<type>(<optional-scope>): <subject line in imperative present tense>
```

### Types:
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Code style/formatting
- `refactor`: Code refactoring without behavior change
- `perf`: Performance improvement
- `test`: Adding or correcting tests
- `chore`: Maintenance tasks

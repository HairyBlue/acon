---
name: security-devops
description: "Master security, git safety, and devops suite covering static code security audits (50+ vulnerability types), git guardrails, git worktrees, shell scripting, conventional commits, and pre-commit hooks."
license: MIT
metadata:
  author: acon
---

# Security & DevOps Master Suite

This skill serves as the primary router and master guide for static security analysis, Git safety policies, shell automation, and pre-commit workflows in ACON.

---

## Suite Directory & Child Skills

| Skill Name | Description & When to Activate | Child Path |
| :--- | :--- | :--- |
| **`conventional-commits`** | Specification and formatting standards for Git Conventional Commits v1.0.0. | [`conventional-commits/SKILL.md`](conventional-commits/SKILL.md) |
| **`git-guardrails`** | Universal pre-execution hooks blocking destructive git operations (`push`, `reset --hard`, `clean -fd`, `branch -D`). | [`git-guardrails/SKILL.md`](git-guardrails/SKILL.md) |
| **`git-worktrees`** | Multi-agent git worktree isolation topology, lifecycle management (spawn/bootstrap/teardown), and branch collision avoidance. | [`git-worktrees/SKILL.md`](git-worktrees/SKILL.md) |
| **`security-audit`** | Universal, language-agnostic static security audit engine with OWASP Top 10 (2021), OWASP API Security Top 10 (2023), D1-D10 matrix, AST triage, taint analysis, and closed-loop remediation. | [`security-audit/SKILL.md`](security-audit/SKILL.md) |
| **`setup-pre-commit`** | Automates Husky + lint-staged + Prettier / typecheck pre-commit hook configuration. | [`setup-pre-commit/SKILL.md`](setup-pre-commit/SKILL.md) |
| **`shell-scripting`** | Production bash scripting: `set -euo pipefail`, cleanup `trap` handlers, defensive quoting, `getopts` options, and stderr/stdout separation. | [`shell-scripting/SKILL.md`](shell-scripting/SKILL.md) |

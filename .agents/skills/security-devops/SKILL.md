---
name: security-devops
description: "Master security, git safety, and devops suite covering static code security audits (50+ vulnerability types), multi-agent orchestration, git guardrails, conventional commits, and pre-commit hooks."
license: MIT
metadata:
  author: acon
---

# Security & DevOps Master Suite

This skill serves as the primary router and master guide for static security analysis, Git safety policies, and multi-agent orchestration in ACON.

---

## Suite Directory & Child Skills

| Skill Name | Description & When to Activate | Child Path |
| :--- | :--- | :--- |
| **`security-audit`** | Comprehensive static security code analysis (50+ vulnerability types across PHP, JS, Python, C#) with OWASP matrix and WooYun parameters. | [`security-audit/SKILL.md`](security-audit/SKILL.md) |
| **`multi-agent-orchestration`** | Parallel subagent task delegation and non-overlapping file scoping for 5+ file tasks. | [`multi-agent-orchestration/SKILL.md`](multi-agent-orchestration/SKILL.md) |
| **`conventional-commits`** | Specification and formatting standards for Git Conventional Commits v1.0.0. | [`conventional-commits/SKILL.md`](conventional-commits/SKILL.md) |
| **`git-guardrails-claude-code`** | PreToolUse hooks blocking destructive git operations (`push`, `reset --hard`, `clean -fd`, `branch -D`). | [`git-guardrails-claude-code/SKILL.md`](git-guardrails-claude-code/SKILL.md) |
| **`setup-pre-commit`** | Automates Husky + lint-staged + Prettier / typecheck pre-commit hook configuration. | [`setup-pre-commit/SKILL.md`](setup-pre-commit/SKILL.md) |

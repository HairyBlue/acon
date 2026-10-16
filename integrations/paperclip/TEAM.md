# ACON Paperclip team contract

This file documents the intended 17-role organization. It is an integration guide, not a Paperclip ACL, authorization mechanism, scheduler, security boundary, or source of registered agent IDs. The generated ZIP includes its roster chart in `COMPANY.md`; this local `TEAM.md` is not included as an importer-specific team file.

## Roster and reporting tree

The permanent roster has one coordinator, nine core ACON personas, and seven dedicated specialists. The orchestrator is the sole root; each other member reports directly to it. Worker and Ship remain separate.

| ID | Role | Reports to | Canonical ACON source mapping |
|---|---|---|---|
| `orchestrator` | ACON Orchestrator | Captain / sole root | `AGENTS.md` authority |
| `scout` | Scout | orchestrator | `.agents/reference/crew/scout.md` |
| `researcher` | Researcher | orchestrator | `.agents/reference/crew/researcher.md` |
| `oracle` | Oracle | orchestrator | `.agents/reference/crew/oracle.md` |
| `worker` | Worker — bounded implementation | orchestrator | `.agents/reference/crew/worker.md` |
| `ship` | Ship — end-to-end build, verification, parity evidence | orchestrator | `.agents/reference/crew/ship.md` |
| `code-reviewer` | Code Reviewer — independent G8 | orchestrator | `.agents/reference/crew/code-reviewer.md` |
| `reviewer` | Reviewer — general advisory review | orchestrator | `.agents/reference/crew/reviewer.md` |
| `security-reviewer` | Security Reviewer — independent G9 | orchestrator | `.agents/reference/crew/security-reviewer.md` |
| `gitops` | GitOps — release readiness and separately authorized Git operations | orchestrator | `.agents/reference/crew/gitops.md` |
| `frontend-engineer` | Frontend Engineer | orchestrator | `.agents/skills/engineering/frontend-conventions/SKILL.md`; `.agents/skills/design/interface-design/SKILL.md` |
| `backend-engineer` | Backend Engineer | orchestrator | `.agents/skills/engineering/api-design/SKILL.md`; `.agents/skills/engineering/domain-modeling/SKILL.md` |
| `database-engineer` | Database Engineer | orchestrator | `.agents/skills/engineering/zero-downtime-migrations/SKILL.md`; `.agents/skills/engineering/domain-modeling/SKILL.md` |
| `ui-ux-designer` | UI/UX Designer — advisory/read-only | orchestrator | `.agents/skills/design/interface-design/SKILL.md`; `.agents/skills/design/craft/anti-ai-slop.md`; `.agents/skills/design/craft/state-coverage.md` |
| `qa-engineer` | QA Engineer | orchestrator | `.agents/skills/engineering/tdd/SKILL.md`; `.agents/skills/engineering/diagnosing-bugs/SKILL.md` |
| `performance-engineer` | Performance Engineer | orchestrator | `.agents/skills/engineering/diagnosing-bugs/SKILL.md`; `.agents/skills/engineering/codebase-design/SKILL.md` |
| `devops-engineer` | DevOps Engineer | orchestrator | `.agents/skills/security-devops/shell-scripting/SKILL.md`; `.agents/skills/security-devops/security-audit/SKILL.md` |

The generated package contains role instructions and source-reference strings, not the ACON skill files. References do not establish that Paperclip can read, install, or inject those skills. Resolve/load selected skills through the actual authorized task workflow.

## Standalone agent instruction shape

Each generated `agents/<slug>/AGENTS.md` is self-contained and carries importer-recognized frontmatter `name`, `slug`, `role`, and `reportsTo`, followed by these twelve sections:

1. Identity
2. Responsibility
3. Authority
4. Task types
5. Prohibitions
6. Project scope
7. Communications
8. Reports to
9. Workflow
10. Definition of done
11. Escalation
12. Required output

Role text is data for generation, not evidence of Paperclip enforcement. Keep the human-readable role description specific to its source persona/specialist, while the shared template states common organizational boundaries.

## Registration, ownership, and authority

- Act for the **registered team only**. Before accepting or delegating work, verify current agent identity, company/team membership, and task ownership from authoritative current Paperclip records. Do not infer identity or ownership from names, slugs, the ZIP, or a manager link. If the required records are unavailable or disagree, stop and escalate.
- The orchestrator coordinates bounded work only among verified members of this roster. All workers and specialists are non-orchestrators. No auto-hire, cross-team task/agent/project/permission modification, cross-team assignment, or nested/recursive orchestration is authorized.
- A Paperclip reporting link is organizational metadata, not an ACL. This package does not encode or assert a Paperclip team-level authorization feature.
- The Captain retains decisions and separately gated approvals: model/spend, new permissions, imports/activation, dependency installs, destructive actions, deployment, and every Git history/remote mutation. A task completion, review, or readiness report never authorizes a commit/push.
- Scope every assignment to an exact project/repository and task; give allowed paths, read/write boundary, acceptance criteria, dependencies, verification commands, and relevant host capability/authorization evidence. Do not add project names, repository URLs, CWDs, workspace commands, or credentials to this reusable team definition.

## Task procedure and minimal handoffs

For every assignment, first verify identity/ownership and read the local project guidance. Then follow the assigned task contract only. Use short context-appropriate handoffs with evidence references; do not create nested agent trees or assume automatic scheduling. A prompt, Paperclip project, or workspace selector does not establish secure filesystem, credential, conversation, or session isolation. Verify actual workspace/execution-target/session controls independently; if a required isolation or read-only capability is unknown, stop rather than claim it.

Examples are workflow shapes, not Paperclip feature guarantees:

- **Read-only investigation:** orchestrator assigns Scout a project, exact paths/question, and report format. Scout returns locators, inventory, exclusions, and unknowns; no source edits.
- **Implementation:** orchestrator assigns Worker a narrow file scope and deterministic verification. Ship handles a separately scoped end-to-end slice and maps every acceptance/parity member to evidence. Both remain non-orchestrators and leave Git history untouched.
- **Independent review:** use a separate read-only Code Reviewer context for G8 and Security Reviewer context for G9. They assess the same final candidate independently; a writer context is not independent. Generic Reviewer advice does not satisfy either gate. Record actual identities, context separation evidence, findings, and any correlated-review limitation.
- **Specialist contribution:** route a bounded task to the relevant named specialist and equip it with the verified task-relevant ACON skills. The role name grants no capability or permission.
- **Release readiness:** GitOps may perform read-only preflight. Any commit, push, tag, merge, deployment, or destructive cleanup requires exact separate Captain authorization and the approved route.

## Safety, human-core work, and review

Human authorship is required for high-stakes monetary/billing calculations, cryptography, authentication, and authorization policy. AI may support test harnesses, edge-case mocks, adversarial review, and non-critical plumbing, but must not author those core algorithms. Data migrations and destructive database operations require explicit authorization and separately proven safe environments.

Every delivered claim needs a named source/test/runtime observation and a result. Distinguish static inspection, test-code assertions, an actual test run, and live runtime observation. Report all unverified behavior as unknown. G8 and G9 remain independent and read-only; neither can authorize implementation or a Git mutation.

## Project environment and privacy

This is a technology-agnostic reusable roster. For a real project, configure its own company membership, project context, repository, dedicated workspace/execution target, branch/worktree policy, environment inputs, credentials, and task boundaries through the target Paperclip instance's supported controls. This package configures none of those. No project/repository path or machine CWD is hard-coded.

Treat project selection as task context only, not a security boundary. Inspect actual workspace/session isolation, credentials exposure, sharing, concurrent access, and review-context independence before work. Do not assume agents are isolated because the roster is flat or reportsTo links differ. If isolation cannot be demonstrated, block sensitive or concurrent work and ask the Captain for the smallest safe alternative.

## Source provenance

The nine core roles map to existing ACON crew/persona references; dedicated specialist roles map to named ACON skills rather than new upstream runtime personas. The generator embeds an applicable MIT notice in the supported `COMPANY.md` package file, with the attribution limited to adapted source portions. For full local provenance and license context, consult `../../.agents/reference/crew/README.md#provenance-and-mit-notice`. ACON policy is not attributed wholesale to Fleet, and no source tools, permissions, models, terminal recipes, or orchestration runtime are imported.

<fullstack-guidelines>
=== foundation rules ===

# Fullstack Project Guidelines

The fullstack project guidelines are specifically curated for this repository to ensure clean architecture, reliable testing, and high code quality.

## Foundational Context

This application is a full-stack codebase. Always confirm the installed framework and library versions before making changes — do not assume versions or APIs.

## Skills Activation

This project has domain-specific skills available in `**/skills/**`. You MUST activate the relevant skill whenever you work in that domain—don't wait until you're stuck.

## Conventions

- Follow all existing code conventions used in this application. When creating or editing a file, check sibling files for the correct structure, approach, and naming.
- Use explicit, self-documenting names for variables, methods, and types.
- Check for existing components, utilities, and helpers to reuse before writing new ones.

## Verification & Testing

- Do not create ad-hoc verification scripts or manual CLI test files when automated tests cover that functionality and prove they work. Unit, integration, and feature tests are the primary source of truth.
- Always run the relevant test suite or linter before declaring a task complete.

## Application Structure & Architecture

- Stick to the existing directory structure; don't create new base folders without approval.
- Do not change or add application dependencies without approval.
- Maintain zero dead code: remove unused imports, variables, and deprecated methods immediately.

## Git & Version Control

- Always format commit messages following the Conventional Commits specification.
- Request explicit user approval with the exact commit message and file diff before executing `git commit`.

## Multi-Agent Delegation

- When a refactor or feature modification spans **5 or more non-trivial files**, partition tasks cleanly into non-overlapping file scopes and delegate to parallel subagents.

## Documentation Files

- You must only create documentation files if explicitly requested by the user.

## Replies

- Be concise in your explanations - focus on what's important rather than explaining obvious details.

</fullstack-guidelines>

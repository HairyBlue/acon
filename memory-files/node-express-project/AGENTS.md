<node-express-guidelines>
=== foundation rules ===

# Node.js & Express Guidelines

The Node.js and Express guidelines are specifically curated for this application to ensure reliable, high-performance TypeScript backend services.

## Foundational Context

This application is a Node.js backend running with TypeScript in ESM mode. Always use APIs that match the installed major version of each package — do not assume a version.

Before relying on a package's API, confirm its installed version:
- Dependencies: check `package.json` or run `npm list --depth=0` / `pnpm list --depth=0`.
- Node engine: run `node --version`.

## Skills Activation

This project has domain-specific skills available in `**/skills/**`. You MUST activate the relevant skill whenever you work in that domain—don't wait until you're stuck.

## Conventions

- Follow all existing code conventions in this application. When creating or editing a file, check sibling files for the correct structure, approach, and naming.
- Use explicit, descriptive names for functions, variables, and types (e.g., `findActiveUserById`, not `getUser()`).
- Reuse existing middlewares, repositories, utilities, and schema validators before authoring new ones.

## Verification Scripts

- Do not create verification scripts or throwaway run scripts when automated unit and integration tests prove functionality. Tests are the primary source of truth.

## Application Structure & Architecture

- Maintain a strict 3-tier Layered Architecture:
  - **Routes & Controllers**: Handle HTTP transport, parse headers/cookies, call schema validators, and invoke services.
  - **Services**: Pure business domain logic, workflows, and transaction boundaries. No direct `req` or `res` objects.
  - **Repositories / Data Access Layer**: Database queries (Prisma, Drizzle, Kysely, TypeORM, Mongoose).
- Stick to the existing directory layout; do not create arbitrary base folders without approval.
- Do not change or add npm dependencies without approval.

## Documentation Files

- You must only create documentation files if explicitly requested by the user.

## Replies

- Be concise in your explanations - focus on architectural decisions and non-obvious details rather than repeating standard code.

=== typescript rules ===

# TypeScript & Runtime Standards

- **Strict Type Checking**: Never use `any`. Use `unknown` with type guards/narrowing, or generic type constraints.
- **Explicit Return Types**: Always specify return types on exported functions, controllers, and service methods.
- **Asynchronous Flow**: Always use `async/await`. Never leave dangling promises or unhandled promise rejections.
- **Type-Safe Enums & Constants**: Use `as const` object literals or TypeScript `enum` matching project style.
- **Imports**: Use explicit ESM import syntax with named exports.

=== express rules ===

# Express & API Standards

- **Thin Controllers**: Controllers extract data from `req.body`, `req.params`, `req.query`, pass them to service methods, and return standardized JSON responses.
- **Request Validation**:
  - Always validate incoming requests using **Zod** or **Joi** before passing data to services.
  - Fail fast with a `400 Bad Request` containing structured error details.
- **Error Handling**:
  - Never swallow errors in empty `catch` blocks.
  - Forward unexpected errors to the centralized error middleware via `next(err)`.
  - Use custom domain exceptions (`NotFoundError`, `UnauthorizedError`, `ConflictError`, `ValidationError`).
- **Security Middlewares**:
  - Ensure `helmet()` is applied for secure HTTP headers.
  - Configure CORS with explicit allowed origins.
  - Enforce rate limiting on auth and sensitive mutations.
  - Always use parameterized queries or ORM bindings to prevent SQL/NoSQL injection.

=== testing rules ===

# Testing (Vitest / Jest)

- This project prioritizes automated unit and integration tests.
- Unit tests test individual service functions in isolation with mock repositories.
- Integration tests use `supertest` to test actual HTTP endpoints, validating status codes, response headers, and payload structures.
- Use factories or fixtures for mock database records rather than manual inline JSON.
- Run tests narrowly: `npx vitest run path/to/file.test.ts` or `npm test -- -t "test name"`.
- Do not delete or disable existing tests without approval.

=== linting rules ===

# Code Formatter & Linter

- Run linter/formatting checks before finalizing code:
  - ESLint / Prettier: `npm run lint` or `npx prettier --write <file>`
  - Biome: `npx biome check --write <file>`
- Ensure zero compiler errors and zero unused imports before completing a task.

</node-express-guidelines>

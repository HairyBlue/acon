<python-fastapi-guidelines>
=== foundation rules ===

# Python & FastAPI Guidelines

The Python & FastAPI guidelines are specifically curated for this application to ensure robust, high-performance API services.

## Foundational Context

This application is a Python application running on Python 3.11+ using FastAPI (or Django). You are an expert in the modern Python ecosystem. Always use APIs that match the installed major versions — do not assume a version.

Before relying on a package's API, confirm its installed version:
- Dependencies: check `pyproject.toml`, `requirements.txt`, or run `pip list` / `poetry show` / `uv pip list`.
- Python version: run `python --version`.

## Skills Activation

This project has domain-specific skills available in `**/skills/**`. You MUST activate the relevant skill whenever you work in that domain—don't wait until you're stuck.

## Conventions

- Follow all existing code conventions in this application. When creating or editing a file, check sibling files for the correct structure, approach, and naming.
- Use explicit, descriptive names for functions, classes, and variables (`get_active_organization_by_id`, not `get_org()`).
- Reuse existing schemas, dependencies, database models, and service helpers before authoring new ones.

## Verification Scripts

- Do not create ad-hoc verification scripts or manual CLI test files when automated pytest suites cover that functionality. Tests are the primary source of truth.

## Application Structure & Architecture

- Maintain clean architectural separation:
  - **Routers (`app/api/`)**: Define route endpoints, response models, status codes, and inject dependencies.
  - **Schemas (`app/schemas/`)**: Pydantic v2 request/response models with field validation.
  - **Services (`app/services/`)**: Business logic, external integrations, transaction management.
  - **Models (`app/models/`)**: SQLAlchemy 2.0 / SQLModel ORM models.
- Stick to the existing directory layout; do not create arbitrary base folders without approval.
- Do not modify or add dependencies without approval.

## Documentation Files

- You must only create documentation files if explicitly requested by the user.

## Replies

- Be concise in your explanations - focus on architectural decisions and non-obvious details rather than repeating standard code.

=== python rules ===

# Python Standards

- **Strict Type Annotations**: Use Python 3.10+ modern type hints on all function signatures (`param: int | None = None -> list[UserResponse]`).
- **Async Execution**: Use `async def` for I/O-bound route handlers and database operations; use `def` for CPU-bound utility functions.
- **Context Managers**: Use `async with` for database sessions, Redis connections, and HTTP client sessions (`httpx.AsyncClient`).
- **Docstrings & Comments**: Prefer concise Google-style or Sphinx-style docstrings on public methods over inline comments.

=== fastapi rules ===

# FastAPI & API Standards

- **Dependency Injection**: Use `Depends()` for database session lifecycles, authentication/authorization contexts, and shared services.
- **Pydantic v2 Models**:
  - Use Pydantic v2 `BaseModel` schemas with `Field()` descriptions and constraints.
  - Enable `model_config = ConfigDict(from_attributes=True)` for ORM model serialization.
  - Separate Create, Update, and Read schemas (`UserCreate`, `UserUpdate`, `UserResponse`).
- **Error Handling**:
  - Raise `HTTPException` with explicit status codes and error detail payloads.
  - Register custom global exception handlers in `app/core/exceptions.py`.
- **Database & Queries**:
  - Use SQLAlchemy 2.0 async sessions (`AsyncSession`).
  - Always paginate endpoints returning lists of records.
  - Manage database migrations exclusively through Alembic (`alembic revision --autogenerate`, `alembic upgrade head`).

=== testing rules ===

# Testing (Pytest)

- This project uses `pytest` with `pytest-asyncio` for automated testing.
- Use `httpx.AsyncClient` with `ASGITransport` to perform fast, in-memory integration testing of API routes without spinning up a live server.
- Use model factories and test database fixtures (with transaction rollback per test).
- Run tests with narrow filters during development:
  ```bash
  pytest tests/test_users.py -k "test_create_user" -v
  ```
- Do not delete or disable existing tests without approval.

=== linting rules ===

# Code Formatter & Linter (Ruff)

- Format and lint code before finalizing changes:
  ```bash
  ruff check --fix .
  ruff format .
  ```

</python-fastapi-guidelines>

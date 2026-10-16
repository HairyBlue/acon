#!/usr/bin/env python3
"""Build the pinned Paperclip schema-7 ACON organization package."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import stat
import sys
import uuid
import zipfile
from pathlib import Path, PurePosixPath

REPO_ROOT = Path(__file__).absolute().parent.parent.parent
INTEGRATION_RELATIVE = "integrations/paperclip"
AUXILIARY_FILES = {"README.md", "TEAM.md", "VALIDATION.md", "LICENSE.md"}
MAX_INPUT_BYTES = 4 * 1024 * 1024
CANONICAL_SOURCE_ALLOWLIST = {
    "AGENTS.md",
    ".agents/reference/crew/scout.md", ".agents/reference/crew/researcher.md",
    ".agents/reference/crew/oracle.md", ".agents/reference/crew/worker.md",
    ".agents/reference/crew/ship.md", ".agents/reference/crew/code-reviewer.md",
    ".agents/reference/crew/reviewer.md", ".agents/reference/crew/security-reviewer.md",
    ".agents/reference/crew/gitops.md",
    ".agents/skills/engineering/frontend-conventions/SKILL.md",
    ".agents/skills/design/interface-design/SKILL.md",
    ".agents/skills/engineering/api-design/SKILL.md",
    ".agents/skills/engineering/domain-modeling/SKILL.md",
    ".agents/skills/engineering/zero-downtime-migrations/SKILL.md",
    ".agents/skills/design/craft/anti-ai-slop.md",
    ".agents/skills/design/craft/state-coverage.md",
    ".agents/skills/engineering/tdd/SKILL.md",
    ".agents/skills/engineering/diagnosing-bugs/SKILL.md",
    ".agents/skills/engineering/codebase-design/SKILL.md",
    ".agents/skills/security-devops/shell-scripting/SKILL.md",
    ".agents/skills/security-devops/security-audit/SKILL.md",
}
PRIVATE_PATH = re.compile(r"(?i)(?:/(?:home|tmp|mnt|Users)/|[A-Z]:\\Users\\)")
FINAL_OUTPUT = Path("/home/mewho/ai-stuff/paperclip-acon-team.zip")
PAPERCLIP_BUNDLE_SCHEMA_VERSION = 7  # Captured source pin: paperclip master fd057f6ac4e9148bb4055883ae1d0e7f49242692.

EXPECTED_GROUPS = {"coordinator": 1, "core": 9, "specialist": 7}
EXPECTED_SLUGS = {
    "orchestrator", "scout", "researcher", "oracle", "worker", "ship",
    "code-reviewer", "reviewer", "security-reviewer", "gitops",
    "frontend-engineer", "backend-engineer", "database-engineer",
    "ui-ux-designer", "qa-engineer", "performance-engineer", "devops-engineer",
}
ROLE_FIELDS = {
    "identity", "responsibility", "authority", "task_types", "prohibitions",
    "project_scope", "communications", "reports_to", "workflow",
    "definition_of_done", "escalation", "required_output",
}
CATALOG_FIELDS = {"schema_version", "company", "groups", "agents"}
COMPANY_FIELDS = {"name", "slug"}
AGENT_FIELDS = {"slug", "name", "group", "reports_to", "source_refs", "role_fields"}
SECRET_VALUE = re.compile(
    r"(?i)(?:sk-[A-Za-z0-9]{20,}|gh[pousr]_[A-Za-z0-9]{20,}|"
    r"-----BEGIN [A-Z ]*PRIVATE KEY-----|(?:api[_-]?key|secret|password)\s*[:=]\s*['\"][^'\"]{8,})"
)
SLUG = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")


class PackageError(ValueError):
    """Invalid package/catalog data or unsafe output request."""


def _exact_keys(value: object, expected: set[str], label: str) -> dict:
    if not isinstance(value, dict):
        raise PackageError(f"{label} must be an object")
    actual = set(value)
    if actual != expected:
        missing = sorted(expected - actual)
        extra = sorted(actual - expected)
        raise PackageError(f"{label} keys mismatch (missing={missing}, extra={extra})")
    return value


def _safe_text(value: object, label: str) -> str:
    if not isinstance(value, str) or not value.strip():
        raise PackageError(f"{label} must be a non-empty string")
    if any(ord(ch) < 32 and ch not in "\t" for ch in value):
        raise PackageError(f"{label} contains a control character")
    if SECRET_VALUE.search(value):
        raise PackageError(f"{label} resembles a credential; remove it from the package source")
    return value


def validate_catalog(catalog: object) -> dict:
    data = _exact_keys(catalog, CATALOG_FIELDS, "catalog")
    if data["schema_version"] != 1:
        raise PackageError("catalog schema_version must equal 1")
    company = _exact_keys(data["company"], COMPANY_FIELDS, "company")
    _safe_text(company["name"], "company.name")
    if company["slug"] != "acon-agent-organization":
        raise PackageError("company.slug must equal acon-agent-organization")
    if data["groups"] != {"core": 9, "specialist": 7}:
        raise PackageError("groups must declare exactly 9 core and 7 specialist roles")
    agents = data["agents"]
    if not isinstance(agents, list) or len(agents) != 17:
        raise PackageError("agents must contain exactly 17 entries")

    seen_slugs: set[str] = set()
    seen_names: set[str] = set()
    groups: dict[str, int] = {key: 0 for key in EXPECTED_GROUPS}
    by_slug: dict[str, dict] = {}
    for index, raw in enumerate(agents):
        label = f"agents[{index}]"
        agent = _exact_keys(raw, AGENT_FIELDS, label)
        slug = _safe_text(agent["slug"], f"{label}.slug")
        if not SLUG.fullmatch(slug) or ".." in slug:
            raise PackageError(f"{label}.slug is unsafe: {slug!r}")
        name = _safe_text(agent["name"], f"{label}.name")
        if slug in seen_slugs:
            raise PackageError(f"duplicate agent slug: {slug}")
        if name in seen_names:
            raise PackageError(f"duplicate agent name: {name}")
        seen_slugs.add(slug)
        seen_names.add(name)

        group = agent["group"]
        if group not in groups:
            raise PackageError(f"{label}.group is unsupported: {group!r}")
        groups[group] += 1
        manager = agent["reports_to"]
        if manager is not None and not isinstance(manager, str):
            raise PackageError(f"{label}.reports_to must be null or an agent slug")

        refs = agent["source_refs"]
        if not isinstance(refs, list) or not refs:
            raise PackageError(f"{label}.source_refs must be a non-empty list")
        for ref in refs:
            _safe_text(ref, f"{label}.source_refs[]")
            posix = PurePosixPath(ref)
            if posix.is_absolute() or ".." in posix.parts or "\\" in ref or ref.startswith("/"):
                raise PackageError(f"{label}.source_refs contains unsafe path {ref!r}")
        fields = _exact_keys(agent["role_fields"], ROLE_FIELDS, f"{label}.role_fields")
        for key, value in fields.items():
            _safe_text(value, f"{label}.role_fields.{key}")
        by_slug[slug] = agent

    if seen_slugs != EXPECTED_SLUGS:
        raise PackageError(f"roster IDs differ from the approved 17-role roster: {sorted(seen_slugs ^ EXPECTED_SLUGS)}")
    if groups != EXPECTED_GROUPS:
        raise PackageError(f"roster group counts are invalid: {groups}")
    if list(a["slug"] for a in agents) != [
        "orchestrator", "scout", "researcher", "oracle", "worker", "ship",
        "code-reviewer", "reviewer", "security-reviewer", "gitops",
        "frontend-engineer", "backend-engineer", "database-engineer",
        "ui-ux-designer", "qa-engineer", "performance-engineer", "devops-engineer",
    ]:
        raise PackageError("roster order differs from the approved order")
    if set(by_slug) != seen_slugs:
        raise PackageError("duplicate or unresolved agent IDs")
    # Validate graph references/cycles before enforcing the one-root flat roster.
    for slug in seen_slugs:
        visited: set[str] = set()
        current: str | None = slug
        while current is not None:
            if current in visited:
                raise PackageError(f"reporting cycle contains {current}")
            if current not in by_slug:
                raise PackageError(f"reporting link references unknown agent {current}")
            visited.add(current)
            current = by_slug[current]["reports_to"]
    if by_slug["orchestrator"]["reports_to"] is not None:
        raise PackageError("orchestrator must be the sole root (reports_to null)")
    for slug, agent in by_slug.items():
        if slug != "orchestrator" and agent["reports_to"] != "orchestrator":
            raise PackageError(f"{slug} must report directly to orchestrator")
    return data


def render_agent(template: str, agent: dict) -> str:
    fields = agent["role_fields"]
    role = agent["name"].removeprefix("ACON ")
    replacements = {
        "name": agent["name"],
        "slug": agent["slug"],
        "role": role,
        "paperclip_reports_to": "null" if agent["reports_to"] is None else agent["reports_to"],
        "source_refs": ", ".join(f"`{ref}`" for ref in agent["source_refs"]),
        **fields,
    }
    rendered = template
    for key, value in replacements.items():
        rendered = rendered.replace("{{" + key + "}}", value)
    if re.search(r"\{\{[^{}]+\}\}", rendered):
        raise PackageError(f"unresolved template placeholder in {agent['slug']}/AGENTS.md")
    if not rendered.endswith("\n"):
        rendered += "\n"
    return rendered


def build_manifest(catalog: dict) -> dict:
    agents: dict[str, dict] = {}
    for agent in catalog["agents"]:
        role = agent["name"].removeprefix("ACON ")
        agents[agent["slug"]] = {
            "role": role,
            "adapter": {
                "type": "pi_local",
                "config": {
                    "model": "openai-codex/gpt-6-luna",
                    "thinking": "high",
                },
            },
            "runtime": {"heartbeat": {"enabled": False}},
            "permissions": {},
            "permissionGrants": [],
        }
    return {"schemaVersion": PAPERCLIP_BUNDLE_SCHEMA_VERSION, "agents": agents}


def _company_markdown(catalog: dict) -> str:
    company = catalog["company"]
    lines = [
        "---",
        f"name: {company['name']}",
        f"slug: {company['slug']}",
        "---",
        "",
        f"# {company['name']}",
        "",
        "Project-agnostic ACON agent organization. Task assignments must provide the exact project, repository, task scope, acceptance criteria, and verification; this package creates no project/workspace configuration.",
        "",
        "## Roster and reporting chart",
        "",
        "All roles are intended to be registered in this organization. The orchestrator is the sole root; every other role reports directly to it. The roster is descriptive package data, not a Paperclip ACL. Verify actual registered identity, membership, and ownership from authoritative Paperclip records before delegation.",
        "",
        "| ID | Role | Reports to | Canonical ACON source mapping |",
        "|---|---|---|---|",
    ]
    for agent in catalog["agents"]:
        manager = "—" if agent["reports_to"] is None else agent["reports_to"]
        refs = ", ".join(f"`{ref}`" for ref in agent["source_refs"])
        lines.append(f"| `{agent['slug']}` | {agent['name']} | {manager} | {refs} |")
    lines.extend([
        "",
        "## Operating and safety boundary",
        "",
        "No auto-hire, cross-team task/agent modification, cross-team assignment, or nested orchestration is authorized by this package. Non-orchestrator agents are not coordinators. Prompt text and reportsTo links do not enforce permissions, team ownership, workspace isolation, or conversation isolation. Captain approval remains required for gated operations. The package contains no projects, tasks, routines, skills, environment inputs, secrets, workspace commands, or repository paths.",
        "",
        "Agent heartbeat is configured disabled in the portable extension. This does not prove that all wakeups are disabled or that an imported agent has paused status. Import must be submitted through a supported UI/API request with `pauseAutomations: true`, then the owner must verify resulting status and automation state. The ZIP itself cannot set import status.",
        "",
        "An empty declared permission map/grant list does not prove zero effective permissions: Paperclip may apply importer/company defaults. Inspect effective permissions after import in a separately authorized disposable company before activation.",
        "",
        "## Source provenance and license",
        "",
        "Role adaptations map to the ACON crew personas and skill references listed above. ACON authority and safety wording remains ACON policy; no upstream runtime, tools, fixed provider catalog, terminal recipe, or permissions are adopted. Capability/verification reconciliation is informed by Fleet revision `0af843fa2c92413ea16c50e50bd8a9e24f1d1995` as ideas only. This attribution is not an authorship claim for the full ACON content. The following MIT notice applies to adapted source portions, not the entire ACON repository:",
        "",
        "```text",
        "MIT License",
        "",
        "Copyright (c) 2025 Addy Osmani",
        "",
        "Permission is hereby granted, free of charge, to any person obtaining a copy",
        'of this software and associated documentation files (the "Software"), to deal',
        "in the Software without restriction, including without limitation the rights",
        "to use, copy, modify, merge, publish, distribute, sublicense, and/or sell",
        "copies of the Software, and to permit persons to whom the Software is",
        "furnished to do so, subject to the following conditions:",
        "",
        "The above copyright notice and this permission notice shall be included in all",
        "copies or substantial portions of the Software.",
        "",
        'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR',
        "IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,",
        "FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE",
        "AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER",
        "LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,",
        "OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE",
        "SOFTWARE.",
        "```",
        "",
    ])
    return "\n".join(lines)


def _input_path_parts(relative_path: str) -> list[str]:
    if (
        not isinstance(relative_path, str)
        or not relative_path
        or "\x00" in relative_path
        or "\\" in relative_path
        or relative_path.startswith("/")
        or "//" in relative_path
        or relative_path.endswith("/")
    ):
        raise PackageError(f"unsafe source input path: {relative_path!r}")
    parts = relative_path.split("/")
    if any(part in ("", ".", "..") for part in parts):
        raise PackageError(f"unsafe source input path: {relative_path!r}")
    return parts


def _open_input_root(root: str | os.PathLike[str]) -> int:
    raw = os.fspath(root)
    if not isinstance(raw, str) or "\x00" in raw:
        raise PackageError("unsafe source root path")
    if not raw.startswith("/"):
        raw = os.path.abspath(raw)
    if raw != "/" and ("//" in raw or raw.endswith("/")):
        raise PackageError("unsafe source root path")
    parts = [] if raw == "/" else raw.split("/")[1:]
    if any(part in ("", ".", "..") for part in parts):
        raise PackageError("unsafe source root path")
    if (
        not hasattr(os, "O_NOFOLLOW")
        or not hasattr(os, "O_DIRECTORY")
        or os.open not in os.supports_dir_fd
    ):
        raise PackageError("host lacks descriptor-relative no-follow input reads")
    flags = os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW | getattr(os, "O_CLOEXEC", 0)
    try:
        fd = os.open("/", flags)
        for component in parts:
            child = os.open(component, flags, dir_fd=fd)
            if not stat.S_ISDIR(os.fstat(child).st_mode):
                os.close(child)
                raise PackageError(f"unsafe non-directory source-root component: {component!r}")
            os.close(fd)
            fd = child
        return fd
    except PackageError:
        if "fd" in locals():
            os.close(fd)
        raise
    except OSError as exc:
        if "fd" in locals():
            os.close(fd)
        raise PackageError(f"unsafe source root (no symlink following): {exc.strerror or exc}") from None


def _read_rooted_input(root: str | os.PathLike[str], relative_path: str) -> bytes:
    parts = _input_path_parts(relative_path)
    root_fd = _open_input_root(root)
    parent_fd = root_fd
    file_fd: int | None = None
    try:
        directory_flags = os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW | getattr(os, "O_CLOEXEC", 0)
        for component in parts[:-1]:
            child = os.open(component, directory_flags, dir_fd=parent_fd)
            if not stat.S_ISDIR(os.fstat(child).st_mode):
                os.close(child)
                raise PackageError(f"unsafe source input parent is not a directory: {relative_path!r}")
            if parent_fd != root_fd:
                os.close(parent_fd)
            parent_fd = child
        flags = os.O_RDONLY | os.O_NOFOLLOW | getattr(os, "O_CLOEXEC", 0) | getattr(os, "O_NONBLOCK", 0)
        file_fd = os.open(parts[-1], flags, dir_fd=parent_fd)
        before = os.fstat(file_fd)
        if not stat.S_ISREG(before.st_mode) or before.st_nlink != 1:
            raise PackageError(f"unsafe source input (expected single-link regular file): {relative_path!r}")
        if before.st_size < 0 or before.st_size > MAX_INPUT_BYTES:
            raise PackageError(f"source input exceeds {MAX_INPUT_BYTES} bytes: {relative_path!r}")
        chunks: list[bytes] = []
        remaining = MAX_INPUT_BYTES + 1
        while remaining:
            chunk = os.read(file_fd, min(65536, remaining))
            if not chunk:
                break
            chunks.append(chunk)
            remaining -= len(chunk)
        data = b"".join(chunks)
        after = os.fstat(file_fd)
        if (
            len(data) > MAX_INPUT_BYTES
            or (before.st_dev, before.st_ino, before.st_size, before.st_mtime_ns, before.st_ctime_ns)
            != (after.st_dev, after.st_ino, after.st_size, after.st_mtime_ns, after.st_ctime_ns)
            or len(data) != after.st_size
            or after.st_nlink != 1
        ):
            raise PackageError(f"source input changed while being read: {relative_path!r}")
        return data
    except PackageError:
        raise
    except OSError as exc:
        raise PackageError(f"unsafe or unreadable source input {relative_path!r} (no symlink following): {exc.strerror or exc}") from None
    finally:
        if file_fd is not None:
            os.close(file_fd)
        if parent_fd != root_fd:
            os.close(parent_fd)
        os.close(root_fd)


def _decode_input(data: bytes, relative_path: str) -> str:
    try:
        return data.decode("utf-8")
    except UnicodeDecodeError as exc:
        raise PackageError(f"source input is not valid UTF-8: {relative_path!r}: {exc}") from None


def _read_support_files(repository_root: str | os.PathLike[str]) -> dict[str, bytes]:
    docs: dict[str, bytes] = {}
    for name in sorted(AUXILIARY_FILES):
        relative = f"{INTEGRATION_RELATIVE}/{name}"
        content = _read_rooted_input(repository_root, relative)
        text = _decode_input(content, relative)
        if SECRET_VALUE.search(text) or PRIVATE_PATH.search(text):
            raise PackageError(f"support document contains credential-like text or a private host path: {name}")
        docs[name] = content
    return docs


def _validate_canonical_sources(catalog: dict, repository_root: str | os.PathLike[str]) -> None:
    refs = {ref for agent in catalog["agents"] for ref in agent["source_refs"]}
    for ref in sorted(refs):
        if ref not in CANONICAL_SOURCE_ALLOWLIST:
            raise PackageError(f"source reference is not in the canonical allowlist: {ref!r}")
        content = _read_rooted_input(repository_root, ref)
        if not _decode_input(content, ref).strip():
            raise PackageError(f"canonical source input is empty: {ref!r}")


def build_package(
    catalog: object,
    template: str,
    repository_root: str | os.PathLike[str] | None = None,
) -> dict[str, bytes]:
    checked = validate_catalog(catalog)
    if not isinstance(template, str) or not template:
        raise PackageError("agent template must be non-empty text")
    source_root = REPO_ROOT if repository_root is None else repository_root
    _validate_canonical_sources(checked, source_root)
    support_files = _read_support_files(source_root)
    files: dict[str, bytes] = {
        "COMPANY.md": _company_markdown(checked).encode("utf-8"),
        ".paperclip.yaml": (json.dumps(build_manifest(checked), ensure_ascii=False, indent=2, sort_keys=True) + "\n").encode("utf-8"),
        **support_files,
    }
    for agent in checked["agents"]:
        path = f"agents/{agent['slug']}/AGENTS.md"
        files[path] = render_agent(template, agent).encode("utf-8")
    validate_package_files(files)
    return files


def validate_package_files(files: dict[str, bytes]) -> None:
    expected = {"COMPANY.md", ".paperclip.yaml", *AUXILIARY_FILES} | {
        f"agents/{slug}/AGENTS.md" for slug in EXPECTED_SLUGS
    }
    if set(files) != expected:
        raise PackageError("package paths differ from the fixed company, manifest, 17-agent, and support-file contract")
    seen: set[str] = set()
    for name, content in files.items():
        posix = PurePosixPath(name)
        if (
            not isinstance(name, str)
            or not name
            or "\\" in name
            or posix.is_absolute()
            or ".." in posix.parts
            or name != posix.as_posix()
            or name in seen
        ):
            raise PackageError(f"unsafe or duplicate package path: {name!r}")
        if not isinstance(content, bytes):
            raise PackageError(f"package content must be bytes: {name}")
        text = _decode_input(content, name)
        if PRIVATE_PATH.search(text):
            raise PackageError(f"package file contains a private host path: {name}")
        if SECRET_VALUE.search(text):
            raise PackageError(f"package file contains credential-like text: {name}")
        seen.add(name)
    try:
        manifest = json.loads(files[".paperclip.yaml"].decode("utf-8"))
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise PackageError(f"generated .paperclip.yaml is not valid JSON/YAML text: {exc}") from exc
    if set(manifest) != {"schemaVersion", "agents"}:
        raise PackageError("generated manifest contains unsupported or missing top-level fields")
    if manifest["schemaVersion"] != PAPERCLIP_BUNDLE_SCHEMA_VERSION:
        raise PackageError("generated manifest schemaVersion does not match pinned schema 7")
    agents = manifest["agents"]
    if not isinstance(agents, dict) or set(agents) != EXPECTED_SLUGS:
        raise PackageError("generated manifest agent IDs differ from the fixed roster")
    for slug, config in agents.items():
        if not isinstance(config, dict) or set(config) != {"role", "adapter", "runtime", "permissions", "permissionGrants"}:
            raise PackageError(f"manifest has unsupported fields for agent {slug}")
        adapter = config["adapter"]
        if not isinstance(adapter, dict) or set(adapter) != {"type", "config"} or adapter["type"] != "pi_local":
            raise PackageError(f"manifest adapter fields are unsupported for agent {slug}")
        adapter_config = adapter["config"]
        if not isinstance(adapter_config, dict) or set(adapter_config) != {"model", "thinking"}:
            raise PackageError(f"manifest adapter config fields are unsupported for agent {slug}")
        runtime = config["runtime"]
        if not isinstance(runtime, dict) or set(runtime) != {"heartbeat"}:
            raise PackageError(f"manifest runtime fields are unsupported for agent {slug}")
        heartbeat = runtime["heartbeat"]
        if not isinstance(heartbeat, dict) or set(heartbeat) != {"enabled"} or heartbeat["enabled"] is not False:
            raise PackageError(f"manifest heartbeat fields are unsupported for agent {slug}")
        if config["permissions"] != {} or config["permissionGrants"] != []:
            raise PackageError(f"manifest permission declarations differ from the approved empty baseline for {slug}")
    if not files["COMPANY.md"].startswith(b"---\nname: ACON Agent Organization\nslug: acon-agent-organization\n---\n"):
        raise PackageError("COMPANY.md frontmatter does not match the required importer contract")


def _parent_directory_fd(raw_path: str) -> tuple[int, str]:
    if not isinstance(raw_path, str) or not raw_path.startswith("/") or "\x00" in raw_path:
        raise PackageError("output path must be an absolute path")
    if "//" in raw_path or raw_path.endswith("/") or ".." in raw_path.split("/"):
        raise PackageError("output path contains a non-canonical or traversal component")
    components = raw_path.split("/")[1:]
    if not components or any(part in ("", ".", "..") for part in components):
        raise PackageError("output path must name a file beneath an existing directory")
    name = components[-1]
    directory_flags = os.O_RDONLY | getattr(os, "O_DIRECTORY", 0) | getattr(os, "O_CLOEXEC", 0) | getattr(os, "O_NOFOLLOW", 0)
    required_dir_fd = (os.open, os.stat, os.link, os.unlink)
    if (
        not hasattr(os, "O_NOFOLLOW")
        or not hasattr(os, "O_DIRECTORY")
        or any(operation not in os.supports_dir_fd for operation in required_dir_fd)
        or os.link not in os.supports_follow_symlinks
    ):
        raise PackageError("host lacks no-follow, directory-relative exclusive file creation; refusing ZIP output")
    fd = os.open("/", directory_flags)
    try:
        for component in components[:-1]:
            child = os.open(component, directory_flags, dir_fd=fd)
            info = os.fstat(child)
            if not stat.S_ISDIR(info.st_mode):
                os.close(child)
                raise PackageError(f"output ancestor is not a directory: {component}")
            os.close(fd)
            fd = child
        return fd, name
    except BaseException:
        os.close(fd)
        raise


def write_zip(files: dict[str, bytes], output_path: str | os.PathLike[str]) -> str:
    validate_package_files(files)
    raw_path = os.fspath(output_path)
    if not isinstance(raw_path, str):
        raise PackageError("output path must be text")
    parent_fd, name = _parent_directory_fd(raw_path)
    temp_name = f".paperclip-acon-{uuid.uuid4().hex}.tmp"
    temp_fd: int | None = None
    temp_identity: tuple[int, int] | None = None
    installed_final = False
    try:
        try:
            os.stat(name, dir_fd=parent_fd, follow_symlinks=False)
        except FileNotFoundError:
            pass
        else:
            raise FileExistsError(f"refusing to overwrite existing output: {raw_path}")

        flags = os.O_RDWR | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW | getattr(os, "O_CLOEXEC", 0)
        temp_fd = os.open(temp_name, flags, 0o600, dir_fd=parent_fd)
        temp_stat = os.fstat(temp_fd)
        if not stat.S_ISREG(temp_stat.st_mode) or temp_stat.st_nlink != 1:
            raise PackageError("exclusive temporary output is not a single-link regular file")
        temp_identity = (temp_stat.st_dev, temp_stat.st_ino)
        with os.fdopen(temp_fd, "w+b") as stream:
            temp_fd = None
            with zipfile.ZipFile(stream, mode="w", compression=zipfile.ZIP_STORED, allowZip64=False) as archive:
                for entry_name in sorted(files):
                    info = zipfile.ZipInfo(entry_name, date_time=(1980, 1, 1, 0, 0, 0))
                    info.compress_type = zipfile.ZIP_STORED
                    info.create_system = 3
                    info.external_attr = (stat.S_IFREG | 0o644) << 16
                    info.flag_bits = 0
                    archive.writestr(info, files[entry_name], compress_type=zipfile.ZIP_STORED)
            stream.flush()
            os.fsync(stream.fileno())
            final_stat = os.fstat(stream.fileno())
            if not stat.S_ISREG(final_stat.st_mode) or final_stat.st_nlink != 1:
                raise PackageError("temporary ZIP changed identity or link count during write")
        try:
            os.link(temp_name, name, src_dir_fd=parent_fd, dst_dir_fd=parent_fd, follow_symlinks=False)
            installed_final = True
        except FileExistsError as exc:
            raise FileExistsError(f"refusing to overwrite existing output: {raw_path}") from exc
        installed = os.stat(name, dir_fd=parent_fd, follow_symlinks=False)
        temp_link = os.stat(temp_name, dir_fd=parent_fd, follow_symlinks=False)
        if (
            temp_identity != (installed.st_dev, installed.st_ino)
            or temp_identity != (temp_link.st_dev, temp_link.st_ino)
            or not stat.S_ISREG(installed.st_mode)
            or installed.st_nlink != 2
            or temp_link.st_nlink != 2
        ):
            raise PackageError("installed ZIP identity/link count did not match the exclusively created file")
        os.unlink(temp_name, dir_fd=parent_fd)
        installed = os.stat(name, dir_fd=parent_fd, follow_symlinks=False)
        if temp_identity != (installed.st_dev, installed.st_ino) or installed.st_nlink != 1:
            raise PackageError("final ZIP is not a single-link regular file")
        os.fsync(parent_fd)
        installed_final = False
        return hashlib.sha256(files_to_zip_bytes(files)).hexdigest()
    except BaseException:
        if temp_fd is not None:
            os.close(temp_fd)
        if installed_final and temp_identity is not None:
            try:
                current_final = os.stat(name, dir_fd=parent_fd, follow_symlinks=False)
                if (current_final.st_dev, current_final.st_ino) == temp_identity:
                    os.unlink(name, dir_fd=parent_fd)
            except FileNotFoundError:
                pass
        if temp_identity is not None:
            try:
                current = os.stat(temp_name, dir_fd=parent_fd, follow_symlinks=False)
                if (current.st_dev, current.st_ino) == temp_identity:
                    os.unlink(temp_name, dir_fd=parent_fd)
            except FileNotFoundError:
                pass
        raise
    finally:
        os.close(parent_fd)


def files_to_zip_bytes(files: dict[str, bytes]) -> bytes:
    """Return the deterministic archive bytes used for the emitted SHA-256."""
    import io

    buffer = io.BytesIO()
    with zipfile.ZipFile(buffer, mode="w", compression=zipfile.ZIP_STORED, allowZip64=False) as archive:
        for entry_name in sorted(files):
            info = zipfile.ZipInfo(entry_name, date_time=(1980, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_STORED
            info.create_system = 3
            info.external_attr = (stat.S_IFREG | 0o644) << 16
            info.flag_bits = 0
            archive.writestr(info, files[entry_name], compress_type=zipfile.ZIP_STORED)
    return buffer.getvalue()


def load_package_files(repository_root: str | os.PathLike[str] | None = None) -> dict[str, bytes]:
    source_root = REPO_ROOT if repository_root is None else repository_root
    catalog_relative = f"{INTEGRATION_RELATIVE}/catalog/agents.json"
    template_relative = f"{INTEGRATION_RELATIVE}/templates/agent.md.tmpl"
    try:
        catalog_text = _decode_input(_read_rooted_input(source_root, catalog_relative), catalog_relative)
        template = _decode_input(_read_rooted_input(source_root, template_relative), template_relative)
        catalog = json.loads(catalog_text)
    except json.JSONDecodeError as exc:
        raise PackageError(f"catalog is not valid JSON: {exc}") from None
    return build_package(catalog, template, source_root)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Build the ACON Paperclip schema-7 organization ZIP.")
    parser.add_argument("--output", required=True, help=f"must be exactly {FINAL_OUTPUT}")
    args = parser.parse_args(argv)
    if args.output != str(FINAL_OUTPUT):
        parser.error(f"output is fixed to the Captain-approved destination: {FINAL_OUTPUT}")
    try:
        files = load_package_files()
        sha256 = write_zip(files, args.output)
    except (OSError, PackageError, zipfile.LargeZipFile) as exc:
        print(f"generate.py: error: {exc}", file=sys.stderr)
        return 1
    print(f"Wrote {args.output} ({len(files)} entries; SHA-256 {sha256})")
    print("ZIP generation does not import, pause, activate, or validate effective permissions.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

import copy
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
import unittest
import zipfile
from unittest import mock
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
import generate

CATALOG = json.loads((ROOT / "catalog" / "agents.json").read_text(encoding="utf-8"))
TEMPLATE = (ROOT / "templates" / "agent.md.tmpl").read_text(encoding="utf-8")
EXPECTED = {"orchestrator", "scout", "researcher", "oracle", "worker", "ship", "code-reviewer", "reviewer", "security-reviewer", "gitops", "frontend-engineer", "backend-engineer", "database-engineer", "ui-ux-designer", "qa-engineer", "performance-engineer", "devops-engineer"}
REPO = ROOT.parents[1]


def _copy_input_fixture(destination):
    source_paths = {
        f"integrations/paperclip/{name}"
        for name in ("catalog/agents.json", "templates/agent.md.tmpl", "README.md", "TEAM.md", "VALIDATION.md", "LICENSE.md")
    }
    source_paths.update(ref for agent in CATALOG["agents"] for ref in agent["source_refs"])
    for relative in source_paths:
        source = REPO / relative
        target = destination / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, target)


class GeneratorTests(unittest.TestCase):
    def setUp(self):
        self.files = generate.build_package(CATALOG, TEMPLATE)

    def test_input_catalog_leaf_and_parent_symlinks_are_refused_without_leaking_or_mutating_sentinel(self):
        for symlink_parent in (False, True):
            with self.subTest(symlink_parent=symlink_parent), tempfile.TemporaryDirectory() as tmp:
                base = Path(tmp)
                root = base / "repo"
                _copy_input_fixture(root)
                integration = root / "integrations" / "paperclip"
                sentinel = base / "foreign-catalog.json"
                private = copy.deepcopy(CATALOG)
                private["agents"][1]["role_fields"]["responsibility"] = "PRIVATE_SENTINEL_MUST_NOT_ENTER_ZIP"
                sentinel.write_text(json.dumps(private), encoding="utf-8")
                original_sentinel = sentinel.read_bytes()
                template_path = integration / "templates" / "agent.md.tmpl"
                catalog_path = integration / "catalog" / "agents.json"
                if symlink_parent:
                    outside_catalog = base / "outside-catalog"
                    outside_catalog.mkdir()
                    shutil.copyfile(sentinel, outside_catalog / "agents.json")
                    catalog_path.unlink()
                    catalog_path.parent.rmdir()
                    catalog_path.parent.symlink_to(outside_catalog, target_is_directory=True)
                else:
                    catalog_path.unlink()
                    catalog_path.symlink_to(sentinel)

                with mock.patch.object(generate, "REPO_ROOT", root, create=True), mock.patch.object(generate, "CATALOG_PATH", catalog_path, create=True), mock.patch.object(generate, "TEMPLATE_PATH", template_path, create=True):
                    try:
                        files = generate.load_package_files()
                    except generate.PackageError as exc:
                        self.assertRegex(str(exc), "symlink|unsafe|no-follow")
                    else:
                        self.assertNotIn(b"PRIVATE_SENTINEL_MUST_NOT_ENTER_ZIP", b"".join(files.values()))
                self.assertEqual(sentinel.read_bytes(), original_sentinel)

    def test_support_and_canonical_source_symlink_leaves_are_refused_without_reading_sentinel(self):
        input_paths = {
            f"integrations/paperclip/{name}" for name in generate.AUXILIARY_FILES
        } | {
            "integrations/paperclip/templates/agent.md.tmpl",
            *generate.CANONICAL_SOURCE_ALLOWLIST,
        }
        for relative in sorted(input_paths):
            with self.subTest(input=relative), tempfile.TemporaryDirectory() as tmp:
                base = Path(tmp)
                root = base / "repo"
                _copy_input_fixture(root)
                target = root / relative
                target.unlink()
                sentinel = base / "controlled-sentinel.txt"
                sentinel.write_text("PRIVATE_SENTINEL_NOT_PACKAGE_INPUT", encoding="utf-8")
                sentinel_bytes = sentinel.read_bytes()
                target.symlink_to(sentinel)
                with mock.patch.object(generate, "REPO_ROOT", root, create=True):
                    with self.assertRaisesRegex(generate.PackageError, "unsafe|symlink|no-follow"):
                        generate.load_package_files()
                self.assertEqual(sentinel.read_bytes(), sentinel_bytes)

    def test_template_and_canonical_parent_symlinks_are_refused(self):
        for relative_parent in ("integrations/paperclip/templates", ".agents/reference/crew"):
            with self.subTest(parent=relative_parent), tempfile.TemporaryDirectory() as tmp:
                base = Path(tmp)
                root = base / "repo"
                _copy_input_fixture(root)
                parent = root / relative_parent
                parked = base / "parked-inputs"
                parent.rename(parked)
                outside = base / "outside-inputs"
                outside.mkdir()
                for source in parked.iterdir():
                    if source.is_file():
                        shutil.copyfile(source, outside / source.name)
                parent.symlink_to(outside, target_is_directory=True)
                with mock.patch.object(generate, "REPO_ROOT", root, create=True):
                    with self.assertRaisesRegex(generate.PackageError, "unsafe|symlink|no-follow"):
                        generate.load_package_files()

    def test_manifest_and_files_match_captured_paperclip_contract(self):
        self.assertEqual(set(self.files), {"COMPANY.md", ".paperclip.yaml", *generate.AUXILIARY_FILES} | {f"agents/{slug}/AGENTS.md" for slug in EXPECTED})
        manifest = json.loads(self.files[".paperclip.yaml"])
        self.assertEqual(set(manifest), {"schemaVersion", "agents"})
        self.assertEqual(manifest["schemaVersion"], 7)
        self.assertEqual(set(manifest["agents"]), EXPECTED)
        for slug, agent in manifest["agents"].items():
            with self.subTest(agent=slug):
                self.assertEqual(set(agent), {"role", "adapter", "runtime", "permissions", "permissionGrants"})
                self.assertEqual(agent["adapter"], {"type": "pi_local", "config": {"model": "openai-codex/gpt-6-luna", "thinking": "high"}})
                self.assertEqual(agent["runtime"], {"heartbeat": {"enabled": False}})
                self.assertEqual(agent["permissions"], {})
                self.assertEqual(agent["permissionGrants"], [])
                self.assertNotIn("status", agent)
        company = self.files["COMPANY.md"].decode("utf-8")
        self.assertTrue(company.startswith("---\nname: ACON Agent Organization\nslug: acon-agent-organization\n---\n"))
        self.assertIn("| `orchestrator` |", company)
        self.assertIn("Copyright (c) 2025 Addy Osmani", company)
        self.assertIn("pauseAutomations: true", company)
        self.assertNotIn("/home/", company)

    def test_support_documents_and_license_are_bundled_without_manifest_extensions(self):
        for name in generate.AUXILIARY_FILES:
            with self.subTest(document=name):
                self.assertEqual(self.files[name], (ROOT / name).read_bytes())
                text = self.files[name].decode("utf-8")
                self.assertNotIn("/home/", text)
                self.assertNotIn("/tmp/", text)
                self.assertNotRegex(text, generate.SECRET_VALUE)
        self.assertIn(b"MIT License", self.files["LICENSE.md"])
        self.assertIn(b"Copyright (c) 2025 Addy Osmani", self.files["LICENSE.md"])
        manifest = json.loads(self.files[".paperclip.yaml"])
        self.assertEqual(set(manifest), {"schemaVersion", "agents"})

    def test_manifest_unknown_fields_private_docs_and_unsafe_archive_names_are_rejected(self):
        bad_manifest = dict(self.files)
        manifest = json.loads(bad_manifest[".paperclip.yaml"])
        manifest["paused"] = True
        bad_manifest[".paperclip.yaml"] = json.dumps(manifest).encode("utf-8")
        with self.assertRaisesRegex(generate.PackageError, "unsupported or missing top-level fields"):
            generate.validate_package_files(bad_manifest)

        bad_docs = dict(self.files)
        bad_docs["README.md"] = bad_docs["README.md"] + b"\\nLocal path: /tmp/private-fixture"
        with self.assertRaisesRegex(generate.PackageError, "private host path"):
            generate.validate_package_files(bad_docs)

        bad_agent = dict(self.files)
        bad_agent["agents/scout/AGENTS.md"] += b"\\nLocal path: /home/private-fixture"
        with self.assertRaisesRegex(generate.PackageError, "private host path"):
            generate.validate_package_files(bad_agent)

        bad_path = dict(self.files)
        bad_path["../escape"] = b"controlled fixture"
        with self.assertRaisesRegex(generate.PackageError, "package paths differ"):
            generate.validate_package_files(bad_path)

    def test_hardlinked_support_input_is_refused_and_sentinel_is_preserved(self):
        with tempfile.TemporaryDirectory() as tmp:
            base = Path(tmp)
            root = base / "repo"
            _copy_input_fixture(root)
            target = root / "integrations/paperclip/README.md"
            sentinel = base / "controlled-sentinel.md"
            sentinel.write_text("PRIVATE_SENTINEL_NOT_PACKAGE_INPUT", encoding="utf-8")
            before = sentinel.read_bytes()
            target.unlink()
            os.link(sentinel, target)
            with mock.patch.object(generate, "REPO_ROOT", root, create=True):
                with self.assertRaisesRegex(generate.PackageError, "single-link regular file"):
                    generate.load_package_files()
            self.assertEqual(sentinel.read_bytes(), before)

    def test_all_17_agent_files_are_self_contained_and_flat(self):
        expected_sections = (
            "Identity", "Responsibility", "Authority", "Task types", "Prohibitions",
            "Project scope", "Communications", "Reports to", "Workflow",
            "Definition of done", "Escalation", "Required output",
        )
        for slug in EXPECTED:
            with self.subTest(agent=slug):
                body = self.files[f"agents/{slug}/AGENTS.md"].decode("utf-8")
                self.assertTrue(body.startswith("---\nname: "))
                self.assertIn(f"slug: {slug}\n", body)
                report_value = "null" if slug == "orchestrator" else "orchestrator"
                self.assertIn(f"reportsTo: {report_value}\n", body)
                for section in expected_sections:
                    self.assertEqual(body.count(f"## {section}"), 1)
                self.assertNotIn("{{", body)
                self.assertNotIn("/home/", body)
    def test_store_zip_is_deterministic_hashable_and_classic(self):
        with tempfile.TemporaryDirectory() as tmp:
            one, two = Path(tmp) / "one.zip", Path(tmp) / "two.zip"
            digest_one = generate.write_zip(self.files, one)
            digest_two = generate.write_zip(self.files, two)
            bytes_one, bytes_two = one.read_bytes(), two.read_bytes()
            self.assertEqual(bytes_one, bytes_two)
            self.assertNotIn(b"PK\\x06\\x06", bytes_one)  # Zip64 EOCD
            self.assertNotIn(b"PK\\x06\\x07", bytes_one)  # Zip64 locator
            self.assertEqual(digest_one, hashlib.sha256(bytes_one).hexdigest())
            self.assertEqual(digest_one, digest_two)
            self.assertEqual(one.stat().st_nlink, 1)
            self.assertEqual(two.stat().st_nlink, 1)
            with zipfile.ZipFile(one) as archive:
                names = archive.namelist()
                self.assertEqual(names, sorted(names))
                self.assertEqual(len(names), len(set(names)))
                self.assertIsNone(archive.testzip())
                self.assertEqual(set(names), set(self.files))
                for info in archive.infolist():
                    self.assertEqual(info.compress_type, zipfile.ZIP_STORED)
                    self.assertEqual(info.date_time, (1980, 1, 1, 0, 0, 0))
                    self.assertEqual((info.external_attr >> 16) & 0o777, 0o644)
                    self.assertEqual(info.flag_bits & 0x08, 0)
                    self.assertLess(info.file_size, 0xFFFFFFFF)

    def test_duplicate_slug_path_traversal_cycle_malformed_and_unknown_fields_fail_closed(self):
        bad = copy.deepcopy(CATALOG)
        bad["agents"][1]["slug"] = bad["agents"][2]["slug"]
        with self.assertRaisesRegex(generate.PackageError, "duplicate agent slug"):
            generate.build_package(bad, TEMPLATE)

        bad = copy.deepcopy(CATALOG)
        bad["agents"][1]["slug"] = "../outside"
        with self.assertRaises(generate.PackageError):
            generate.build_package(bad, TEMPLATE)

        bad = copy.deepcopy(CATALOG)
        bad["agents"][0]["reports_to"] = "scout"
        with self.assertRaisesRegex(generate.PackageError, "cycle"):
            generate.build_package(bad, TEMPLATE)

        bad = copy.deepcopy(CATALOG)
        del bad["agents"][1]["role_fields"]["authority"]
        with self.assertRaisesRegex(generate.PackageError, "keys mismatch"):
            generate.build_package(bad, TEMPLATE)

        bad = copy.deepcopy(CATALOG)
        bad["agents"][1]["source_refs"] = [".agents/private/notes.md"]
        with self.assertRaisesRegex(generate.PackageError, "canonical allowlist"):
            generate.build_package(bad, TEMPLATE)

        bad = copy.deepcopy(CATALOG)
        bad["agents"][1]["apiKey"] = "not-accepted"
        with self.assertRaisesRegex(generate.PackageError, "keys mismatch"):
            generate.build_package(bad, TEMPLATE)

        bad = copy.deepcopy(CATALOG)
        bad["agents"][1]["role_fields"]["responsibility"] = "api_key='sk-123456789012345678901234'"
        with self.assertRaisesRegex(generate.PackageError, "resembles a credential"):
            generate.build_package(bad, TEMPLATE)

        with self.assertRaisesRegex(generate.PackageError, "unresolved template placeholder"):
            generate.render_agent(TEMPLATE + "\n{{unknown_field}}", CATALOG["agents"][1])

    def test_existing_symlink_hardlink_and_traversal_outputs_are_refused(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            existing = root / "existing.zip"
            existing.write_bytes(b"retain-existing")
            with self.assertRaises(FileExistsError):
                generate.write_zip(self.files, existing)
            self.assertEqual(existing.read_bytes(), b"retain-existing")

            hardlink = root / "hardlink.zip"
            os.link(existing, hardlink)
            with self.assertRaises(FileExistsError):
                generate.write_zip(self.files, hardlink)
            self.assertEqual(existing.read_bytes(), hardlink.read_bytes())

            symlink = root / "linked.zip"
            symlink.symlink_to(existing)
            with self.assertRaises(FileExistsError):
                generate.write_zip(self.files, symlink)
            self.assertEqual(existing.read_bytes(), b"retain-existing")

            real_parent = root / "real"
            real_parent.mkdir()
            linked_parent = root / "linked-parent"
            linked_parent.symlink_to(real_parent, target_is_directory=True)
            with self.assertRaises((OSError, generate.PackageError)):
                generate.write_zip(self.files, linked_parent / "never.zip")
            self.assertFalse((real_parent / "never.zip").exists())

            with self.assertRaisesRegex(generate.PackageError, "traversal"):
                generate.write_zip(self.files, str(root / ".." / "escape.zip"))

    def test_cli_requires_the_exact_approved_destination_and_has_clean_errors(self):
        script = ROOT / "generate.py"
        help_result = subprocess.run([sys.executable, str(script), "--help"], capture_output=True, text=True)
        self.assertEqual(help_result.returncode, 0)
        self.assertIn("--output", help_result.stdout)
        missing = subprocess.run([sys.executable, str(script)], capture_output=True, text=True)
        self.assertEqual(missing.returncode, 2)
        self.assertIn("--output", missing.stderr)
        wrong = subprocess.run([sys.executable, str(script), "--output", "/tmp/not-approved.zip"], capture_output=True, text=True)
        self.assertEqual(wrong.returncode, 2)
        self.assertIn("Captain-approved destination", wrong.stderr)
        self.assertFalse(Path("/tmp/not-approved.zip").exists())


if __name__ == "__main__":
    unittest.main()

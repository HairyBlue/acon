import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parents[1]
CATALOG = ROOT / "catalog" / "agents.json"
TEMPLATE = ROOT / "templates" / "agent.md.tmpl"

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


class CatalogContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.catalog = json.loads(CATALOG.read_text(encoding="utf-8"))
        cls.template = TEMPLATE.read_text(encoding="utf-8")
        cls.agents = cls.catalog["agents"]

    def test_exact_roster_counts_ids_and_reporting(self):
        self.assertEqual(self.catalog["schema_version"], 1)
        self.assertEqual(len(self.agents), 17)
        self.assertEqual({a["slug"] for a in self.agents}, EXPECTED_SLUGS)
        self.assertEqual(len({a["slug"] for a in self.agents}), 17)
        self.assertEqual(len({a["name"] for a in self.agents}), 17)
        self.assertEqual(
            {group: sum(a["group"] == group for a in self.agents) for group in EXPECTED_GROUPS},
            EXPECTED_GROUPS,
        )
        roots = [a for a in self.agents if a["reports_to"] is None]
        self.assertEqual([a["slug"] for a in roots], ["orchestrator"])
        self.assertTrue(all(a["reports_to"] == "orchestrator" for a in self.agents if a["slug"] != "orchestrator"))

    def test_every_role_maps_to_an_existing_canonical_source(self):
        for agent in self.agents:
            with self.subTest(agent=agent["slug"]):
                self.assertTrue(agent["source_refs"], agent["slug"])
                for source in agent["source_refs"]:
                    self.assertFalse(Path(source).is_absolute())
                    self.assertTrue((REPO / source).is_file(), source)
        by_slug = {a["slug"]: a["source_refs"] for a in self.agents}
        self.assertIn("AGENTS.md", by_slug["orchestrator"])
        for slug in ("scout", "researcher", "oracle", "worker", "ship", "code-reviewer", "reviewer", "security-reviewer", "gitops"):
            self.assertTrue(any(ref.startswith(".agents/reference/crew/") for ref in by_slug[slug]), slug)
        for slug in EXPECTED_SLUGS - {"orchestrator", "scout", "researcher", "oracle", "worker", "ship", "code-reviewer", "reviewer", "security-reviewer", "gitops"}:
            self.assertTrue(any(ref.startswith(".agents/skills/") for ref in by_slug[slug]), slug)

    def test_all_twelve_role_fields_are_present_and_templated(self):
        for agent in self.agents:
            with self.subTest(agent=agent["slug"]):
                self.assertEqual(set(agent["role_fields"]), ROLE_FIELDS)
                self.assertTrue(all(isinstance(v, str) and v.strip() for v in agent["role_fields"].values()))
        for key in ROLE_FIELDS:
            self.assertIn("{{" + key + "}}", self.template)
        headings = [
            "Identity", "Responsibility", "Authority", "Task types", "Prohibitions",
            "Project scope", "Communications", "Reports to", "Workflow",
            "Definition of done", "Escalation", "Required output",
        ]
        for heading in headings:
            self.assertEqual(self.template.count(f"## {heading}"), 1, heading)

    def test_template_contains_registered_team_and_non_orchestration_boundaries(self):
        required = (
            "registered team only",
            "authoritative current Paperclip records",
            "Do not auto-hire",
            "Do not modify another team",
            "Do not create nested orchestration",
            "name or slug alone is not identity or ownership proof",
            "project/workspace selection is not a security boundary",
            "Captain approval",
        )
        for phrase in required:
            self.assertIn(phrase.casefold(), self.template.casefold())
        self.assertIn("{{reports_to}}", self.template)


if __name__ == "__main__":
    unittest.main()

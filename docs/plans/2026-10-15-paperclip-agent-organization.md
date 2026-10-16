# Implementation Plan: Paperclip ACON Agent Organization

- **Plan File:** `docs/plans/2026-10-15-paperclip-agent-organization.md`
- **Author:** Bounded planning worker
- **Date:** 2026-10-15
- **Status:** Implementation complete; corrected final ZIP built; targeted final G8/G9 reviews APPROVE; live import/runtime validation not performed
- **Source target:** the bounded Paperclip integration paths recorded in the closure below; approved final ZIP is an external artifact
- **Planning evidence:** `/tmp/acon-paperclip-research-JiBVlC/researchreport.md` and `/tmp/acon-paperclip-research-JiBVlC/sources/index.json`

## Implementation closure (2026-10-15)

The bounded implementation and final documentation correction are complete. This closure records actual outputs and supersedes preimplementation sketches below wherever they differ; source/release research history and unverified runtime limits remain intact.

### Actual source files

- `integrations/paperclip/catalog/agents.json`
- `integrations/paperclip/templates/agent.md.tmpl`
- `integrations/paperclip/generate.py`
- `integrations/paperclip/tests/test_catalog.py`
- `integrations/paperclip/tests/test_generate.py`
- `integrations/paperclip/README.md`, `TEAM.md`, `VALIDATION.md`, and `LICENSE.md`

The 17 standalone rendered `agents/<slug>/AGENTS.md` files are ZIP entries, not additional repository source files. No root `AGENTS.md` is required in the ZIP. The original four-section template sketch below was superseded: each rendered agent has exactly these 12 headings, as checked by the artifact verifier: Identity, Responsibility, Authority, Task types, Prohibitions, Project scope, Communications, Reports to, Workflow, Definition of done, Escalation, and Required output.

### Actual package and verification

- Final ZIP: `/home/mewho/ai-stuff/paperclip-acon-team.zip`; 127,216 bytes; 23 entries (19 core plus four support documents); 17 agents; SHA-256 `568713d00eface0ec619f19b9f35aa7b48043b8be86b917e5963b070b6bf3d37`.
- The ZIP carries the pinned Paperclip `master` schema-7 contract and the configured `pi_local` model `openai-codex/gpt-6-luna` with `thinking: high`. This is configuration/source evidence only, not a Paperclip adapter run.
- Integration suite: 16 tests, exit 0. `GIT_OPTIONAL_LOCKS=0 bash tests/adopt-acon-session-ledger.sh`: exit 0. Two complete temporary builds after the final documentation correction were byte-identical. The captured Paperclip ZIP reader accepted the final archive: exit 0, 23 entries/schema 7/17 agents. The final two-document correction was checked with targeted doc assertions and archive comparison; the full integration suite was not rerun for that correction, per reviewer direction.
- No Paperclip full parser/import, live company, model request, or runtime/workspace/session validation was performed. Targeted final G8 and fresh G9 reviews of the corrected two documents and replacement artifact both returned **APPROVE** (G8 `01a137be-ced2-7216-b16f-f386ccfe3aba`, 2026-10-15 10:13:12.633Z; G9 `f6e0369a-33e8-43d9-ac2f-32c6eba0d7e0`, 2026-10-15 10:12:53.238Z). Writer `1f87a9a0-5aab-484c-9ca3-339e17bcdf58` and both read-only reviewers used the same Luna High selection; record `CORRELATED_REVIEW`, not model-independent review. No full-code or live-import approval is implied.
- The initial final ZIP and intermediate documentation-correction ZIP are preserved as read-only evidence. The current archive differs from the initial one only in `README.md` and `VALIDATION.md` entries.

### Pause and ownership status

The ZIP does not set an imported status and does not keep agents paused by itself. The captured new-organization UI initializes **Start imported agents and routines paused** checked and sends `pauseAutomations: true` when checked. Before any separately authorized import, use the new-company UI flow, explicitly verify that request option, then inspect actual status, automation state, identity/membership, ownership, and effective grants. Heartbeat disabled and empty declared grants do not prove paused status or zero effective permissions.

## 1. Context and objective

Create a portable, project-agnostic ACON organization package for Paperclip, with a deterministic Python-stdlib generator, catalog/templates, documentation, automated structural tests, and a Paperclip-readable ZIP. Preserve the requested 17 permanent agents: one orchestrator, nine ACON crew roles, and seven dedicated domain specialists. All 16 non-orchestrator agents report directly to the orchestrator. Worker and Ship remain distinct. This is a documentation/package integration, not a Paperclip adapter, deployment, or runtime enforcement mechanism.

The original plan-review/dispatch gate was completed and implementation authorization was exercised; the implementation and artifact are complete. Targeted corrected-document/artifact G8/G9 reviews both returned APPROVE; their shared model selection is `CORRELATED_REVIEW` as recorded above. Any live import, model activation, or permission grant remains separately gated. Source edits were confined to the assigned `integrations/paperclip/` files and this plan; there were no app CLI, dependency, service/database, Git, or company changes.

## 2. Evidence boundary and current findings

### Verified source facts

- The official latest release captured for this plan is Paperclip **v2026.1012.0**, tag commit `bba6a45f0d364cfd962ac59b3bdf2426a8222adb`; this is distinct from reviewed `master` commit `fd057f6ac4e9148bb4055883ae1d0e7f49242692`.
- Five importer/ZIP/adapter source files were compared at the release tag and reviewed `master`. Both importer revisions declare bundle schema 7, treat unstamped bundles as schema 5, require `COMPANY.md`, and recognize `agents.<slug>.adapter`, `runtime`, `permissions`, and `permissionGrants`. Both ZIP reader copies are byte-identical. Other compared importer/adapter files differ. The original plan proposed targeting the release-tag contract; the completed implementation instead pins the captured `master` revision identified above and makes no arbitrary-release compatibility claim.
- The release importer recognizes `AGENTS.md` files and reads `name`, `slug`, and `reportsTo` frontmatter. Its `.paperclip.yaml` extension reads numeric `schemaVersion` and agent entries. The released Pi-local adapter accepts `adapterConfig.model` as `provider/model`, optional `adapterConfig.thinking`, and passes them to Pi as provider/model/thinking arguments.
- The ZIP does not set imported agent status. Heartbeat disabled is not proof that agents are paused. At the captured UI source, the **Start imported agents and routines paused** checkbox starts checked and forwards `pauseAutomations: true` when selected; verify that request option and resulting status in any separately authorized new-company UI import. Import is not permission-free: the importer applies manifest permission grants and ensures `tasks:assign`; release notes also report default configuration grants for newly created agents.
- Importer/parser/ZIP behavior is source evidence only. No local Paperclip CLI/server, live Pi model listing, disposable company, ZIP import, workspace/session behavior, or runtime permission state has been verified.

### Unresolved blockers / stop conditions

1. **Permission floor:** Empty `permissions` and `permissionGrants` in our package cannot prove that the Paperclip importer/company policy creates no baseline grants. Before claiming “no hidden permission grants” or importing, a separately authorized disposable-company test must inspect resulting effective grants, including `tasks:assign` and defaults. If the target requires literally zero grants, this import route is blocked unless a supported configuration meets it; do not weaken that requirement by wording.
2. **Model selection:** the generated bundle configures `pi_local` with `openai-codex/gpt-6-luna` and `thinking: high`, based on supplied local Pi metadata. This does not confirm a Paperclip adapter run or model request. Before any separately authorized activation, verify the model in the target environment; do not silently substitute or claim agents are paused from ZIP contents.
3. **Import validation:** the completed integration suite and captured official ZIP reader checked package structure/framing; they did not run the full Paperclip parser/importer. No company import occurred. A live import requires separate Captain authorization and a disposable company.
4. **Security boundaries:** Agent prompts and Paperclip project/workspace selection do not prove context isolation, read-only review, permission enforcement, or safe egress. These remain host/runtime validation gates, not documentation claims.

Do not resolve these blockers by importing into a real company, enabling routines, adding projects/tasks/workspaces, probing GitHub hosts, or adding external services.

## 3. Architecture and exact package contract

The completed source implementation is limited to the assigned `integrations/paperclip/` files listed in the closure above. The approved final ZIP is written outside the repository; no `dist/` tree or expanded generated source directory is created.

```text
integrations/paperclip/
  README.md
  TEAM.md
  VALIDATION.md
  LICENSE.md
  catalog/agents.json
  templates/agent.md.tmpl
  generate.py
  tests/test_catalog.py
  tests/test_generate.py
```

The final ZIP contains exactly 23 entries: 19 core entries (`COMPANY.md`, `.paperclip.yaml`, and one `agents/<slug>/AGENTS.md` for each of 17 roles) plus four root support documents (`README.md`, `TEAM.md`, `VALIDATION.md`, `LICENSE.md`). No root repository `AGENTS.md` is required or included. `TEAM.md` and `VALIDATION.md` are ordinary auxiliary files, not assumed Paperclip manifest schemas; no extra manifest fields are added for them.

Do not package repository `.agents/`, `.acon/`, Git metadata, credentials, workspaces, project/task/routine data, generator/test files, or a root `AGENTS.md`. No Paperclip skills, projects, tasks, environment inputs, or workspace setup commands are emitted.

### Roster and flat hierarchy (exact slugs)

| Group | Slug | Responsibility/source mapping |
|---|---|---|
| Coordinator | `orchestrator` | ACON `AGENTS.md` authority; the only root, `reportsTo: null` |
| Core | `scout` | `.agents/reference/crew/scout.md`, read-only codebase archaeology |
| Core | `researcher` | `.agents/reference/crew/researcher.md`, external-source research |
| Core | `oracle` | `.agents/reference/crew/oracle.md`, advisory challenge/alternatives |
| Core | `worker` | `.agents/reference/crew/worker.md`, bounded implementation/self-verification |
| Core | `ship` | `.agents/reference/crew/ship.md`, distinct end-to-end bounded build/verify/parity reporting |
| Core | `code-reviewer` | `.agents/reference/crew/code-reviewer.md`, independent G8 |
| Core | `reviewer` | `.agents/reference/crew/reviewer.md`, general read-only review, not a substitute for G8/G9 |
| Core | `security-reviewer` | `.agents/reference/crew/security-reviewer.md`, independent G9 |
| Core | `gitops` | `.agents/reference/crew/gitops.md`, readiness and only separately authorized Git operations |
| Specialist | `frontend-engineer` | frontend implementation; relevant craft/interface skills only |
| Specialist | `backend-engineer` | backend implementation; API/domain skills only |
| Specialist | `database-engineer` | database/migration implementation; zero implicit migration authority |
| Specialist | `ui-ux-designer` | read-only UI/UX assessment; no implementation authority |
| Specialist | `qa-engineer` | test planning/verification; does not certify unobserved runtime behavior |
| Specialist | `performance-engineer` | read-only profiling/evidence and bounded recommendations |
| Specialist | `devops-engineer` | bounded infrastructure implementation; no deploy/credential authority |

Every non-orchestrator entry has `reportsTo: orchestrator`. Do not collapse Worker into Ship or treat specialist names as platform capabilities. The source nine-role audit informs these instructions; retain Captain authority, `[HUMAN-CORE / AI-TEST]`, skill-loading rules, worktree isolation, and independent G8/G9. Do not import upstream tools, fixed models, dispatch mechanisms, terminal recipes, or permissions. Preserve provenance/MIT attribution for adapted ACON/Fleet-derived material in the integration README, following `.agents/reference/crew/README.md#provenance-and-mit-notice`.

### Paperclip package manifest contract

`.paperclip.yaml` is JSON text (valid YAML 1.2) emitted by `json.dumps`; the completed manifest has exactly the top-level `schemaVersion` and `agents` fields and no `company` field. Each of 17 agent entries has `role`, `adapter`, `runtime`, `permissions`, and `permissionGrants`; the generated `pi_local` adapter sets `config.model` to `openai-codex/gpt-6-luna` and `config.thinking` to `high`. Heartbeat is declared disabled. Empty permission declarations are not proof of zero effective grants, and no ZIP field sets imported status or pause state. The manifest makes no projects/tasks/routines/env-input/skills entries and adds no unsupported fields.

The `COMPANY.md` frontmatter is `name: ACON Agent Organization` and `slug: acon-agent-organization`. Its body contains the roster/reporting chart and explicit authority, import-pause, permission, and provenance limits. The ZIP adds the four root support documents as auxiliary files; they do not create manifest fields. At the pinned source, the importer classifies `README.md` as a readme and other unrecognized root docs as `other`; full importer execution remains untested.

Every generated `agents/<slug>/AGENTS.md` is standalone and uses importer-recognized YAML frontmatter `name`, `slug`, `role`, and `reportsTo` (`null` only for orchestrator). The actual template has exactly these 12 headings: Identity, Responsibility, Authority, Task types, Prohibitions, Project scope, Communications, Reports to, Workflow, Definition of done, Escalation, and Required output. Each agent carries its own mandate and role distinctions; no shared/root `AGENTS.md` is required in the archive. Prompt text does not enforce permissions/isolation, and skill references do not prove availability/loading.

### Generator and output invariants

- Python standard library only (`argparse`, `hashlib`, `json`, `os`, `pathlib`, `re`, `stat`, `sys`, `uuid`, `zipfile`; `unittest`/temporary fixtures in tests). No dependency or network access.
- Catalog schema is version 1 with exact catalog/company/agent/role-field keys, 17 unique approved slugs, source references from a fixed canonical allowlist, and exactly one null manager (`orchestrator`); all other managers equal `orchestrator`. It declares nine core and seven specialist roles, with the orchestrator represented as the coordinator group.
- The CLI accepts only the Captain-approved external destination `/home/mewho/ai-stuff/paperclip-acon-team.zip`. It refuses an existing target and unsafe/symlinked ancestors. Its no-follow input loader anchors reads at the repository root, rejects unsafe or linked catalog/template/support/canonical inputs, and does not resolve then reopen by path. ZIP entries are sorted, relative, unique, `ZIP_STORED`, fixed to timestamp `(1980, 1, 1, 0, 0, 0)`, regular-file mode `0644`, and `allowZip64=False`.
- Two complete post-correction temporary builds were byte-identical. Python `zipfile` CRC and the captured Paperclip Node ZIP reader accepted the final 23-entry archive (19 core plus four support docs), with 17 standalone agents and schema 7. The 16-test integration suite passed before the final docs-only correction; targeted docs/build/reader checks passed afterward. Full importer/parser/runtime behavior remains unverified.
- Output creation uses a unique exclusive no-follow temporary file and no-replace link install, refusing existing destinations. Final user-approved ZIP generation and later owned-artifact documentation correction were guarded by no-follow parent and expected identity/content checks; previous versions were preserved in evidence. No `dist/` output was generated.

## 4. Engineering constraints and plan eligibility

- G2 is **REQUIRED**: this is a new integration with unresolved trust/runtime semantics.
- All implementation work is `[AUTONOMOUS-SHIP]` only for deterministic packaging/docs. Permission policy, model activation, live import, or security decisions remain Captain-controlled and blocked pending evidence.
- The bounded implementation, package generation, and two-document correction are complete. The 17 rendered `AGENTS.md` files are archive entries, not additional source files. The final artifact was generated under the approved no-overwrite/owned-artifact procedures; targeted G8/G9 corrections both APPROVE with `CORRELATED_REVIEW` recorded in the closure above.
- YAGNI: no Paperclip adapter, importer, service, server, database, project, task, skill, runtime orchestration, or generalized package framework. Zero new dependencies. No Git commands in the implementation task. Static tests do not establish import/runtime security.

## 5. Implementation slices

The four slice descriptions below are the original preimplementation task drafts. All four are complete. Where their sketches differ from the actual source inventory, manifest/template, fixed destination, verification count, or ZIP contents, the implementation closure and source-derived contract above supersede them. No implementation work remains in this plan. The corrected two-document/artifact G8 and G9 reviews both APPROVE; no further review or test rerun is required by this closure.

### Task 1 — Define the closed roster catalog and prompt template (`[AUTONOMOUS-SHIP]`) — COMPLETED

**Files:** `integrations/paperclip/catalog/agents.json` and `integrations/paperclip/templates/agent.md.tmpl`.

Actual catalog/template shape and all 12 standalone instruction sections are recorded in the implementation closure and §3 above. The schema examples below are retained as original planning sketches only, not as a description of current source contents.

**Consumes:** the roster/source mapping above and the audited ACON crew/persona references listed above. **Produces:** catalog schema version 1 with 17 entries; one template whose required fields are `name`, `slug`, `role`, `reports_to`, `mandate`, `lens`, `non_goals`, `output`, `source_refs`.

Catalog entry shape (all values required; no extra top-level fields):

```json
{
  "schema_version": 1,
  "company": {"name": "ACON Agent Organization", "slug": "acon-agent-organization"},
  "groups": {"core": 9, "specialists": 7},
  "agents": [
    {"slug": "orchestrator", "name": "ACON Orchestrator", "role": "Orchestrator", "group": "coordinator", "reports_to": null, "mandate": "Coordinate bounded assignments; retain Captain decision authority.", "lens": "Separate control from execution; verify capabilities and terminal evidence.", "non_goals": "No project implementation, model switching, permission changes, live import, or Git mutation.", "output": "Task contracts, blockers, evidence-grounded synthesis, and Captain decisions required.", "source_refs": ["AGENTS.md"]},
    {"slug": "scout", "name": "ACON Scout", "role": "Scout", "group": "core", "reports_to": "orchestrator", "mandate": "Read-only project archaeology.", "lens": "Trace paths, members, contracts, and gaps.", "non_goals": "No edits, tests, or guessed runtime behavior.", "output": "Cited inventory, findings, exclusions, and unknowns.", "source_refs": [".agents/reference/crew/scout.md"]}
  ]
}
```

The two rows above define the exact record shape and illustrate content; implementation must populate all remaining 15 records using the roster table, not copy these two as the whole catalog. For every role preserve its source mandate and role-specific differences; the final catalog tests in Task 2 enforce the exact full slug list and group/hierarchy invariants. The four-section Markdown illustration below is a historical proposal only; the actual 12-section standalone prompt contract is in §3 and the implementation closure.

```markdown
---
name: {{name}}
slug: {{slug}}
role: {{role}}
reportsTo: {{reports_to_yaml}}
---

# {{name}}

## Mandate
{{mandate}}

## Lens
{{lens}}

## Scope and non-goals
{{non_goals}}

## Required output and escalation
{{output}}

## ACON references
{{source_refs_markdown}}

Project context, available tools, skills, workspace isolation, model and authorization are task-/host-specific. This instruction file is not an enforcement boundary. Do not infer permission, isolation, model availability, or Captain approval from prose or agent selection.
```

Template must be rendered with a closed replacement function, not Python `str.format` (braces in instructions are literal). Metadata strings are validated against CR/LF and YAML scalar hazards; `reports_to_yaml` is exactly `null` or `orchestrator`; references are repository-relative literals.

**Verify:** `python3 -c 'import json; p=json.load(open("integrations/paperclip/catalog/agents.json")); assert p["schema_version"] == 1 and len(p["agents"]) == 17'` exits 0. This is an interim structural check, not roster proof.

### Task 2 — Implement generator and regression tests (`[AUTONOMOUS-SHIP]`) — COMPLETED

**Files:** `integrations/paperclip/generate.py`, `integrations/paperclip/tests/test_catalog.py`, and `integrations/paperclip/tests/test_generate.py`.

**Actual result:** the completed generator provides `build_package`, `build_manifest`, `render_agent`, `validate_package_files`, and a safe ZIP writer returning the archive SHA-256. Its CLI requires `--output` exactly matching the approved external destination. Input files are opened root-contained and no-follow; output collisions are refused.

Generator requirements are the output invariants in §3. Validation must reject malformed JSON, extra/missing keys, wrong roster, duplicate/unsafe slugs, wrong hierarchy, empty fields, more/less than one orchestrator/nine core/seven specialists, newline/YAML injection, and any attempt to write outside the fixed integration `dist` path. Failures are nonzero with a concise diagnostic. The actual manifest selects `pi_local` with `openai-codex/gpt-6-luna` and `thinking: high`; it declares no pause status and emits no project/task/routine/env-input/skill entries. The concrete Python test module below is the original proposal, not the actual passing suite; in particular, its no-model assertion was superseded by the implemented configuration.

Complete test module contract (use `unittest`; tests may import `generate` by adding `integrations/paperclip` to `sys.path`):

```python
import json
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
import generate

class GeneratorTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.catalog = json.loads((ROOT / "catalog/agents.json").read_text(encoding="utf-8"))
        cls.template = (ROOT / "templates/agent.md.tmpl").read_text(encoding="utf-8")

    def test_roster_is_exact_flat_and_complete(self):
        files = generate.build_package(self.catalog, self.template)
        agents = [p for p in files if p.startswith("agents/") and p.endswith("/AGENTS.md")]
        self.assertEqual(len(agents), 17)
        manifest = json.loads(files[".paperclip.yaml"])
        self.assertEqual(manifest["schemaVersion"], 7)
        self.assertEqual(set(manifest["agents"]), {p.split("/")[1] for p in agents})
        self.assertIsNone(self.catalog["agents"][0]["reports_to"])
        self.assertTrue(all(a["reports_to"] == "orchestrator" for a in self.catalog["agents"][1:]))

    def test_package_excludes_runtime_activation_and_project_data(self):
        files = generate.build_package(self.catalog, self.template)
        manifest = json.loads(files[".paperclip.yaml"])
        self.assertEqual(manifest["agents"]["orchestrator"]["adapter"], {"type": "pi_local", "config": {}})
        self.assertEqual(manifest["agents"]["orchestrator"]["runtime"]["heartbeat"]["enabled"], False)
        self.assertEqual(manifest["agents"]["orchestrator"]["permissionGrants"], [])
        self.assertNotIn("model", manifest["agents"]["orchestrator"]["adapter"]["config"])
        self.assertFalse(any(k in manifest for k in ("projects", "tasks", "routines", "envInputs", "skills")))
        self.assertNotIn(".acon/", "\n".join(files))

    def test_rendered_agents_have_importer_frontmatter_and_role_sections(self):
        files = generate.build_package(self.catalog, self.template)
        for agent in self.catalog["agents"]:
            body = files[f"agents/{agent['slug']}/AGENTS.md"].decode("utf-8")
            self.assertIn(f"slug: {agent['slug']}\n", body)
            self.assertIn("reportsTo: null" if agent["reports_to"] is None else "reportsTo: orchestrator", body)
            for section in ("## Mandate", "## Lens", "## Scope and non-goals", "## Required output and escalation"):
                self.assertIn(section, body)

    def test_zip_is_store_only_sorted_safe_and_deterministic(self):
        files = generate.build_package(self.catalog, self.template)
        with tempfile.TemporaryDirectory() as tmp:
            a, b = Path(tmp) / "a.zip", Path(tmp) / "b.zip"
            generate.write_zip(files, a)
            generate.write_zip(files, b)
            self.assertEqual(a.read_bytes(), b.read_bytes())
            with zipfile.ZipFile(a) as archive:
                names = archive.namelist()
                self.assertEqual(names, sorted(names))
                self.assertEqual(len(names), len(set(names)))
                self.assertIsNone(archive.testzip())
                self.assertTrue(all(not n.startswith("/") and ".." not in Path(n).parts for n in names))
                self.assertTrue(all(i.compress_type == zipfile.ZIP_STORED for i in archive.infolist()))
                self.assertIn("COMPANY.md", names)
                self.assertIn(".paperclip.yaml", names)

    def test_refuses_existing_destination(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "already.zip"
            path.write_bytes(b"keep")
            with self.assertRaises(FileExistsError):
                generate.write_zip({}, path)
            self.assertEqual(path.read_bytes(), b"keep")

    def test_rejects_catalog_injection_and_wrong_roster(self):
        bad = json.loads(json.dumps(self.catalog))
        bad["agents"][1]["name"] = "bad\nslug: injected"
        with self.assertRaises(ValueError):
            generate.build_package(bad, self.template)
        bad = json.loads(json.dumps(self.catalog))
        bad["agents"].pop()
        with self.assertRaises(ValueError):
            generate.build_package(bad, self.template)

if __name__ == "__main__":
    unittest.main()
```

The implementation must make the above API/test contracts real; adjust only test imports if necessary, not assertions. Add a unit test for symlink/out-of-root output refusal and a duplicate-slug case. These tests establish package structure and deterministic bytes, not Paperclip import or effective permissions.

**TDD and verification:** First author failing tests, run `python3 -m unittest discover -s integrations/paperclip/tests -v` (expect failure before implementation), implement the smallest generator, then rerun and require exit 0. No dependencies installed.

### Task 3 — Write human operating and security docs (`[AUTONOMOUS-SHIP]`) — COMPLETED

**Files:** `integrations/paperclip/README.md`, `TEAM.md`, `VALIDATION.md`, and `LICENSE.md`.

**Consumes:** this plan's release pin, roster, import/runtime blockers, and ACON provenance source. **Produces:** user-facing contents including purpose/roster, generated ZIP command, exact Paperclip release reference, import selection procedure, schema facts, no-runtime-claim notices, approval gates, troubleshooting, provenance/MIT notice, and validation checklist.

`README.md` records the reusable role pack, pinned-master versus captured-release distinction, new-company UI preview, explicit `pauseAutomations: true` request, permission/model/workspace limits, and no-live-import status. It does not claim ZIP contents pause agents or that the master pin certifies an arbitrary installed release.

`VALIDATION.md` records the pinned master/release distinction, historical and current test counts, final 23-entry/17-agent structure, captured ZIP-reader evidence, and explicit parser/import/runtime unknowns. It does not claim a full Paperclip import or runtime check.

**Verification outcome:** the integration suite passed 16 tests (exit 0) before the final docs-only correction; targeted documentation assertions, corrected archive comparison, deterministic rebuilds, and official ZIP-reader checks passed afterward. No full regression rerun was required for the docs-only correction. No live import.

### Task 4 — Generate and audit distributable artifacts — COMPLETED

**Actual artifact:** `/home/mewho/ai-stuff/paperclip-acon-team.zip`, 127,216 bytes, 23 entries, 17 agents, SHA-256 `568713d00eface0ec619f19b9f35aa7b48043b8be86b917e5963b070b6bf3d37`. The 23 entries are 19 core files plus four support documents. No `integrations/paperclip/dist/` tree or extracted `AGENTS.md` source files were created.

**Verification:** the integration suite passed 16 tests (exit 0) before the last docs-only correction; reviewers waived rerunning it for that correction. Two complete builds after correction were byte-identical. The captured Paperclip ZIP reader accepted the final archive (exit 0; 23 entries, schema 7, 17 agents). The two-document correction had targeted assertion, archive-content comparison, and official-reader checks (exit 0). Targeted corrected-document/artifact G8 and G9 both returned APPROVE; reviewer model identity is correlated as recorded in the closure. No full Paperclip parser/import/runtime behavior was tested.

The artifact was created at the Captain-approved destination with exclusive no-follow output handling. The later README/VALIDATION-only correction replaced that exact owned artifact only after inode/content/mode/link-count checks and an atomic same-directory rename; both prior versions are preserved in the external evidence bundle. Do not rerun generation against the existing final path: the generator refuses collisions. No live import, company mutation, model request, CLI operation, or activation occurred.

## 6. Acceptance criteria (traceability: 14 points)

| ID | Acceptance point | Planned proof | Status before implementation |
|---|---|---|---|
| AC-01 | Source edits stay under `integrations/paperclip/` plus this plan; approved ZIP is the sole external build artifact; no expanded generated source tree | implementation closure inventory and final archive check | SLICE 4 COMPLETE |
| AC-02 | Package uses actual importer-required `COMPANY.md` and numeric `schemaVersion: 7`, not the mock `TEAM.md`/draft schema | static ZIP test; release-pinned parser check | SOURCE VERIFIED, PACKAGE UNPROVEN |
| AC-03 | One orchestrator + exactly nine core roles + seven named specialists, no omitted or extra slug | catalog validation and ZIP member count | UNPROVEN |
| AC-04 | All 16 agents directly report to orchestrator; orchestrator alone is root | catalog + manifest + frontmatter assertions | UNPROVEN |
| AC-05 | Worker and Ship remain separate and their distinct instructions preserve bounded implementation vs end-to-end parity/evidence | role-specific catalog review and rendered prompt check | UNPROVEN |
| AC-06 | Nine ACON source crew findings are applied case-by-case; preserve G8/G9, authority, [HUMAN-CORE], skills, worktrees; do not copy source runtime | provenance/source mapping and manual prompt audit | UNPROVEN |
| AC-07 | Seven specialists remain domain-specific; skills are references, not invented Paperclip capabilities | catalog role descriptions and prompt audit | UNPROVEN |
| AC-08 | Pi-local contract uses `adapter.type=pi_local`, `config.model=openai-codex/gpt-6-luna`, and `config.thinking=high`; no Paperclip runtime availability claim | static manifest and captured source evidence | PACKAGE STRUCTURE VERIFIED; ADAPTER RUNTIME UNTESTED |
| AC-09 | Bundle declares heartbeat disabled and no routines/status field; import pause must be requested with `pauseAutomations: true` and verified after import | manifest structure, UI-source evidence, docs | PACKAGE DECLARATION VERIFIED; ACTUAL PAUSED STATUS NOT TESTED |
| AC-10 | No company projects, tasks, workspaces, routines, skills, env inputs, setup/cleanup commands, secrets, or external calls are packaged | ZIP path/manifest static assertions + source text scan | UNPROVEN |
| AC-11 | No permission grants are declared in package, and effective grants are not misrepresented as empty | manifest check; disposable import inspection required for effective-grant claim | DECLARED EMPTY ONLY; EFFECTIVE PERMISSIONS BLOCKED |
| AC-12 | Generator is stdlib-only, deterministic, path-contained, non-overwriting, sorted STORE ZIP; no existing CLI changes | unittest, repeat-byte equality, `zipfile -t`, scoped path audit | UNPROVEN |
| AC-13 | Docs explain import preview, pause, model/permission approval, separation limits, release pin, unknowns, and provenance/MIT | bounded doc audit and link check | UNPROVEN |
| AC-14 | No runtime/import/model request or company mutation is claimed or performed without separate explicit authorization | task record and explicit evidence classification | CURRENTLY NOT PERFORMED; future import blocked pending approval |

## 7. Integration verification and residual risk

Static verification does not prove that Paperclip loads all instructions, interprets the reporting links, pauses imported agents, applies only expected grants, or isolates agent workspaces/sessions. Any future separately authorized validation may use a disposable Paperclip company, inspect preview and actual effective grants/status, and validate model visibility only under the needed approval. Any live model request or agent run requires its own approval. Targeted corrected-document/artifact G8 and G9 are APPROVED; their shared model is recorded as `CORRELATED_REVIEW`. This does not approve a full-code review, importer/parser, live import, or runtime behavior.

Do not update package schema opportunistically. If a supported release moves beyond schema 7 or changes the importer contract, pause and revise this plan with fresh pinned-source evidence before implementation. Do not treat the reviewed `master` commit as a release or claim compatibility with arbitrary Paperclip versions.

## 8. Rollback and stop strategy

The generator never overwrites an existing destination. For a failed temporary build, clean only that build's own newly created temporary file; never delete or replace a pre-existing artifact. The current final ZIP was replaced only under the separately authorized exact-owned-artifact procedure recorded in the closure evidence, with both prior versions preserved. This plan authorizes no company deletion, agent termination, DB rollback, Git rollback, or unrelated cleanup. If an import is ever accidentally invoked, stop and report; do not attempt compensating mutations.

## 9. Review and import gate

The original plan-review and bounded-dispatch gate has been completed; the implementation and final artifact are built. The corrected README/VALIDATION entries and replacement ZIP received targeted G8 and fresh G9 **APPROVE**. The shared Luna High writer/reviewer model is `CORRELATED_REVIEW`, not independent model identity. No live import or activation is authorized by this closure. Any future import requires separate authorization for a disposable new company, explicit UI request `pauseAutomations: true`, and inspection of actual status, permissions, identity/membership, and project/workspace controls. If effective grants or isolation do not meet the requirement, remain blocked and report the smallest compliant alternative.

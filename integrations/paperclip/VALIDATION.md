# ACON Paperclip package: validation record and limits

This file distinguishes checks actually performed from checks still required. It is not an importer certification, security review, or claim that an organization has been created. `TEAM.md` defines intended operating guidance; `README.md` has the owner-facing UI procedure.

## Pinned source facts

- Package generator is pinned to the captured Paperclip development source `master` commit `fd057f6ac4e9148bb4055883ae1d0e7f49242692` (2026-10-15), not described as a release.
- The captured latest release metadata is **v2026.1012.0**, tag commit `bba6a45f0d364cfd962ac59b3bdf2426a8222adb` (published 2026-10-12). A five-file source comparison found differences in package types, validator, importer service, and Pi adapter execution; the ZIP reader was byte-identical. Schema 7 and the `COMPANY.md` requirement were observed in both compared importer revisions. This is not a complete release-compatibility audit. Confirm the installed Paperclip build/source before use.
- At the master pin, captured `server/src/services/company-portability.ts` SHA-256 is `232336554fa304b35dd1ae707abfb6092a9ea09271b7401cb6f602efc81ce5dc`; captured `packages/shared/src/types/company-portability.ts` SHA-256 is `5052912cee12bc618b9efeae292625faa4982f9eadf13d7221e23b2290a02096`. The importer source requires text `COMPANY.md`, reads numeric `.paperclip.yaml` `schemaVersion`, declares version 7, and discovers `agents/<slug>/AGENTS.md` frontmatter including `name`, `slug`, `role`, and `reportsTo`.
- Captured Pi-local adapter source uses built-in `pi_local`, `adapter.config.model` in `provider/model` form and optional `adapter.config.thinking`; runtime passes provider/model/thinking to Pi. Package config is `openai-codex/gpt-6-luna` plus `high`. Supplied local Pi metadata lists this model and reports local auth readiness; that is not a Paperclip adapter/runtime check.

## Completed checks (Slice 4 final package; structural and source-reader evidence)

| Check | Exact command/evidence | Result and meaning |
|---|---|---|
| Catalog and generator suite | `PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s integrations/paperclip/tests -v` | Slice 4: exit 0, 16 tests passed. This suite ran before the subsequent documentation-only correction; reviewers explicitly did not require another regression-suite run for that correction. |
| Package shape and fields | `test_generate.py` and the final archive verifier | Exactly 23 entries: 19 core (`COMPANY.md`, `.paperclip.yaml`, 17 agent files) plus `README.md`, `TEAM.md`, `VALIDATION.md`, and `LICENSE.md`. The manifest remains only `schemaVersion` and `agents`; all 17 roles retain the schema-7 adapter/runtime/permission field contract, flat reporting, and no ZIP status field. These are integration-owned structural checks, not Paperclip's full importer validator. |
| ZIP safety and determinism | `test_generate.py`; two temporary builds and archive checks recorded in the external Slice 4 report | STORE, sorted unique relative paths, fixed timestamps/modes, classic ZIP/no Zip64/data-descriptor checks, CRC, unsafe-name rejection, and output collision/symlink/hardlink refusal. Two complete 23-entry builds after the documentation correction were byte-identical. The final ZIP matches their size and hash; its checksum is recorded outside the ZIP to avoid self-reference. |
| Captured Paperclip Node ZIP reader | Exact final invocation and log are in the external final-doc-correction evidence bundle. The command imports the captured `readZipArchive`, reads the final ZIP, and asserts exact names, all 17 standalone agent files, 12 instruction headings each, support files, manifest fields/schema, and the archive checksum. | Node v24.18.0; exit 0; `OFFICIAL_ZIP_READER=PASS files=23 core=19 support=4 schema=7 agents=17`. Source `packages/shared/src/portability-zip.ts`, pin `fd057f6ac4e9148bb4055883ae1d0e7f49242692`, SHA-256 `b5860afd9ab301fb9cd44f3b3799c28d6fe6297fc891ebbe330b4b62bc53bd4e`. This is ZIP-reader acceptance, not full company import or runtime validation. |
| Input integrity | Historical Slice 4 before/after manifests; current doc-only build comparison | The prior Slice 4 build checked 28 catalog/template/support/canonical-source inputs with descriptor-anchored no-follow reads and recorded unchanged hashes/modes/link counts. In this correction, only `README.md` and `VALIDATION.md` changed versus the preserved prior ZIP; `TEAM.md`, `LICENSE.md`, the manifest, and all 17 agent files are byte-identical. |

**Historical Slice 2 only:** the earlier core-only candidate had 19 entries and the then-current suite had 10 passing tests. Those results remain historical; they do not describe the final 23-entry package. Slice 4 recorded 16 passing integration tests and a final 23-entry/17-agent ZIP. The later documentation-only correction was rebuilt twice and accepted by the captured ZIP reader, but the full regression suite was not rerun for that correction.

The final ZIP is built, but no Paperclip company parser/import transaction was executed. The captured reader accepts ZIP framing and entry data only; it does **not** prove `COMPANY.md`/YAML/frontmatter import success, company transaction behavior, effective permissions, or runtime semantics.

## Not tested; do not claim

No Paperclip server, CLI, UI import, company API, database, live importer/parser, disposable organization, agent run, model request, or production action was run. Therefore these remain unknown:

- full importer/schema validation of this ZIP and compatibility with an installed Paperclip release;
- resulting company membership/ownership, effective permission grants, baseline configuration grants, and `tasks:assign`;
- actual imported agent status, automation/routine state, and all wakeup paths;
- adapter startup, model availability after import, credentials propagation, or `high` effort behavior in Paperclip;
- instruction loading, task/project access enforcement, workspace/session isolation, reviewer separation, Git controls, and rollback/partial-import behavior;
- security of remote GitHub fetch, redirects, private-network protections, or any external egress path.

The manifest's empty `permissions` and `permissionGrants` are declarations only. Captured importer source ensures `tasks:assign` for imported agents; release notes also describe default configuration grants for new agents. Normal new-hire approval policy is not proof that import is gated. A true zero-effective-grant requirement cannot be asserted from this package.

Heartbeat `enabled: false` is a runtime-config declaration/sanitizer fact, not a paused agent status or universal wakeup disable. Pause is an import-request option `pauseAutomations: true`, not a ZIP field. The captured UI source at the master pin (`ui/src/pages/CompanyImport.tsx`) initializes its checkbox true at line 967, includes **Local zip**, **Create new organization**, **Preview import**, and labels the checkbox **Start imported agents and routines paused** (the import call forwards the checkbox value). The high-level CLI import definition in `cli/src/commands/client/company.ts:1644–1656` has no observed pause option. UI behavior itself has not been exercised.

## Separate manual validation required before use

1. Confirm the actual target Paperclip version/build against the pinned importer contract; inspect the actual import preview.
2. Use the UI's **Local zip** and **Create new organization** flow. Select only company+agents; confirm the preview shows all 17 agents. Keep **Start imported agents and routines paused** checked so the request sends `pauseAutomations: true`; do not rely on package heartbeat config or normal hiring approval.
3. In a separately authorized disposable company, inspect actual registered agent IDs, ownership/membership, all 16 reporting links, agent statuses, routines/wakeups, and effective grants (especially `tasks:assign` and default configuration grants). Do not activate or assign work until actual authority and permissions are acceptable. No live import is authorized or claimed here.
4. Configure a project-specific repository/workspace and credentials only through the target instance's authorized controls. Confirm actual execution target, filesystem sharing, session separation, credentials scope, and concurrent access. Project/workspace selection and prompt text are not security isolation.
5. Check `pi --list-models` and host-local auth readiness only when separately authorized. The observed model metadata in this task is not an adapter test; do not issue a model request unless separately authorized.

## Generation and final ZIP

For command syntax, run the real generator help from the repository root:

```bash
python3 integrations/paperclip/generate.py --help
```

The generator requires `--output` and restricts it to the approved destination embedded in the executable. The destination and final archive checksum are intentionally omitted from this portable document. The initial Slice 4 build followed a no-follow destination check. The subsequent documentation-only correction replaced that exact owned artifact only after checking its expected identity, content hash, mode, and link count through a no-follow parent descriptor; the original bytes were preserved separately. The corrected archive matched two deterministic temporary builds. If rebuilding, do not overwrite an existing output: use a separately authorized, ownership-checked artifact-replacement procedure. The ZIP is not an import request and cannot pause or activate agents.

## Provenance and scope

The nine core role mappings follow the canonical ACON crew/persona files; seven specialists map to selected ACON skills. Only references and concise role adaptations are packaged, not the ACON skill tree or design presets. The generated supported `COMPANY.md` includes attribution and the applicable MIT notice for adapted source portions; it does not relicense all ACON policy. See [`../../.agents/reference/crew/README.md#provenance-and-mit-notice`](../../.agents/reference/crew/README.md#provenance-and-mit-notice). No private IDs, machine paths, credentials, host CWD, or personal runtime profiles belong in the package.

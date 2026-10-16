# ACON Paperclip organization package

This integration generates a project-agnostic Paperclip organization containing 17 permanent ACON roles: one coordinator, nine core personas, and seven domain specialists. See [TEAM.md](TEAM.md) for the roster and operating contract and [VALIDATION.md](VALIDATION.md) for the exact evidence boundary and remaining checks.

The package is a portable description, not a Paperclip adapter, team ACL, sandbox policy, or runtime compatibility certification. It creates no project, workspace, task, routine, skill package, environment input, setup command, or machine-specific path. The generated ZIP contains exactly 23 entries: the 19 core files (`COMPANY.md`, `.paperclip.yaml`, and 17 `agents/<slug>/AGENTS.md` files) plus four auxiliary root documents (`README.md`, `TEAM.md`, `VALIDATION.md`, and `LICENSE.md`). `COMPANY.md` carries the roster/provenance/license content; the four documents are included as ordinary support files and add no manifest fields. The pinned importer source classifies `README.md` as a readme and other unrecognized root support documents as `other`; ZIP-reader acceptance is not full importer validation. The generator and tests are not ZIP entries.

## Version and prerequisites

- Package contract is authored against the captured Paperclip **master** source pin `fd057f6ac4e9148bb4055883ae1d0e7f49242692`, whose company importer declares numeric bundle `schemaVersion: 7` and requires `COMPANY.md`.
- The captured latest release metadata is Paperclip `v2026.1012.0`, tag commit `bba6a45f0d364cfd962ac59b3bdf2426a8222adb`. Five selected portability/adapter files were compared between that release and the master pin: schema 7 and `COMPANY.md` were observed in both, but several source files differ. This is not a full compatibility audit or a claim that an arbitrary installed release matches the master snapshot. Confirm the target instance version and review its own package importer before use.
- Generator uses Python standard library only; no install or network access. Python 3.10+ is required. Output creation additionally requires POSIX directory-relative `open/stat/link/unlink`, `O_NOFOLLOW`, and `O_DIRECTORY`; the generator fails closed when those host capabilities are absent. Only Python 3.14.4 was exercised for this task.
- The runtime adapter is Paperclip's `pi_local`. `adapter.config.model` uses `provider/model` and optional `adapter.config.thinking`; the package selects `openai-codex/gpt-6-luna` with `high`. Supplied local Pi metadata listed that model and reported local auth readiness. No Paperclip adapter run, model request, or import was performed. Host-side Pi authentication is not bundled; never put credential values in the catalog, package, issue, or prompt.

## Generate and inspect

From the ACON repository root, first inspect the generator's real supported command syntax and the fixed destination it prints:

```bash
python3 integrations/paperclip/generate.py --help
```

Generation requires the mandatory `--output` argument to exactly match the generator's approved absolute output destination. It refuses existing outputs, symlink ancestors, path traversal, and hosts that cannot safely create the file exclusively. Do not redirect it to a different path or overwrite a prior ZIP. The user-facing output destination is provided at delivery time, not embedded in this portable documentation.

After generation, use the structural verification command recorded in [VALIDATION.md](VALIDATION.md). The generator's own checks establish only this package's closed roster/field/path invariants and deterministic ZIP properties; they do not prove Paperclip import or effective permissions.

## Import safely — UI source guidance, not an observed import

The reviewed Paperclip UI source uses these labels and behavior (not smoke-tested here):

1. In the import view choose **Import source** → **Local zip** → **Choose zip**.
2. Set **Target** to **Create new organization**; do not target or replace an existing company. Use **New organization name** only if an explicit name override is wanted.
3. Choose **Preview import**. Inspect the complete file preview and planned records: `COMPANY.md`, `.paperclip.yaml`, and exactly 17 agent files. Select only the company and agents; this package has no projects, tasks, routines, or skills to import.
4. Before applying, verify the checkbox **Start imported agents and routines paused** is checked. The captured UI initializes this checkbox to checked and sends `pauseAutomations: true` when checked. Verify the checkbox yourself; the ZIP cannot set imported status, and the default may differ in another Paperclip version.
5. Apply only after the preview is understood. After completion, verify the new organization's agent count, every reporting link, imported agent status, automation state, and effective permission grants from authoritative Paperclip data before assigning work or activating agents.

The high-level Paperclip CLI import command has no observed `pauseAutomations` option. Its `--dry-run` and `--yes` behavior does not establish the paused-import request. Do not use CLI apply as a substitute for the paused UI flow. A direct API request is not documented here because no endpoint invocation was tested in this task.

### Permissions, ownership, and activation gates

The extension declares empty `permissions` and `permissionGrants`, but that is not proof of zero effective grants. Paperclip import code ensures `tasks:assign` and the release notes describe default configuration grants for new standard agents. Company new-hire approval settings are not proof that import itself is gated by normal hiring approval. Inspect actual resulting grants and owner/company membership in a separately authorized disposable company; do not activate if they exceed the intended boundary.

Imported heartbeat configuration is set disabled by the importer sanitizer. That does not disable every possible wakeup, guarantee paused status, or verify that routines are inactive. The import request must carry `pauseAutomations: true`; then inspect actual status and automations. No company import has been performed here.

The roster and `reportsTo` frontmatter are descriptive structure, not authorization. Before delegation, verify the exact registered agent identity, company/team membership, and task ownership using current authoritative Paperclip records; names/slugs alone are insufficient. Configure actual project context and a dedicated execution workspace in the target Paperclip environment only for a separately authorized project/task. Do not hard-code a repository, current working directory, host path, or credentials into this reusable organization. Project selection, workspaces, and prompts do not prove context/session isolation.

## Model and source notes

Model metadata in the package is configuration only. Local Pi metadata is not a successful Paperclip run or proof of provider behavior after import. Credentials remain on the configured execution host; no secrets are exported. All generated instructions preserve ACON provenance and the applicable MIT notice. The full roster/source mappings and governance are in [TEAM.md](TEAM.md); evidence and nonclaims are in [VALIDATION.md](VALIDATION.md).

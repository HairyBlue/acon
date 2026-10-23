#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d -t acon-adopt-ledger-test.XXXXXX)"
trap 'rm -rf -- "$TMP"' EXIT
SOURCE="$TMP/source"
mkdir -p "$SOURCE/scripts" "$SOURCE/.agents" "$SOURCE/.acon"
cp "$REPO_ROOT/AGENTS.md" "$SOURCE/AGENTS.md"
cp "$REPO_ROOT/scripts/adopt.sh" "$SOURCE/scripts/adopt.sh"
cp -a "$REPO_ROOT/.agents/." "$SOURCE/.agents/"
printf 'PRIVATE-SESSION-SENTINEL\n' > "$SOURCE/.acon/sessions.json"
printf 'PRIVATE-TEMP-SENTINEL\n' > "$SOURCE/.acon/sessions.json.tmp"

TARGET="$TMP/target"
mkdir -p "$TARGET/.agents" "$TARGET/.acon"
printf 'Local target instruction.\n' > "$TARGET/AGENTS.md"
printf 'local target state\n' > "$TARGET/.agents/local-only.md"
printf 'TARGET-PRIVATE-SESSION\n' > "$TARGET/.acon/sessions.json"
printf 'local-only-pattern\n.agents/sessions/\n.worktrees/\nscratch/' > "$TARGET/.gitignore"
cp "$TARGET/.gitignore" "$TMP/expected-ignore"
printf '\n/.acon/sessions.json\n/.acon/sessions.json.tmp\n' >> "$TMP/expected-ignore"
bash "$SOURCE/scripts/adopt.sh" --force "$TARGET" >/dev/null
cmp "$TMP/expected-ignore" "$TARGET/.gitignore"
for pattern in 'local-only-pattern' '.agents/sessions/' '.worktrees/' 'scratch/' '/.acon/sessions.json' '/.acon/sessions.json.tmp'; do
  grep -Fqx -- "$pattern" "$TARGET/.gitignore"
  test "$(grep -Fxc -- "$pattern" "$TARGET/.gitignore")" -eq 1
done
grep -Fq 'Local target instruction.' "$TARGET/AGENTS.md"
test -f "$TARGET/.agents/local-only.md"
test ! -e "$TARGET/scripts"
grep -Fqx 'TARGET-PRIVATE-SESSION' "$TARGET/.acon/sessions.json"
test ! -e "$TARGET/.acon/sessions.json.tmp"
! grep -R -Fq 'PRIVATE-SESSION-SENTINEL' "$TARGET"
! grep -R -Fq 'PRIVATE-TEMP-SENTINEL' "$TARGET"
grep -Fq 'Pane-pool policy and local session boundary' "$TARGET/.agents/skills/productivity/adopt-acon/SKILL.md"
for skill in better-interface find-animation-opportunities; do
  test -f "$TARGET/.agents/skills/design/$skill/SKILL.md"
done
grep -Fq 'name: better-interface' "$TARGET/.agents/skills/design/better-interface/SKILL.md"
grep -Fq 'name: find-animation-opportunities' "$TARGET/.agents/skills/design/find-animation-opportunities/SKILL.md"
grep -Fq 'Use when explicitly requesting a multi-domain, read-only audit' "$TARGET/.agents/skills/design/better-interface/SKILL.md"
grep -Fq 'Use when explicitly asking to discover or audit motion opportunities' "$TARGET/.agents/skills/design/find-animation-opportunities/SKILL.md"
grep -Fq '[anti-slop invariants](../craft/anti-ai-slop.md)' "$TARGET/.agents/skills/design/better-interface/SKILL.md"
grep -Fq '[interactive-state coverage](../craft/state-coverage.md)' "$TARGET/.agents/skills/design/better-interface/SKILL.md"
grep -Fq '[minimalism discipline](../craft/minimalism-discipline.md)' "$TARGET/.agents/skills/design/better-interface/SKILL.md"
grep -Fq '[anti-slop invariants](../craft/anti-ai-slop.md)' "$TARGET/.agents/skills/design/find-animation-opportunities/SKILL.md"
grep -Fq '[interactive-state coverage](../craft/state-coverage.md)' "$TARGET/.agents/skills/design/find-animation-opportunities/SKILL.md"
grep -Fq '[minimalism discipline](../craft/minimalism-discipline.md)' "$TARGET/.agents/skills/design/find-animation-opportunities/SKILL.md"
grep -Fq '[the accessibility floor](../craft/accessibility-baseline.md)' "$TARGET/.agents/skills/design/better-interface/SKILL.md"
grep -Fq '[the canonical motion guide](../craft/motion.md)' "$TARGET/.agents/skills/design/find-animation-opportunities/SKILL.md"
grep -Fq '[`better-interface`](better-interface/SKILL.md)' "$TARGET/.agents/skills/design/SKILL.md"
grep -Fq '[`find-animation-opportunities`](find-animation-opportunities/SKILL.md)' "$TARGET/.agents/skills/design/SKILL.md"
grep -Fq '4 Skills + 67 Presets + 17 Craft References' "$TARGET/.agents/INDEX.md"
test "$(find "$TARGET/.agents/skills/design" -mindepth 2 -type f -name SKILL.md | wc -l | tr -d ' ')" -eq 4
grep -Fq '`job_title`, when present on an ORCHESTRATOR or fleet-agent record, is a string' "$TARGET/.agents/reference/crew/README.md"
grep -Fq '`skills`, when present on those records, is an object containing only optional `assigned` and `loaded` arrays' "$TARGET/.agents/reference/crew/README.md"
grep -Fq '`{}` and empty arrays are valid.' "$TARGET/.agents/reference/crew/README.md"
grep -Fq '"fleets":[{"agents":[{"session_id":"placeholder-worker-populated"' "$TARGET/.agents/reference/crew/README.md"
grep -Fq '"skills":{"assigned":[],"loaded":[]}' "$TARGET/.agents/reference/crew/README.md"
grep -Fq '"skills":{}' "$TARGET/.agents/reference/crew/README.md"
grep -Fq '`loaded` must be a subset of `assigned`.' "$TARGET/.agents/reference/crew/README.md"
grep -Fq 'A verified idle/untasked session remains a known session' "$TARGET/.agents/reference/crew/README.md"
grep -Fq 'Compaction alone proves neither retention nor loss' "$TARGET/.agents/reference/crew/README.md"
grep -Fq 'Never guess historical titles or skills.' "$TARGET/.agents/reference/crew/README.md"
grep -Fq '{"skills":{"assigned":[],"loaded":["ponytail"]}}' "$TARGET/.agents/reference/crew/README.md"
grep -Fq 'An ORCHESTRATOR record has required `session_id`, extensible `cli`, `type`/role, `resume_cmd`, and `fleets`, plus optional `pane_id`, `model`, `job_title`, and `skills`' "$TARGET/.agents/reference/crew/README.md"
grep -Fq 'each fleet agent has required `session_id`, `cli`, `type`, and `resume_cmd`, plus optional `pane_id`, `model`, `job_title`, and `skills`' "$TARGET/.agents/reference/crew/README.md"
assert_absent() {
  if grep -Fq -- "$1" "$TARGET/.agents/reference/crew/README.md"; then
    printf 'unexpected superseded text found: %s\n' "$1" >&2
    exit 1
  fi
}
assert_absent 'An ORCHESTRATOR record has only `session_id`, extensible `cli`'
assert_absent 'each fleet agent has only `session_id`, `cli`, `type`, optional `pane_id` and `model`'
assert_absent 'Existing records without `pane_id` or `model` remain valid.'
assert_absent 'initialize only the existing minimal schema through the exact sibling temp followed by atomic rename.'
assert_absent 'construct only the existing minimal schema;'
assert_absent 'Preserve the existing schema, safe IO/no-follow and anchored-rename requirements'
grep -Fq 'initialize the existing minimal schema (including only the optional `job_title` and `skills` fields on agent records as defined below)' "$TARGET/.agents/reference/crew/README.md"
bash "$SOURCE/scripts/adopt.sh" --force "$TARGET" >/dev/null
cmp "$TMP/expected-ignore" "$TARGET/.gitignore"

# A fresh real run creates only the two required lines when .gitignore is absent.
MISSING_IGNORE="$TMP/missing-ignore-target"
mkdir -p "$MISSING_IGNORE"
bash "$SOURCE/scripts/adopt.sh" --force "$MISSING_IGNORE" >/dev/null
test "$(grep -Fxc '/.acon/sessions.json' "$MISSING_IGNORE/.gitignore")" -eq 1
test "$(grep -Fxc '/.acon/sessions.json.tmp' "$MISSING_IGNORE/.gitignore")" -eq 1

# Dry run leaves a missing .gitignore absent and never writes either pattern.
DRY_TARGET="$TMP/dry-target"
mkdir -p "$DRY_TARGET"
printf 'Dry-run target instruction.\n' > "$DRY_TARGET/AGENTS.md"
bash "$SOURCE/scripts/adopt.sh" --dry-run "$DRY_TARGET" >/dev/null
test ! -e "$DRY_TARGET/.gitignore"
grep -Fqx 'Dry-run target instruction.' "$DRY_TARGET/AGENTS.md"
DRY_EXISTING="$TMP/dry-existing-target"
mkdir -p "$DRY_EXISTING"
printf 'Dry-run existing ignore' > "$DRY_EXISTING/.gitignore"
cp "$DRY_EXISTING/.gitignore" "$TMP/dry-existing-before"
bash "$SOURCE/scripts/adopt.sh" --dry-run "$DRY_EXISTING" >/dev/null
cmp "$TMP/dry-existing-before" "$DRY_EXISTING/.gitignore"
! grep -Fq '/.acon/sessions.json' "$DRY_EXISTING/.gitignore"
! grep -Fq '/.acon/sessions.json.tmp' "$DRY_EXISTING/.gitignore"

# Live and dangling .gitignore symlinks fail before any target or outside write.
printf 'outside ignore sentinel\n' > "$TMP/outside-ignore"
SYMLINK_TARGET="$TMP/symlink-target"
mkdir -p "$SYMLINK_TARGET/.agents"
printf 'Must remain unchanged.\n' > "$SYMLINK_TARGET/AGENTS.md"
printf 'local asset\n' > "$SYMLINK_TARGET/.agents/local-only.md"
ln -s "$TMP/outside-ignore" "$SYMLINK_TARGET/.gitignore"
cp "$TMP/outside-ignore" "$TMP/outside-before"
cp "$SYMLINK_TARGET/AGENTS.md" "$TMP/symlink-agents-before"
if bash "$SOURCE/scripts/adopt.sh" --force "$SYMLINK_TARGET" >/dev/null 2>&1; then
  echo 'expected live .gitignore symlink refusal' >&2
  exit 1
fi
cmp "$TMP/outside-before" "$TMP/outside-ignore"
cmp "$TMP/symlink-agents-before" "$SYMLINK_TARGET/AGENTS.md"
test -L "$SYMLINK_TARGET/.gitignore"
test -f "$SYMLINK_TARGET/.agents/local-only.md"

DANGLING_TARGET="$TMP/dangling-target"
mkdir -p "$DANGLING_TARGET/.agents"
printf 'Must remain unchanged.\n' > "$DANGLING_TARGET/AGENTS.md"
printf 'local asset\n' > "$DANGLING_TARGET/.agents/local-only.md"
ln -s "$TMP/absent-ignore-target" "$DANGLING_TARGET/.gitignore"
cp "$DANGLING_TARGET/AGENTS.md" "$TMP/dangling-agents-before"
if bash "$SOURCE/scripts/adopt.sh" --force "$DANGLING_TARGET" >/dev/null 2>&1; then
  echo 'expected dangling .gitignore symlink refusal' >&2
  exit 1
fi
cmp "$TMP/dangling-agents-before" "$DANGLING_TARGET/AGENTS.md"
test -L "$DANGLING_TARGET/.gitignore"
test ! -e "$TMP/absent-ignore-target"
test -f "$DANGLING_TARGET/.agents/local-only.md"

printf 'adoption fixture assertions passed\n'

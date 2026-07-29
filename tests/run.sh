#!/bin/sh

set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
WRITE="$REPO_ROOT/skills/write-spk/scripts/agentspk-write"
SEARCH="$REPO_ROOT/skills/search-spk/scripts/agentspk-search"
CHECK="$REPO_ROOT/skills/check-spk/scripts/agentspk-check"

TMP_ROOT=${TMPDIR:-/tmp}/agentspk-tests.$$
PASS_COUNT=0

cleanup() {
  rm -rf "$TMP_ROOT"
}
trap cleanup EXIT HUP INT TERM

mkdir -p "$TMP_ROOT"

fail() {
  printf 'not ok - %s\n' "$1" >&2
  exit 1
}

json_assert() {
  JSON_INPUT=$1 EXPR=$2 python3 - <<'PY'
import json
import os
import sys

data = json.loads(os.environ["JSON_INPUT"])
expr = os.environ["EXPR"]
try:
    ok = bool(eval(expr, {"__builtins__": {}}, {"data": data, "len": len, "set": set, "sorted": sorted}))
except Exception as exc:
    print(f"json assertion raised {exc!r}: {expr}", file=sys.stderr)
    print(json.dumps(data, indent=2, sort_keys=True), file=sys.stderr)
    sys.exit(1)
if not ok:
    print(f"json assertion failed: {expr}", file=sys.stderr)
    print(json.dumps(data, indent=2, sort_keys=True), file=sys.stderr)
    sys.exit(1)
PY
  _status=$?
  [ "$_status" -eq 0 ] || fail "JSON assertion failed"
}

content_assert() {
  FILE_PATH=$1 EXPECTED=$2 python3 - <<'PY'
import os
import sys

path = os.environ["FILE_PATH"]
expected = os.environ["EXPECTED"]
with open(path, "r", encoding="utf-8") as handle:
    actual = handle.read()
if actual != expected:
    print(f"content assertion failed for {path}", file=sys.stderr)
    print("--- expected ---", file=sys.stderr)
    print(expected, file=sys.stderr)
    print("--- actual ---", file=sys.stderr)
    print(actual, file=sys.stderr)
    sys.exit(1)
PY
  _status=$?
  [ "$_status" -eq 0 ] || fail "content assertion failed"
}

contains_assert() {
  HAYSTACK=$1 NEEDLE=$2 python3 - <<'PY'
import os
import sys

if os.environ["NEEDLE"] not in os.environ["HAYSTACK"]:
    print(f"expected output to contain: {os.environ['NEEDLE']}", file=sys.stderr)
    print(os.environ["HAYSTACK"], file=sys.stderr)
    sys.exit(1)
PY
  _status=$?
  [ "$_status" -eq 0 ] || fail "contains assertion failed"
}

new_root() {
  mktemp -d "$TMP_ROOT/root.XXXXXX"
}

run_test() {
  _name=$1
  shift
  if "$@"; then
    PASS_COUNT=$((PASS_COUNT + 1))
    printf 'ok %s - %s\n' "$PASS_COUNT" "$_name"
  else
    fail "$_name"
  fi
}

expect_failure_json() {
  _expr=$1
  shift
  set +e
  _output=$("$@" 2>&1)
  _status=$?
  set -e
  [ "$_status" -ne 0 ] || fail "expected command to fail: $*"
  json_assert "$_output" "$_expr"
}

test_entrypoints_and_help() {
  [ -x "$WRITE" ] || fail "write CLI is not executable"
  [ -x "$SEARCH" ] || fail "search CLI is not executable"
  [ -x "$CHECK" ] || fail "check CLI is not executable"
  [ -f "$REPO_ROOT/skills/write-spk/scripts/agentspk-write.ps1" ] || fail "write PowerShell launcher is missing"
  [ -f "$REPO_ROOT/skills/search-spk/scripts/agentspk-search.ps1" ] || fail "search PowerShell launcher is missing"
  [ -f "$REPO_ROOT/skills/check-spk/scripts/agentspk-check.ps1" ] || fail "check PowerShell launcher is missing"

  _out=$($WRITE --help)
  contains_assert "$_out" "agentspk-write"
  _out=$($SEARCH --help)
  contains_assert "$_out" "agentspk-search"
  _out=$($CHECK --help)
  contains_assert "$_out" "agentspk-check"
}

test_write_creates_default_sectioned_sorted_file() {
  _root=$(new_root)
  _out=$($WRITE --root "$_root" \
    --atom 'goal:G_Z | outcome="Z"; metric="m"; target="t"; reason="r"' \
    --atom 'fea:F_A | name="A feature"')

  json_assert "$_out" 'data["ok"] is True and data["changed_files"] == ["spec/specifications.spk"] and [op["action"] for op in data["operations"]] == ["created", "created"]'
  content_assert "$_root/spec/specifications.spk" '# fea
fea:F_A | name="A feature"

# goal
goal:G_Z | outcome="Z"; metric="m"; target="t"; reason="r"
'
}

test_write_rejects_duplicates_and_replaces_in_place() {
  _root=$(new_root)
  $WRITE --root "$_root" --atom 'fea:F_ONE | name="Original"' >/dev/null

  expect_failure_json 'data["ok"] is False and "atom already exists" in data["message"] and data["existing"]["atom"] == "fea:F_ONE"' \
    $WRITE --root "$_root" --atom 'fea:F_ONE | name="Original"'

  _out=$($WRITE --root "$_root" --replace --atom 'fea:F_ONE | name="Updated"')
  json_assert "$_out" 'data["ok"] is True and data["operations"] == [{"action":"replaced","atom":"fea:F_ONE","file":"spec/specifications.spk"}]'
  content_assert "$_root/spec/specifications.spk" '# fea
fea:F_ONE | name="Updated"
'

  _out=$($WRITE --root "$_root" --replace --atom 'fea:F_ONE | name="Updated"')
  json_assert "$_out" 'data["ok"] is True and data["changed_files"] == [] and data["operations"][0]["action"] == "unchanged"'
}

test_write_file_override_and_move() {
  _root=$(new_root)
  _out=$($WRITE --root "$_root" --file custom/features.spk --atom 'fea:F_MOVE | name="Movable"')
  json_assert "$_out" 'data["ok"] is True and data["changed_files"] == ["custom/features.spk"] and data["operations"][0]["action"] == "created"'
  [ -f "$_root/custom/features.spk" ] || fail "custom target file was not created"

  _out=$($WRITE --root "$_root" --replace --file spec/specifications.spk --atom 'fea:F_MOVE | name="Moved"')
  json_assert "$_out" 'data["ok"] is True and data["operations"] == [{"action":"moved","atom":"fea:F_MOVE","file":"spec/specifications.spk"}] and data["deleted_files"] == ["custom/features.spk"]'
  [ ! -e "$_root/custom/features.spk" ] || fail "old custom file was not deleted after move"
  content_assert "$_root/spec/specifications.spk" '# fea
fea:F_MOVE | name="Moved"
'
}

test_write_delete_semantics() {
  _root=$(new_root)
  $WRITE --root "$_root" \
    --atom 'fea:F_DELETE | name="Delete me"' \
    --atom 'goal:G_KEEP | outcome="Keep"; metric="m"; target="t"; reason="r"' >/dev/null

  _out=$($WRITE --root "$_root" --delete 'fea:F_DELETE')
  json_assert "$_out" 'data["ok"] is True and data["operations"] == [{"action":"deleted","atom":"fea:F_DELETE","file":"spec/specifications.spk"}]'
  content_assert "$_root/spec/specifications.spk" '# goal
goal:G_KEEP | outcome="Keep"; metric="m"; target="t"; reason="r"
'

  expect_failure_json 'data["ok"] is False and "cannot be deleted" in data["message"]' \
    $WRITE --root "$_root" --delete 'fea:F_MISSING'
  expect_failure_json 'data["ok"] is False and data["message"] == "invalid delete atom id"' \
    $WRITE --root "$_root" --delete 'fea:F_*'
  expect_failure_json 'data["ok"] is False and "cannot combine" in data["message"]' \
    $WRITE --root "$_root" --atom 'fea:F_NEW | name="New"' --delete 'goal:G_KEEP'
  expect_failure_json 'data["ok"] is False and "--file is not supported" in data["message"]' \
    $WRITE --root "$_root" --file spec/other.spk --delete 'goal:G_KEEP'
  expect_failure_json 'data["ok"] is False and "--replace is not supported" in data["message"]' \
    $WRITE --root "$_root" --replace --delete 'goal:G_KEEP'
}

test_write_rejects_malformed_target_rewrite() {
  _root=$(new_root)
  mkdir -p "$_root/spec"
  printf '%s\n' 'this is not an atom' > "$_root/spec/specifications.spk"

  expect_failure_json 'data["ok"] is False and "malformed atoms" in data["message"] and data["parse_errors"] == ["1:invalid-atom"]' \
    $WRITE --root "$_root" --atom 'fea:F_SAFE | name="Safe"'
  content_assert "$_root/spec/specifications.spk" 'this is not an atom
'
}

test_cli_argument_validation() {
  _root=$(new_root)
  _missing_root="$TMP_ROOT/missing-root"

  expect_failure_json 'data["ok"] is False and "write requires" in data["message"]' \
    $WRITE --root "$_root"
  expect_failure_json 'data["ok"] is False and data["message"] == "invalid atom input"' \
    $WRITE --root "$_root" --atom 'not-an-atom'
  expect_failure_json 'data["ok"] is False and "same atom more than once" in data["message"]' \
    $WRITE --root "$_root" --atom 'fea:F_DUP | name="One"' --atom 'fea:F_DUP | name="Two"'
  expect_failure_json 'data["ok"] is False and "root path does not exist" in data["message"]' \
    $WRITE --root "$_missing_root" --atom 'fea:F_ROOT | name="Root"'
  expect_failure_json 'data["ok"] is False and data["message"] == "unknown argument: --bogus"' \
    $WRITE --bogus

  expect_failure_json 'data["ok"] is False and "root path does not exist" in data["message"]' \
    $SEARCH --root "$_missing_root" --all
  expect_failure_json 'data["ok"] is False and data["message"] == "unknown argument: --bogus"' \
    $SEARCH --bogus

  expect_failure_json 'data["ok"] is False and "root path does not exist" in data["message"]' \
    $CHECK --root "$_missing_root"
  expect_failure_json 'data["ok"] is False and data["message"] == "unknown argument: --bogus"' \
    $CHECK --bogus
}

make_search_fixture() {
  _root=$1
  mkdir -p "$_root/spec"
  cat > "$_root/spec/specifications.spk" <<'EOF'
# beh
beh:B_ONE | when="Thing happens"; then="Feature runs" | rel:uses:fea:F_ONE

# cmp
cmp:C_ONE | name="Component One"; kind="service"; responsibility="help feature"

# fea
fea:F_ONE | name="Feature One"; summary="Searchable feature" | rel:requires:goal:G_ONE,uses:cmp:C_ONE

# goal
goal:G_ONE | outcome="Goal One"; metric="m"; target="t"; reason="r"
EOF
}

test_search_selectors_text_all_and_errors() {
  _root=$(new_root)
  make_search_fixture "$_root"

  _out=$($SEARCH --root "$_root" --all)
  json_assert "$_out" 'data["ok"] is True and data["all"] is True and data["files_scanned"] == 1 and [m["atom"] for m in data["matches"]] == ["beh:B_ONE", "cmp:C_ONE", "fea:F_ONE", "goal:G_ONE"]'

  _out=$($SEARCH --root "$_root" --selector 'fea:F_*')
  json_assert "$_out" 'data["ok"] is True and data["selectors"] == ["fea:F_*"] and [m["atom"] for m in data["matches"]] == ["fea:F_ONE"]'

  _out=$($SEARCH --root "$_root" --selector 'goal:G_ONE' --selector 'cmp:C_ONE')
  json_assert "$_out" 'data["ok"] is True and [m["atom"] for m in data["matches"]] == ["cmp:C_ONE", "goal:G_ONE"]'

  _out=$($SEARCH --root "$_root" --text 'Feature One')
  json_assert "$_out" 'data["ok"] is True and data["text"] == ["Feature One"] and [m["atom"] for m in data["matches"]] == ["fea:F_ONE"]'

  _out=$($SEARCH --root "$_root" --selector 'fea:*' --text 'Searchable')
  json_assert "$_out" 'data["ok"] is True and [m["atom"] for m in data["matches"]] == ["fea:F_ONE"]'

  expect_failure_json 'data["ok"] is False and "provide --all" in data["message"]' \
    $SEARCH --root "$_root"
  expect_failure_json 'data["ok"] is False and data["message"] == "invalid regex: ["' \
    $SEARCH --root "$_root" --text '['
}

test_search_skips_malformed_atoms() {
  _root=$(new_root)
  mkdir -p "$_root/spec"
  cat > "$_root/spec/specifications.spk" <<'EOF'
this is not an atom
fea:F_VALID | name="Valid"
EOF

  _out=$($SEARCH --root "$_root" --all)
  json_assert "$_out" 'data["ok"] is True and data["files_scanned"] == 1 and [m["atom"] for m in data["matches"]] == ["fea:F_VALID"]'
}

test_search_include_related_depth() {
  _root=$(new_root)
  make_search_fixture "$_root"

  _out=$($SEARCH --root "$_root" --selector 'fea:F_ONE' --include-related --depth 0)
  json_assert "$_out" 'data["ok"] is True and data["include_related"] is True and [m["atom"] for m in data["matches"]] == ["fea:F_ONE"] and data["related"] == []'

  _out=$($SEARCH --root "$_root" --selector 'fea:F_ONE' --include-related --depth 1)
  json_assert "$_out" 'data["ok"] is True and [m["atom"] for m in data["matches"]] == ["fea:F_ONE"] and [r["atom"] for r in data["related"]] == ["beh:B_ONE", "cmp:C_ONE", "goal:G_ONE"]'
}

test_check_valid_atomset() {
  _root=$(new_root)
  mkdir -p "$_root/spec" "$_root/docs"
  printf '%s\n' 'referenced document' > "$_root/docs/ref.md"
  cat > "$_root/spec/specifications.spk" <<'EOF'
# cmp
cmp:C_VALID | name="Valid Component"; kind="service"; responsibility="serve" | rel:uses:api:A_VALID | ref:doc:"docs/ref.md"

# api
api:A_VALID | name="Valid API"; summary="api"; protocol="cli"; version="1"
EOF

  _out=$($CHECK --root "$_root")
  json_assert "$_out" 'data["ok"] is True and data["summary"] == {"atoms": 2, "errors": 0, "files_scanned": 1, "warnings": 0} and data["issues"] == []'
}

test_check_reports_validation_issues() {
  _root=$(new_root)
  mkdir -p "$_root/spec"
  cat > "$_root/spec/specifications.spk" <<'EOF'
fea:F_DUP | name="First duplicate"
fea:F_DUP | name="Second duplicate"
this is not an atom
beh:B_MISSING | when="bad"; then="bad" | rel:uses:api:A_MISSING | ref:doc:"missing.md"
cmp:C_ALONE | name="Alone"; kind="service"; responsibility="none"
EOF

  _out=$($CHECK --root "$_root")
  json_assert "$_out" 'data["ok"] is True and data["summary"]["errors"] == 4 and data["summary"]["warnings"] >= 1 and {issue["code"] for issue in data["issues"]} >= {"parse_error", "duplicate_atom", "missing_relation_target", "missing_reference_path", "strangler_atom"}'
}

test_agents_instructions_use_explicit_decision_workflow() {
  for _file in "$REPO_ROOT/AGENTS.md" "$REPO_ROOT/INSTALL_AGENTSPK.md"; do
    _content=$(cat "$_file")
    contains_assert "$_content" "Before editing: decide whether to search"
    contains_assert "$_content" "MUST search AgentSPK before editing if any answer is yes"
    contains_assert "$_content" "A search with no match is not a reason to stop"
    contains_assert "$_content" "Before finishing: decide whether to write"
    contains_assert "$_content" "MUST update AgentSPK before finishing"
    contains_assert "$_content" "Never invent AgentSPK commands"
  done

  _install=$(cat "$REPO_ROOT/INSTALL_AGENTSPK.md")
  contains_assert "$_install" '.agents/skills/search-spk/SKILL.md'
  contains_assert "$_install" '.agents/skills/write-spk/SKILL.md'

  _self_hosted=$(cat "$REPO_ROOT/AGENTS.md")
  contains_assert "$_self_hosted" '`skills/search-spk/SKILL.md`'
  contains_assert "$_self_hosted" '`skills/write-spk/SKILL.md`'
}

run_test "entrypoints and help" test_entrypoints_and_help
run_test "AGENTS instructions use explicit decision workflow" test_agents_instructions_use_explicit_decision_workflow
run_test "write creates default sectioned sorted file" test_write_creates_default_sectioned_sorted_file
run_test "write rejects duplicates and replaces in place" test_write_rejects_duplicates_and_replaces_in_place
run_test "write file override and move" test_write_file_override_and_move
run_test "write delete semantics" test_write_delete_semantics
run_test "write rejects malformed target rewrite" test_write_rejects_malformed_target_rewrite
run_test "CLI argument validation" test_cli_argument_validation
run_test "search selectors text all and errors" test_search_selectors_text_all_and_errors
run_test "search skips malformed atoms" test_search_skips_malformed_atoms
run_test "search include-related depth" test_search_include_related_depth
run_test "check valid atomset" test_check_valid_atomset
run_test "check reports validation issues" test_check_reports_validation_issues

printf '1..%s\n' "$PASS_COUNT"

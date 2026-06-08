---
name: write-spk
description: Create, update, and intentionally replace AgentSPK atoms in .spk files when durable specification knowledge should be recorded.
compatibility: Requires a POSIX shell for scripts/agentspk-write. On Windows, scripts/agentspk-write.ps1 requires bash, sh, or WSL.
---

# Write SPK Skill

Use this skill when you need to create, update, or intentionally move atoms between `.spk` files. AgentSPK is durable specification memory, not an activity log.

## Available Scripts

- `scripts/agentspk-write` - POSIX shell CLI for write operations.
- `scripts/agentspk-write.ps1` - PowerShell launcher for the bundled write CLI.

## Canonical Command

```bash
scripts/agentspk-write
```

```powershell
pwsh -File scripts/agentspk-write.ps1
```

## Rules

- Do not hand-edit `.spk` files when this tool is available.
- By default, new atoms are stored in `spec/specifications.spk`.
- By default, replacing an existing atom updates the matched atom in place.
- Pass `--file` only when you intentionally want a specific target file.
- Pass one or more complete atom lines with repeated `--atom` arguments.
- Only pass `--replace` when you intentionally want to override an existing `type:id`.
- If the tool refuses a duplicate and you did not mean to replace it, stop and choose a new ID.
- Always write atom content in English, even if the user is speaking another language.
- Use this skill when user conversation or implementation work produces durable specification knowledge, not only when the user explicitly names `.spk` files.
- Do not record routine implementation steps, command results, formatting, mechanical refactors, small fixes, or details that are immediately discoverable from source code.
- Prefer one compact atom for a cohesive feature, interface, configuration set, or design decision, with `ref` entries pointing to detailed code or docs.
- Split into multiple atoms only when a subtopic has independently important specification, relations, or retrieval value.
- Use `chg` only for historical changes future agents must know to understand why current specification or code exists, such as legacy migrations or deprecated-but-still-present behavior. Do not create `chg` atoms for every code change.

## Behavior Guarantees

The tool rewrites managed `.spk` files mechanically so diffs stay predictable:

- new atoms use `spec/specifications.spk` by default
- touched files are rendered as type sections with blank lines between sections
- atoms inside each section are sorted by id
- existing atoms with the same `type:id` are rejected unless `--replace` is present

## Examples

Create a new atom:

```bash
scripts/agentspk-write --root . --atom 'goal:G_CART_RECOVERY | outcome="increase resumed purchases"; metric="saved-for-later conversion"; target="15%"; reason="buyers often leave before checkout"'
```

The default output path for that atom is `spec/specifications.spk`.

Update an existing atom intentionally:

```bash
scripts/agentspk-write --root . --replace --atom 'goal:G_CART_RECOVERY | outcome="increase resumed purchases"; metric="saved-for-later conversion"; target="20%"; reason="buyers often leave before checkout"'
```

Write multiple atoms in one call:

```bash
scripts/agentspk-write --root . --atom 'uss:U_SAVE | as="buyer"; want="save items for later"; because="I may purchase later from another device" | rel:requires:fea:F_SAVE' --atom 'fea:F_SAVE | name="Save For Later" | rel:requires:beh:B_SAVE,uses:api:A_CART'
```

## Output

The command returns JSON describing:

- whether the operation succeeded
- which files changed
- which atoms were created, replaced, moved, or left unchanged

Use that JSON as the source of truth instead of inferring what happened from git diffs alone.

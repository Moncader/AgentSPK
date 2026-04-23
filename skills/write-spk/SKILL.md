---
name: write-spk
description: Create, update, and intentionally replace AgentSPK atoms in .spk files. Use when the user defines specifications, requirements, features, behaviors, interfaces, data models, technical decisions, or when implementation work produces durable specification knowledge that should be recorded.
compatibility: Requires a POSIX shell for scripts/agentspk-write. On Windows, scripts/agentspk-write.ps1 requires bash, sh, or WSL.
---

# Write SPK Skill

Use this skill when you need to create, update, or intentionally move atoms between `.spk` files.

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
- Default writes to `spec/specifications.spk` unless the user or repository rules explicitly choose another `.spk` file.
- Pass `--file` only when you intentionally want a different target file.
- Pass one or more complete atom lines with repeated `--atom` arguments.
- Only pass `--replace` when you intentionally want to override an existing `type:id`.
- If the tool refuses a duplicate and you did not mean to replace it, stop and choose a new ID.
- Always write atom content in English, even if the user is speaking another language.
- Use this skill when user conversation or implementation work produces durable specification knowledge, not only when the user explicitly names `.spk` files.

## Behavior Guarantees

The tool rewrites managed `.spk` files mechanically so diffs stay predictable:

- atoms are sorted by type and id
- existing atoms with the same `type:id` are rejected unless `--replace` is present

## Examples

Create a new atom:

```bash
scripts/agentspk-write --root . --atom 'goal:G_CART_RECOVERY | outcome="increase resumed purchases"; metric="saved-for-later conversion"; target="15%"; reason="buyers often leave before checkout"'
```

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

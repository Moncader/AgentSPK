---
name: search-spk
description: Load AgentSPK atoms by id, wildcard, text pattern, related references, or full atomset. Use before modifying implementation, when exploring specifications, or when the user asks about requirements, features, behaviors, APIs, data models, constraints, or technical decisions.
compatibility: Requires a POSIX shell for scripts/agentspk-search. On Windows, scripts/agentspk-search.ps1 requires bash, sh, or WSL.
---

# Search SPK Skill

Use this skill when you need to load one atom, many atoms, wildcard matches, related atoms, or the full atomset.

## Available Scripts

- `scripts/agentspk-search` - POSIX shell CLI for search operations.
- `scripts/agentspk-search.ps1` - PowerShell launcher for the bundled search CLI.

## Canonical Command

```bash
scripts/agentspk-search
```

```powershell
pwsh -File scripts/agentspk-search.ps1
```

## Rules

- Prefer `--selector` when you know the atom `type:id` or a wildcard pattern.
- Use repeated `--selector` arguments to load multiple atoms in one call.
- Use `--text` for grep-style regex matching against atom lines.
- Use `--include-related` when you need incoming and outgoing neighbors of the matched atoms.
- Use `--all` when you need the entire atomset for overall project understanding.
- Before changing implementation in any create, read, update, delete, repair, or refactor flow, search AgentSPK first for relevant context.
- If the user is speaking another language, translate the intent conceptually and search AgentSPK in English because the atomset should stay English.

## Selector Semantics

- Selectors are matched against `type:id` using glob-style wildcards.
- Exact example: `beh:B_SAVE`
- Wildcard example: `beh:B_*`
- Cross-type example: `*:B_SAVE`

## Examples

Load one atom:

```bash
scripts/agentspk-search --root . --selector 'beh:B_SAVE'
```

Load multiple atoms:

```bash
scripts/agentspk-search --root . --selector 'goal:G_CART_RECOVERY' --selector 'fea:F_SAVE'
```

Load wildcard matches plus their neighbors:

```bash
scripts/agentspk-search --root . --selector 'cmp:C_*' --include-related --depth 1
```

Load by text pattern:

```bash
scripts/agentspk-search --root . --text 'save items'
```

Load the full atomset:

```bash
scripts/agentspk-search --root . --all
```

## Output

The command returns JSON with:

- the direct matches
- any related atoms requested via `--include-related`

Malformed atoms are skipped silently. Use the check skill when you need validation.

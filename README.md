# AgentSPK

![Status](https://img.shields.io/badge/status-experimental-blue)
![Format](https://img.shields.io/badge/format-SPK-6f42c1)
![Tooling](https://img.shields.io/badge/tooling-posix%20sh%20%2B%20pwsh-4EAA25)

AgentSPK is a repo-native specification format for AI coding agents. It stores project knowledge as compact, one-line `.spk` atoms so an agent can reload intent, behavior, constraints, and history without depending on external memory systems.

## Why AgentSPK

- Git-friendly plain text with stable, conflict-resistant diffs.
- Low-context files that are easy to grep and reload.
- Recoverable project knowledge after context loss or session boundaries.
- Model-agnostic storage that works with local or hosted agents.
- Session-friendly guidance so agents search and write specs only when durable context is needed.

## Example

```text
uss:U_SAVE | as="buyer"; want="save items for later"; because="I may purchase later from another device" | rel:requires:fea:F_SAVE
fea:F_SAVE | name="Save For Later" | rel:requires:beh:B_SAVE,uses:api:A_CART
beh:B_SAVE | when="buyer saves an item for later"; then="system moves the item out of the active cart" | rel:uses:api:A_CART
```

## Repository Contents

- `docs/specification-model.md`: the specification philosophy and atom taxonomy.
- `docs/spk-format.md`: the formal SPK line format, rules, and canonical keys.
- `skills/write-spk/`: an Agent Skills package for writing and updating atoms.
- `skills/search-spk/`: an Agent Skills package for loading atoms and related context.
- `skills/check-spk/`: an Agent Skills package for validating an atomset.
- `INSTALL_AGENTSPK.md`: self-contained install instructions for another repo.
- `examples/cart/`: a small example atomset and referenced file.

## Tooling

AgentSPK packages its tooling inside the skill directories using the Agent Skills layout. Repository-local examples:

```bash
skills/write-spk/scripts/agentspk-write --root . --atom 'goal:G1 | outcome="..."; metric="..."; target="..."; reason="..."'
skills/write-spk/scripts/agentspk-write --root . --delete 'goal:G1'
skills/search-spk/scripts/agentspk-search --root . --selector 'beh:B_*' --include-related
skills/check-spk/scripts/agentspk-check --root .
```

The CLI guarantees:

- sectioned default storage for new atoms in `spec/specifications.spk`
- deterministic atom sorting by type and id within touched files
- explicit duplicate replacement via `--replace`
- exact atom deletion via repeated `--delete 'type:id'`
- machine-readable JSON output for agents

By default, new atoms go to `spec/specifications.spk`. Touched files are rendered as type sections with blank lines between sections, replacements update matched atoms in place unless `--file` is explicitly provided, and deletes require exact `type:id` matches.

## Installing In Another Project

Tell the target AI agent to read and follow `INSTALL_AGENTSPK.md`.

That file explains:

- which files to copy into the target repository
- how to upgrade an existing AgentSPK install
- what to add to `AGENTS.md`
- where to place the AgentSPK tool and skills

## Documentation

- [Specification Model](docs/specification-model.md)
- [SPK Format](docs/spk-format.md)
- [Write Skill](skills/write-spk/SKILL.md)
- [Search Skill](skills/search-spk/SKILL.md)
- [Check Skill](skills/check-spk/SKILL.md)

## Status

AgentSPK is experimental. The format and tooling are intentionally simple and deterministic, but they should still be treated as evolving.

## Contributing

Issues and pull requests are welcome. Favor repo-native, plain-text, deterministic changes that are easy for both humans and agents to review.

## License

A license has not been added to this repository yet.

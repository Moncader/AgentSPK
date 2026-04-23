# SPK Format

SPK is a one-line-per-atom specification format for AI agents.

## Purpose

- keep project specifications compact and grepable
- minimize context cost when reloading project knowledge
- preserve specifications as repo-native text files

## Atom Shape

```text
<type>:<id> | <key>="<value>"[; <key>="<value>"]... [| rel:<verb>:<type>:<id>[,<verb>:<type>:<id>...]] [| ref:<kind>:"<path>"[,<kind>:"<path>"...]]
```

## Core Rules

- Exactly one atom per line.
- The first field is always `<type>:<id>`.
- The second field is always the body.
- The body is `key="value"` pairs separated by `;`.
- All values are quoted.
- `rel` is optional.
- `ref` is optional.
- If both exist, the order is body, then `rel`, then `ref`.
- Keys must not repeat within one atom.
- IDs should be unique within their type.
- Reference paths should be repo-root relative so tooling can validate them consistently.

## Types

- `goal`: implementation-relevant goal
- `uss`: user story
- `fea`: feature or capability
- `upn`: user persona
- `beh`: behavior
- `cmp`: component
- `api`: interface or API
- `dat`: data model
- `arc`: system structure or architecture
- `nfr`: non-functional requirement
- `tcn`: technical constraint
- `rcr`: regulatory or compliance requirement
- `asm`: assumption
- `tds`: technical design decision
- `cfg`: configuration
- `chg`: important historical change
- `dep`: deprecation
- `grp`: retrieval or targeting group

## Relation Verbs

- `requires`
- `defines`
- `affects`
- `uses`
- `replaces`
- `belongs`

## Reference Kinds

- `openapi`
- `sql`
- `proto`
- `graphql`
- `jsonschema`
- `file`
- `doc`

## Canonical Keys

- `goal`: `outcome`, `metric`, `target`, `reason`
- `uss`: `as`, `want`, `because`
- `fea`: `name`, `summary`, `notes`
- `upn`: `name`, `summary`, `traits`
- `beh`: `when`, `then`, `invariant`, `unless`, `notes`
- `cmp`: `name`, `kind`, `responsibility`, `notes`
- `api`: `name`, `summary`, `protocol`, `version`
- `dat`: `name`, `summary`, `kind`, `storage`
- `arc`: `style`, `nodes`, `flow`, `notes`
- `nfr`: `concern`, `rule`, `metric`, `target`
- `tcn`: `scope`, `rule`, `reason`
- `rcr`: `scope`, `rule`, `source`
- `asm`: `claim`, `risk`, `fallback`
- `tds`: `decision`, `reason`, `tradeoff`
- `cfg`: `key`, `value`, `scope`, `required`, `notes`
- `chg`: `change`, `reason`, `scope`, `notes`
- `dep`: `target`, `replacement`, `rule`, `reason`
- `grp`: `name`, `summary`, `scope`

For `fea`, only `name` is required. `summary` and `notes` are optional.

## Extension Rule

- Prefer canonical keys.
- If no canonical key fits without distortion, introduce a new key.
- Do not invent synonyms of an existing canonical key.

## Examples

```text
uss:U_SAVE | as="buyer"; want="save items for later"; because="I may purchase later from another device" | rel:requires:fea:F_SAVE
fea:F_SAVE | name="Save For Later"; summary="lets buyers move cart items out of checkout" | rel:requires:beh:B_SAVE,uses:api:A_CART
```

# SPK Format

SPK stores each specification atom on its own line for AI agents.

## Purpose

- keep project specifications compact and grepable
- minimize context cost when reloading project knowledge
- preserve specifications as repo-native text files
- reduce merge conflicts by separating atoms into deterministic type sections

## Atom Shape

```text
<type>:<id> | <key>="<value>"[; <key>="<value>"]... [| rel:<verb>:<type>:<id>[,<verb>:<type>:<id>...]] [| ref:<kind>:"<path>"[,<kind>:"<path>"...]]
```

## Core Rules

- Exactly one atom per line.
- A `.spk` file may contain one atom or many atoms.
- The first field is always `<type>:<id>`.
- The second field is always the body.
- The body is `key="value"` pairs separated by `;`.
- All values are quoted.
- `rel` is optional.
- `ref` is optional.
- If both exist, the order is body, then `rel`, then `ref`.
- Keys must not repeat within one atom.
- IDs should be unique within their type.
- Prefer stable ASCII IDs using letters, digits, `_`, `-`, or `.` so atoms sort and grep predictably.
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
- `chg`: historical change required to understand why current specification or code exists
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

## Atom Granularity

- Prefer one compact atom for a cohesive feature, interface, behavior, configuration set, data model, or design decision.
- Use `ref` entries to point to detailed code or documentation instead of copying every implementation detail into atom values.
- Split details into separate atoms only when they have independently important specification, relations, lifecycle, or retrieval value.
- Use one overview atom as the lookup point when a topic needs multiple detail atoms.
- Use `chg` only for historical rationale such as legacy migrations or deprecated-but-still-present behavior, not for every implementation change.

## Storage Layout

- Tools must treat the atomset as all `.spk` files under the repository root.
- The default writer stores new atoms in `spec/specifications.spk`.
- Touched files are rendered as type sections with blank lines between sections.
- Atoms within each touched file are sorted by `type:id`.
- Replacing an existing atom without `--file` updates the matched atom in place.
- Passing `--file` intentionally overrides the default target path.
- Same-type concurrent edits can still conflict when they touch the same insertion point; resolve those conflicts by preserving each intended atom line in sorted order.

## Extension Rule

- Prefer canonical keys.
- If no canonical key fits without distortion, introduce a new key.
- Do not invent synonyms of an existing canonical key.

## Examples

```text
uss:U_SAVE | as="buyer"; want="save items for later"; because="I may purchase later from another device" | rel:requires:fea:F_SAVE
fea:F_SAVE | name="Save For Later"; summary="lets buyers move cart items out of checkout" | rel:requires:beh:B_SAVE,uses:api:A_CART
```

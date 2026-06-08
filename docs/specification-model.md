# Specification Model

AgentSPK treats a project specification as a set of small, implementation-relevant units called atoms.

The format is optimized for a practical AI-agent workflow:

- store durable project knowledge in the repository
- keep the context footprint small enough to reload quickly
- make relationships grepable and reviewable in git
- let agents recover from lost or compressed context
- let agents cache loaded specification context within a session instead of rereading it every turn

The files are AI-first, but still readable by humans when needed.

## Atom Groups

Each atom type belongs to one of five logical groups, plus one meta-type used for retrieval and targeting.

### Intent

- Goals (`goal`): implementation-relevant outcomes the product should achieve, including measurable targets and reasons.
- User Stories (`uss`): user-perspective problem statements in the form "As a ..., I want ..., because ...".

### Definition

- Features (`fea`): user-visible or system-level capabilities that bridge user stories and implementation atoms.
- User Personas (`upn`): archetypal representations of target users.
- Behaviors (`beh`): concrete system behavior, rules, flows, and state transitions.
- Components (`cmp`): structural units such as UI elements, services, or modules.
- Interfaces (`api`): contracts between components or external systems.
- Data Models (`dat`): data structure and relationship definitions.
- System Structure (`arc`): high-level architecture needed to guide implementation.

### Constraint

- Non-Functional Requirements (`nfr`): performance, scalability, security, reliability, and similar concerns.
- Technical Constraints (`tcn`): required technologies, platforms, or implementation limits.
- Regulatory / Compliance Requirements (`rcr`): legal or policy requirements such as GDPR or HIPAA.
- Assumptions (`asm`): assumptions that materially affect implementation decisions.

### Execution

- Technical Designs (`tds`): concrete implementation decisions and tradeoffs.
- Configurations (`cfg`): runtime or environment configuration that affects behavior.

### Evolution

- Changes (`chg`): historical changes future agents must know to understand why current specification or code exists, especially legacy migrations or deprecated-but-still-present behavior.
- Deprecations (`dep`): removals and replacements of existing definitions.

### Group

- Group (`grp`): a semantic grouping of related atoms for retrieval, planning, or feature targeting.

## Opinionated Scope

AgentSPK has an opinionated view of what belongs in a project specification. The syntax is still extensible, but the default taxonomy is intentionally narrow so agents can reason about the atomset consistently.

The goal is not to replace every other project document. The goal is to capture the parts of a specification that agents repeatedly need when implementing, revisiting, or extending a system.

AgentSPK is not an activity log. Do not record routine implementation steps, command results, formatting, small fixes, mechanical refactors, or details that are immediately discoverable in source code.

## Retrieval Discipline

Agents should search AgentSPK when they need durable specification context that is not already available from the conversation, loaded atoms, or inspected source files. Within one session, an agent should reuse prior AgentSPK search results and assume no external human or source/spec changes occurred unless the user says so or tools show evidence of it.

## Atom Granularity

Prefer compact atoms that summarize a cohesive area and point to detailed code or documentation with `ref` entries. For example, a CLI's arguments should usually be summarized in one interface or configuration atom with a reference to the command implementation or docs.

Split a topic into multiple atoms only when a subtopic has independently important specification, relations, ownership, lifecycle, or retrieval value. When details are too numerous, use one overview atom as the lookup point and relate it to focused detail atoms.

## Historical Changes

Use `chg` sparingly. A `chg` atom should explain historical rationale required to understand current specification or code, such as a migration from a legacy system or a behavior whose old specification still exists but is deprecated. Do not create `chg` atoms merely because an agent changed code during a session.

## Storage Layout

The writer's default storage is a sectioned shared file: new atoms go to `spec/specifications.spk`, and touched files are rendered as type sections with blank lines between sections and deterministic sorting by type and id. Replacements update the matched atom in place, and `--file` is an explicit override. The default optimizes for one grep-friendly location.

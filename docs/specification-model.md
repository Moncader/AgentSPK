# Specification Model

AgentSPK treats a project specification as a set of small, implementation-relevant units called atoms.

The format is optimized for a practical AI-agent workflow:

- store durable project knowledge in the repository
- keep the context footprint small enough to reload quickly
- make relationships grepable and reviewable in git
- let agents recover from lost or compressed context

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

- Changes (`chg`): important historical changes that future agents may need to understand.
- Deprecations (`dep`): removals and replacements of existing definitions.

### Group

- Group (`grp`): a semantic grouping of related atoms for retrieval, planning, or feature targeting.

## Opinionated Scope

AgentSPK has an opinionated view of what belongs in a project specification. The syntax is still extensible, but the default taxonomy is intentionally narrow so agents can reason about the atomset consistently.

The goal is not to replace every other project document. The goal is to capture the parts of a specification that agents repeatedly need when implementing, revisiting, or extending a system.

# AgentSPK

This is a repo for defining a specification to define specifications that AI agents can efficiently understand without using a large amount of context.

It is a set of files of type `.spk` (pronounced speck).

Each spk file is a set of one-line, greppable, compact definitions of a part of a project specification.

With the help of a single part in an AGENTS.md file, any LLM, local or cloud, can understand how to read a spk file and therefore no tools are strictly required to use this specification.

However AgentSPK also provides agent tools and skills to be able to more efficiently read and write to these specifications. Along with sub-agents that can use these skills directly and specifically. 

It's possible for a human to read these files, but they are absolutely aimed towards AI agents for reading.

The philosophy behind using this format is that a coding agent in modern (early 2026) times has the ability to code whatever instructions are given to them with quite high degree of quality. Problems only occur when the their tasks are stretched over multiple sessions, or when their context gets compressed or too large and they begin to 'forget' things.

This format is designed so that when an agent has lost past context, it is able to recover it by reading parts of these spk files. The files themselves are quite terse as well, and especially with a cloud model, easily able to load the entire file in to a single context for a full logical understanding of the project's specifications in full.

This allows an agent to not only code, but also write human-oriented documentation from the spk files as well.

The reason a spk file is in text format on not using a vector database like other 'memory' methods is to be git friendly as well as avoiding external dependencies to load those vector database entries for the agent.

These files are orchestrator/model agnostic and be used with you favourite agent and in a worse-case scenario, can be read by a human if needed.

# Opiniated Views on Project Specifications
AgentSPK is has an opiniated view on how you should define specifications for a project. The SPK file format specifically only supports these opinions. However the syntax is extendable for your own project if you want to rewrite the types for your own project. In the end, all of this is just text based. The tools that the skills use are purposely not tied down to the opiniated views and should not need editing. The skills however are and would need an edit to use.

## Types
A project specification is made up of many single units called specification `atoms`.

Each atom has a `type` that defines some different meaning in a project specification.

Each type belongs logically to one of 5 groups, or reasons for existance:
- Intent: Why
- Definition: What
- Constraint: Limits
- Execution: How
- Evolution: Change over time

There is also a special meta-types so-to-say that help organize information semantically.
- Group: Logically group atoms together for instant and quick access and greppable understanding of relationships between atoms. Can be used for system level logic grouping as well as grouping for project management. For example, a milestone or a way to request an agent to implement a 'feature group' by just simply specifying which 'group' to do.

Below are the types in the format `NAME:SPK_FILE_ABBRIVIATION: DESCRIPTION`

### Intent
- Goals:goal: High-level description of what the product aims to achieve, concrete goals the business wants to accomplish. Includes concepts like KPI. Agents should implement goals so that it's possible to know if a goal has been achieved or not.
- User Stories:uss: Becomes "Why" from a user persona's perspective for the existence of something in the system. A problem statement. As a {user persona} I want to do {action} because {why}.

### Definition
- User Personas:upn: Archetypal representations of target users.
- Behaviors:beh: Concrete description of what the system does (flows, rules, state transitions).
- Components:cmp: Structural units of the system (UI elements, services, modules).
- Interfaces:api: Contracts between components or external systems. Can reference a definition file instead of define inline here.
- Data Models:dat: Structure and relationships of data. Can reference a definition file instead of define inline here.
- System Structure:arc: High-level architecture required to guide implementation.
 
### Constraint
- Non-Functional Requirements:nfr: Performance, scalability, security, etc.
- Technical Constraints:tcn: Required technologies, platforms, or limitations.
- Regulatory / Compliance Requirements:rcr: Legal constraints (e.g., GDPR, HIPAA).
- Assumptions:asm: Must be tracked because breaking them invalidates implementation decisions.

### Execution
- Technical Designs:tds: Concrete implementation decisions (this replaces most ADR value for agents).
- Configurations:cfg: Environment or runtime configuration affecting behavior.

### Evolution
- Changes:chg: Modifications to any existing atom (primary driver of iteration). Should not track _all_ changes. Just changes that might need to leave behind historical knowledge for future implementations or atoms.
- Deprecations:dep: Signals removal or replacement of existing definitions.

### Group
- Group:grp: A list of atoms that should be grouped together.

# SPK File Format
Purpose:
- SPK is a one-line-per-atom specification format for AI agents.
- It is optimized for grepability, low context cost, and repo-native storage.

Atom shape:
- <type>:<id> | <key>="<value>"[; <key>="<value>"]... [| rel:<verb>:<type>:<id>[,<verb>:<type>:<id>...]] [| ref:<kind>:"<path>"[,<kind>:"<path>"...]]

Core rules:
- Exactly one atom per line.
- First field is always <type>:<id>.
- Second field is always the body.
- Body is key="value" pairs separated by `;`.
- All values are quoted.
- `rel` is optional.
- `ref` is optional.
- If both exist, order is: body, rel, ref.
- Keys must not repeat within one atom.
- IDs should be unique within their type.

Types:
- goal  = implementation-relevant goal
- uss   = user story
- upn   = user persona
- beh   = behavior
- cmp   = component
- api   = interface / API
- dat   = data model
- arc   = system structure / architecture
- nfr   = non-functional requirement
- tcn   = technical constraint
- rcr   = regulatory / compliance requirement
- asm   = assumption
- tds   = technical design decision
- cfg   = configuration
- chg   = important historical change
- dep   = deprecation
- grp   = retrieval / targeting group

Relation verbs:
- requires
- defines
- affects
- uses
- replaces
- belongs

Reference kinds:
- openapi
- sql
- proto
- graphql
- jsonschema
- file
- doc

Canonical keys:
- goal: outcome, metric, target, reason
- uss: as, want, because
- upn: name, summary, traits
- beh: when, then, invariant, unless, notes
- cmp: name, kind, responsibility, notes
- api: name, summary, protocol, version
- dat: name, summary, kind, storage
- arc: style, nodes, flow, notes
- nfr: concern, rule, metric, target
- tcn: scope, rule, reason
- rcr: scope, rule, source
- asm: claim, risk, fallback
- tds: decision, reason, tradeoff
- cfg: key, value, scope, required, notes
- chg: change, reason, scope, notes
- dep: target, replacement, rule, reason
- grp: name, summary, scope

Extension rule:
- Prefer canonical keys.
- If no canonical key fits without distortion, a new key may be introduced.
- Do not invent synonyms of existing keys.

Examples:
- uss:U_SAVE | as="buyer"; want="save items for later"; because="I may purchase later from another device"
- api:A_CART | name="Cart API"; protocol="http" | ref:openapi:"spec/cart.openapi.yaml"
- chg:CH_SAVE | change="cart now supports saved-for-later items" | rel:affects:beh:B_ADD_ITEM,affects:dat:D_CART_ITEM

# TODO for AI
- Rewrite this README.md file to make it in to a more proper github hosted OSS project with proper sections, badges (if they make sense for this kind of thing). If that means splitting this file up in to multiple files. Fine.
- Write a skill for writing spk files. This skill should be predictable in it's output. An AI should use a tool defined by the skill to write specific files, in a specific fashion. And the tools should mechanically keep the file organized to reduce git diffs, as well as to keep the file logically clean and in order (like sorting). If the AI asks to write an atom with the same ID as one that already exists, it should be overridden. However, only if the AI understands that it's overridding something via a flag. This is to avoid the AI accidently defining an atom that it didn't know about that already existed.
- Write a skill for searching spk files for a given specifcation atom. Instead of leaving the usage of the grep tools and such up to the AI agent, a custom skill/tool combo should exist that ultimately does the same kind of grep search, but will search and pick up all atoms related to what the AI agent wants. It should have the ability to return multiple hits from wildcard searching, as well as simply accept multiple arguments to load multiple atoms at the same time. There should be the ability to load the entire atomset as well for overall project understanding when required.
- Write a file whose sole purpose is to be a file to 'install' AgentSPK in to a given project via an AI agent. Instructions to add AgentAPK to your own repo will be on a separate website (out of scope here) that will simply say, "Tell your AI Agent to read and follow the instructions of this file: xxxxx" where xxxxx is this file in question. Instructions should include things like 'write xxx in to the AGENTS.md file', or 'write xxxx to yyyy/zzzz'.
- Write a skill with an associated tool that has the ability to check the sanity of all the atoms for the project to make sure all references are valid, and that there are no stranglers that aren't referenced by anything. This tool doesn't 'error' when it finds issues, it just returns issues in a format that an AI agent can understand and attempt to fix itself.

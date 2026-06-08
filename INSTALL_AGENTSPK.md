# Install AgentSPK Into Another Repository

This file is meant to be read and followed by an AI agent.

## Goal

Install or upgrade the AgentSPK tool and skill set in the current repository so future agents can read, write, search, and validate `.spk` files predictably.

## Required Result

Create these files in the target repository:

- `.agents/skills/write-spk/`
- `.agents/skills/search-spk/`
- `.agents/skills/check-spk/`

Update or create this file in the target repository:

- `AGENTS.md`

## Copy Instructions

For a fresh install or upgrade, copy the exact contents of these source files from the AgentSPK repository into the target repository:

- `skills/write-spk/` -> `.agents/skills/write-spk/`
- `skills/search-spk/` -> `.agents/skills/search-spk/`
- `skills/check-spk/` -> `.agents/skills/check-spk/`

Do not rename the installed skill directories unless the user explicitly asks for a different layout.
If the target repository supports file permissions, mark each installed `scripts/agentspk-write`, `scripts/agentspk-search`, and `scripts/agentspk-check` file as executable when present.

## Upgrade Instructions

When upgrading an existing AgentSPK install:

- Replace only the installed AgentSPK skill directories listed above with the source repository's current versions.
- Update the target `AGENTS.md` AgentSPK section to match the current block below, preserving unrelated project instructions.
- Do not rewrite existing `.spk` atoms as part of the upgrade unless the user asks or validation reports a format issue that must be repaired.
- Do not create `chg` atoms merely to record that the tool was upgraded.
- After copying files, run the post-install verification commands below.

## AGENTS.md Instructions

Ensure `AGENTS.md` contains this section exactly once:

```md
## AgentSPK

AgentSPK is the repository's durable specification memory for AI agents.
It stores project intent, features, behaviors, components, interfaces, data models, constraints, technical decisions, and important historical changes as compact `.spk` atoms so specification knowledge survives context loss and can be reused across sessions.

The AgentSPK skills in this repository use the standard Agent Skills interoperability layout under `.agents/skills/<skill-name>/SKILL.md`.

Use AgentSPK proactively, not reflexively. It exists to keep implementation work aligned with the repository's intended behavior and to make important product and technical knowledge durable instead of leaving it only in transient chat context or scattered code.

When to read AgentSPK:

- Read `.agents/skills/search-spk/SKILL.md` before the first AgentSPK search in a session.
- Search AgentSPK when the current task needs specification context that is not already available in the conversation, loaded atoms, or inspected source files.
- Search before edits when the request is broad, ambiguous, cross-cutting, touches unfamiliar existing behavior, or changes durable behavior, interfaces, data models, architecture, constraints, deprecations, or historical rationale.
- Within the same session, reuse prior AgentSPK search results and inspected context. Do not repeat the same search query just in case something changed.
- Assume no human intervention or source/spec changes outside the agent's own work have occurred within the same session unless the user says so or tools show evidence of it.
- If source files and existing session context are enough to safely handle a local implementation task, skip AgentSPK search.

When to write AgentSPK:

- If the user is defining specifications, requirements, features, product behavior, APIs, data models, architecture, constraints, assumptions, or project groupings, capture durable knowledge in AgentSPK.
- If implementation work creates or changes durable technical decisions, configurations, behaviors, interfaces, data models, assumptions, deprecations, or important historical rationale that is not obvious from code or docs, capture that knowledge in AgentSPK as part of the task.
- Do not record routine implementation steps, command results, refactors, formatting, small fixes, or details that are immediately discoverable in source code.
- Prefer compact atoms that summarize a cohesive area and point to detailed code or documentation with `ref` entries. Split atoms only when a subtopic has independently important specification, relations, or retrieval value.
- Use `chg` atoms only for historical changes that future agents must know to understand why a specification or code path exists, such as legacy migrations or deprecated-but-still-present behavior. Do not create `chg` atoms for every code change.
- Read `.agents/skills/write-spk/SKILL.md` before creating or updating atoms.
- Use the write CLI's default sectioned storage for new atoms unless the user or repository rules explicitly require `--file`.
- Do not overwrite an existing atom unless you intentionally pass `--replace`.

Language and format rules:

- Always write AgentSPK files, atom IDs, values, summaries, notes, and technical decisions in English, even if the user speaks another language.
- Keep atoms compact, factual, and implementation-relevant.
- Use canonical keys and existing relation verbs.

Validation:

- Read `.agents/skills/check-spk/SKILL.md` before validating or repairing the atomset.
- After meaningful AgentSPK edits, or when the specification may be stale or inconsistent, run the checker and repair issues when appropriate.

Tools:

- Follow the instructions inside each activated `SKILL.md` and use the bundled `scripts/` files from that skill package.
- Treat each skill package as self-contained. Do not call scripts from another skill directory or rely on sibling skill resources.
- On macOS, Linux, and WSL the bundled skill scripts use `scripts/agentspk-write`, `scripts/agentspk-search`, and `scripts/agentspk-check`.
- On Windows the bundled skill scripts use `scripts/agentspk-write.ps1`, `scripts/agentspk-search.ps1`, and `scripts/agentspk-check.ps1`.
- The PowerShell launcher expects `bash`, `sh`, or WSL to be available.
```

If `AGENTS.md` already exists, merge this section without removing unrelated instructions.

## Optional Project Setup

If the target repository does not already have a clear location for project specification files, use the writer default: `spec/specifications.spk` rendered as type sections with blank lines between sections. Use `--file` only when the repository explicitly chooses a custom target.

## Post-Install Verification

Run this command in the target repository:

```bash
.agents/skills/write-spk/scripts/agentspk-write --help
```

Also verify the read and check entrypoints:

```bash
.agents/skills/search-spk/scripts/agentspk-search --help
.agents/skills/check-spk/scripts/agentspk-check --help
```

On Windows, the equivalent verification command is:

```powershell
pwsh -File .agents/skills/write-spk/scripts/agentspk-write.ps1 --help
```

Also verify the read and check entrypoints:

```powershell
pwsh -File .agents/skills/search-spk/scripts/agentspk-search.ps1 --help
pwsh -File .agents/skills/check-spk/scripts/agentspk-check.ps1 --help
```

The installation is complete when the verification commands succeed and the files above exist in the target repository.

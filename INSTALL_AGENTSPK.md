# Install AgentSPK Into Another Repository

This file is meant to be read and followed by an AI agent.

## Goal

Install the AgentSPK tool and skill set into the current repository so future agents can read, write, search, and validate `.spk` files predictably.

## Required Result

Create these files in the target repository:

- `.agents/skills/write-spk/`
- `.agents/skills/search-spk/`
- `.agents/skills/check-spk/`

Update or create this file in the target repository:

- `AGENTS.md`

## Copy Instructions

Copy the exact contents of these source files from the AgentSPK repository into the target repository:

- `skills/write-spk/` -> `.agents/skills/write-spk/`
- `skills/search-spk/` -> `.agents/skills/search-spk/`
- `skills/check-spk/` -> `.agents/skills/check-spk/`

Do not rename the installed skill directories unless the user explicitly asks for a different layout.
If the target repository supports file permissions, mark each installed `scripts/agentspk-write`, `scripts/agentspk-search`, and `scripts/agentspk-check` file as executable when present.

## AGENTS.md Instructions

Ensure `AGENTS.md` contains this section exactly once:

```md
## AgentSPK

AgentSPK is the repository's durable specification memory for AI agents.
It stores project intent, features, behaviors, components, interfaces, data models, constraints, technical decisions, and important historical changes as compact `.spk` atoms so specification knowledge survives context loss and can be reused across sessions.

The AgentSPK skills in this repository use the standard Agent Skills interoperability layout under `.agents/skills/<skill-name>/SKILL.md`.

Use AgentSPK proactively. It exists to keep implementation work aligned with the repository's intended behavior and to make important product and technical knowledge durable instead of leaving it only in transient chat context or scattered code.

When to read AgentSPK:

- Before modifying implementation in any create, read, update, delete, repair, refactor, or migration flow, load relevant specification context first.
- Read `.agents/skills/search-spk/SKILL.md` before loading project specification context.
- If the request touches an existing area of the system, search for related goals, user stories, features, behaviors, components, interfaces, data models, constraints, assumptions, technical designs, changes, and deprecations before editing code.
- If the request is broad, ambiguous, or likely to span multiple areas, load more related atoms or the full atomset.

When to write AgentSPK:

- If the user is defining specifications, requirements, features, product behavior, APIs, data models, architecture, constraints, assumptions, or project groupings, capture that knowledge in AgentSPK.
- If implementation work creates or changes durable technical decisions, configurations, behaviors, interfaces, data models, assumptions, deprecations, or historically important changes, capture that knowledge in AgentSPK as part of the task.
- If the user interaction naturally produces any valid AgentSPK atom, follow the write skill and record it instead of leaving it only in prose.
- Read `.agents/skills/write-spk/SKILL.md` before creating or updating atoms.
- Default all writes to `spec/specifications.spk` unless the user or repository rules explicitly choose another `.spk` file.
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

If the target repository does not already have a clear location for project specification files, create a `spec/` directory and use `spec/specifications.spk` as the default specification file.

## Post-Install Verification

Run this command in the target repository:

```bash
.agents/skills/write-spk/scripts/agentspk-write --help
```

On Windows, the equivalent verification command is:

```powershell
pwsh -File .agents/skills/write-spk/scripts/agentspk-write.ps1 --help
```

The installation is complete when the command succeeds and the files above exist in the target repository.

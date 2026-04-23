## AgentSPK

AgentSPK is this repository's durable specification memory for AI agents.
It stores project intent, features, behaviors, components, interfaces, data models, constraints, technical decisions, and important historical changes as compact `.spk` atoms so specification knowledge survives context loss and can be reused across sessions.

This repository is the source repository for AgentSPK itself, not just a consumer repository using AgentSPK.
When you modify files here, you may be changing AgentSPK's own behavior, documentation, skills, install instructions, or conventions, so treat those edits as self-hosting changes.

This repository uses the AgentSPK skill packages directly from `skills/<skill-name>/SKILL.md`.
Do not assume an installation under `.agents/`; use the root `skills/` directory and each skill's bundled `scripts/` files.

Use AgentSPK proactively. It exists to keep implementation work aligned with the repository's intended behavior and to make important product and technical knowledge durable instead of leaving it only in transient chat context or scattered code.

When to read AgentSPK:

- Before modifying implementation in any create, read, update, delete, repair, refactor, or migration flow, load relevant specification context first.
- Read `skills/search-spk/SKILL.md` before loading project specification context.
- If the request touches an existing area of the system, search for related goals, user stories, features, behaviors, components, interfaces, data models, constraints, assumptions, technical designs, changes, and deprecations before editing code.
- If the request is broad, ambiguous, or likely to span multiple areas, load more related atoms or the full atomset.

When to write AgentSPK:

- If the user is defining specifications, requirements, features, product behavior, APIs, data models, architecture, constraints, assumptions, or project groupings, capture that knowledge in AgentSPK.
- If implementation work creates or changes durable technical decisions, configurations, behaviors, interfaces, data models, assumptions, deprecations, or historically important changes, capture that knowledge in AgentSPK as part of the task.
- If the user interaction naturally produces any valid AgentSPK atom, follow the write skill and record it instead of leaving it only in prose.
- Read `skills/write-spk/SKILL.md` before creating or updating atoms.
- Default all writes to `spec/specifications.spk` unless the user or repository rules explicitly choose another `.spk` file.
- Do not overwrite an existing atom unless you intentionally pass `--replace`.

Language and format rules:

- Always write AgentSPK files, atom IDs, values, summaries, notes, and technical decisions in English, even if the user speaks another language.
- Keep atoms compact, factual, and implementation-relevant.
- Use canonical keys and existing relation verbs.

Validation:

- Read `skills/check-spk/SKILL.md` before validating or repairing the atomset.
- After meaningful AgentSPK edits, or when the specification may be stale or inconsistent, run the checker and repair issues when appropriate.

Tools:

- Follow the instructions inside each activated `SKILL.md` and use the bundled `scripts/` files from that skill package.
- Treat each skill package as self-contained. Do not call scripts from another skill directory or rely on sibling skill resources.
- On macOS, Linux, and WSL the bundled skill scripts use `skills/write-spk/scripts/agentspk-write`, `skills/search-spk/scripts/agentspk-search`, and `skills/check-spk/scripts/agentspk-check`.
- On Windows the bundled skill scripts use `skills/write-spk/scripts/agentspk-write.ps1`, `skills/search-spk/scripts/agentspk-search.ps1`, and `skills/check-spk/scripts/agentspk-check.ps1`.
- The PowerShell launcher expects `bash`, `sh`, or WSL to be available.

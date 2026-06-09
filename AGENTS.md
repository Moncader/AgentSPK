## AgentSPK

AgentSPK is this repository's durable specification memory for AI agents.
It stores project intent, features, behaviors, components, interfaces, data models, constraints, technical decisions, and important historical changes as compact `.spk` atoms so specification knowledge survives context loss and can be reused across sessions.

This repository is the source repository for AgentSPK itself, not just a consumer repository using AgentSPK.
When you modify files here, you may be changing AgentSPK's own behavior, documentation, skills, install instructions, or conventions, so treat those edits as self-hosting changes.

This repository uses the AgentSPK skill packages directly from `skills/<skill-name>/SKILL.md`.
Do not assume an installation under `.agents/`; use the root `skills/` directory and each skill's bundled `scripts/` files.

Use AgentSPK proactively, not reflexively. It exists to keep implementation work aligned with the repository's intended behavior and to make important product and technical knowledge durable instead of leaving it only in transient chat context or scattered code.

When to read AgentSPK:

- Read `skills/search-spk/SKILL.md` before the first AgentSPK search in a session.
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
- Read `skills/write-spk/SKILL.md` before creating, updating, or deleting atoms.
- Use the write CLI's default sectioned storage for new atoms unless the user or repository rules explicitly require `--file`.
- Do not overwrite an existing atom unless you intentionally pass `--replace`.

Language and format rules:

- Always write AgentSPK files, atom IDs, values, summaries, notes, and technical decisions in English, even if the user speaks another language.
- Keep atoms compact, factual, and implementation-relevant.
- Use canonical keys and existing relation verbs.

Validation:

- Read `skills/check-spk/SKILL.md` before validating or repairing the atomset.
- Do not run the checker just because you used the write CLI.
- Run the checker when the specification may be stale or inconsistent, or after manually editing `spec/specifications.spk` by hand, which should generally be avoided.

Testing:

- After modifying this repository, run the test suite and ensure it passes before considering the task complete.
- Add or update tests for all new features, behaviors, interfaces, tooling changes, and bug fixes.
- Use `tests/run.sh` for the repository test suite unless a task explicitly adds or documents another test command.

Tools:

- Follow the instructions inside each activated `SKILL.md` and use the bundled `scripts/` files from that skill package.
- Treat each skill package as self-contained. Do not call scripts from another skill directory or rely on sibling skill resources.
- On macOS, Linux, and WSL the bundled skill scripts use `skills/write-spk/scripts/agentspk-write`, `skills/search-spk/scripts/agentspk-search`, and `skills/check-spk/scripts/agentspk-check`.
- On Windows the bundled skill scripts use `skills/write-spk/scripts/agentspk-write.ps1`, `skills/search-spk/scripts/agentspk-search.ps1`, and `skills/check-spk/scripts/agentspk-check.ps1`.
- The PowerShell launcher expects `bash`, `sh`, or WSL to be available.

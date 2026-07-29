## AgentSPK

AgentSPK is this repository's durable specification memory for AI agents.
It stores project intent, features, behaviors, components, interfaces, data models, constraints, technical decisions, and important historical changes as compact `.spk` atoms so specification knowledge survives context loss and can be reused across sessions.

This repository is the source repository for AgentSPK itself, not just a consumer repository using AgentSPK.
When you modify files here, you may be changing AgentSPK's own behavior, documentation, skills, install instructions, or conventions, so treat those edits as self-hosting changes.

This repository uses the AgentSPK skill packages directly from `skills/<skill-name>/SKILL.md`.
Do not assume an installation under `.agents/`; use the root `skills/` directory and each skill's bundled `scripts/` files.

### Before editing: decide whether to search

Do this check before changing files. **You MUST search AgentSPK before editing if any answer is yes:**

- Is the request broad, ambiguous, or spread across multiple parts of the repository?
- Are you changing behavior, an interface or API, a data model, architecture, configuration, a constraint, a deprecation, or compatibility?
- Do you need to understand product intent, a prior decision, or why the current implementation exists?
- Are you unfamiliar with the affected behavior or unsure that source code tells the whole story?

If yes:

1. Read `skills/search-spk/SKILL.md` if you have not read it in this session.
2. Run its search command with a relevant English term, atom ID, or wildcard.
3. Read the matching atoms and relevant relations before editing.
4. If the search has no useful match, continue using the conversation and source code. A search with no match is not a reason to stop.

You MAY skip search only for a small, local task when the conversation and inspected source files already provide all needed context, such as a spelling fix, formatting-only change, or obvious isolated bug fix.

Do not search again for the same context in one session. Reuse atoms already loaded unless the user reports an external change.

### Before finishing: decide whether to write

After implementation, ask: **Did this task create or change knowledge a future agent must know that is not clear from the code alone?**

If yes, you MUST update AgentSPK before finishing. This includes new or changed requirements, product behavior, APIs, data models, architecture, configuration rules, constraints, assumptions, compatibility, deprecations, or the reason for an important decision.

To update AgentSPK:

1. Read `skills/write-spk/SKILL.md` if you have not read it in this session.
2. Use its writer command; do not hand-edit `.spk` files.
3. Write compact, factual atoms in English, even when the user uses another language.
4. Prefer one cohesive atom with `ref` entries to detailed code or docs. Split only when a subtopic has independent retrieval value.
5. Use canonical keys and existing relation verbs. Pass `--replace` only when intentionally replacing an existing atom.

Do NOT write atoms for commands run, implementation steps, routine refactors, formatting, small fixes, or facts obvious from source code. Use a `chg` atom only when future agents need historical context to understand the current system, not merely because a change occurred.

### Validation

Do not run validation after every write. If the atomset may be stale, malformed, or inconsistent, or if a `.spk` file was edited by hand, first read `skills/check-spk/SKILL.md`, then run its checker.

### Required workflow summary

1. **Before edits:** run the search decision check above and search when any trigger applies.
2. **Make the change:** use loaded specification context to guide the implementation.
3. **Before finishing:** run the write decision check above and persist durable knowledge when required.
4. **Never invent AgentSPK commands:** follow the relevant `SKILL.md` and use its bundled scripts.

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

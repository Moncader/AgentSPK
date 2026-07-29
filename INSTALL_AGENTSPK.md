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

AgentSPK is this repository's durable specification memory. `.spk` atoms contain requirements, behavior, interfaces, data models, constraints, decisions, and important history that may not be obvious from code.

The AgentSPK skills are installed at `.agents/skills/<skill-name>/`. Do not guess the commands: read the named `SKILL.md`, then use the script it documents.

### Before editing: decide whether to search

Do this check before changing files. **You MUST search AgentSPK before editing if any answer is yes:**

- Is the request broad, ambiguous, or spread across multiple parts of the repository?
- Are you changing behavior, an interface or API, a data model, architecture, configuration, a constraint, a deprecation, or compatibility?
- Do you need to understand product intent, a prior decision, or why the current implementation exists?
- Are you unfamiliar with the affected behavior or unsure that source code tells the whole story?

If yes:

1. Read `.agents/skills/search-spk/SKILL.md` if you have not read it in this session.
2. Run the documented search command with a relevant English term, atom ID, or wildcard.
3. Read the matching atoms and relevant relations before editing.
4. If the search has no useful match, continue using the conversation and source code. A search with no match is not a reason to stop.

You MAY skip search only for a small, local task when the conversation and inspected source files already provide all needed context, such as a spelling fix, formatting-only change, or obvious isolated bug fix.

Do not search again for the same context in one session. Reuse atoms already loaded unless the user reports an external change.

### Before finishing: decide whether to write

After implementation, ask: **Did this task create or change knowledge a future agent must know that is not clear from the code alone?**

If yes, you MUST update AgentSPK before finishing. This includes new or changed requirements, product behavior, APIs, data models, architecture, configuration rules, constraints, assumptions, compatibility, deprecations, or the reason for an important decision.

To update AgentSPK:

1. Read `.agents/skills/write-spk/SKILL.md` if you have not read it in this session.
2. Use its writer command; do not hand-edit `.spk` files.
3. Write compact, factual atoms in English, even when the user uses another language.
4. Prefer one cohesive atom with `ref` entries to detailed code or docs. Split only when a subtopic has independent retrieval value.
5. Use canonical keys and existing relation verbs. Pass `--replace` only when intentionally replacing an existing atom.

Do NOT write atoms for commands run, implementation steps, routine refactors, formatting, small fixes, or facts obvious from source code. Use a `chg` atom only when future agents need historical context to understand the current system, not merely because a change occurred.

### Validation

Do not run validation after every write. If the atomset may be stale, malformed, or inconsistent, or if a `.spk` file was edited by hand, first read `.agents/skills/check-spk/SKILL.md`, then run its checker.

### Required workflow summary

1. **Before edits:** run the search decision check above and search when any trigger applies.
2. **Make the change:** use loaded specification context to guide the implementation.
3. **Before finishing:** run the write decision check above and persist durable knowledge when required.
4. **Never invent AgentSPK commands:** follow the relevant `SKILL.md` and use its bundled scripts.

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

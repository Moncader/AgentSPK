---
name: check-spk
description: Validate an AgentSPK atomset and report parse issues, duplicates, broken references, and isolated atoms. Use when the atomset may be inconsistent, after manual `.spk` edits, or when repairing project specifications.
compatibility: Requires a POSIX shell for scripts/agentspk-check. On Windows, scripts/agentspk-check.ps1 requires bash, sh, or WSL.
---

# Check SPK Skill

Use this skill when you need to validate the overall health of an SPK atomset because it may be inconsistent, because someone manually edited a `.spk` file, or because you are repairing project specifications.

## Available Scripts

- `scripts/agentspk-check` - POSIX shell CLI for check operations.
- `scripts/agentspk-check.ps1` - PowerShell launcher for the bundled check CLI.

## Canonical Command

```bash
scripts/agentspk-check
```

```powershell
pwsh -File scripts/agentspk-check.ps1
```

## What It Checks

- malformed atom lines
- duplicate `type:id` definitions
- missing relation targets
- missing referenced files
- isolated atoms with no incoming or outgoing relations

## Important Behavior

- The command returns a machine-readable JSON report.
- The command does not treat specification issues as a hard tool failure.
- Use the report to repair the atomset with the write skill.
- Do not run this command just because you used the write CLI; normal write operations should not require an immediate manual check.
- Treat isolation warnings as prompts to evaluate retrieval usefulness, not as a requirement to add filler relations or low-value atoms.

## Example

```bash
scripts/agentspk-check --root .
```

## Output

The JSON report includes:

- a summary of files, atoms, and issue counts
- an `issues` array with severity, code, location, and message

Treat the report as a repair queue for follow-up edits.

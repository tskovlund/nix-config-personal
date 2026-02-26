---
name: issue-track
description: >
  Track ideas and tasks for later. Use when the user says "track this",
  "add to Linear", "create an issue", "defer this", "file an issue", or
  when a deferrable idea comes up mid-conversation — something that should
  be captured but not acted on now. Routes to GitHub Issues for repo-specific
  work, Linear for everything else. Do NOT use for shaping existing triage
  issues (use issue-triage) or auditing issue health (use issue-hygiene).
user-invocable: true
argument-hint: "[description]"
allowed-tools: mcp__plugin_linear_linear__*, Bash(gh *)
metadata:
  author: tskovlund
  version: "2.0"
---

# Issue tracking

Capture ideas and tasks for later action. Route to the right tracker.

## Routing: GitHub Issues vs Linear

**GitHub Issues** — repo-specific implementation work:
- Bugs, features, or tasks scoped to a single repo
- Anything resolved by a PR in that repo
- Create with: `gh issue create -R <owner>/<repo> --title "..." --body "..."`

**Linear** — everything else:
- Cross-project planning, personal backlog, ideas not scoped to a repo
- When both apply: create Linear issue, note that GitHub issue should be created when implementation starts

## Safety

**For Linear:** Always run `list_teams` before any mutation to confirm workspace (tskovlund).
**For GitHub:** Confirm the target repo before creating.

## When to auto-trigger

**Create silently** — intent to track is clear:
- Explicit: "track this", "add to Linear", "create an issue", "defer this"
- Contextual: "note to research X", "we should have X for Y"
- Mid-conversation: Thomas names a concrete task to do later

**Ask first** — genuinely ambiguous:
- Vague musings: "it would be nice if..."
- Unsure which tracker is appropriate
- Prompt: "Want me to track that?"

## Triage vs shaped issue

**Triage** (Triage status, Low priority) — rough idea, needs scoping:
```markdown
## Idea
[Core idea in 1-3 sentences]
## Context
[What prompted this, relevant constraints]
```

**Shaped** (Backlog status) — clear scope, actionable:
```markdown
## Summary
[What and why]
## Requirements
- [ ] [Specific requirement]
## Acceptance criteria
- [ ] [How to verify done]
```

## Metadata

### Linear
- **Priority:** per CLAUDE.md (Urgent/High/Medium/Low mapping)
- **Labels:** use the labels defined in the Linear Workspace section of CLAUDE.md (at least one)
- **Project:** assign if it clearly belongs to one

### GitHub
- **Labels:** use the repo's existing labels
- **Assignee:** leave unassigned unless specified

## Cross-referencing

When a Linear issue maps to repo work:
- In Linear: include GitHub issue URL in a comment
- In GitHub: include Linear URL (`Related: https://linear.app/tskovlund/issue/TSK-123`)

## After creating

Report: issue identifier, which tracker and why, status, brief confirmation.

## Examples

### Example 1: Explicit deferral

Thomas says: "we should also set up automated flake input updates"

→ Cross-project infra → Linear, Triage, label `nix`, Low
→ "Tracked as TSK-87 (Triage, nix, Low)."

### Example 2: Repo-specific bug

Thomas says: "track that the pre-commit hook fails on files with spaces"

→ Repo-specific → `gh issue create -R tskovlund/nix-config`
→ "Filed tskovlund/nix-config#52."

## Troubleshooting

### Error: `create_issue` fails with "Team not found"

**Cause:** Wrong workspace auth.
**Solution:** Run `list_teams` to verify. Team ID: `4931919c-2b49-4bd0-b316-005f8bd66554`.

### Created in wrong tracker

**Solution:** Create in the correct tracker, cancel/close the wrong one with a note.

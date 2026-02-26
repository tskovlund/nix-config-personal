---
name: issue-triage
description: >
  Shape and promote triage issues. Use when working with Linear triage items
  or unscoped GitHub issues, when the user says "triage", "shape issues",
  "process triage", or when encountering issues that need prioritization
  and scoping. Do NOT use for creating new issues (use issue-track) or
  bulk auditing issue health (use issue-hygiene).
user-invocable: true
argument-hint: "[issue-id]"
allowed-tools: mcp__plugin_linear_linear__*, Bash(gh *)
metadata:
  author: tskovlund
  version: "2.0"
---

# Issue triage

Shape triage issues into actionable backlog items.

## Safety

**Always run `list_teams` before any mutation** to confirm workspace (tskovlund).

## Before acting on any issue

1. Read the full issue body
2. Read ALL comments — they contain scope changes, decisions, and corrections
3. Understand the intent before making changes

## Triage workflow

### Assess the issue

- Clear enough to act on? If not, add a comment asking for clarification
- Standalone issue or part of a project?
- Actionable now, or needs research first?

### Set metadata

**Priority:** per CLAUDE.md (Urgent=today, High=this week, Medium=this month, Low=no timeline)

**Labels:** use the labels defined in the Linear Workspace section of CLAUDE.md (at least one)

### Promote status

- **Triage → Backlog** — shaped, not scheduled
- **Triage → Todo** — ready to work on now

### Edit rules

- **Triage bodies CAN be edited freely** — raw ideas being shaped
- **Non-triage bodies get comments only** — the body is the original spec
- Exception: typos, missing sections before work starts, ticking checkboxes

## Batch processing

Work through items one at a time. For each: read, set metadata, promote, add shaping comment if significant changes. Summary when done.

## Examples

### Example 1: Shape a rough idea

`/issue-triage TSK-91` — body: "look into tailscale for connecting machines"

→ Rough idea, needs research → Low, labels `infra` + `research`
→ Edit body to add structure, promote Triage → Backlog
→ "TSK-91 shaped and promoted to Backlog."

### Example 2: Promote a clear item

TSK-95: "Add direnv .envrc to nix-config-personal" + comment: "Should be straightforward"

→ Clear, actionable → Medium, label `nix`, promote Triage → Todo

## Troubleshooting

### Accidentally edited a non-triage issue body

**Solution:** Can't undo via API. Add comment explaining the change, flag to Thomas.

### Unsure Backlog or Todo

**Solution:** Default to Backlog. Todo means "ready to pick up now."

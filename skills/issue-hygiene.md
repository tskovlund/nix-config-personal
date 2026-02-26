---
name: issue-hygiene
description: >
  Audit and sync issues with reality across Linear and GitHub. Use when the
  user says "clean up issues", "audit issues", "sync statuses", "hygiene
  pass", or when issues may be stale, mislabeled, or out of sync with
  actual progress. Do NOT use for creating new issues (use issue-track) or
  shaping triage items (use issue-triage).
user-invocable: true
allowed-tools: mcp__plugin_linear_linear__*, Bash(gh *)
metadata:
  author: tskovlund
  version: "2.0"
---

# Issue hygiene

Sync issues with reality across both trackers.

## Safety

**Always run `list_teams` before any mutation** to confirm workspace (tskovlund).

## Audit workflow

### 1. Gather all active issues

List all issues NOT in Done or Canceled. Group by project and standalone.

### 2. Check each against reality

**Status accuracy:**
- Actually In Progress, or has work stalled?
- Done but not marked? (Check for merged PRs)
- Should be Blocked?
- Still relevant, or cancel?

**Stale detection:**
- In Progress, no activity in 2+ weeks → flag or Blocked
- Todo, no activity in 4+ weeks → consider Backlog
- Urgent/High sitting untouched → flag for priority review

**Label and priority accuracy:**
- Every issue should have at least one label
- Priority still matches reality?

### 3. Cross-reference GitHub

- Check for merged PRs that close Linear work
- Add cross-reference comments where missing

### 4. Report

- **Changes made** — status, label, priority updates
- **Flagged** — items needing Thomas's decision
- **Cross-references added**

Make changes directly for clear-cut cases. Flag ambiguous cases.

## Examples

### Example 1: Routine hygiene

"clean up issues" → find TSK-42 stale (In Progress 3 weeks) → Blocked. Find TSK-58 with merged PR → Done. Find TSK-61 unlabeled → add `nix`.

### Example 2: Cross-reference audit

"sync GitHub and Linear" → find merged PRs referencing Linear → mark Done, add cross-references.

## Troubleshooting

### `list_teams` returns wrong workspace

**Solution:** Use `/mcp` to clear and re-auth to tskovlund.

### Issue appears stale but has off-platform activity

**Solution:** Flag for Thomas instead of auto-updating.

---
name: planning
description: >
  Prioritize the Linear backlog using strategic goals and compounding
  preference. Use when the user says "plan", "prioritize", "what should I
  work on", "review backlog", or when the user implicitly asks about task
  order or what to pick up next. Do NOT use for creating individual issues
  (use issue-track) or triaging specific items (use issue-triage).
user-invocable: true
allowed-tools: mcp__plugin_linear_linear__*, mcp__memory__*
metadata:
  author: tskovlund
  version: "2.0"
---

# Planning

Prioritize the Linear backlog through the lens of Thomas's strategic goals.

## Safety

**Always run `list_teams` before any mutation** to confirm workspace (tskovlund).

## Strategic context

Read the "Why we're doing all of this" section in `~/.claude/CLAUDE.md` for Thomas's goals and strategy. Apply those goals when evaluating and prioritizing work.

**Compounding preference:** Infrastructure, automation, and reusable systems > one-off tasks. Prefer things that multiply future productivity.

## Gather context

1. **Linear backlog:** List all projects and standalone issues across all statuses
2. **MCP memory:** Search for prior planning decisions, strategic context, and preferences
3. **Current state:** What's In Progress? What's Blocked? What was recently completed?

## Evaluation framework

For each item, assess:

### Does it compound?
- Creates reusable infrastructure? Makes future work faster? Reduces manual toil?

### Does it ship?
- Produces something people can use? Moves a product closer to launch? Revenue potential?

### Does it unblock?
- Anything waiting on this? Removes a bottleneck? Enables parallel work?

### Is it time-sensitive?
- External deadlines? Decaying opportunities? Dependencies that might change?

## Output

Prioritized list grouped by time horizon:

- **Today (Urgent)** — external deadlines, blocking issues, decaying opportunities
- **This week (High)** — compounding infrastructure, active project momentum
- **This month (Medium)** — planned features, quality improvements, research
- **Backlog (Low)** — future exploration, nice-to-haves, long-term bets

For each item: current vs recommended priority, rationale, dependencies, blockers.

## Flag for Thomas

- Items where priority should change
- Sequencing suggestions (do X before Y because...)
- Items to cancel or archive
- New items to create (use `/issue-track`)

## Examples

### Example 1: Weekly planning

User says: "what should I work on this week?"

Actions:
1. `list_teams` → confirm tskovlund
2. Search memory for recent planning decisions
3. List all In Progress, Todo, and Backlog items
4. Apply evaluation framework

Output:
> **This week (High):**
> - TSK-45: Nix module for agent orchestration — compounds (infrastructure), unblocks Cambr work
> - TSK-52: Fix flake input caching — compounds (dev experience), quick win
>
> **Flag:** TSK-38 has been In Progress for 3 weeks. Cancel or re-scope?

### Example 2: Implicit planning

Thomas says: "I've got a few hours, what should I pick up?"

Auto-triggers. Same workflow as above, but focused on quick wins and items already in Todo.

## Troubleshooting

### Backlog too large to review meaningfully

**Solution:** Focus on In Progress and Todo first. For Backlog, scan titles only and flag cancellation candidates. Suggest `/issue-hygiene` first.

### Memory returns conflicting prior decisions

**Solution:** Use the most recent decision. Store a new memory with `SUPERSEDES` relationship.

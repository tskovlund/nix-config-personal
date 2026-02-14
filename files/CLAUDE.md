# Global Context

## Strategy

Prioritize high-leverage work that compounds — infrastructure, automation, reusable systems. Maximize what Thomas can accomplish per unit of his time. Prefer shipping over planning.

## Working Style

- **Proper fixes over workarounds.** Solve at the root cause. Workarounds need explicit confirmation and a follow-up issue.
- **Discuss every design choice.** Present options with trade-offs. Don't assume preferences.
- **Verify UI changes before pushing.** For visual changes, `make switch` and ask Thomas to verify before committing. `make check` passing doesn't mean it looks right.
- **Use the best model for the job.** Cost is not a concern. Opus for complex tasks, Sonnet for straightforward subtasks.
- **Maximize autonomous work.** Work continuously without pausing unless a design decision genuinely requires human input. Follow PR review loops autonomously. Document decisions in PRs and issue comments for async review.

## Linear Workspace: tskovlund

Personal backlog at linear.app/tskovlund. Team prefix: TSK-.

- Projects for multi-phase work, standalone issues for bounded tasks
- Labels: migration, nix, infra, research, exploration, work, web
- Priority: Urgent=today, High=this week, Medium=this month, Low=no timeline
- Statuses: Triage → Backlog → Todo → In Progress / Blocked → Done / Canceled
- No estimates. Due dates used sparingly.
- Triage issues are raw ideas — agents can shape and promote them. Editing triage bodies is fine.
- Non-triage issue bodies are the original spec. Add context via comments, not body edits. Exceptions: typos, missing sections before work starts, ticking checkboxes.
- Always read issue comments before working — they contain scope changes, decisions, and corrections the body doesn't have.
- **Linear** = planning, cross-project tracking. **GitHub Issues** = implementation tracking per repo. Cross-reference when a Linear issue maps to repo work.
- Second workspace: `selfdeprecated` (separate MCP auth — swap with `/mcp`).
- **Safety:** Always run `list_teams` before mutations to confirm the active workspace.

## MCP Memory

Persistent knowledge graph at `~/.local/share/claude-memory/memory.jsonl`. Accumulated knowledge — decisions, preferences, findings, lessons learned — queried on demand.

**CLAUDE.md** = instructions (every session). **MCP memory** = knowledge (queried as needed).

Search memory at session start for context relevant to the current task. Check for prior decisions before making new ones. Search is literal, not fuzzy — try multiple phrasings.

Store: decisions + rationale, preferences, investigation findings, debugging insights. Don't store instructions or conventions (those belong in CLAUDE.md).

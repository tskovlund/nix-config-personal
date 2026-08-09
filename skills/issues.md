---
name: issues
description: >
  Create, shape, and audit issues across Linear and GitHub. Use when the user
  says "track this", "file an issue", "add to Linear", "defer this", "triage",
  "shape issues", "clean up issues", "audit issues", "sync statuses", or when a
  deferrable idea comes up mid-conversation. Also use before working any Linear
  or GitHub issue, to pick up the conventions and read the comment history.
user-invocable: true
argument-hint: "[description or issue id]"
---

# Issues

Two trackers, two layers. Getting the routing wrong is the main failure mode.

## Routing

**Linear** (linear.app/tskovlund, `TSK-`) is the **portfolio layer** — projects,
priorities, cross-repo ideas, decisions, anything without a repo to live in.

**GitHub Issues** are the **execution layer** — anything a PR resolves, filed in
the repo where the work happens.

**Bridge:** when a Linear item goes active, spawn a GitHub issue in the target
repo and cross-link both ways. Linear then tracks the milestone, GitHub tracks
the work.

## Privacy guardrail

These repos are **public**: nix-config, nix-config-personal, qed, mcp-score,
skovlund.dev, kammer, dot-github, eliza-config, adventofcode, academy-fx.

Never put strategy, revenue, pricing, or personal details in a public repo's
issues — not in titles, bodies, or comments. That material goes to Linear or to
a private repo (cambr, cambr-strategies, cv). When an issue needs both, keep the
public issue purely technical and hold the reasoning in Linear.

## Linear facts

- **Statuses:** Triage → Backlog → Todo → In Progress / Blocked → Done / Canceled
- **Priorities:** Urgent = today, High = this week, Medium = this month, Low = no timeline
- **Labels:** `migration`, `nix`, `infra`, `research`, `exploration`, `work`, `web`, `spec` — at least one per issue
- **No estimates** — disabled in the workspace
- Run `list_teams` before any mutation. A second workspace (`selfdeprecated`)
  exists and the MCP can only be authed to one at a time.

**Editing rules:** triage issues are raw ideas — agents may freely rewrite,
shape, and promote them. Non-triage bodies are the original spec: add context as
comments, never by rewriting the body. Exceptions: typos, filling in a missing
section before work starts, ticking checkboxes.

**Always read the comments before working an issue.** Scope changes, reversals,
and decisions live there, not in the body.

## GitHub facts

- Every issue needs acceptance criteria and at least one label.
- No `Status:` headers in bodies — the status is the issue state, and a stale
  header is worse than none.
- Trackers link their children as **native sub-issues**, not markdown checklists.

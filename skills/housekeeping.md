---
name: housekeeping
description: >
  Recurring maintenance sweep across all active repos — sync, resolve
  dependency-bot PRs, audit security alerts and stale branches, scan for drift.
  Use when the user says "housekeeping", "maintenance sweep", "clean up the
  repos", "deal with the bot PRs", or asks what needs attention across projects.
user-invocable: true
---

# Housekeeping

The recurring cross-repo maintenance sweep. First run (2026-08-08) cleared 35
accumulated bot PRs — expect volume if it has been a while.

**Active repos:** mcp-score, kammer, qed, cambr, cambr-strategies, nix-config,
nix-config-personal, skovlund.dev, dot-github, cv. Plus adventofcode, seasonally.

## Sequence

1. **Sync** every repo (see `repo-sync`).
2. **Dependency-bot PRs.** Prefer **one local batch update per repo** over
   merging bot PRs serially — one lockfile bump, one run of the repo's gate, one
   commit. Then close the superseded PRs with a comment referencing the commit.
   Hold majors that break the gate, and say so in a comment on the PR rather
   than closing it silently.
3. **Audit** open security alerts and stale branches. Delete branches that are
   fully merged; leave anything else alone.
4. **Drift scan.** Red CI, stale configs, repos falling behind shared workflows.
5. **Report** with a review queue — the short list of things that actually need
   Thomas's eyes, separated from what you already handled.

## Guardrails

- **Never touch uncommitted work.** If a repo has a dirty tree, that is Thomas's
  WIP — work around it or skip the repo. Do not stash, reset, or clean.
- **Never force-push.**
- **Skip ZeroClaw and eliza-config** — decommission-pending, not worth maintaining.

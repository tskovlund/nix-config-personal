---
name: repo-sync
description: >
  Bring a repo up to date with its remote. Auto-triggers at session start in a
  git repo and before pushing. Use when the user says "sync", "pull", "am I up
  to date", or when starting work in a repo that may have moved on the remote.
user-invocable: true
---

# Repo sync

Fetch, fast-forward when it is safe, and get out of the way. If everything is
already current, say nothing and proceed with the actual task.

## Guardrails

- **Never stash, reset, checkout over, or clean Thomas's uncommitted changes.**
  Work around them. Some of that WIP is months old and not reproducible — losing
  it is the worst outcome this skill can produce, far worse than a stale branch.
- **Diverged branches: report, don't resolve.** No auto-rebase, no auto-merge,
  no conflict resolution on his behalf. Tell him and let him choose.
- Never force-push.

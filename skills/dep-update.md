---
name: dep-update
description: >
  Update a repo's dependencies and validate with its gate. Use when the user
  says "update deps", "update dependencies", "bump packages", when a dependency
  vulnerability surfaces, or when resolving dependency-bot PRs during
  housekeeping.
user-invocable: true
argument-hint: "[repo or dependency]"
---

# Dependency updates

The update command and the gate vary per repo, and the gate is the part that
matters. Both are in `~/.claude/REPOS.md` — run the gate exactly as listed
there, not a subset.

## Conventions

- Major bumps need an upper-bound review against CONVENTIONS.md before merging —
  the bound exists so majors produce a reviewable PR, so review it.
- When bot PRs are open, **batch-update locally, then close the superseded PRs**
  with a reference to the commit. One validated commit beats N serial merges.

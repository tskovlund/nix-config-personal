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

Per-repo command and gate — the gate is the part that varies and matters.

| Repo             | Update                                 | Gate                                                                  |
| ---------------- | -------------------------------------- | --------------------------------------------------------------------- |
| mcp-score, cambr | `uv lock --upgrade`                    | `devbox run check` (pytest + ruff + pyright)                          |
| nix-config       | `nix flake update`                     | `nix flake check`, then build the darwin closure **before** switching |
| kammer           | `mix deps.update` inside `nix develop` | `mix precommit` + audit                                               |
| skovlund.dev     | `pnpm update` via devbox               | the repo's `check` target                                             |
| qed              | lake manifest, by hand                 | small surface — read the diff                                         |

## Conventions

- Major bumps need an upper-bound review against CONVENTIONS.md before merging —
  the bound exists so majors produce a reviewable PR, so review it.
- When bot PRs are open, **batch-update locally, then close the superseded PRs**
  with a reference to the commit. One validated commit beats N serial merges.

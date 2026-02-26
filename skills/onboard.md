---
name: onboard
description: >
  Explore and internalize an unfamiliar repo's architecture, conventions,
  and key patterns. Auto-triggers when entering a repo for the first time
  or one with no prior MCP memory entries. Use when the user says "onboard",
  "learn this repo", "explore this codebase", "get familiar", or when starting
  work in an unfamiliar project. Do NOT use for syncing repos (use repo-sync)
  or writing documentation (use docs).
user-invocable: true
allowed-tools: Bash(git *), Bash(find *), Bash(wc *), Bash(gh *), Read, Grep, Glob, Task
metadata:
  author: tskovlund
  version: "1.0"
---

# Onboard to a repository

Quickly build a mental model of an unfamiliar codebase. Explore structure,
read key files, understand conventions, and store findings for future sessions.

## When to trigger

- First time working in a repo (no MCP memory entries for it)
- User explicitly asks to explore or understand a codebase
- Starting a task in a repo you haven't worked in recently

Check MCP memory first — if prior onboarding exists, load it instead of re-exploring:

```
memory-recall: search for repo name, project name, architecture
```

If recent findings exist, skip to a quick refresh (step 5 only).

## Exploration steps

### 1. Repo overview

```sh
# Identity
basename $(git rev-parse --show-toplevel)
git remote get-url origin 2>/dev/null

# Size and shape
find . -type f -not -path './.git/*' | wc -l
find . -type f -not -path './.git/*' -name '*.py' -o -name '*.ts' -o -name '*.tsx' \
  -o -name '*.js' -o -name '*.nix' -o -name '*.rs' -o -name '*.go' | head -50
```

### 2. Read key files

Read these in order (skip if missing):

1. **README.md** — purpose, setup, architecture overview
2. **CLAUDE.md** — AI agent instructions, conventions, constraints
3. **CONVENTIONS.md** — code standards, commit rules, test expectations
4. **CONTRIBUTING.md** — development workflow, PR process

```sh
# Check what exists
ls README.md CLAUDE.md CONVENTIONS.md CONTRIBUTING.md 2>/dev/null
```

### 3. Understand project structure

```sh
# Top-level layout
ls -la

# Directory tree (2 levels deep, ignore noise)
find . -maxdepth 2 -type d -not -path './.git*' -not -path './node_modules*' \
  -not -path './.devbox*' -not -path './result*' -not -path './__pycache__*' \
  -not -path './.next*' -not -path './dist*' -not -path './build*' | sort
```

Identify:
- **Source layout:** `src/`, `lib/`, `app/`, flat, or domain-driven
- **Test layout:** `tests/`, co-located `.test.` files, or both
- **Config:** `flake.nix`, `package.json`, `pyproject.toml`, `Cargo.toml`
- **CI/CD:** `.github/workflows/`, `Makefile`, deploy scripts
- **Infra:** `Dockerfile`, `docker-compose.yml`, Nix modules

### 4. Identify patterns and conventions

Look for:

```sh
# Build/dev tooling
cat Makefile flake.nix package.json pyproject.toml 2>/dev/null | head -100

# Git hooks
ls .githooks/ .husky/ 2>/dev/null

# Linting/formatting config
ls .eslintrc* .prettierrc* pyproject.toml rustfmt.toml .editorconfig 2>/dev/null

# Recent commit style
git log --oneline -10
```

Note:
- Commit message convention (conventional commits, imperative, etc.)
- Branch strategy (main only, feature branches, etc.)
- Dev shell approach (nix develop, devbox, venv, etc.)

### 5. Check recent activity

```sh
# What's being worked on
git log --oneline --since="2 weeks ago" -20
git branch -a --sort=-committerdate | head -10

# Open PRs and issues
gh pr list --limit 5 2>/dev/null
gh issue list --limit 5 2>/dev/null
```

## Output

Present a concise summary to the user:

```
## [repo-name] — onboarding summary

**Purpose:** One-line description
**Stack:** Language, framework, key dependencies
**Structure:** Brief layout description
**Dev workflow:** How to build, test, lint
**Conventions:** Commit style, branch strategy, key rules
**Recent focus:** What's actively being worked on
**Notes:** Anything unusual or important to remember
```

## Store findings

After summarizing, store key findings in MCP memory for future sessions:

```
memory-store: Create entities for:
- repo architecture and purpose
- key conventions and workflows
- important file paths
- dev shell / tooling setup
```

Only store durable facts — not session-specific details like "currently working on X".

## Examples

### Example 1: New Python project

Agent starts a task in `~/repos/cambr` — no MCP memory entries found.

Actions:
1. Check MCP memory for "cambr" — no results
2. Read README.md, CLAUDE.md, CONVENTIONS.md
3. Explore: Python project, pytest + pyright, nix develop, src/cambr/ layout
4. Check git log — conventional commits, recent work on strategy engine
5. Present summary:
   > **cambr** — Algorithmic trading bot. Python 3.12, pytest, pyright, nix develop.
   > Source in src/cambr/, tests in tests/. Conventional commits.
   > Pre-push hook runs pytest + pyright. Recent: strategy backtesting.
6. Store architecture and workflow in MCP memory

### Example 2: Returning to a familiar repo

Agent starts work in `~/repos/mcp-score` — MCP memory has prior entries.

Actions:
1. Check MCP memory for "mcp-score" — finds architecture notes from 2 weeks ago
2. Quick refresh: `git log --oneline --since="2 weeks ago"` to catch up on changes
3. Report: "Loaded prior context for mcp-score. 4 commits since last session: [summary]"
4. Proceed with the user's task

## What NOT to do

- Don't read every file — focus on key files and structure
- Don't store session-specific or speculative information in memory
- Don't block the user's task with a lengthy exploration — be efficient
- Don't re-onboard if recent MCP memory entries exist — just refresh

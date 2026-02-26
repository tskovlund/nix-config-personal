---
name: pr-fix
description: >
  Address review comments on a PR: fix code or decline with explanation,
  and reply to every comment on GitHub. Auto-triggers within the pr-review-loop
  workflow. Do NOT use for reviewing PRs (use pr-review) or orchestrating
  the full loop (use pr-review-loop).
user-invocable: false
allowed-tools: Bash(gh *), Bash(git *), Bash(nix develop --command *), Bash(devbox run *), Read, Grep, Glob, Edit, Write
metadata:
  author: tskovlund
  version: "1.0"
---

# Address PR review comments

Fix code and reply to every review comment on a PR.

## For each comment

Do BOTH:

### 1. Act on it

- **Fix it** — make the code change, commit with a conventional commit message:
  `fix(scope): address review comment about X`
- **Or decline** — if the comment is incorrect or the code is intentional

Keep fix commits atomic — one fix per comment where practical.

### 2. Reply on GitHub

Every comment gets an explicit reply — an unaddressed comment looks identical to an ignored comment:

```sh
gh api "repos/{owner}/{repo}/pulls/{number}/comments/{comment_id}/replies" \
  -f body="Your reply here"
```

- If fixed: explain what you changed (e.g., "Fixed — renamed to avoid shadowing")
- If declined: explain why (e.g., "Intentional — the fallback is needed for X")

**Never skip the reply.**

## Commit conventions

- Conventional commits: `fix(scope): address review comment about X`
- Atomic fixes — one per comment where practical
- Don't amend published commits unless Thomas explicitly asks
- Use the repo's dev shell for commits if hooks require it

## After addressing all comments

Push and wait for CI:

```sh
git push
gh pr checks {number} --watch
```

If CI fails, fix, commit, and push before continuing.

## Notes

- For PR-level comments (not inline review comments), reply via:
  `POST /repos/{owner}/{repo}/issues/{number}/comments`
- Git commands with hooks may need dev shell (`nix develop --command` or `devbox run --`)

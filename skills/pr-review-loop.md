---
name: pr-review-loop
description: >
  Autonomous PR review loop: spawn independent review subagent(s), address
  their feedback, and repeat until clean. Use when the user says "review loop",
  "feedback loop", "self-review", or after creating/pushing a PR during a
  larger workflow. Do NOT use for creating PRs (use git/gh directly) or for
  reviewing others' PRs (use pr-review).
user-invocable: true
argument-hint: "[PR-number]"
allowed-tools: Bash(gh *), Bash(git *), Bash(nix develop --command *), Bash(devbox run *), Read, Grep, Glob, Edit, Write, Task
metadata:
  author: tskovlund
  version: "5.0"
---

# PR review loop

Autonomously review and iterate on a PR until clean. Orchestrates two skills:
- **pr-review** — independent review subagent (posts comments)
- **pr-fix** — address each comment (fix + reply)

## Overview

```
gather context → record baseline → spawn pr-review → read comments → pr-fix → push → assess → repeat or done
```

## PR context

```sh
gh pr view $0
gh pr checks $0
gh repo view --json owner,name -q '.owner.login + "/" + .name'
```

Ensure CI is green before starting. If failing, fix and push first.

## Constants

| Parameter | Value |
|-----------|-------|
| Max review rounds | 5 |
| Default review subagents | 1 |

## Loop

### 1. Record comment baseline

```sh
BASELINE_ID=$(gh api "repos/{owner}/{repo}/pulls/$0/comments" \
  --jq '[.[].id] | max // 0')
BASELINE_REVIEWS=$(gh api "repos/{owner}/{repo}/pulls/$0/reviews" \
  --jq '[.[].id] | max // 0')
```

### 2. Spawn review subagent

Spawn an independent review subagent using the Task tool with `subagent_type: "general-purpose"`. The subagent:
- Has **no context** from the authoring session
- Is **read-only** — reviews and comments only
- Follows the **pr-review** skill protocol

**Default: 1 subagent.** For complex PRs (large diff, many files, multiple subsystems), ask the user before spawning 2-3 focused subagents.

If spawning multiple:
- Subagent A: correctness and security
- Subagent B: style, conventions, and completeness

### 3. Read new comments

```sh
gh api "repos/{owner}/{repo}/pulls/$0/comments" \
  --jq '[.[] | select(.id > BASELINE_ID)]'
gh api "repos/{owner}/{repo}/pulls/$0/reviews" \
  --jq '[.[] | select(.id > BASELINE_REVIEWS)]'
gh pr view $0 --comments
```

**No new comments?** Clean review — go to step 5.
**Comments exist?** Continue to step 4.

### 4. Address comments (pr-fix)

Follow the pr-fix protocol: for each comment, fix or decline AND reply on GitHub. Push when done. Wait for CI.

### 5. Assess and loop

- **Another round** if: substantive bugs were fixed (fixes may introduce new issues), or significant new code was written
- **No further round** if: only nits/suggestions, review was clean, or fixes were trivial (renames, formatting)
- **Max rounds (5):** exit — summarize remaining concerns

### 6. Report done

- Summarize what was reviewed and fixed across all rounds
- State exit reason (clean / minor issues / max rounds)
- List unresolved comments or open questions
- Note the PR is ready for Thomas's final review and merge

## Handling external comments

Treat human reviewer and bot comments the same as subagent feedback: read, address, and reply. But the loop is driven by the self-review subagents.

## Examples

### Example 1: Clean review

`/pr-review-loop 42` → spawn reviewer → no issues found → "Review clean. PR #42 ready."

### Example 2: Single round

`/pr-review-loop 38` → reviewer finds 2 issues (bug + nit) → fix both, reply → push, CI passes → trivial fixes, no further round → "Addressed 2 comments in 1 round. PR #38 ready."

### Example 3: Multiple rounds

`/pr-review-loop 55` → round 1: 3 bugs fixed → round 2: 1 nit in new code → "2 rounds. PR #55 ready."

## Notes

- Git commands with hooks need dev shell: `nix develop --command git commit` or `devbox run -- git commit`
- Don't use `--no-verify` to bypass hooks — fix the underlying issue
- Review subagents work from the same working directory and can read local files

## Troubleshooting

### Error: `git push` rejected — pre-push hook failed

**Cause:** Pre-push checks failed (e.g., `nix flake check`, `pytest`).
**Solution:** Fix the error, commit, retry push.

### Error: Review subagent can't post APPROVE

**Cause:** GitHub blocks PR authors from approving their own PRs.
**Solution:** Expected. Subagents post COMMENT reviews.

### Error: Comment reply API returns 404

**Cause:** Wrong endpoint for the comment type.
**Solution:** Inline review comments: `POST /repos/.../pulls/$0/comments/{id}/replies`. PR-level comments: `POST /repos/.../issues/$0/comments`.

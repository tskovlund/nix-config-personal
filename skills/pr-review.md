---
name: pr-review
description: >
  Review a PR for code quality, bugs, style, and correctness. Reads the diff,
  analyzes changes, and posts review comments on GitHub. Use when the user says
  "review PR", "review this PR", "code review", or when asked to review someone
  else's (or your own) PR. Also used as the review subagent in pr-review-loop.
  Do NOT use for iteratively fixing review feedback (use pr-review-loop).
user-invocable: true
argument-hint: "[PR-number-or-URL]"
allowed-tools: Bash(gh *), Read, Grep, Glob
metadata:
  author: tskovlund
  version: "3.0"
---

# PR review

Review a pull request for code quality, bugs, style, and correctness. Post findings as GitHub review comments.

## Context

Used in two ways:
1. **Standalone** — invoked directly to review any PR
2. **As subagent** — spawned by pr-review-loop for independent self-review

This skill is **read-only** — it posts comments but never modifies code.

## Gather PR context

```sh
gh pr view $0
gh pr diff $0
gh pr diff $0 --name-only
gh pr checks $0
gh pr view $0 --comments
gh repo view --json owner,name -q '.owner.login + "/" + .name'
```

## Review process

### 1. Understand the change

- Read PR description for intent
- Read linked issues for requirements
- Identify scope: which files, which subsystem
- Read surrounding code in modified files for context

### 2. Analyze the diff

For each changed file, assess:

- **Correctness** — logic errors, off-by-one, race conditions, edge cases, error paths
- **Security** — injection, path traversal, secrets, overly permissive permissions
- **Style/conventions** — repo patterns, naming, structure (check CLAUDE.md and CONVENTIONS.md)
- **Completeness** — docs updated, tests added, TODOs justified
- **Simplicity** — over-engineering, unnecessary abstractions

### 3. Read surrounding context

For non-trivial changes, read full files (not just hunks) to understand knock-on effects.

### 4. Post the review

Post as a **COMMENT review** (not APPROVE/REQUEST_CHANGES — GitHub blocks these for self-review).

**With inline comments (preferred):**

Build a JSON payload and write to a unique temp file:

```sh
gh api "repos/{owner}/{repo}/pulls/$0/reviews" \
  --input /tmp/review-payload-$0.json
```

Where the JSON contains:
```json
{
  "event": "COMMENT",
  "body": "## Review summary\n\n...",
  "comments": [
    {
      "path": "path/to/file.py",
      "line": 42,
      "side": "RIGHT",
      "body": "Bug: off-by-one — should be `< length` not `<= length`"
    }
  ]
}
```

**Simple reviews:**
```sh
gh pr review $0 --comment --body "Review summary."
```

### 5. Summarize

- **Verdict:** clean / minor issues / significant issues
- **Key findings:** bullet list
- **Suggestions:** optional non-blocking improvements

## Severity levels

- **Bug:** — correctness issue causing wrong behavior
- **Security:** — potential vulnerability
- **Nit:** — style/preference, non-blocking
- **Question:** — need clarification
- **Suggestion:** — improvement idea, non-blocking

## Review comment guidelines

- Be specific — point to exact lines, explain consequences
- Distinguish blocking (Bug, Security) from non-blocking (Nit, Suggestion)
- Offer fixes — use GitHub suggestion syntax where applicable
- One concern per comment
- Acknowledge good work when warranted

## Examples

### Example 1: Standalone review

`/pr-review 50` → gather context → read diff → find 1 nit → post COMMENT review → "Minor issues — 1 suggestion."

### Example 2: Self-review as subagent

Spawned by pr-review-loop for PR #42 → fresh context → find 2 bugs → post review → return "Significant issues — 2 bugs found."

## Troubleshooting

### Error: Review comment position is invalid

**Cause:** `position` refers to diff hunk position, not file line number.
**Solution:** Use `line` with `side: "RIGHT"` instead.

### Error: Cannot post APPROVE on own PR

**Cause:** GitHub blocks this for self-review.
**Solution:** Use COMMENT event — expected behavior.

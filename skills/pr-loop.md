---
name: pr-loop
description: >
  Self-review loop for a pull request: spawn an independent reviewer, address
  every finding, reply to every comment, iterate until clean. Use right after
  opening or pushing a PR, and when the user says "review loop", "self-review",
  "review this PR", "feedback loop", or asks for a PR to be made ready.
user-invocable: true
argument-hint: "[pr-number]"
---

# PR review loop

Run this after opening a PR, or whenever asked to self-review one.

## The reviewer must be independent

Spawn a **fresh-context** subagent to review. It reads the committed head from
GitHub itself — pin it to the SHA (`gh pr view --json headRefOid`). Never hand
it a diff you captured, and never review your own work in your own context: a
reviewer that already believes the change is correct finds nothing.

## Addressing findings

Address every finding, or justify declining it **in a GitHub reply**. The
dismissal bar is high: "minor", "rare", "small edge case" are not reasons to
skip a fix — if the fix is cheap, do it. Decline only when the finding is
factually wrong or the change would be worse.

**Reply to every review comment on GitHub.** An unaddressed comment is
indistinguishable from an ignored one, and Thomas reads the thread, not your
summary.

## Iterating

Up to 5 rounds: review → fix → push → wait for CI → re-review the new head.
Stop when CI is green and no comment is unresolved. If round 5 still isn't
clean, stop and report what's outstanding rather than continuing.

## Handoff

Assign Thomas to every PR he needs to review. Then hand it over and stop —
**never merge a PR that is gated on his review**, no matter how green it is.

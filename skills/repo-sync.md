---
name: repo-sync
description: >
  Ensure the current repo is up-to-date with remote. Auto-triggers at
  session start when working in a git repo, or when about to push changes.
  Use when the user says "sync", "pull", "am I up to date", or when
  starting work in a repo that may have remote changes.
user-invocable: true
allowed-tools: Bash(git *), Bash(gh *), Bash(find *)
metadata:
  author: tskovlund
  version: "2.0"
---

# Repo sync

Ensure the repo is current before starting work. Act silently when safe, report when something needs attention.

## Checks and actions

### 1. Fetch and sync remote

```sh
git fetch --quiet
git status -sb
```

- **Behind (no local changes):** auto-pull: `git pull --rebase --quiet`. Report: "Pulled N commits."
- **Behind (with local changes):** warn: "Remote has N new commits, but there are local changes."
- **Diverged:** warn: "Local and remote have diverged. Rebase or merge?"
- **Ahead:** note only — unpushed commits from a previous session.

### 2. Uncommitted changes

```sh
git status --short
```

Mention briefly but don't block — may be intentional work-in-progress.

### 3. Stale branches

```sh
git branch -vv
```

Look for `[gone]` branches (tracking deleted remotes). Mention if found.

### 4. Nix-config specific

Only when working in nix-config or nix-config-personal:

**Flake input freshness:**
```sh
# Cross-platform: check if flake.lock is older than 14 days
if [ -n "$(find . -maxdepth 1 -name flake.lock -mtime +14 2>/dev/null)" ]; then
  echo "Flake inputs are stale"
fi
```

If stale, suggest: "Flake inputs are over 14 days old. Consider `/nix-update`."

**Personal flake sync (nix-config only):**

If nix-config-personal exists, fetch and auto-pull if safe fast-forward:
```sh
PERSONAL_DIR=$(eval echo ~)/repos/nix-config-personal
if [ -d "$PERSONAL_DIR" ]; then
  git -C "$PERSONAL_DIR" fetch --quiet
  git -C "$PERSONAL_DIR" pull --rebase --quiet 2>/dev/null
fi
```

## Output format

If everything is clean, say nothing — proceed with the user's task.

If actions were taken:
> Pulled 3 commits from remote. Flake inputs are 18 days old — consider `/nix-update`.

## What NOT to do

- Don't block the user's task — sync and move on
- Don't repeat checks within the same session unless asked
- Don't force-push, rebase published branches, or resolve conflicts automatically

## Troubleshooting

### `git fetch` fails with authentication error

**Solution:** Check `ssh-add -l` for loaded keys. Try `gh auth status`.

### `git pull --rebase` causes conflicts

**Solution:** Don't auto-resolve. Warn: "Rebase conflict on pull. Resolve manually."

### Flake input age check gives wrong result on Linux

**Cause:** Previous versions used macOS-specific `stat -f "%m"`.
**Solution:** Now uses `find -mtime` which works on both macOS and Linux.

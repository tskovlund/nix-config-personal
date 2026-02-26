---
name: skill-update
description: >
  Update existing Claude Code skills. Handles the edit-commit-deploy cycle
  for personal skills and the edit-commit cycle for project skills. Use when
  the user says "update skill", "edit skill", "change skill", "improve skill",
  or when implementing approved changes from skill-evolve. Do NOT use for
  creating new skills (use skill-add).
user-invocable: true
argument-hint: "[skill-name]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(git *), Bash(nix develop --command *), Bash(ls *), Bash(head *)
metadata:
  author: tskovlund
  version: "3.0"
---

# Update an existing skill

Edit, commit, and deploy changes to an existing Claude Code skill. Follow the skill-write guide for writing quality standards.

## Step 1: Identify the skill and type

```sh
ls -la ~/.claude/skills/<name>/SKILL.md  # symlink = personal, regular file = project
```

**Personal skill** — source: `~/repos/nix-config-personal/skills/<name>.md`
**Project skill** — edit directly: `<repo>/.claude/skills/<name>/SKILL.md`

## Step 2: Edit the source

For personal skills, edit `skills/<name>.md` in nix-config-personal (NOT the deployed symlink). For project skills, edit directly. Bump `metadata.version`.

## Step 3: Commit

```sh
cd ~/repos/nix-config-personal
git add skills/<name>.md
nix develop --command git commit -m "feat: update <name> skill"
git push
```

## Step 4: Deploy

```sh
cd ~/repos/nix-config
make switch PERSONAL_INPUT=path:$HOME/repos/nix-config-personal
# Or after pushing: make switch REFRESH=1
```

## Batch updates

Edit all sources first, then commit in one batch:

```sh
cd ~/repos/nix-config-personal
git add skills/*.md
nix develop --command git commit -m "feat: update skills — <summary>"
```

## Troubleshooting

### Error: Deployed file unchanged after make switch

**Cause:** Nix input cache served the old flake.
**Solution:** Use `PERSONAL_INPUT=path:...` for local changes, or `REFRESH=1` after pushing.

### Error: Permission denied editing deployed SKILL.md

**Cause:** Editing the home-manager symlink instead of the source.
**Solution:** Edit `~/repos/nix-config-personal/skills/<name>.md`.

### Skill doesn't reload after deploy

**Cause:** Claude Code caches skills per session.
**Solution:** Start a new session to pick up changes.

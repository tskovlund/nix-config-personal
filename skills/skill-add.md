---
name: skill-add
description: >
  Create a new Claude Code skill, handling the full workflow: write SKILL.md,
  wire into nix module, and commit. Use when the user says "add a skill",
  "create a skill", "new skill", or when skill-evolve identifies a workflow
  that should become a skill. Do NOT use for updating existing skills
  (use skill-update).
user-invocable: true
argument-hint: "[skill-name]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(git *), Bash(nix develop --command *), Bash(ls *)
metadata:
  author: tskovlund
  version: "3.0"
---

# Add a new Claude Code skill

Full automation for creating and deploying skills. Follow the skill-write guide for writing quality standards.

## Step 1: Determine skill type

**Personal skill** (`~/.claude/skills/`, deployed via home-manager):
- Cross-project workflows, workspace IDs, personal conventions
- Deployed to all projects via home-manager
- Lives in nix-config-personal (`skills/<name>.md`)

**Project skill** (`.claude/skills/` in a repo):
- Project-specific conventions and workflows
- Committed directly to the repo

## Step 2: Design the skill

Confirm with Thomas:
- **Name**: `<topic>-<action>` pattern (see skill-write for naming convention)
- **Type**: slash-invocable, auto-only, or both (`user-invocable` field)
- **Allowed tools**: least privilege
- **Arguments**: does it take arguments? What hint?

## Step 3: Write SKILL.md

Follow the **skill-write** guide for frontmatter, body structure, quality checklist, and progressive disclosure. Write to `skills/<name>.md` for personal skills, or `.claude/skills/<name>/SKILL.md` for project skills.

## Step 4: Deploy

### Personal skills (nix-config-personal)

```sh
# 1. Write the skill file to skills/<name>.md

# 2. Add to home/skills.nix — both home.file entry and managedSkills list
home.file.".claude/skills/<name>/SKILL.md".source = ../skills/<name>.md;
# And add "<name>" to the managedSkills list

# 3. Commit
git add skills/<name>.md home/skills.nix
nix develop --command git commit -m "feat: add <name> skill"
```

### Project skills

```sh
mkdir -p .claude/skills/<name>
# Write SKILL.md
git add .claude/skills/<name>/SKILL.md
git commit -m "feat(claude): add <name> skill"
```

## Step 5: Verify

```sh
ls -la ~/.claude/skills/<name>/          # personal
head -5 ~/.claude/skills/<name>/SKILL.md
```

Start a new Claude Code session to confirm the skill appears.

## Renaming a skill

1. Rename the file in `skills/`, update `home/skills.nix` (home.file entry + managedSkills)
2. Update cross-references in other skills
3. Deploy — `cleanStaleSkills` activation removes stale directories automatically

## Notes

- After pushing nix-config-personal, use `make switch REFRESH=1` in nix-config
- Skills are plaintext and committed directly to the repo

## Troubleshooting

### Error: Skill doesn't appear after deploy

**Cause:** Missing entry in `managedSkills` or `home.file` in `skills.nix`.
**Solution:** Check both are consistent.

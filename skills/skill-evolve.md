---
name: skill-evolve
description: >
  Background awareness for keeping skills up-to-date and proposing new ones.
  Active when completing tasks that follow repeatable workflows, when
  struggling with tasks that a skill could have helped with, when a skill's
  instructions didn't match reality, or when updating CLAUDE.md with content
  that might work better as a skill.
user-invocable: false
metadata:
  author: tskovlund
  version: "2.0"
---

# Skill evolution

Background awareness for maintaining, improving, and healing the Claude Code skills system. See the skill-write guide for writing quality standards and checklists.

## When to consider new skills

**After completing a task:** Did I follow a repeatable workflow that isn't yet a skill?
- Multi-step process I'd do the same way next time
- Conventions from CLAUDE.md that could be loaded on demand
- Specific tools in a specific order

**After struggling with a task:** Would a skill have helped?
- Had to search for conventions that should be readily available
- Made a mistake that instructions would have prevented

**When updating CLAUDE.md:** Should this be a skill instead?
- CLAUDE.md = always loaded (every token counts)
- Skills = loaded on demand (better for reference material and workflows)

## When to update existing skills

- A step failed in a real scenario the skill didn't account for
- A command, tool, or API changed behavior
- A better approach was discovered
- A skill contradicts reality (renamed file, changed convention, removed skill)

## Infrastructure healing

Watch for and fix:

- **Stale symlinks after renames** — `cleanStaleSkills` activation handles this via `managedSkills` list in `home/skills.nix`
- **Missing skills after deploy** — check `skills.nix` has both the `home.file` entry and the name in `managedSkills`

## Applying changes

### Direct corrections → apply immediately

When Thomas corrects behavior ("you should have done X"), this is implicit approval. Use `/skill-update` and briefly confirm what changed. The correction is the approval.

### New skills and major redesigns → propose first

For speculative new skills or architectural changes, propose: name, type (slash/auto/both), personal vs project, outline of content. Use `/skill-add` after approval.

### Edge case fixes → use judgment

Obvious, low-risk fixes: apply via `/skill-update` and mention the change. Behavior-changing fixes: propose first.

## Naming convention

See skill-write for the `<topic>-<action>` naming pattern and examples.

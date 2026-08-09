---
name: skill
description: >
  Create, update, or remove a personal Claude Code skill, including the nix
  wiring and deployment. Use when the user says "add a skill", "new skill",
  "update the skill", "edit a skill", "remove a skill", or when a repeated
  workflow or a confirmed correction should be captured as one.
user-invocable: true
argument-hint: "[skill-name]"
---

# Skills

## Where they live

Personal skills are one markdown file each in
`~/repos/nix-config-personal/skills/<name>.md`, deployed to
`~/.claude/skills/<name>/SKILL.md`.

Wiring is `home/skills.nix`: the `managedSkills` list drives both the `home.file`
entries and the `cleanStaleSkills` activation, so **adding a name to that list is
the whole wiring change** — check the file before assuming, since a past version
required editing two places.

Deploy with `make switch` in `~/repos/nix-config` (Thomas runs it — it needs
sudo). `cleanStaleSkills` removes directories for skills no longer in the list,
so renames and deletions clean up on their own.

**Verify in a fresh session.** Skills are read once per session; the current one
will keep using the old body no matter what is on disk.

Project-specific skills instead live in `<repo>/.claude/skills/<name>/SKILL.md`,
committed to that repo — no nix involved.

## Style law

A skill is context the model doesn't have, not a tutorial for the model. Write
only:

1. **Facts it can't know** — IDs, paths, repo lists, which gate a repo uses.
2. **Thomas's preferences** — the choice he'd make where several are defensible.
3. **Guardrails earned from incidents** — with enough of the why that the rule
   survives a plausible-sounding reason to break it.
4. **Trigger and routing glue** — when this skill applies, and which sibling
   handles the neighbouring case.

Cut everything else. No step-by-step procedures the model already knows, no
Examples or Troubleshooting or What-NOT-to-do sections, no restating CONVENTIONS.md.

Frontmatter is `name`, `description`, and `user-invocable: true` where it makes
sense as a slash command. **The description is the entire discovery mechanism** —
load it with the concrete phrases someone would actually type, plus negative
triggers pointing at the sibling skill. Skip `allowed-tools` unless it genuinely
constrains something.

Skills are plaintext in a public repo: no secrets, no revenue or strategy detail.

## When to propose one

When a workflow repeats, or a correction lands and Thomas confirms it, propose
the skill edit — **a confirmed correction is implicit approval to write it down.**

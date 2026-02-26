---
name: skill-write
description: >
  Skill writing guide and quality standards. Auto-triggers when creating or
  updating skills via skill-add, skill-update, or skill-evolve. Provides
  frontmatter rules, body structure, quality checklist, and progressive
  disclosure guidelines. Do NOT invoke directly.
user-invocable: false
metadata:
  author: tskovlund
  version: "1.0"
---

# Skill writing guide

Quality standards and structural guidelines for Claude Code skills.

## Frontmatter (required)

```yaml
---
name: skill-name-in-kebab-case
description: >
  [WHAT it does]. Use when [WHEN to trigger — specific phrases].
  Do NOT use for [negative triggers — what other skills handle].
user-invocable: true  # or false for auto-only
argument-hint: "[arg-description]"  # only if user-invocable with arguments
allowed-tools: [least privilege tool list]
metadata:
  author: tskovlund
  version: "1.0"
---
```

### Rules

- `name`: kebab-case, must match folder name. No "claude" or "anthropic" (reserved)
- `description`: under 1024 chars. MUST include WHAT + WHEN + negative triggers
- `user-invocable`: explicit on every skill — `true` for slash commands, `false` for auto-only
- `allowed-tools`: least privilege — only what the skill needs
- No XML angle brackets (`<` `>`) in frontmatter values

### Naming convention

Follow `<topic>-<action>` pattern. Group related skills by topic prefix:

- `issue-triage`, `issue-track`, `issue-hygiene` (topic: issue)
- `skill-add`, `skill-evolve`, `skill-update` (topic: skill)
- `memory-recall`, `memory-store` (topic: memory)
- `pr-review`, `pr-review-loop`, `pr-fix` (topic: pr)

## Body structure

Recommended sections (adapt per skill):

1. **Header** — one-line summary
2. **Safety** — pre-conditions, workspace checks (if mutations)
3. **Instructions** — clear, actionable steps with specific commands
4. **Examples** — 1-2 worked scenarios: "User says X → Actions → Result"
5. **Troubleshooting** — "Error: X / Cause: Y / Solution: Z" for known failures
6. **Notes** — edge cases, cross-references to related skills

## Quality checklist

- [ ] Description includes WHAT + WHEN + negative triggers
- [ ] `user-invocable` explicitly set
- [ ] Instructions are specific and actionable (commands, not vibes)
- [ ] At least 1-2 worked examples
- [ ] Error handling for known failure modes
- [ ] `allowed-tools` scoped to least privilege
- [ ] Under 500 lines (move detail to `references/` if needed)
- [ ] Cross-references to related skills where natural
- [ ] `metadata.version` set (and bumped on updates)

## Progressive disclosure

- **Level 1** (frontmatter): Always loaded — keep description tight, trigger-rich
- **Level 2** (SKILL.md body): Loaded when relevant — core instructions and examples
- **Level 3** (references/): Loaded on demand — detailed docs, templates, API patterns

Keep SKILL.md focused. If a section exceeds ~100 lines of reference material, move it to `references/` within the skill directory.

## Triggering quality

- Triggers on obvious queries (exact phrases in description)
- Triggers on paraphrased requests (natural language variations)
- Does NOT trigger on unrelated topics (negative triggers help)
- Distinguished from sibling skills in the same topic group

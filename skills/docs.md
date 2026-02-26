---
name: docs
description: >
  Write and structure documentation using the Diataxis framework. Use when
  writing READMEs, runbooks, guides, reference docs, or restructuring existing
  documentation. Use when the user says "write docs", "document this",
  "add documentation", or when creating a new file that is primarily
  documentation. Do NOT use for code comments or commit messages.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
metadata:
  author: tskovlund
  version: "2.0"
---

# Documentation skill

Write clear, well-structured documentation using the Diataxis framework.

## The Diataxis framework

Every piece of documentation serves one of four purposes. Identify which type before starting.

### 1. Tutorials (learning-oriented)

Teach a beginner through a hands-on experience.
- Show the destination upfront, deliver results early
- Use "we" language, minimize explanation, focus on the concrete
- Ignore alternatives — stay on the direct path
- Must be perfectly reliable — test every step

### 2. How-to guides (task-oriented)

Help a competent user accomplish a specific goal.
- Title states the goal: "How to add a new secret"
- Ordered steps, no teaching, no reference material
- Name by user need, not tool operation

### 3. Reference (information-oriented)

Describe the machinery — what exists and how it works.
- Austere and authoritative — facts, not opinions
- Structure mirrors the thing documented
- Consistent patterns, consulted not read

### 4. Explanation (understanding-oriented)

Provide context, background, and the "why."
- Higher, wider perspective — makes connections
- Admits opinion, considers alternatives
- Title implies "about": "About the base/personal split"

## Identifying the type

| Reader's mode | They need | Type |
|---------------|-----------|------|
| Learning a new skill | A guided experience | **Tutorial** |
| Trying to get something done | Steps to follow | **How-to guide** |
| Looking up specific info | Facts and descriptions | **Reference** |
| Wanting to understand | Context and reasoning | **Explanation** |

## Writing guidelines

- Lead with the most important information
- Short sentences, short paragraphs
- Tables for structured data, code blocks for commands
- Link to other docs rather than duplicating
- Keep docs close to what they document

## Structural patterns

**README.md:** project name, what this is, quick start, architecture, commands
**Runbook:** quick reference table, common tasks, troubleshooting, disaster recovery
**Architecture doc:** overview, components, data flow, conventions

## Examples

### Example 1: "document the miles server"

→ Operational reference + how-to → runbook with quick reference, common tasks, troubleshooting, disaster recovery.

### Example 2: "write a README"

→ Reference with quick-start tutorial → follow README pattern, quick start under 5 steps.

### Example 3: "explain why we chose Resend"

→ Explanation → decision record: context, options, trade-offs, rationale.

## Troubleshooting

### Docs are too long

**Cause:** Mixing Diataxis types in one document.
**Solution:** Split. Tutorial shouldn't contain reference tables.

### Docs go stale

**Cause:** Documentation far from what it documents.
**Solution:** Keep docs close to code. Prefer generated docs where possible.

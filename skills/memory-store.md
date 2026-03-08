---
name: memory-store
description: >
  Store decisions, preferences, findings, debugging insights, and personal
  context in semantic memory. Auto-triggers after completing tasks that involved
  decisions worth preserving, after debugging sessions that produced reusable
  insights, when the user explicitly confirms a preference or convention, after
  research or exploration that produced durable findings, and when personal
  information is shared that a personal assistant should remember. Do NOT use
  for querying existing knowledge (use memory-recall).
user-invocable: false
allowed-tools: mcp__memory__memory_store, mcp__memory__memory_search, mcp__memory__memory_update, mcp__memory__memory_delete
metadata:
  author: tskovlund
  version: "3.0"
---

# Memory store

Persist durable knowledge to semantic memory so future sessions benefit.

## When to store

- **Decision with rationale** — choice AND why (alternatives, trade-offs)
- **After debugging** — root cause + solution for recurring problems
- **User confirms preference** — "always do X", "I prefer Y"
- **After research** — findings that save time if encountered again
- **Something surprisingly hard** — the insight is worth preserving
- **Personal context** — facts about Thomas, his life, relationships, taste,
  goals, and preferences that make interactions more personal and useful

## What NOT to store

- **Instructions** — belong in CLAUDE.md (loaded every session)
- **Session context** — current task, in-progress work, temporary state
- **Unverified conclusions** — verify before storing
- **CLAUDE.md duplicates** — memory supplements, doesn't replace
- **Trivial facts** — obvious from reading the code

## How to store

Use `memory_store` with content (freeform text) and tags (list of strings).

**Content:** Write clear, searchable prose. Include context so semantic search
finds it. A title line followed by bullet points works well.

**Tags:** Use descriptive tags for filtering:
- **Topic tags:** `nix`, `cambr`, `skovlund.dev`, `mcp-score`, `eliza`, `vps`
- **Type tags:** `decision`, `preference`, `debugging`, `gotcha`, `convention`,
  `finding`, `personal`, `reference`
- **Domain tags:** `infrastructure`, `ci`, `git`, `deployment`, `taste`

## Updating existing knowledge

Search before creating. If a relevant memory exists:
- **Update** it with `memory_update` (add new info, correct old info)
- **Delete** with `memory_delete` if completely superseded
- **Store new** if the topic is distinct enough to warrant a separate entry

## Examples

### Example 1: Decision

Thomas decides to use `mkOutOfStoreSymlink` for dotfiles.

```
memory_store:
  content: "nix-config dotfile symlink strategy: Use mkOutOfStoreSymlink.
    Alternative was file copy but requires rebuild on every edit."
  tags: ["decision", "nix", "infrastructure"]
```

### Example 2: Debugging insight

agenix secrets not updating after deploy.

```
memory_store:
  content: "agenix deploy cache gotcha: Nix input cache serves old flake.
    Fix: PERSONAL_INPUT=path:... or REFRESH=1."
  tags: ["debugging", "gotcha", "nix", "agenix"]
```

### Example 3: Personal context

Thomas shares something about his life.

```
memory_store:
  content: "Thomas plays piano — jazz, classical, and film music.
    Has a Yamaha CLP-785 digital piano. Studied at conservatory briefly."
  tags: ["personal", "music", "hobbies"]
```

## Troubleshooting

### Memory grows too large

**Solution:** Use `memory_cleanup` or manually review with `memory_list`.
Delete session-specific, CLAUDE.md-duplicated, or irrelevant entries.

---
name: memory-store
description: >
  Store decisions, preferences, findings, and debugging insights in the MCP
  knowledge graph. Auto-triggers after completing tasks that involved decisions
  worth preserving, after debugging sessions that produced reusable insights,
  when the user explicitly confirms a preference or convention, and after
  research or exploration that produced durable findings. Do NOT use for
  querying existing knowledge (use memory-recall).
user-invocable: false
allowed-tools: mcp__memory__create_entities, mcp__memory__create_relations, mcp__memory__add_observations, mcp__memory__delete_entities, mcp__memory__delete_observations, mcp__memory__delete_relations, mcp__memory__search_nodes
metadata:
  author: tskovlund
  version: "2.0"
---

# Memory store

Persist durable knowledge to the knowledge graph so future sessions benefit.

## When to store

- **Decision with rationale** — choice AND why (alternatives, trade-offs)
- **After debugging** — root cause + solution for recurring problems
- **User confirms preference** — "always do X", "I prefer Y"
- **After research** — findings that save time if encountered again
- **Something surprisingly hard** — the insight is worth preserving

## What NOT to store

- **Instructions** — belong in CLAUDE.md (loaded every session)
- **Session context** — current task, in-progress work, temporary state
- **Unverified conclusions** — verify before storing
- **CLAUDE.md duplicates** — memory supplements, doesn't replace
- **Trivial facts** — obvious from reading the code

## Entity naming

Descriptive and searchable — think about future search terms:
- Include context: `nix-config-dotfile-symlink-strategy` not `symlink-rule`
- Lowercase hyphens: `skovlund-dev-blog-setup` not `Blog Setup`

## Relationship types

- `DECIDED` — a decision was made
- `PREFERS` — Thomas prefers this approach
- `DEPENDS_ON` — X requires Y
- `RELATES_TO` — general connection
- `SUPERSEDES` — replaces a previous decision

## Updating existing knowledge

Search before creating. If found:
- **Add observation** to existing entity (not a duplicate)
- **SUPERSEDES** relationship if old info is wrong
- **Delete** observations that are no longer true

## Examples

### Example 1: Decision

Thomas decides to use `mkOutOfStoreSymlink` for dotfiles.

→ Entity: `nix-config-dotfile-symlink-strategy`, type: decision
→ Observation: "Use mkOutOfStoreSymlink. Alternative was file copy but requires rebuild on every edit."

### Example 2: Debugging insight

agenix secrets not updating after deploy.

→ Entity: `agenix-deploy-cache-gotcha`, type: debugging-insight
→ Observation: "Nix input cache serves old flake. Fix: PERSONAL_INPUT=path:... or REFRESH=1."

## Troubleshooting

### Memory graph grows too large

**Solution:** Review and prune. Delete session-specific, CLAUDE.md-duplicated, or irrelevant entities.

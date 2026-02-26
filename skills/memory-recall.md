---
name: memory-recall
description: >
  Recall relevant context from the MCP knowledge graph. Auto-triggers at the
  start of every session, when encountering topics that may have prior decisions
  or findings, before making architectural or workflow decisions, and when the
  user references prior work or preferences. Do NOT use for storing new
  knowledge (use memory-store).
user-invocable: false
allowed-tools: mcp__memory__search_nodes, mcp__memory__read_graph, mcp__memory__open_nodes
metadata:
  author: tskovlund
  version: "2.0"
---

# Memory recall

Search the persistent knowledge graph for prior decisions, preferences, and findings before acting.

## When to search

- **Every session start** — context relevant to the task at hand
- **Before making decisions** — check if decided before
- **Familiar topics** — may have stored findings
- **User references prior work** — "remember when we...", "like last time"
- **Before proposing alternatives** — don't suggest something already rejected

## How to search

Search is **literal, not fuzzy**. Try multiple phrasings:

1. **Specific term**: `nix-config`, `cambr`, `skovlund.dev`
2. **Related concepts**: `home-manager module`, `flake input`
3. **Decision area**: `git workflow`, `deployment`, `styling`
4. **Abbreviations + full names**: `HM` and `home-manager`

If first search returns nothing, try at least 2 more phrasings.

## What to do with results

- **Prior decision found** → follow it unless clear reason to diverge (flag if diverging)
- **Preference found** → apply it without re-confirming
- **Outdated info found** → note it (memory-store handles updates)
- **Nothing found** → proceed normally

## Examples

### Example 1: Session start

Working on nix-config → search `nix-config`, `nix convention` → find dotfile strategy → apply it.

### Example 2: Before a decision

Structuring a new module → search `module structure`, `module pattern` → find prior convention → follow it.

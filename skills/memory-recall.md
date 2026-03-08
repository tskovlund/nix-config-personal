---
name: memory-recall
description: >
  Recall relevant context from semantic memory. Auto-triggers at the start of
  every session, when encountering topics that may have prior decisions or
  findings, before making architectural or workflow decisions, and when the user
  references prior work or preferences. Do NOT use for storing new knowledge
  (use memory-store).
user-invocable: false
allowed-tools: mcp__memory__memory_search, mcp__memory__memory_list, mcp__memory__memory_graph
metadata:
  author: tskovlund
  version: "3.0"
---

# Memory recall

Search semantic memory for prior decisions, preferences, personal context, and
findings before acting.

## When to search

- **Every session start** — context relevant to the task at hand
- **Before making decisions** — check if decided before
- **Familiar topics** — may have stored findings
- **User references prior work** — "remember when we...", "like last time"
- **Before proposing alternatives** — don't suggest something already rejected
- **Personal interactions** — recall personal context for better assistance

## How to search

Search uses **semantic matching** (ONNX embeddings). Queries can be natural
language — meaning matters more than exact keywords.

1. **Natural query**: "how do we handle dotfiles in nix-config"
2. **Topic search**: "cambr architecture"
3. **Personal**: "Thomas music preferences"

One well-phrased query usually suffices. If results seem incomplete, try a
different angle — but semantic search is much more forgiving than keyword search.

You can also filter by tags when you know the category:
- `tags: ["decision"]` — all decisions
- `tags: ["personal"]` — personal context about Thomas
- `tags: ["nix", "gotcha"]` — Nix-specific gotchas

## What to do with results

- **Prior decision found** → follow it unless clear reason to diverge (flag if diverging)
- **Preference found** → apply it without re-confirming
- **Personal context found** → use naturally in conversation
- **Outdated info found** → note it (memory-store handles updates)
- **Nothing found** → proceed normally

## Examples

### Example 1: Session start

Working on nix-config → search "nix-config conventions and decisions" → find
dotfile strategy → apply it.

### Example 2: Before a decision

Structuring a new module → search "module structure conventions" → find prior
convention → follow it.

### Example 3: Personal context

Thomas mentions a trip → search "Thomas travel Netherlands" → recall he's
planning to move to be with Maud → respond with awareness.

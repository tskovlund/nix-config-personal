---
name: docs
description: >
  Write or restructure documentation — guides, runbooks, reference, explanation,
  docs/ layout. Use when the user says "write docs", "document this", "add
  documentation", or when creating a file that is primarily documentation. Do
  NOT use for READMEs (use readme-write) or for code comments.
user-invocable: true
---

# Docs

Use **Diataxis** as a thinking tool, not a filing system: decide whether the
reader is learning (tutorial), doing (how-to), looking something up (reference),
or trying to understand (explanation) — then write one of those, not a blend.
Mixing modes in one document is what makes docs bloated and unreadable.

**The README sells, `docs/` teaches.** Keep the README as a landing page and
push depth into `docs/`, linked from it. Small repos where the README covers
everything don't need a `docs/` directory at all.

Every README ends with an Author section, and a License section below it when
the repo is licensed — see `readme-write`.

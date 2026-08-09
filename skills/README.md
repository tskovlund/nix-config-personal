# Claude Code Skills

Personal skills deployed to `~/.claude/skills/<name>/SKILL.md` via home-manager. Claude Code loads a skill's body when its `description` matches what you're doing, or when you invoke it as `/<name>`.

For project-specific skills, see `.claude/skills/` in individual repos (e.g. nix-config has `nix-update`, `nix-debug`, `nix-module`, `nix-secret`, `switch-verify`).

## Inventory

| Skill                             | Description                                                             |
| --------------------------------- | ----------------------------------------------------------------------- |
| [issues](issues.md)               | Linear vs GitHub routing, tracker conventions, public-repo privacy rules |
| [pr-loop](pr-loop.md)             | Independent-reviewer self-review loop until a PR is ready for Thomas     |
| [housekeeping](housekeeping.md)   | Recurring cross-repo maintenance sweep: bot PRs, alerts, branches, drift |
| [planning](planning.md)           | Backlog review and what-to-work-on-next                                  |
| [dep-update](dep-update.md)       | Per-repo dependency update commands and validation gates                 |
| [repo-sync](repo-sync.md)         | Sync with remote without ever endangering uncommitted work               |
| [docs](docs.md)                   | Diataxis as a thinking tool; README sells, `docs/` teaches               |
| [readme-write](readme-write.md)   | README structure and the house Author/License convention                 |
| [skill](skill.md)                 | Skill lifecycle, nix wiring, and the style law for writing skills        |

## How it works

Each skill is a single markdown file in this directory. [`home/skills.nix`](../home/skills.nix) reads the `managedSkills` list to generate the `home.file` entries, so **adding a name to that list is the entire wiring change**. The `cleanStaleSkills` activation removes deployed directories for skills no longer in the list, so renames and deletions clean up after themselves.

Deploy with `make switch` in nix-config. Skills are cached per session — verify in a **fresh** Claude Code session.

## Style

Skills carry only what the model can't derive: facts it has no way to know, Thomas's preferences among defensible options, guardrails earned from real incidents, and routing glue between sibling skills. No procedures the model already knows, no ceremony sections, no restating [CONVENTIONS.md](../../dot-github/CONVENTIONS.md). See [skill](skill.md) for the full standard.

## Sensitive data

Skills are plaintext in a public repo. Do **not** put secrets, API keys, revenue details, or strategy in skill files. Sensitive context belongs in the encrypted `~/.claude/CLAUDE.md` (managed via agenix).

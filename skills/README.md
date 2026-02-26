# Claude Code Skills

Personal skills deployed to `~/.claude/skills/` via home-manager. These are loaded by Claude Code based on context and slash commands.

For project-specific skills, see `.claude/skills/` in individual repos (e.g., nix-config has `nix-update`, `nix-debug`, `nix-module`, `nix-secret`, `switch-verify`).

## Inventory

### Issue management

| Skill | Type | Description |
|-------|------|-------------|
| [issue-triage](issue-triage.md) | slash + auto | Shape and promote Linear triage issues into actionable backlog items |
| [issue-track](issue-track.md) | slash + auto | Capture ideas and tasks — routes to GitHub Issues or Linear |
| [issue-hygiene](issue-hygiene.md) | slash | Audit and sync issues with reality across both trackers |

### PR workflow

| Skill | Type | Description |
|-------|------|-------------|
| [pr-review](pr-review.md) | slash | Review a PR for bugs, style, and correctness; post comments on GitHub |
| [pr-fix](pr-fix.md) | auto | Address review comments: fix code + reply to every comment |
| [pr-review-loop](pr-review-loop.md) | slash + auto | Orchestrate review/fix cycles until a PR is clean |

### Planning

| Skill | Type | Description |
|-------|------|-------------|
| [planning](planning.md) | slash + auto | Prioritize the Linear backlog using strategic goals |

### Memory

| Skill | Type | Description |
|-------|------|-------------|
| [memory-recall](memory-recall.md) | auto | Query MCP knowledge graph for prior decisions and context |
| [memory-store](memory-store.md) | auto | Persist decisions, preferences, and findings to knowledge graph |

### Dev workflow

| Skill | Type | Description |
|-------|------|-------------|
| [onboard](onboard.md) | slash + auto | Explore and internalize an unfamiliar repo's architecture |
| [repo-sync](repo-sync.md) | slash + auto | Ensure repo is up-to-date with remote before starting work |
| [test-write](test-write.md) | slash + auto | Generate tests following CONVENTIONS.md rules |
| [dep-update](dep-update.md) | slash | Update project dependencies and verify nothing breaks |
| [docs](docs.md) | slash | Write documentation using the Diataxis framework |

### Skill management

| Skill | Type | Description |
|-------|------|-------------|
| [skill-add](skill-add.md) | slash | Create a new skill: write, wire into nix, commit |
| [skill-update](skill-update.md) | slash | Edit an existing skill: modify, commit, deploy |
| [skill-evolve](skill-evolve.md) | auto | Background awareness for skill improvements and new skill candidates |
| [skill-write](skill-write.md) | auto | Writing guide, quality checklist, and naming conventions |

## How it works

Skills are plaintext markdown files in this directory, deployed to `~/.claude/skills/<name>/SKILL.md` via `home.file` entries in [`home/skills.nix`](../home/skills.nix).

Each skill has YAML frontmatter that Claude Code reads to determine when to load the skill body:
- **`description`** — triggers matching (WHAT + WHEN + negative triggers)
- **`user-invocable`** — whether it can be called as `/skill-name`
- **`allowed-tools`** — least-privilege tool access

### Adding a skill

1. Write `skills/<name>.md` following the [skill-write](skill-write.md) guide
2. Add a `home.file` entry and `managedSkills` entry in `home/skills.nix`
3. Commit, push, `make switch REFRESH=1`

### Naming convention

`<topic>-<action>` pattern. Related skills share a topic prefix:
- `issue-*`, `pr-*`, `memory-*`, `skill-*`

## Sensitive data

Skills are plaintext in a public repo. Do **not** put secrets, API keys, or personal goals in skill files. Sensitive context belongs in the encrypted `~/.claude/CLAUDE.md` (managed via agenix).

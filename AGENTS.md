# nix-config-personal

Personal identity, secrets, and config for [nix-config](https://github.com/tskovlund/nix-config).

Follow the code standards in [CONVENTIONS.md](CONVENTIONS.md).

## What this repo is

This flake exports two things that nix-config consumes via `--override-input`:

- **`identity`** — username, name, email (consumed by `flake.nix` and `home/git/`)
- **`homeModules`** — list of home-manager modules for secrets, SSH, and personal dotfiles (imported by personal targets)

## Interface contract

nix-config depends on this exact structure:

```nix
{
  identity = {
    isStub = false;     # must be false for real identity
    username = "...";   # system user, home directory path
    fullName = "...";   # git author name
    email = "...";      # git author email
  };

  homeModules = [ ... ];  # list of home-manager modules (can be empty)
}
```

Do not rename, remove, or change the types of these fields without updating nix-config's consumers.

## Secrets (agenix)

This repo is the **canonical home for the secrets workflow** — nix-config's AGENTS.md points here rather than duplicating it.

Secrets are age-encrypted in `secrets/`. A single portable age key (`~/.config/agenix/age-key.txt`) decrypts everything — the same key is copied to every machine.

- `secrets/secrets.nix` — maps `.age` files to recipient public keys
- `secrets/*.age` — encrypted secret files
- `files/` — plaintext public keys and non-secret files. Plaintext working copies of encrypted content are gitignored; only `.age` files are committed.
- `skills/` — Claude Code skill files (plaintext, deployed to `~/.claude/skills/` by `home/skills.nix`). Adding or renaming a skill means updating the `managedSkills` list there — its cleanup activation uses that list to delete stale directories.

### Adding a new secret

1. Add the entry to `secrets/secrets.nix`
2. Encrypt with the agenix CLI (recommended — reads recipients from `secrets/secrets.nix`): `agenix -e secrets/<name>.age`
   Or manually: `age -r <pubkey-from-secrets.nix> -o secrets/<name>.age <plaintext-file>`
3. Declare `age.secrets.<name>` in a home-manager module under `home/`
4. Reference the decrypted path via `config.age.secrets.<name>.path`

After changing recipients, re-encrypt everything with `cd secrets && agenix -r`.

### SSH key naming convention

Keys follow `id_ed25519_<purpose>`:

- `id_ed25519_github` — GitHub authentication + commit signing
- `id_ed25519_miles` — Hetzner VPS (miles) SSH access + deployment
- Future: `id_ed25519_<hostname>` for additional hosts, `id_ed25519_work`, etc.

### Updating ~/.claude/CLAUDE.md

The global Claude Code instructions file is agenix-encrypted (`secrets/claude-global-context.md.age`) and decrypted on `make switch`. The plaintext source at `files/CLAUDE.md` is gitignored.

`agenix -e secrets/claude-global-context.md.age` decrypts, opens `$EDITOR`, and re-encrypts on save. Commit the `.age` file, then `make switch` in nix-config to deploy. The deployed file is a read-only agenix symlink — edits must go through this path.

## Development

The flake provides a dev shell with `nixfmt`, `statix`, and `deadnix`. Enter it with `nix develop` or automatically via direnv (`.envrc`). Hooks in `.githooks/` are activated by the dev shell: pre-commit formats and lints staged `.nix` files, pre-push runs `nix flake check --all-systems`.

Git commands that trigger hooks need those tools, so prefix with `nix develop --command` when not already in the dev shell.

Branch protection matches nix-config: "Protect main" ruleset, no force push (owner can bypass), no deletion, Copilot auto-review, required CI status checks.

## Testing

```sh
# Validate the flake
nix flake check

# Test integration with nix-config
cd ~/repos/nix-config
make switch PERSONAL_INPUT=path:$HOME/repos/nix-config-personal
```

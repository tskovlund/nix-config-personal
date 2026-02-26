# CLAUDE.md — nix-config-personal

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

Secrets are age-encrypted in `secrets/`. A single portable age key (`~/.config/agenix/age-key.txt`) decrypts everything — the same key is copied to every machine.

- `secrets/secrets.nix` — maps `.age` files to recipient public keys
- `secrets/*.age` — encrypted secret files
- `files/` — plaintext public keys and non-secret files

### Adding a new secret

1. Add the entry to `secrets/secrets.nix`
2. Encrypt with the agenix CLI (recommended — reads recipients from `secrets/secrets.nix`): `agenix -e secrets/<name>.age`
   Or manually: `age -r <pubkey-from-secrets.nix> -o secrets/<name>.age <plaintext-file>`
3. Declare `age.secrets.<name>` in a home-manager module under `home/`
4. Reference the decrypted path via `config.age.secrets.<name>.path`

### SSH key naming convention

Keys follow `id_ed25519_<purpose>`:
- `id_ed25519_github` — GitHub authentication + commit signing
- `id_ed25519_miles` — Hetzner VPS (miles) SSH access + deployment
- Future: `id_ed25519_<hostname>` for additional hosts, `id_ed25519_work`, etc.

## Updating ~/.claude/CLAUDE.md

The global Claude Code instructions file is agenix-encrypted (`secrets/CLAUDE.md.age`) and decrypted on `make switch`. The plaintext source at `files/CLAUDE.md` is gitignored — only the `.age` file is committed.

To update:

1. `agenix -e secrets/CLAUDE.md.age` — decrypts, opens in `$EDITOR`, re-encrypts on save
2. Commit and push the updated `.age` file
3. Run `make switch` in nix-config to deploy

The file is read-only on disk (agenix symlink). Changes go through version control.

## Development

The flake provides a dev shell with `nixfmt`, `statix`, and `deadnix`. Enter it with `nix develop` or automatically via direnv (`.envrc`).

Commit hooks (`.githooks/`) are activated by the dev shell:
- **pre-commit**: formats staged `.nix` files with `nixfmt`, lints with `statix`
- **pre-push**: runs `nix flake check --all-systems`

Git commands that trigger hooks require dev shell tools. Prefix with `nix develop --command` if not already in the dev shell.

## Git workflow

Same conventions as nix-config:
- **Conventional commits** (`feat`, `fix`, `docs`, `chore`)
- **Direct to main** for small changes (this repo is tiny — most changes are direct)
- **Branch + PR** if adding significant new functionality

## Branch protection

Same setup as nix-config: "Protect main" ruleset with no force push (owner can bypass), no deletion, Copilot auto-review, and required CI status checks.

## Testing

```sh
# Validate the flake
nix flake check

# Test integration with nix-config
cd ~/repos/nix-config
make switch PERSONAL_INPUT=path:$HOME/repos/nix-config-personal
```

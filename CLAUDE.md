# CLAUDE.md — nix-config-personal

Private identity, secrets, and personal config for [nix-config](https://github.com/tskovlund/nix-config).

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
2. Encrypt: `age -r <pubkey> -o secrets/<name>.age <plaintext-file>`
   Or with agenix CLI: `agenix -e secrets/<name>.age`
3. Declare `age.secrets.<name>` in a home-manager module under `home/`
4. Reference the decrypted path via `config.age.secrets.<name>.path`

### SSH key naming convention

Keys follow `id_ed25519_<purpose>`:
- `id_ed25519_github` — GitHub authentication + commit signing
- Future: `id_ed25519_server`, `id_ed25519_work`, etc.

## Updating ~/.claude/CLAUDE.md

The global Claude Code instructions file will be managed by this flake (deployed via `home.file`). To update it:

1. Edit the source file in this repo
2. Commit and push
3. Run `make switch` in nix-config — the file is deployed as a symlink to the Nix store

The file is read-only on disk (Nix store symlink). This is intentional — changes go through version control.

## Git workflow

Same conventions as nix-config:
- **Conventional commits** (`feat`, `fix`, `docs`, `chore`)
- **Direct to main** for small changes (this repo is tiny — most changes are direct)
- **Branch + PR** if adding significant new functionality

## No branch protection

This is a private repo on a free GitHub plan. Branch protection and rulesets are unavailable. Be careful pushing to main — there's no safety net.

## Testing

```sh
# Validate the flake
nix flake check

# Test integration with nix-config
cd ~/repos/nix-config
make switch PERSONAL_INPUT=path:$HOME/repos/nix-config-personal
```

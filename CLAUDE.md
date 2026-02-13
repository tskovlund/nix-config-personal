# CLAUDE.md — nix-config-personal

Private identity and personal config for [nix-config](https://github.com/tskovlund/nix-config).

## What this repo is

This flake exports an `identity` attribute set that nix-config consumes via `--override-input`. It's the single source of personal information — nix-config itself contains none.

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
}
```

Do not rename, remove, or change the types of these fields without updating nix-config's consumers. Currently `home/git/default.nix` and `flake.nix` depend on them.

## Git workflow

Same conventions as nix-config:
- **Conventional commits** (`feat`, `fix`, `docs`, `chore`)
- **Direct to main** for small changes (this repo is tiny — most changes are direct)
- **Branch + PR** if adding significant new functionality (agenix secrets, dotfiles modules)

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

## Future direction

This repo will grow to include agenix-encrypted secrets, SSH config, and personal dotfiles (tracked in [nix-config GH#34](https://github.com/tskovlund/nix-config/issues/34)). The flake will export home-manager modules in addition to identity.

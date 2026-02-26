# nix-config-personal

[![Check](https://github.com/tskovlund/nix-config-personal/workflows/Check/badge.svg)](https://github.com/tskovlund/nix-config-personal/actions/workflows/check.yml)
[![Nix Flakes](https://img.shields.io/badge/Nix-Flakes-blue?logo=nixos&logoColor=white)](https://nixos.wiki/wiki/Flakes)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)

Personal identity, secrets, and config for [nix-config](https://github.com/tskovlund/nix-config).

## Structure

```
nix-config-personal/
├── flake.nix           # Exports identity + homeModules
├── identity.nix        # Username, name, email
├── home/
│   ├── default.nix     # Module list (imported by nix-config as homeModules)
│   └── github.nix      # GitHub SSH key, commit signing, protocol rewrite
├── secrets/
│   ├── secrets.nix     # Agenix recipients (age public keys)
│   └── *.age           # Encrypted secrets
├── files/
│   └── *.pub           # SSH public keys (plaintext)
└── README.md
```

## How it integrates

nix-config declares `inputs.personal` which defaults to a stub. On real machines, override it:

```sh
mkdir -p ~/.config/nix-config
echo "git+ssh://git@github.com/tskovlund/nix-config-personal" > ~/.config/nix-config/personal-input
```

Then `make switch` in nix-config automatically passes `--override-input personal <url>`.

## Exports

### identity

| Field      | Type   | Description                                              |
|------------|--------|----------------------------------------------------------|
| `isStub`   | `bool` | Must be `false` (distinguishes real identity from stub)  |
| `username` | `str`  | System user account, home directory path                 |
| `fullName` | `str`  | Git commit author name                                   |
| `email`    | `str`  | Git commit email address                                 |

### homeModules

List of home-manager modules imported by nix-config's personal targets. Currently includes:

- **github.nix** — SSH key decryption via agenix, GitHub host routing, commit signing, SSH protocol rewrite

## Secrets

Secrets use [agenix](https://github.com/ryantm/agenix). A single portable age key decrypts everything.

| Secret | Purpose | Decrypted to |
|--------|---------|-------------|
| `id_ed25519_github.age` | GitHub SSH authentication + commit signing | `~/.ssh/id_ed25519_github` |

### Prerequisites

The age key must exist at `~/.config/agenix/age-key.txt` before `make switch` can decrypt secrets. It's generated once and copied to new machines manually. See nix-config's `bootstrap.sh` for automated generation.

## Creating your own personal flake

1. Create a new repo with `flake.nix` and `identity.nix`
2. `flake.nix` must export `identity` and `homeModules`:
   ```nix
   {
     description = "Personal identity for nix-config";
     outputs = { ... }: {
       identity = import ./identity.nix;
       homeModules = [ ];  # add modules as needed
     };
   }
   ```
3. Point nix-config at your flake:
   ```sh
   mkdir -p ~/.config/nix-config
   echo "git+ssh://git@github.com/your-user/your-personal-flake" > ~/.config/nix-config/personal-input
   ```
4. Run `make switch` in nix-config

## CI

PRs run `nix flake check` on Ubuntu via GitHub Actions to validate the flake structure.

## Branch protection

The "Protect main" ruleset enforces: no force push (owner can bypass), no branch deletion, Copilot auto-review on PRs, and required CI status checks.

## Author

Thomas Skovlund Hansen — [thomas@skovlund.dev](mailto:thomas@skovlund.dev)

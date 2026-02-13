# nix-config-personal

Private identity and config for [nix-config](https://github.com/tskovlund/nix-config).

## Structure

```
nix-config-personal/
├── flake.nix       # Exports identity (and future: secrets, dotfiles)
├── identity.nix    # Username, name, email
└── README.md
```

## How it integrates

nix-config declares `inputs.personal` which defaults to a stub. On real machines, override it:

```sh
mkdir -p ~/.config/nix-config
echo "github:tskovlund/nix-config-personal" > ~/.config/nix-config/personal-input
```

Then `make switch` in nix-config automatically passes `--override-input personal github:tskovlund/nix-config-personal`.

## Identity interface

The `identity` attribute set is consumed by nix-config modules:

| Field | Used for |
|-------|---------|
| `username` | System user account, home directory |
| `fullName` | Git commit author |
| `email` | Git commit email |
| `isStub` | Must be `false` (distinguishes real identity from placeholder) |

## Future additions

- agenix secrets (SSH keys, API tokens)
- Personal dotfiles (`~/.claude/CLAUDE.md`, etc.)
- Per-host identity overrides

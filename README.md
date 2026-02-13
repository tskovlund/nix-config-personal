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

| Field      | Type   | Description                                              |
|------------|--------|----------------------------------------------------------|
| `isStub`   | `bool` | Must be `false` (distinguishes real identity from stub)  |
| `username` | `str`  | System user account, home directory path                 |
| `fullName` | `str`  | Git commit author name                                   |
| `email`    | `str`  | Git commit email address                                 |

## Creating your own personal flake

To create your own personal flake for use with nix-config:

1. Create a new repo with `flake.nix` and `identity.nix`
2. `flake.nix` must export an `identity` attribute:
   ```nix
   {
     description = "Personal identity for nix-config";
     outputs = { ... }: {
       identity = import ./identity.nix;
     };
   }
   ```
3. `identity.nix` must contain all four fields:
   ```nix
   {
     isStub = false;
     username = "your-username";
     fullName = "Your Name";
     email = "you@example.com";
   }
   ```
4. Point nix-config at your flake:
   ```sh
   mkdir -p ~/.config/nix-config
   echo "git+ssh://git@github.com/your-user/your-personal-flake" > ~/.config/nix-config/personal-input
   ```
5. Run `make switch` in nix-config

## CI

PRs run `nix flake check` on Ubuntu via GitHub Actions to validate the flake structure.

## Known limitations

- **No branch protection.** Rulesets and branch protection require GitHub Pro for private repos. Self-discipline replaces automation here.

## Future additions

- agenix secrets (SSH keys, API tokens)
- Personal dotfiles (`~/.claude/CLAUDE.md`, etc.)
- Per-host identity overrides

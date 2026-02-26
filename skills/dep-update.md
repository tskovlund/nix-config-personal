---
name: dep-update
description: >
  Update project dependencies: flake inputs, pip, npm, or cargo. Runs tests
  after updating to verify nothing breaks. Use when the user says "update deps",
  "update dependencies", "update packages", "bump dependencies", when
  repo-sync flags stale inputs, or when a dependency vulnerability is found.
  Do NOT use for updating nix-config flake inputs specifically (use nix-update)
  or for syncing repos (use repo-sync).
user-invocable: true
argument-hint: "[dependency-name or 'all']"
allowed-tools: Bash(nix *), Bash(pip *), Bash(npm *), Bash(cargo *), Bash(devbox *), Bash(git *), Bash(pytest *), Bash(npx *), Read, Grep, Glob
metadata:
  author: tskovlund
  version: "1.0"
---

# Update dependencies

Update project dependencies, run tests, and commit the changes.

## Detect project type

```sh
# Check what dependency systems are in use
ls flake.lock package-lock.json yarn.lock pnpm-lock.yaml Cargo.lock \
   requirements.txt poetry.lock pyproject.toml devbox.lock 2>/dev/null
```

A project may use multiple systems (e.g., flake.nix + pyproject.toml).

## Update by type

### Nix flake inputs

```sh
# Update all inputs
nix flake update

# Update a specific input
nix flake update <input-name>
```

**Important:** For nix-config specifically, use the `/nix-update` skill instead — it handles the personal flake sync and `make switch` deployment.

### Python (pip/poetry/uv)

```sh
# pip with requirements.txt
pip install --upgrade -r requirements.txt
pip freeze > requirements.txt

# poetry
poetry update

# uv
uv lock --upgrade
```

### Node.js (npm/yarn/pnpm)

```sh
# npm
npm update
# or for major versions:
npx npm-check-updates -u && npm install

# yarn
yarn upgrade

# pnpm
pnpm update
```

### Rust (cargo)

```sh
cargo update
```

### Devbox

```sh
devbox update
```

## After updating

### 1. Run tests

Run whatever test suite the project has:

```sh
# Python
pytest

# Node
npm test

# Rust
cargo test

# Nix
nix flake check
```

### 2. Check for breakage

If tests fail after updating:

1. Identify which dependency caused the failure
2. Check the dependency's changelog for breaking changes
3. **If fixable:** apply the fix, include it in the commit
4. **If not easily fixable:** roll back that specific dependency and report to the user:
   "Updated all dependencies except X — upgrading X from v1 to v2 breaks Y. See changelog: [link]"

### 3. Commit

Commit the lockfile and any adaptation changes:

```sh
git add <lockfile> <any-changed-source>
git commit -F /tmp/msg.txt
```

Commit message format:
```
chore(deps): update [scope] dependencies

Updated: package-a 1.0→2.0, package-b 3.1→3.2
[If applicable: adapted X to new API in package-a v2]
```

## Selective updates

If the user specifies a dependency name:

```sh
# Nix
nix flake update <input-name>

# npm
npm update <package-name>

# pip — update just one package
pip install --upgrade <package-name>
```

Update only what was requested, run tests, commit.

## Examples

### Example 1: Update all in a Python project

User says: "update deps"

Actions:
1. Detect: `pyproject.toml` + `flake.lock` present
2. Run `nix flake update` — updates nix inputs
3. Run `poetry update` — updates Python dependencies
4. Run `pytest` — all pass
5. Commit: "chore(deps): update nix inputs and Python dependencies"
6. Report: "Updated 3 flake inputs and 8 Python packages. All tests pass."

### Example 2: Specific dependency with breakage

User says: "update deps httpx"

Actions:
1. Run `pip install --upgrade httpx`
2. Run `pytest` — 2 failures in `test_api_client.py`
3. Check httpx changelog — `Response.json()` is now async in v0.28
4. Fix `api_client.py` to await the call
5. Run `pytest` — all pass
6. Commit: "chore(deps): update httpx 0.27→0.28, adapt async json() call"

### Example 3: Auto-trigger from repo-sync

repo-sync reports: "Flake inputs are 18 days old — consider `/nix-update`."

For nix-config: defer to `/nix-update`.
For other repos: offer to run `/dep-update` to update the flake inputs.

## What NOT to do

- Don't update nix-config inputs with this skill — use `/nix-update`
- Don't force-update past pinned versions without asking
- Don't commit broken lockfiles — always run tests first
- Don't update dev-only and prod dependencies in the same commit if both are large

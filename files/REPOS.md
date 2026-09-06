# Repos

The one list of Thomas's repos, deployed to `~/.claude/REPOS.md`. The
`housekeeping`, `issues`, and `dep-update` skills point here instead of
carrying their own copies. GitHub path is `tskovlund/<repo>` unless noted;
local checkout is `~/repos/<repo>`. Verified 2026-09-06.

## Active

| Repo                                                                   | Visibility | Stack                                     | Gate                                                                                                                                                          | Update deps                                         |
| ---------------------------------------------------------------------- | ---------- | ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------- |
| mcp-score                                                              | public     | Python 3, uv, devbox                      | `devbox run check` (ruff check + format check, pyright strict, pytest)                                                                                        | `devbox run -- uv lock --upgrade`                   |
| kammer                                                                 | public     | Elixir/Phoenix, nix flake (+ devbox)      | `make check` (`mix precommit`) **and** `mix dialyzer --format short`, `mix sobelow --config`, `npx prettier@3.8.1 --check .` — all four, inside `nix develop` | `mix deps.update --all` inside `nix develop`        |
| qed                                                                    | public     | Lean 4, lake, devbox                      | `devbox run check` (lake build + lake test + generated docs must match `docs/`)                                                                               | lake manifest, by hand                              |
| cambr                                                                  | private    | Python 3.13, nix flake + uv               | inside `nix develop`: `ruff check . && ruff format --check . && pyright src/ && pytest`                                                                       | `uv lock --upgrade && uv sync` inside `nix develop` |
| cambr-strategies                                                       | private    | standalone Python scripts                 | none — no tests, no CI; strategies are evolutionary outputs, do not edit them                                                                                 | n/a                                                 |
| nix-config                                                             | public     | Nix flake (darwin, NixOS-WSL, linux)      | `make check` (`nix flake check --all-systems`); build the darwin closure **before** switching                                                                 | `make update`                                       |
| nix-config-personal                                                    | public     | Nix flake                                 | `nix flake check` + `nix run nixpkgs#prettier -- --check .` (CI runs both; pre-push runs `--all-systems`)                                                     | `nix flake update`                                  |
| skovlund.dev                                                           | public     | Astro 5, Tailwind v4, TS, pnpm via devbox | `devbox run -- pnpm lint`, `devbox run -- pnpm format:check`, `devbox run -- pnpm build` (CI also runs `pnpm test:a11y`, needs Playwright chromium)           | `devbox run -- pnpm update`                         |
| dot-github ([tskovlund/.github](https://github.com/tskovlund/.github)) | public     | Markdown, reusable workflows              | `nix run nixpkgs#prettier -- --check .`                                                                                                                       | Renovate only                                       |
| cv                                                                     | private    | Typst via devbox                          | `devbox run -- typst compile --font-path fonts/ cv.typ` (same for `letter.typ`)                                                                               | n/a                                                 |

Renovate is enabled on every active repo except cambr-strategies (no bot at
all) and cv (Dependabot for Actions only).

dot-github is the source of `CONVENTIONS.md`, the shared CI workflows, and the
`commit-msg` hook. Its sync targets are a hardcoded matrix in
`.github/workflows/sync-conventions.yml` plus `.github/sync.yml` — a new repo
has to be added there by hand.

## Dormant

Public, unarchived, no gate. Sync them in a sweep; do not spend time on them
otherwise.

| Repo         | Stack               | Last push | Note                                                        |
| ------------ | ------------------- | --------- | ----------------------------------------------------------- |
| adventofcode | Python              | 2023-12   | Seasonal — wakes up in December                             |
| academy-fx   | Static HTML + audio | 2026-04   | Sound effects for the Academy game; not checked out locally |

## Skip

- **eliza-config** (public) — ZeroClaw/Eliza configuration. Decommission
  pending; not worth maintaining. ZeroClaw itself is an upstream project, not
  a tskovlund repo — its wiring lives in eliza-config and in the nix-configs.

Everything else under `tskovlund/` is archived.

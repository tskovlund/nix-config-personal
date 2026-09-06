{ config, ... }:

let
  homeDir = config.home.homeDirectory;
in
{
  # Global Claude Code context (mission, working style, tracking) — agenix-
  # encrypted at rest, decrypted on make switch. Deliberately named distinctly
  # from CONVENTIONS.md: the two were once confused in a single agenix editing
  # session, which silently replaced the global context with a copy of the
  # conventions for five months (recovered 2026-08-09). To update:
  # `agenix -e secrets/claude-global-context.md.age`, commit, deploy.
  age.secrets.claude-global-context = {
    file = ../secrets/claude-global-context.md.age;
    path = "${homeDir}/.claude/CLAUDE.md";
    mode = "0644";
  };

  # Code conventions — plain file (not secret), deployed to ~/.claude/CONVENTIONS.md.
  # Referenced by the global CLAUDE.md so every Claude Code session has access.
  # The source is the repo-root CONVENTIONS.md, which tskovlund/.github syncs
  # via PR. Never edit it here: change conventions/ in dot-github and let the
  # sync land, then `make switch`.
  home.file.".claude/CONVENTIONS.md".source = ../CONVENTIONS.md;
}

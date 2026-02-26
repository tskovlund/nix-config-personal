{ config, ... }:

let
  homeDir = config.home.homeDirectory;
in
{
  # Global Claude Code instructions — agenix-encrypted at rest, decrypted on
  # make switch. To update: `agenix -e secrets/CLAUDE.md.age` (decrypts,
  # opens in $EDITOR, re-encrypts on save), then commit and deploy.
  age.secrets.claude-md = {
    file = ../secrets/CLAUDE.md.age;
    path = "${homeDir}/.claude/CLAUDE.md";
    mode = "0644";
  };

  # Code standards — plain file (not secret), deployed to ~/.claude/standards.md.
  # Referenced by the global CLAUDE.md so every Claude Code session has access.
  # To update: edit files/standards.md, commit, and `make switch`.
  home.file.".claude/standards.md".source = ../files/standards.md;
}

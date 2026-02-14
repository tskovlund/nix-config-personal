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
}

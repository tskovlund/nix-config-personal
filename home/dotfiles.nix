{ ... }:

{
  # Global Claude Code instructions — deployed as read-only Nix store symlink.
  # Edit the source in files/CLAUDE.md, commit, and `make switch` to deploy.
  home.file.".claude/CLAUDE.md".source = ../files/CLAUDE.md;
}

# GitHub machine-account identity for Claude (tskovlund-claude).
#
# Claude-authored work uses this identity instead of Thomas's, so PRs are
# honestly attributed and Thomas can be formally requested as reviewer —
# his review-requested inbox becomes the single cross-repo review queue.
#
# Pieces:
#   - agenix-deployed SSH key (auth + commit signing for the bot account)
#   - `github.com-claude` SSH host alias — pushes over this alias
#     authenticate as the bot; the plain `github.com` host stays Thomas
#   - `gh-claude` wrapper — gh CLI under a separate config dir so the bot's
#     login never touches Thomas's gh session
#
# One-time setup on the GitHub side (bot account): add the public key as
# both authentication key and signing key; `gh-claude auth login` once.
{ config, ... }:

let
  keyName = "id_ed25519_claude";
  homeDir = config.home.homeDirectory;
in
{
  age.secrets.${keyName} = {
    file = ../secrets/${keyName}.age;
    path = "${homeDir}/.ssh/${keyName}";
    mode = "0600";
  };

  home.file.".ssh/${keyName}.pub".source = ../files/${keyName}.pub;

  # Host alias: `git remote` URLs using github.com-claude authenticate as
  # the bot. Example: git@github.com-claude:tskovlund/qed.git
  programs.ssh.settings."github.com-claude" = {
    HostName = "github.com";
    IdentityFile = "${homeDir}/.ssh/${keyName}";
    IdentitiesOnly = "yes";
  };

  # gh CLI as the bot, isolated from Thomas's gh auth.
  home.file.".local/bin/gh-claude" = {
    executable = true;
    text = ''
      #!/bin/sh
      export GH_CONFIG_DIR="$HOME/.config/gh-claude"
      exec gh "$@"
    '';
  };
}

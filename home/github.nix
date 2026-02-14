{ config, identity, ... }:

let
  keyName = "id_ed25519_github";
  homeDir = config.home.homeDirectory;
in
{
  # Decrypt SSH private key via agenix.
  # The .age file is encrypted against the portable age key.
  age.secrets.${keyName} = {
    file = ../secrets/${keyName}.age;
    path = "${homeDir}/.ssh/${keyName}";
    mode = "0600";
  };

  # Deploy the public key (not secret, committed in plaintext)
  home.file.".ssh/${keyName}.pub".source = ../files/${keyName}.pub;

  # SSH: route GitHub traffic through this key
  programs.ssh.matchBlocks."github.com" = {
    identityFile = "${homeDir}/.ssh/${keyName}";
    identitiesOnly = true;
  };

  # Git: SSH commit signing
  programs.git = {
    signing = {
      key = "${homeDir}/.ssh/${keyName}.pub";
      signByDefault = true;
      format = "ssh";
    };

    settings = {
      # Verify own signatures in git log --show-signature
      gpg.ssh.allowedSignersFile = "${homeDir}/.ssh/allowed_signers";

      # Force SSH for all GitHub URLs (HTTPS clone URLs become SSH transparently)
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };

  # Allowed signers file for signature verification
  home.file.".ssh/allowed_signers".text =
    let
      pubKey = builtins.readFile ../files/${keyName}.pub;
    in
    "${identity.email} ${pubKey}";
}

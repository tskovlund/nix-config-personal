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

    # Work identity override for dc-main repos.
    # When a repo has a remote matching dc-main, use the work email and
    # the work RSA signing key (deployed via ~/.ssh/config.local on work machines).
    includes = [
      {
        # Match the HTTPS form — git's hasconfig resolves through
        # url.*.insteadOf, so even SSH-cloned repos match this pattern.
        condition = "hasconfig:remote.*.url:https://github.com/dc-main/**";
        contents = {
          user = {
            email = "tha@danskecommodities.com";
            signingKey = "${homeDir}/.ssh/id_rsa_github.pub";
          };
        };
      }
    ];
  };

  # Allowed signers file for signature verification.
  # Include both personal (ed25519) and work (RSA) keys so that
  # `git log --show-signature` verifies commits from either identity.
  home.file.".ssh/allowed_signers".text =
    let
      personalPubKey = builtins.readFile ../files/${keyName}.pub;
      workPubKey = builtins.readFile ../files/id_rsa_github.pub;
    in
    ''
      ${identity.email} ${personalPubKey}
      tha@danskecommodities.com ${workPubKey}
    '';
}

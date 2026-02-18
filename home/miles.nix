{ config, ... }:

let
  keyName = "id_ed25519_miles";
  homeDir = config.home.homeDirectory;
in
{
  # Decrypt SSH private key via agenix.
  age.secrets.${keyName} = {
    file = ../secrets/${keyName}.age;
    path = "${homeDir}/.ssh/${keyName}";
    mode = "0600";
  };

  # Deploy the public key (not secret, committed in plaintext)
  home.file.".ssh/${keyName}.pub".source = ../files/${keyName}.pub;

  # SSH host entries — matches both `ssh miles` and direct IP connections
  # (e.g. make deploy-miles which uses root@46.225.116.48)
  programs.ssh.matchBlocks."miles 46.225.116.48" = {
    hostname = "46.225.116.48";
    identityFile = "${homeDir}/.ssh/${keyName}";
    identitiesOnly = true;
  };
}

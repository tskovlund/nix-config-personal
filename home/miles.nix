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

  # SSH host entry — routes `ssh miles` and deploy targets to the VPS
  programs.ssh.matchBlocks."miles" = {
    hostname = "46.225.116.48";
    user = "root";
    identityFile = "${homeDir}/.ssh/${keyName}";
    identitiesOnly = true;
  };
}

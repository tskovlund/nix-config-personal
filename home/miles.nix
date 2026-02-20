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

  # SSH host entries — primary access via Tailscale, direct IP for emergencies.
  # `ssh miles` / `ssh root@miles` → Tailscale (default, used by make deploy-miles)
  # `ssh miles-direct` → public IP (emergency only, requires port 22 re-enabled in NixOS firewall)
  programs.ssh.matchBlocks."miles 100.100.125.93" = {
    hostname = "100.100.125.93";
    identityFile = "${homeDir}/.ssh/${keyName}";
    identitiesOnly = true;
  };

  programs.ssh.matchBlocks."miles-direct 46.225.116.48" = {
    hostname = "46.225.116.48";
    identityFile = "${homeDir}/.ssh/${keyName}";
    identitiesOnly = true;
  };
}

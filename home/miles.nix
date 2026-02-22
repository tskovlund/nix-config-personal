{ config, ... }:

let
  keyName = "id_ed25519_miles";
  elizaSigningKey = "id_ed25519_eliza_signing";
  homeDir = config.home.homeDirectory;
in
{
  # Decrypt SSH private key via agenix.
  age.secrets.${keyName} = {
    file = ../secrets/${keyName}.age;
    path = "${homeDir}/.ssh/${keyName}";
    mode = "0600";
  };

  # Eliza's commit signing key — decrypted here, copied to zeroclaw's home
  # by the zeroclaw-ssh-setup oneshot service in nix-config.
  age.secrets.${elizaSigningKey} = {
    file = ../secrets/${elizaSigningKey}.age;
    path = "${homeDir}/.ssh/${elizaSigningKey}";
    mode = "0600";
  };

  # Deploy the public keys (not secret, committed in plaintext)
  home.file.".ssh/${keyName}.pub".source = ../files/${keyName}.pub;
  home.file.".ssh/${elizaSigningKey}.pub".source = ../files/${elizaSigningKey}.pub;

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

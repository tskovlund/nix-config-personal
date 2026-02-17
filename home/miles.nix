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
}

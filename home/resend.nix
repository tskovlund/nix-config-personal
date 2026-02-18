{ config, ... }:

{
  # Resend API key — used for transactional email from notify.skovlund.dev.
  # Decrypted to a known path so NixOS services can reference it via
  # environmentFile or similar mechanisms.
  age.secrets.resend-api-key = {
    file = ../secrets/resend-api-key.age;
    path = "${config.home.homeDirectory}/.config/resend/api-key";
    mode = "0600";
  };
}

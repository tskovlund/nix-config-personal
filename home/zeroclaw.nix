# ZeroClaw secrets — API key, Telegram bot token, gateway pairing token.
#
# Decrypted to ~/.config/zeroclaw/ by agenix.
# The zeroclaw-setup oneshot service on miles copies these into config.toml
# at deploy time (same pattern as restic-secrets in backups.nix).
{ config, ... }:

let
  homeDir = config.home.homeDirectory;
in
{
  age.secrets = {
    zeroclaw-api-key = {
      file = ../secrets/zeroclaw-api-key.age;
      path = "${homeDir}/.config/zeroclaw/api-key";
      mode = "0600";
    };

    zeroclaw-telegram-bot-token = {
      file = ../secrets/zeroclaw-telegram-bot-token.age;
      path = "${homeDir}/.config/zeroclaw/telegram-bot-token";
      mode = "0600";
    };

    zeroclaw-gateway-token = {
      file = ../secrets/zeroclaw-gateway-token.age;
      path = "${homeDir}/.config/zeroclaw/gateway-token";
      mode = "0600";
    };
  };
}

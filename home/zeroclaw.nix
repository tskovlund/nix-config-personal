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

    zeroclaw-brave-api-key = {
      file = ../secrets/zeroclaw-brave-api-key.age;
      path = "${homeDir}/.config/zeroclaw/brave-api-key";
      mode = "0600";
    };

    zeroclaw-linear-api-key = {
      file = ../secrets/zeroclaw-linear-api-key.age;
      path = "${homeDir}/.config/zeroclaw/linear-api-key";
      mode = "0600";
    };

    zeroclaw-notion-api-key = {
      file = ../secrets/zeroclaw-notion-api-key.age;
      path = "${homeDir}/.config/zeroclaw/notion-api-key";
      mode = "0600";
    };

    zeroclaw-openweathermap-api-key = {
      file = ../secrets/zeroclaw-openweathermap-api-key.age;
      path = "${homeDir}/.config/zeroclaw/openweathermap-api-key";
      mode = "0600";
    };

    zeroclaw-newsapi-key = {
      file = ../secrets/zeroclaw-newsapi-key.age;
      path = "${homeDir}/.config/zeroclaw/newsapi-key";
      mode = "0600";
    };

    zeroclaw-finnhub-api-key = {
      file = ../secrets/zeroclaw-finnhub-api-key.age;
      path = "${homeDir}/.config/zeroclaw/finnhub-api-key";
      mode = "0600";
    };
  };
}

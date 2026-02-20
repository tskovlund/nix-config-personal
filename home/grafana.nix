{ config, ... }:

{
  # Grafana service account token — used by mcp-grafana for Claude Code integration.
  # Token is created in Grafana UI (Administration → Service accounts → Editor role).
  age.secrets.grafana-service-account-token = {
    file = ../secrets/grafana-service-account-token.age;
    path = "${config.home.homeDirectory}/.config/grafana/service-account-token";
    mode = "0600";
  };
}

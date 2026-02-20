{ config, ... }:

{
  # Cloudflare API token — Zone:DNS:Edit + Zone:Zone:Read for all zones.
  # Used by flarectl and other Cloudflare CLI tools.
  age.secrets.cloudflare-api-token = {
    file = ../secrets/cloudflare-api-token.age;
    path = "${config.home.homeDirectory}/.config/cloudflare/api-token";
    mode = "0600";
  };

  # Export CF_API_TOKEN so flarectl picks it up automatically
  programs.zsh.initContent = ''
    if [ -f ~/.config/cloudflare/api-token ]; then
      export CF_API_TOKEN="$(cat ~/.config/cloudflare/api-token)"
    fi
  '';
}

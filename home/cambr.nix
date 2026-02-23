{ config, ... }:

{
  # Anthropic API key — dedicated key for cambr (evolutionary trading bot).
  # Used by `cambr evolve` to call Claude API for strategy generation.
  age.secrets.cambr-anthropic-api-key = {
    file = ../secrets/cambr-anthropic-api-key.age;
    path = "${config.home.homeDirectory}/.config/cambr/anthropic-api-key";
    mode = "0600";
  };

  # Export ANTHROPIC_API_KEY so cambr picks it up automatically
  programs.zsh.initContent = ''
    if [ -f ~/.config/cambr/anthropic-api-key ]; then
      export ANTHROPIC_API_KEY="$(cat ~/.config/cambr/anthropic-api-key)"
    fi
  '';
}

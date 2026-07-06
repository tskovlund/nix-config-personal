# Home-manager modules, exposed individually (for cherry-picking) and as
# `default`, which imports them all. The attrset shape is what
# flake-schemas expects for `homeModules` (`nix flake check` fails on a
# bare list); consumers import `homeModules.default`.
let
  modules = {
    agenix-darwin-workaround = ./agenix-darwin-workaround.nix;
    cambr = ./cambr.nix;
    cloudflare = ./cloudflare.nix;
    dotfiles = ./dotfiles.nix;
    github = ./github.nix;
    grafana = ./grafana.nix;
    mcp-memory = ./mcp-memory.nix;
    miles = ./miles.nix;
    resend = ./resend.nix;
    restic = ./restic.nix;
    skills = ./skills.nix;
  };
in
modules // { default = { imports = builtins.attrValues modules; }; }

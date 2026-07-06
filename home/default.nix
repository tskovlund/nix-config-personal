# Home-manager modules, exposed individually (for cherry-picking) and as
# `default`, which imports them all. flake-schemas requires homeModules
# to be an attrset whose values are modules (functions or attrsets —
# bare paths fail the isFunctionOrAttrs check), so each named entry
# wraps its file in an `imports` attrset.
let
  moduleFiles = {
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
  asModule = path: { imports = [ path ]; };
in
builtins.mapAttrs (_name: asModule) moduleFiles
// {
  default = {
    imports = builtins.attrValues moduleFiles;
  };
}

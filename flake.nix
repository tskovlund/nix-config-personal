{
  description = "Personal identity and config for tskovlund/nix-config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      # Dev shell with formatting/linting tools and hook setup.
      makeDevShell =
        pkgs:
        pkgs.mkShell {
          packages = with pkgs; [
            nixfmt
            statix
            deadnix
          ];
          shellHook = ''
            git config core.hooksPath .githooks
          '';
        };
    in
    {
      identity = import ./identity.nix;

      # Home-manager modules for personal config (secrets, SSH, dotfiles).
      # Imported by nix-config's personal targets via personalHomeModules.
      homeModules = import ./home;

      # Dev shell — enter with `nix develop` or automatically via direnv
      # Provides formatting/linting tools and sets up commit hooks
      devShells."aarch64-darwin".default = makeDevShell nixpkgs.legacyPackages.aarch64-darwin;
      devShells."x86_64-linux".default = makeDevShell nixpkgs.legacyPackages.x86_64-linux;
    };
}

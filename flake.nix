{
  description = "Personal identity and config for tskovlund/nix-config";

  outputs =
    { ... }:
    {
      identity = import ./identity.nix;

      # Home-manager modules for personal config (secrets, SSH, dotfiles).
      # Imported by nix-config's personal targets via personalHomeModules.
      homeModules = import ./home;
    };
}

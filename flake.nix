{
  description = "Personal identity and config for tskovlund/nix-config";

  outputs =
    { ... }:
    {
      identity = import ./identity.nix;
    };
}

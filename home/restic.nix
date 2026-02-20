{ config, ... }:

{
  # Backblaze B2 credentials for restic backups.
  # Contains B2_ACCOUNT_ID and B2_ACCOUNT_KEY in env file format.
  age.secrets.restic-b2-env = {
    file = ../secrets/restic-b2-env.age;
    path = "${config.home.homeDirectory}/.config/restic/b2-env";
    mode = "0600";
  };

  # Restic repository encryption password.
  # Critical for disaster recovery — also stored in password manager.
  age.secrets.restic-password = {
    file = ../secrets/restic-password.age;
    path = "${config.home.homeDirectory}/.config/restic/password";
    mode = "0600";
  };
}

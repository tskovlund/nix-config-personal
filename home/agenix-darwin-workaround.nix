{ lib, pkgs, ... }:

# Workaround for agenix home-manager bug on macOS.
#
# The agenix launchd agent (org.nix-community.home.activate-agenix) decrypts
# secrets to generation directories under $DARWIN_USER_TEMP_DIR/agenix.d/<N>/.
# Each secret is first written to a .tmp file with restrictive permissions
# (via `umask u=r,g=,o=`), then chmod'd and mv'd into place. The `agenix`
# symlink is only updated to point to the new generation after ALL secrets
# are decrypted successfully.
#
# Bug: If the script fails midway, stale .tmp files are left behind with 0400
# permissions. On the next run, the script computes the same generation number
# (because the symlink was never updated), tries to write to the same .tmp
# file, and fails with "permission denied". Since the script uses `set -o
# errexit`, it aborts immediately — creating a permanent crash loop where
# secrets are never re-decrypted.
#
# Impact: All secrets declared after the failing one are never decrypted.
# The symlink stays pointing to the old generation with stale content.
#
# Upstream fix: agenix should `rm -f "$TMP_FILE"` before decrypting.
# Until that's fixed, this workaround runs before the launchd agent is
# (re)started, removing all generation directories except the current one
# so the next run starts with a clean directory.
{
  home.activation.cleanStaleAgenixGenerations = lib.mkIf pkgs.stdenv.isDarwin (
    lib.hm.dag.entryBefore [ "setupLaunchAgents" ] ''
      _tmpdir="$(getconf DARWIN_USER_TEMP_DIR)"
      _agenix_link="$_tmpdir/agenix"
      _agenix_dir="$_tmpdir/agenix.d"

      if [ -d "$_agenix_dir" ] && [ -L "$_agenix_link" ]; then
        _current_gen="$(basename "$(readlink "$_agenix_link")")"
        for gen_dir in "$_agenix_dir"/*/; do
          [ -d "$gen_dir" ] || continue
          _gen_name="$(basename "$gen_dir")"
          [ "$_gen_name" = "$_current_gen" ] && continue
          run rm -rf "$gen_dir"
        done
      fi
    ''
  );
}

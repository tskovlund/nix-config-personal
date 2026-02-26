# Agenix recipients — defines which public keys can decrypt each secret.
#
# The age key is portable: the same key is copied to every machine.
# All secrets are encrypted to this single key.
#
# How to add a new secret:
#   1. Add an entry below mapping the .age file to its recipients
#   2. Run: agenix -e secrets/<name>.age
#   3. Declare age.secrets.<name> in a home-manager module under home/
#
# How to re-encrypt after changing recipients:
#   cd secrets && agenix -r

let
  thomas = "age15j2yd89h8ahm93g2um8206atnfcl90hk7q062nt63xqrz57lspmsvmyzle";
in
{
  "id_ed25519_github.age".publicKeys = [ thomas ];
  "id_ed25519_miles.age".publicKeys = [ thomas ];
  "CLAUDE.md.age".publicKeys = [ thomas ];
  "resend-api-key.age".publicKeys = [ thomas ];
  "cloudflare-api-token.age".publicKeys = [ thomas ];
  "grafana-service-account-token.age".publicKeys = [ thomas ];
  "restic-b2-env.age".publicKeys = [ thomas ];
  "restic-password.age".publicKeys = [ thomas ];
  "cambr-anthropic-api-key.age".publicKeys = [ thomas ];
  "zeroclaw-api-key.age".publicKeys = [ thomas ];
  "zeroclaw-telegram-bot-token.age".publicKeys = [ thomas ];
  "zeroclaw-gateway-token.age".publicKeys = [ thomas ];
}

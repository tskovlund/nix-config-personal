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

  # Claude Code personal skills
  "skill-issue-triage.age".publicKeys = [ thomas ];
  "skill-issue-hygiene.age".publicKeys = [ thomas ];
  "skill-issue-track.age".publicKeys = [ thomas ];
  "skill-pr-review.age".publicKeys = [ thomas ];
  "skill-planning.age".publicKeys = [ thomas ];
  "skill-memory-recall.age".publicKeys = [ thomas ];
  "skill-memory-store.age".publicKeys = [ thomas ];
  "skill-evolve.age".publicKeys = [ thomas ];
  "skill-add.age".publicKeys = [ thomas ];
  "skill-repo-sync.age".publicKeys = [ thomas ];
  "skill-update.age".publicKeys = [ thomas ];
}

[
  ./github.nix
  ./miles.nix
  ./resend.nix
  ./cloudflare.nix
  # ./grafana.nix — uncomment after creating the service account token:
  #   1. Grafana → Administration → Service accounts → Add (Editor) → Generate token
  #   2. agenix -e secrets/grafana-service-account-token.age
  #   3. Commit + push, then make switch
  ./dotfiles.nix
  ./skills.nix
]

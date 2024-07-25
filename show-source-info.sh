#!/usr/bin/env bash

set -Eeuf -o pipefail
set -x

main() {
  nix flake update nixpkgs
  nix build .#sysroot --out-link ./result-sysroot --option sandbox false
  nix build --option sandbox false

  ls ./result/bin/

  # rust-lldb result/bin/nix-rust-debug-info \
  #   --batch \
  #   -o 'break set --name nix_rust_debug_info::a_function' \
  #   -o 'process launch' \
  #   -o 'source info'
}
main "$@"

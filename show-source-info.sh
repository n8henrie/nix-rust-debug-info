#!/usr/bin/env bash

set -Eeuf -o pipefail
set -x

main() {
  nix flake lock --update-input nixpkgs
  nix build .#sysroot --out-link ./result-sysroot
  nix build

  ls ./result/bin/

  # nix shell nixpkgs#rustc nixpkgs#lldb -c \
  #   rust-lldb result/bin/nix-rust-debug-info \
  #   --batch \
  #   -o 'break set --name nix_rust_debug_info::a_function' \
  #   -o 'process launch' \
  #   -o 'source info'
}
main "$@"

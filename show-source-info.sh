#!/usr/bin/env bash

set -Eeuf -o pipefail
set -x

main() {
  rm -f ./result ./result-sysroot

  nix flake lock --update-input nixpkgs

  if [[ "$(uname -s)" != Darwin ]]; then
    nix build .#sysroot --out-link ./result-sysroot
  fi

  nix build --option sandbox false

  nix shell nixpkgs#rustc nixpkgs#lldb -c \
    rust-lldb result/bin/nix-rust-debug-info \
    --batch \
    -o 'break set --name nix_rust_debug_info::a_function' \
    -o 'process launch' \
    -o 'source info'

  ls ./result/bin/
}
main "$@"

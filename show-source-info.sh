#!/usr/bin/env bash

set -Eeuf -o pipefail
set -x

main() {
  rm -f ./result-debug ./result-release ./result-sysroot-debug ./result-sysroot-release

  nix flake lock --update-input nixpkgs

  if [[ "$(uname -s)" != Darwin ]]; then
    nix build --no-eval-cache .#sysroot-debug --out-link ./result-sysroot-debug --print-build-logs --show-trace
    nix build --no-eval-cache .#sysroot-release --out-link ./result-sysroot-release --print-build-logs --show-trace
  fi

  nix build .#debug --option sandbox false --out-link ./result-debug --show-trace
  nix build .#release --option sandbox false --out-link ./result-release --show-trace

  nix shell nixpkgs#rustc nixpkgs#lldb -c \
    rust-lldb result-debug/bin/nix-rust-debug-info \
    --batch \
    -o 'break set --name nix_rust_debug_info::a_function' \
    -o 'process launch' \
    -o 'source info'

  find . -maxdepth 1 -name 'result-*' -exec ls -A {}/bin \;
}
main "$@"

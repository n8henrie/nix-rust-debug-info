#!/usr/bin/env bash

main() {
  rust-lldb --batch -o 'break set --name nix_rust_debug_info::a_function' -o 'process launch' -o 'source info' result/bin/nix-rust-debug-info
}
main "$@"

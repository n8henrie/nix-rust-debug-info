#!/usr/bin/env bash

set -x

main() {
  gh api \
    --method POST \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    /repos/n8henrie/nix-rust-debug-info/actions/runs/10273752344/rerun
}
main "$@"

#!/usr/bin/env bash

set -Eeuf -o pipefail

errexit() {
  echo "$*" >&2
  exit 1
}

main() {
  local binary=$1
  local builddir=$(
    local plat=$(uname -s)
    case "${plat}" in
      Linux)
        readelf --debug-dump=info "${binary}" |
          awk '/DW_AT_comp_dir/ { print $NF; exit }'
        ;;
      Darwin)
        dsymutil --symtab "${binary}" |
          awk -F"'" '
            /N_OSO/ {
              buildfile=$(NF-1)
              gsub("/target/.*", "", buildfile);
              print buildfile
              exit
            }
          '
        ;;
      *)
        errexit "unknown platform: ${plat}"
        ;;
    esac
  )

  [[ -z "${builddir}" ]] && errexit "could not find builddir"

  rust-lldb -o "settings set target.source-map ${builddir} ." "${binary}"
}

main "$@"

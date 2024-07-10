{
  lib,
  stdenv,
  rustPlatform,
}:
let
  inherit (rustPlatform) buildRustPackage cargoInstallHook;
  buildType = "debug";
in
buildRustPackage (
  {
    inherit ((builtins.fromTOML (builtins.readFile ./Cargo.toml)).package) name;
    inherit buildType;
    dontStrip = true;
    version = "0.0.1";
    src = ./.;
    cargoHash = "sha256-liwY1EAeCA+0y+GegJdqV3PKzVHN9noD6L5lplqgrus=";
  }
  // lib.optionalAttrs (buildType == "debug" && stdenv.isDarwin) {
    RUSTFLAGS = "-C split-debuginfo=packed";
    postInstall = "cp -RL ./target/${cargoInstallHook.targetSubdirectory}/debug/*.dSYM $out/bin/";
  }
)

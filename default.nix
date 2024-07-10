{
  lib,
  stdenv,
  rustPlatform,
}:
let
  inherit (rustPlatform) buildRustPackage cargoInstallHook;
in
buildRustPackage {
  pname = "nix-rust-debug-info";
  buildType = "debug";
  dontStrip = true;
  version = "0.0.1";
  src = ./.;
  cargoHash = "sha256-3FzjK5hbqA3PNgzhanCvisynkUKK4/9BCDbPFu5FUxA=";
}
// lib.mkIf (buildRustPackage.buildType == "debug" && stdenv.isDarwin) {
  RUSTFLAGS = "-C split-debuginfo=packed";
  postInstall = "cp -RL ./target/${cargoInstallHook.targetSubdirectory}/debug/*.dSYM $out/bin/";
}

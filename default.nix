{
  lib,
  rustPlatform,
  buildType ? "release",
}:
rustPlatform.buildRustPackage {
  inherit ((builtins.fromTOML (builtins.readFile ./Cargo.toml)).package) name;
  inherit buildType;
  dontStrip = true;
  version = "0.0.1";
  src = lib.cleanSource ./.;
  cargoBuildFlags = [ "--verbose" ];
  cargoHash = "sha256-liwY1EAeCA+0y+GegJdqV3PKzVHN9noD6L5lplqgrus=";

  # incompatible with sysroot
  doCheck = false;

  # Required for no_std apparently
  RUSTFLAGS = "-Cpanic=abort ";
}

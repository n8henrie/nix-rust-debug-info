{
  description = ''
    https://github.com/NixOS/nixpkgs/issues/282900
    https://github.com/NixOS/nixpkgs/issues/262131
  '';
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  # inputs.nixpkgs.url = "/Users/n8henrie/git/nixpkgs";
  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-darwin"
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      eachSystem =
        with nixpkgs.lib;
        f: foldAttrs mergeAttrs { } (map (s: mapAttrs (_: v: { ${s} = v; }) (f s)) systems);
    in
    eachSystem (system: {
      packages = {
        default = nixpkgs.legacyPackages.${system}.callPackage ./. { };
        sysroot =
          let
            pkgs = import nixpkgs {
              inherit system;
              crossSystem = {
                inherit system;
                rust = {
                  # rustcTarget = "highly-unlikely";
                  # platform = builtins.fromJSON (builtins.readFile ./target.json);
                  rustcTargetSpec = ./target.json;
                };
              };
            };
          in
          pkgs.callPackage ./. { };
      };
    });
}

{
  description = "https://github.com/NixOS/nixpkgs/issues/282900 https://github.com/NixOS/nixpkgs/issues/262131";
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
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
      packages.default = nixpkgs.legacyPackages.${system}.callPackage ./. { };
    });
}

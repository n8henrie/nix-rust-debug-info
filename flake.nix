{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  outputs =
    { nixpkgs, ... }:
    {
      packages.aarch64-darwin.default = nixpkgs.legacyPackages.aarch64-darwin.callPackage ./. { };
      packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.callPackage ./. { };
    };
}

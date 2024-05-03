{
  description = "Flake for ro.am";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs }:
    let pkgs = import nixpkgs { system = "x86_64-linux"; };
    in { packages.x86_64-linux.default = pkgs.callPackage ./default.nix { }; };
}

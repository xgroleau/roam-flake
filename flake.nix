{
  description = "Flake for ro.am";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {

      formatter.x86_64-linux = pkgs.nixfmt-rfc-style;

      overlays.default = final: prev: { roam = final.callPackage ./default.nix { }; };

      packages.x86_64-linux = rec {
        roam = pkgs.callPackage ./default.nix { };
        default = roam;
      };
    };
}

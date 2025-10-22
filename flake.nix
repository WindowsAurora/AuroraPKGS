{
  description = "A custom repository for my personal NixOS packages";

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-unstable"; 
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true; # Required for steam
        };
      in
      {
        packages = {
          proton-sarek-async = pkgs.callPackage ./pkgs/proton-sarek-async/package.nix { };
        };

        defaultPackage = self.packages.${system}.proton-sarek-async;
      });

  # Cachix configuration
  nixConfig = {
    extra-substituters = [ "https://aurora.cachix.org" ];
    extra-trusted-public-keys = [ "aurora.cachix.org-1:CoSUKK+iuUv1rb61cnqL/Us8bDs1siFqVW4vPxrBu28=" ];
  };
}
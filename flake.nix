{
  description = "A custom repository for my personal NixOS packages";

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-unstable"; 
    flake-utils.url = "github:numtide/flake-utils";
    zig2nix.url = "github:Cloudef/zig2nix";
  };

  outputs = { self, nixpkgs, flake-utils, zig2nix }:
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
          zsnow = pkgs.callPackage ./pkgs/zsnow/package.nix {
            zig2nix = zig2nix.packages.${system}; 
          };
        };

        defaultPackage = self.packages.${system}.proton-sarek-async;
      });

  # Cachix configuration
  nixConfig = {
    extra-substituters = [ "https://aurora.cachix.org" ];
    extra-trusted-public-keys = [ "aurora.cachix.org-1:CoSUKK+iuUv1rb61cnqL/Us8bDs1siFqVW4vPxrBu28=" ];
  };
}
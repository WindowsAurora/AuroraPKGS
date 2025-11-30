# flake.nix
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
        # Get `lib` directly from the nixpkgs flake input. It's needed for the predicate.
        lib = nixpkgs.lib;

        # Import nixpkgs, but instead of a global override,
        # we specify exactly which unfree packages are allowed.
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
            "zsnow"
          ];
        };

        # This line is correct and remains unchanged.
        # It uses the pure `nixpkgs` flake input, as required by zig2nix.
        buildZigPackage = (zig2nix.zig-env.${system} { inherit nixpkgs; }).package;
      in
      {
        packages = {
          proton-sarek-async = pkgs.callPackage ./pkgs/proton-sarek-async/package.nix { };
          zsnow = pkgs.callPackage ./pkgs/zsnow/package.nix {
            inherit buildZigPackage;
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
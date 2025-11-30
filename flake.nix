# flake.nix
{
  description = "A custom repository for my personal NixOS packages";

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zig2nix.url = "github:Cloudef/zig2nix";
  };

  outputs = { nixpkgs, flake-utils, zig2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # 1. Define an overlay containing all your custom packages.
        my-overlay = final: prev: {
          # This builder function is created inside the overlay's scope.
          # It uses the raw `nixpkgs` flake input, as required by zig-env.
          buildZigPackage = (zig2nix.zig-env.${system} { inherit nixpkgs; }).package;

          # Your packages are defined here, using the final package set (`final`).
          proton-sarek-async = final.callPackage ./pkgs/proton-sarek-async/package.nix { };
          zsnow = final.callPackage ./pkgs/zsnow/package.nix {
            # It gets the builder defined just above.
            inherit (final) buildZigPackage;
          };
        };

        # 2. Import nixpkgs ONCE, applying your config and the overlay.
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true; # This config now applies to everything.
          overlays = [ my-overlay ];
        };
      in
      {
        # 3. Expose the packages from the final, configured pkgs set.
        packages = {
          inherit (pkgs) proton-sarek-async zsnow;
        };

        defaultPackage = pkgs.proton-sarek-async;
      });

  # Cachix configuration
  nixConfig = {
    extra-substituters = [ "https://aurora.cachix.org" ];
    extra-trusted-public-keys = [ "aurora.cachix.org-1:CoSUKK+iuUv1rb61cnqL/Us8bDs1siFqVW4vPxrBu28=" ];
  };
}
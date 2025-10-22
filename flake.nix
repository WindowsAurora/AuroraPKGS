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
          proton-sarek-async = pkgs.callPackage ./pkgs/proton-sarek-async-bin/package.nix { };
        };

        defaultPackage = self.packages.${system}.proton-sarek-async-bin;
      });

  # Cachix configuration
  # nixConfig = {
  #  # Replace <your-cachix-name> with your actual Cachix cache name.
  #  extra-substituters = [ "https://<your-cachix-name>.cachix.org" ];
  #  # Replace the public key with the one provided by Cachix for your cache.
  #  extra-trusted-public-keys = [ "<your-cachix-name>.cachix.org-1:..." ];
  # };
}
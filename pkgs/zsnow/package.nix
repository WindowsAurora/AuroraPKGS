# pkgs/zsnow/package.nix
{ lib
, fetchFromGitHub
# These system dependencies are still needed
, wayland
, wayland-protocols
, wlr-protocols
# This is what we passed in from the flake.nix
, zig2nix
}:

zig2nix.build {
  pname = "zsnow";
  version = "unstable-2025-10-23";

  src = fetchFromGitHub {
    owner = "DarkVanityOfLight";
    repo = "ZSnoW";
    rev = "0df5c7f212b11dea3e5cfdab8abb4ef470391bf9";
    hash = "sha256-V/KHhgbNvRUjpxeuNRWPPGykwe3POf+SHV9Pnf4nWYk=";
  };

  # Release mode, equivalent to `-Drelease-safe=true`
  buildMode = "ReleaseSafe";

  # System-level dependencies are passed here
  buildInputs = [
    wayland
    wayland-protocols
    wlr-protocols
  ];

  meta = with lib; {
    description = "A basic XSnow clone for wayland written in zig";
    homepage = "https://github.com/DarkVanityOfLight/ZSnoW";
    license = licenses.cc-by-nc-sa-40;
    platforms = platforms.linux;
    mainProgram = "zsnow";
  };
}
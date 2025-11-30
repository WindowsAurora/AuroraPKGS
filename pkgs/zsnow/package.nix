# pkgs/zsnow/package.nix
{ lib
, fetchFromGitHub
, wayland
, wayland-protocols
, wlr-protocols
, buildZigPackage  # This is the function we get from zig-env.
}:

buildZigPackage {
  pname = "zsnow";
  version = "unstable-2025-10-23";

  src = fetchFromGitHub {
    owner = "DarkVanityOfLight";
    repo = "ZSnoW";
    rev = "0df5c7f212b11dea3e5cfdab8abb4ef470391bf9";
    hash = "sha256-V/KHhgbNvRUjpxeuNRWPPGykwe3POf+SHV9Pnf4nWYk=";
  };

  # buildMode can be used for release builds
  buildMode = "ReleaseSafe";

  # System dependencies are passed just like in stdenv.mkDerivation
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
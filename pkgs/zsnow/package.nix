{ lib
, stdenv
, fetchFromGitHub
, zig
, pkg-config
, wayland
, wayland-protocols
, wayland-scanner
, wlr-protocols
}:

stdenv.mkDerivation rec {
  pname = "zsnow";
  version = "unstable-2025-10-23";

  src = fetchFromGitHub {
    owner = "DarkVanityOfLight";
    repo = "ZSnoW";
    # Use the latest commit hash from the main branch
    rev = "0df5c7f212b11dea3e5cfdab8abb4ef470391bf9"; 
    # Set to lib.fakeHash initially to find the correct hash during the first build
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [
    zig
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    wlr-protocols
  ];

  # This fetches the Zig dependencies (like zig-wayland) before the build
  # so network access isn't required inside the sandbox.
  zigDeps = zig.fetchBuildZigDeps {
    inherit src;
    name = "${pname}-cache";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  # Explicitly tell the build to use the system configuration
  # The hook usually handles this, but some Zig projects need help finding the cache
  zigBuildFlags = [ "-Doptimize=ReleaseSafe" ];

  meta = with lib; {
    description = "A basic XSnow clone for wayland written in zig";
    homepage = "https://github.com/DarkVanityOfLight/ZSnoW";
    license = licenses.cc-by-nc-sa-40;
    platforms = platforms.linux;
    mainProgram = "zsnow";
  };
}
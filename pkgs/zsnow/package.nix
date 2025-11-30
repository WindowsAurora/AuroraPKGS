{ lib
, stdenv
, fetchFromGitHub
, zig
, pkg-config
, wayland
, wayland-protocols
, wlr-protocols
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zsnow";
  version = "unstable-2025-10-23"; # Adjust if needed

  src = fetchFromGitHub {
    owner = "DarkVanityOfLight";
    repo = "ZSnoW";
    rev = "0df5c7f212b11dea3e5cfdab8abb4ef470391bf9";
    # You will still need to get the correct hash by building once
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [
    # This hook automatically handles Zig dependencies from build.zig.zon
    zig.hook
    pkg-config
  ];

  buildInputs = [
    wayland
    wayland-protocols
    wlr-protocols
  ];

  # The hook automatically finds and uses a file named `zon.hash`
  # in the source root to verify zig dependencies.
  # We generate that hash from an empty hash.
  # After the first build fails, Nix will tell you the correct hash.
  postPatch = ''
    echo "sha256-V/KHhgbNvRUjpxeuNRWPPGykwe3POf+SHV9Pnf4nWYk=" > zon.hash
  '';

  meta = with lib; {
    description = "A basic XSnow clone for wayland written in zig";
    homepage = "https://github.com/DarkVanityOfLight/ZSnoW";
    license = licenses.cc-by-nc-sa-40;
    platforms = platforms.linux;
    mainProgram = "zsnow";
  };
})
# pkgs/zsnow/package.nix
{ lib
, fetchFromGitHub
, wayland
, wayland-protocols
, wlr-protocols
, buildZigPackage
, pkg-config
}:

buildZigPackage {
  pname = "zsnow";
  version = "unstable-2025-11-30";

  src = fetchFromGitHub {
    owner = "WindowsAurora";
    repo = "ZSnoW";
    rev = "56c15a924de4a0d386324eaca5ffabedb97255d3";
    hash = "sha256-vtnHWgJVJfePdtPr7onYp+Ztq4cuNSjyuuDuipyv6oE=";
  };

  buildMode = "ReleaseSafe";

  nativeBuildInputs = [
    pkg-config
    wayland  
  ];

  # System dependencies are passed just like in stdenv.mkDerivation
  buildInputs = [
    wayland
    wayland-protocols
    wlr-protocols
  ];

  meta = with lib; {
    description = "A basic XSnow clone for wayland written in zig";
    homepage = "https://github.com/WindowsAurora/ZSnoW";
    license = licenses.cc-by-nc-sa-40;
    platforms = platforms.linux;
    mainProgram = "zsnow";
  };
}
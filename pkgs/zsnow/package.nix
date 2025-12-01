# pkgs/zsnow/package.nix
{ lib
, fetchFromGitHub
, wayland
, wayland-scanner
, wayland-protocols
, wlr-protocols
, xorg
, buildZigPackage
, pkg-config
, libxkbcommon
, autoPatchelfHook
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

  # nativeBuildInputs: Tools and libraries needed for the build.
  # This makes 'wayland-scanner' and all .pc files available to zig build.
  nativeBuildInputs = [
    pkg-config
    wayland
    wayland-scanner
    wayland-protocols
    wlr-protocols
    libxkbcommon
  ];

  # buildInputs: Libraries the final program needs to run.
  buildInputs = [
    autoPatchelfHook
    wayland
    wayland-protocols
    wlr-protocols
    libxkbcommon
    xorg.libX11
    xorg.libXau
    xorg.libXdmcp
  ];

  postPatch = ''
    substituteInPlace build.zig \
      --replace-fail "/usr/share/wlr-protocols/unstable/wlr-layer-shell-unstable-v1.xml" \
                     "${wlr-protocols}/share/wlr-protocols/unstable/wlr-layer-shell-unstable-v1.xml"
  '';

  meta = with lib; {
    description = "A basic XSnow clone for wayland written in zig";
    homepage = "https://github.com/WindowsAurora/ZSnoW";
    license = {
      fullName = "Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International";
      shortName = "cc-by-nc-sa-4.0";
      url = "https://creativecommons.org/licenses/by-nc-sa/4.0/";
      free = true;
    };
    platforms = platforms.linux;
    mainProgram = "zsnow";
  };
}
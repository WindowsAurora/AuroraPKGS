# pkgs/zsnow/package.nix
{ lib
, fetchFromGitHub
, wayland
, wayland-protocols
, wlr-protocols
, buildZigPackage
, pkg-config
, libxkbcommon
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
    wayland-protocols
    wlr-protocols
    libxkbcommon
  ];

  # buildInputs: Libraries the final program needs to run.
  buildInputs = [
    wayland
    wayland-protocols
    wlr-protocols
    libxkbcommon
  ];

  # patch the build file to replace hardcoded, invalid paths with the real paths from the Nix store.
  postPatch = ''
    substituteInPlace build.zig \
      --replace "/usr/share/wlr-protocols/unstable/wlr-layer-shell-unstable-v1.xml" \
                "${wlr-protocols}/share/wlr-protocols/unstable/wlr-layer-shell-unstable-v1.xml"

    substituteInPlace build.zig \
      --'replace' 'const scanner = Scanner.create(b, .{});' \
      '
        const scanner = Scanner.create(b, .{});
        scanner.addPath("${wayland-protocols}/share/wayland-protocols");
      '

    substituteInPlace build.zig \
      --'replace' 'exe.linkSystemLibrary("wayland-client");' \
      '
        exe.linkSystemLibrary("wayland-client");
        exe.linkSystemLibrary("wayland-cursor");
        exe.linkSystemLibrary("xkbcommon");
      '
  '';

  meta = with lib; {
    description = "A basic XSnow clone for wayland written in zig";
    homepage = "https://github.com/WindowsAurora/ZSnoW";
    license = licenses.cc-by-nc-sa-40;
    platforms = platforms.linux;
    mainProgram = "zsnow";
  };
}
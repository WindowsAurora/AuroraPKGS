# pkgs/zsnow/package.nix
{ lib
, stdenv
, fetchFromGitHub
, zig
, pkg-config
, wayland
, wayland-protocols
, wlr-protocols
, xkbcommon # Dependency of zig-wayland
}:

stdenv.mkDerivation {
  pname = "zsnow";
  version = "unstable-2025-11-30";

  src = fetchFromGitHub {
    owner = "WindowsAurora";
    repo = "ZSNoW";
    rev = "56c15a924de4a0d386324eaca5ffabedb97255d3";
    hash = "sha256-vtnHWgJVJfePdtPr7onYp+Ztq4cuNSjyuuDuipyv6oE=";
  };

  # nativeBuildInputs: All tools and libraries needed AT BUILD TIME.
  # The hook handles Zig dependencies. pkg-config needs all .pc files.
  nativeBuildInputs = [
    zig.hook
    pkg-config
    wayland           # Provides wayland-scanner and wayland-scanner.pc
    wayland-protocols # Provides its .pc files
    wlr-protocols     # Provides its .pc files
    xkbcommon         # Provides its .pc files
  ];

  # buildInputs: All libraries needed AT RUN TIME by the final binary.
  buildInputs = [
    wayland
    wayland-protocols
    wlr-protocols
    xkbcommon
  ];

  # This creates the `zon.hash` file that the zig.hook requires.
  # The hash is taken DIRECTLY from the lock file you provided.
  postPatch = ''
    echo "sha256-EMQM3ch2xSBhLxb6a2hUy8WONCuAVWM8jtJIkh2GtA0=" > zon.hash
  '';

  # Standard build and install phases. The hook configures the rest.
  buildPhase = ''
    runHook preBuild
    zig build -Doptimize=ReleaseSafe
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp zig-out/bin/zsnow $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "A basic XSnow clone for wayland written in zig";
    homepage = "https://github.com/WindowsAurora/ZSNoW";
    license = licenses.cc-by-nc-sa-40; # This will be handled by the build command flags.
    platforms = platforms.linux;
    mainProgram = "zsnow";
  };
}
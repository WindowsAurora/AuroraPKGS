{
  lib,
  stdenvNoCC,
  fetchzip,
  writeScript,
  # Can be overridden to alter the display name in steam
  # This could be useful if multiple versions should be installed together
  steamDisplayName ? "Proton-Sarek-Async",
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-sarek-async-bin";
  version = "Proton-Sarek10-17";

  src = fetchzip {
    # This URL now points directly to the Async version of the release
    url = "https://github.com/pythonlover02/Proton-Sarek/releases/download/${finalAttrs.version}/${finalAttrs.version}-Async.tar.gz";
    # IMPORTANT: You must calculate and insert the new hash for the -Async.tar.gz file.
    hash = "sha256-983ae1978918d250f54d7d3a03fa09e505ed6e34fe43e1def90a29998413687f";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  outputs = [
    "out"
    "steamcompattool"
  ];

  installPhase = ''
    runHook preInstall

    # Make it impossible to add to an environment. You should use the appropriate NixOS option.
    # Also leave some breadcrumbs in the file.
    echo "${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    mkdir $steamcompattool
    ln -s $src/* $steamcompattool
    rm $steamcompattool/compatibilitytool.vdf
    cp $src/compatibilitytool.vdf $steamcompattool

    runHook postInstall
  '';

  preFixup = ''
    substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
      --replace-fail "${finalAttrs.version}" "${steamDisplayName}"
  '';

  passthru.updateScript = writeScript "update-proton-sarek" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    repo="https://api.github.com/repos/pythonlover02/Proton-Sarek/releases"
    version="$(curl -sL "$repo" | jq 'map(select(.prerelease == false)) | .[0].tag_name' --raw-output)"
    update-source-version proton-sarek-async-bin "$version"
  '';

  meta = {
    description = ''
      Compatibility tool for Steam Play based on Wine and additional components, with a focus on older PCs (Async version).

      (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
    '';
    homepage = "https://github.com/pythonlover02/Proton-Sarek";
    license = lib.licenses.bsd3; # Based on the original package and Proton's license
    maintainers = with lib.maintainers; [
      WindowsAurora
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
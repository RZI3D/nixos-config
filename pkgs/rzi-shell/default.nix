{ stdenvNoCC, lib }:

stdenvNoCC.mkDerivation {
  pname   = "rzi-shell";
  version = "0.1.0";

  # The QML source lives alongside this file
  src = ./qml;

  # No build step needed — just copy the files
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r . $out/
    runHook postInstall
  '';

  meta = {
    description = "RZI's custom Quickshell config (Catppuccin Mocha)";
    license     = lib.licenses.mit;
    maintainers = [ ];
  };
}

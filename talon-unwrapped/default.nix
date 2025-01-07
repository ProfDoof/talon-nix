{ pkgs
, stdenv
, lib
, callPackage
}:
let
  inherit (lib.importJSON ./info.json) version linux darwin;
  pname = "talon-unwrapped";
  meta = with lib; {
    homepage = "https://talonvoice.com/";
    description = "Voice control application";
    license = licenses.unfree;
    maintainers = [ ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
  linuxPkg = callPackage ./linux.nix {
    inherit pname version meta pkgs;
    inherit (linux) sha256;
  };
  darwinPkg = callPackage ./darwin.nix {
    inherit pname version meta pkgs;
    inherit (darwin) sha256;
  };
in
if stdenv.hostPlatform.isDarwin
then darwinPkg
else linuxPkg


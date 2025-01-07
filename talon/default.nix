{ stdenv
, lib
, callPackage
}:
let
  linuxPkg = callPackage ./linux.nix {};
  darwinPkg = callPackage ./darwin.nix {};
in
if stdenv.hostPlatform.isDarwin
then darwinPkg
else linuxPkg


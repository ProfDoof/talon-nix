{ pkgs
, stdenv
, lib
}:
let
  linuxPkg = pkgs.callPackage ./linux.nix { };
  darwinPkg = pkgs.callPackage ./darwin.nix { };
in
if stdenv.hostPlatform.isDarwin
then darwinPkg
else linuxPkg


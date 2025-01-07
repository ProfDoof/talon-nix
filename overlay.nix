final: prev: {
  talon-unwrapped =  if prev ? talon-unwrapped then prev.talon-unwrapped else prev.callPackage ./talon-unwrapped/default.nix { };
  talon = final.callPackage ./talon/default.nix { pkgs = final; };
}

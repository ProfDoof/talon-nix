{ config, lib, pkgs, ... }:

let
  cfg = config.programs.talon;
  sourceType = lib.types.submodule {
    options = {
      version = lib.mkOption {
        type = lib.types.str;
        description = lib.mdDoc ''
          Sets the version of talon you are sourcing
        '';
      };
      url = lib.mkOption {
        type = lib.types.str;
        description = lib.mdDoc ''
          Sets the URL to pull the source from
        '';
      };
      sha256 = lib.mkOption {
        type = lib.types.str;
        description = lib.mdDoc ''
          Sets the SHA256 Hash for the source pulled down
        '';
      };
    };
  };
in
{
  options.programs.talon = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        Installs talon and configures udev rules for hardware
        used by talon.
      '';
    };
    source = lib.mkOption {
      type = lib.types.nullOr sourceType;
      default = null;
      description = lib.mdDoc ''
        The source used to download and install talon
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    nixpkgs = lib.mkIf (cfg.source != null) {
      overlays = [
        (
          finalPkgs: prevPkgs: 
          {
            talon-unwrapped = prevPkgs.talon-unwrapped.overrideAttrs (prevAttrs: {
              version = cfg.source.version;
              src = prevAttrs.src.override {
                url = cfg.source.url;
                sha256 = cfg.source.sha256;
              };
            });
          }
        )
      ];
    };
    environment.systemPackages = [
      pkgs.talon
    ];
  };
}

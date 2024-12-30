{ config, lib, pkgs, ... }:

let
  cfg = config.programs.talon;
  sourceType = lib.types.submodule {
    options = {
      url = lib.mkOption {
        type = lib.types.str;
      };
      sha256 = lib.mkOption {
        type = lib.types.str;
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
  config = {
    environment.systemPackages = [
      (lib.mkIf (cfg.source == null) pkgs.talon)
      (lib.mkIf (cfg.source != null) (pkgs.talon.overrideAttrs (prevAttrs: {
        src = prevAttrs.src.override {
          url = cfg.source.url;
          sha256 = cfg.source.sha256;
        };
      })))
    ];
  };
}

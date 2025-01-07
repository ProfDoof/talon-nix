{ config, lib, pkgs, ... }:

let
  cfg = config.programs.talon;

in
{
  imports = [ ./system.nix ];
}
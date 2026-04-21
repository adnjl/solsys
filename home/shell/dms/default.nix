{
  config,
  lib,
  inputs,
  pkgs,
  osConfig,
  ...
}:

let
  cfg = osConfig.solSys.desktop.shell;
in
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
  ];
  config = lib.mkIf (cfg == "dms") {

    programs.dank-material-shell = {
      enable = true;
      enableSystemMonitoring = true;
      dgop.package = inputs.dgop.packages.${pkgs.stdenv.hostPlatform.system}.default;

      niri = {
        enableKeybinds = true;
        enableSpawn = true;
        includes.enable = false;
      };
    };

    services.swaync.enable = lib.mkForce false;
    services.hypridle.enable = lib.mkForce false;
    programs.waybar.enable = lib.mkForce false;
    programs.wlogout.enable = lib.mkForce false;
    programs.rofi.enable = lib.mkForce false;
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:

let
  shared = config.solSys.desktop;
  cfg = config.solSys.desktop.i3;
  active = shared.wm == "i3";
in
{
  options.solSys.desktop.i3 = {
    variant = lib.mkOption {
      type = lib.types.enum [
        "i3"
        "i3-gaps"
      ];
      default = "i3";
    };
    statusBar = lib.mkOption {
      type = lib.types.enum [
        "polybar"
        "i3bar"
        "none"
      ];
      default = "i3bar";
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf active {
    services.xserver = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        package = if cfg.variant == "i3-gaps" then pkgs.i3-gaps else pkgs.i3;
      };
      displayManager.lightdm.enable = true;
    };

    environment.systemPackages =
      with pkgs;
      [
        rofi
        dunst
        feh
        picom
        xclip
      ]
      ++ shared.extraPackages;
  };
}

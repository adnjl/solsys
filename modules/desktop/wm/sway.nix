{
  config,
  pkgs,
  lib,
  ...
}:

let
  shared = config.solSys.desktop;
  active = shared.wm == "sway";
in
{
  options.solSys.desktop.sway = {
    statusBar = lib.mkOption {
      type = lib.types.enum [
        "waybar"
        "i3status"
        "none"
      ];
      default = "waybar";
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf active {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    environment.systemPackages =
      with pkgs;
      [
        swaybg
        swayidle
        swaylock-effects
        wl-clipboard
        grim
        slurp
        pamixer
        brightnessctl
      ]
      ++ shared.extraPackages;
  };
}

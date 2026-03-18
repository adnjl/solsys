{
  config,
  pkgs,
  lib,
  ...
}:

let
  shared = config.solSys.desktop;
  active = shared.wm == "hyprland";
in
{
  options.solSys.desktop.hyprland = {
    layout = lib.mkOption {
      type = lib.types.enum [
        "dwindle"
        "scrolling"
        "master"
      ];
      default = "dwindle";
    };
    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs.hyprlandPlugins; [
        hyprscrolling
      ];
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Raw lines appended to the Hyprland config.";
    };
  };

  config = lib.mkIf active {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    xdg.portal = {
      enable = true;
      configPackages = [ pkgs.xdg-desktop-portal-hyprland ];
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };

    environment.systemPackages =
      with pkgs;
      [
        wl-clipboard
        grim
        slurp
        swappy
        hyprpicker
        waypaper
        swaybg
        pamixer
        brightnessctl
      ]
      ++ shared.extraPackages;
  };
}

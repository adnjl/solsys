{
  config,
  pkgs,
  lib,
  ...
}:

let
  shared = config.solSys.desktop;
  cfg = config.solSys.desktop.niri;
  active = shared.wm == "niri";
in
{
  options.solSys.desktop.niri = {
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.niri;
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "KDL config lines appended to the generated niri config.";
    };
  };

  config = lib.mkIf active {
    programs.niri = {
      enable = true;
      package = lib.mkForce cfg.package;
    };
    environment.systemPackages = [
      cfg.package
      pkgs.xwayland-satellite
      pkgs.wl-clipboard
      pkgs.grim
      pkgs.slurp
    ] ++ shared.extraPackages;

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    };

    services.dbus.enable = true;
    security.polkit.enable = true;
  };
}

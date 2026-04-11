{
  pkgs,
  inputs,
  system,
  config,
  osConfig,
  ...
}:
{
  imports = [
    ./binds.nix
    ./windowrules.nix
    ./addons
    ../waybar
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = [ ];

    settings = {
      monitor = osConfig.solSys.desktop.monitor;
      workspace = "1, monitor:${builtins.head (builtins.match "([^,]+),.*" (builtins.head osConfig.solSys.desktop.monitor))}";

      exec-once = [
        "waypaper --restore"
        "swaybg"
        "fcitx5 -d -r"
        "fcitx5-remote -r"
      ];

      "$mod" = "SUPER";
      "$Left" = "H";
      "$Right" = "L";
      "$Up" = "K";
      "$Down" = "J";

      env = [
        "HYPRCURSOR_THEME,Bibata-Original-Classic"
        "HYPRCURSOR_SIZE,22"
        "XCURSOR_THEME,Bibata-Original-Classic"
        "XCURSOR_SIZE,22"
      ];

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };

      animations = {
        enabled = "yes";
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind, slidefadevert"
        ];
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 0;
        layout = osConfig.solSys.desktop.hyprland.layout;
      };

      cursor.hide_on_key_press = true;

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      decoration = {
        rounding = 3;
        dim_special = 0.3;
        blur = {
          enabled = true;
          size = 3;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
          xray = false;
          special = true;
        };
      };

      input = {
        sensitivity = if osConfig.solSys.form.type == "laptop" then 1 else -0.65;
        force_no_accel = if osConfig.solSys.form.type == "laptop" then 0 else 1;
        accel_profile = if osConfig.solSys.form.type == "laptop" then "adaptive" else "flat";
        follow_mouse = 1;
        kb_options = "ctrl:nocaps";
        kb_layout = if osConfig.solSys.form.type == "laptop" then "jp" else "en";
        touchpad = {
          tap-to-click = true;
        };
      };

      plugin = {
        hyprscrolling = {
          column_width = 0.7;
          fullscreen_on_one_column = false;
          follow_focus = true;
        };
      };
    };
  };

  xdg.portal = {
    enable = true;
    configPackages = [ pkgs.xdg-desktop-portal-hyprland ];
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hyprland.nix
    ./sway.nix
    ./niri.nix
    ./i3.nix
  ];

  options.solSys.desktop = {
    wm = lib.mkOption {
      type = lib.types.enum [
        "hyprland"
        "sway"
        "niri"
        "i3"
        "none"
      ];
      default = "hyprland";
      description = ''
        Which window manager to enable.
        "none" lets you manage the WM entirely yourself.
      '';
    };

    monitor = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Monitor config strings. Format is WM-specific:
          hyprland : "HDMI-A-1, 1920x1080@144, 0x0, 1"
          sway/niri : "eDP-1 1920x1200 0,0 1"
      '';
    };

    gaps = {
      inner = lib.mkOption {
        type = lib.types.int;
        default = 5;
      };
      outer = lib.mkOption {
        type = lib.types.int;
        default = 10;
      };
    };

    border = {
      enable = lib.mkEnableOption "window borders" // {
        default = true;
      };
      size = lib.mkOption {
        type = lib.types.int;
        default = 2;
      };
    };

    animations = lib.mkEnableOption "window animations" // {
      default = true;
    };
    blur = lib.mkEnableOption "window blur" // {
      default = true;
    };
    tearing = lib.mkEnableOption "allow tearing" // {
      default = false;
    };

    terminal = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
    };
    browser = lib.mkOption {
      type = lib.types.str;
      default = "firefox-devedition";
    };
    fileManager = lib.mkOption {
      type = lib.types.str;
      default = "dolphin";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };
  };
}

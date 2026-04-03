{
  inputs,
  pkgs,
  osConfig,
  config,
  ...
}:
{
  imports = [
    ../waybar
  ];

  programs.niri = {
    settings = {
      input = {
        keyboard = {
          xkb = {
            layout = if osConfig.solSys.form.type == "laptop" then "jp" else "us";
            options =
              # if osConfig.solSys.form.type == "laptop" then "ctrl:nocaps,altwin:swap_alt_win" else "ctrl:nocaps";
              if osConfig.solSys.form.type == "laptop" then "ctrl:nocaps" else "ctrl:nocaps";
          };
        };

        touchpad = {
          tap = true;
          natural-scroll = false;
          accel-speed = if osConfig.solSys.form.type == "laptop" then 1.0 else 0.0;
          accel-profile = if osConfig.solSys.form.type == "laptop" then "adaptive" else "flat";
        };
        mouse.accel-profile = "flat";
      };

      outputs."eDP-1" = {
        scale = 1.0;
      };

      cursor = {
        hide-when-typing = true;
      };

      layout = {
        gaps = 8;
        center-focused-column = "never";
        default-column-width.proportion = 0.5;
        focus-ring = {
          enable = true;
          active = {
            # color = "#${config.lib.stylix.colors.base0D}";
            color = "#69696c";
          };
          inactive = {
            color = "#${config.lib.stylix.colors.base02}";
          };
          width = 1.5;
        };
        border.enable = false;
      };

      animations.enable = true;

      prefer-no-csd = true;

      spawn-at-startup = [
        { command = [ "swww-daemon" ]; }
        {
          command = [
            "bash"
            "-c"
            "sleep 1 && swww img ${inputs.wallpapers}/desk.jpg"
          ];
        }
        {
          command = [
            "swaybg"
            "-i"
            "${inputs.wallpapers}/desk.jpg"
            "-m"
            "fill"
          ];
        }
        {
          command = [
            "vicinae"
            "server"
          ];
        }
        { command = [ "swaync" ]; }
        {
          command = [
            "fcitx5"
            "-d"
            "-r"
          ];
        }
      ];

      binds = {
        "Super+T".action.spawn = [ "kitty" ];
        "Super+B".action.spawn = [ "firefox" ];
        "Super+E".action.spawn = [ "dolphin" ];
        "Super+Space".action.spawn = [
          # "bash"
          # "-c"
          # "pkill -x rofi || rofi -show drun"
          "vicinae"
          "toggle"
        ];
        "Super+Shift+P".action.spawn = [
          "hyprpicker"
          "-a"
        ];
        "Super+P".action.spawn = [
          "bash"
          "-c"
          "grim -g \"$(slurp)\" - | swappy -f -"
        ];

        "Super+Shift+Backspace".action.spawn = [ "wlogout" ];

        "Super+Shift+Q".action.close-window = { };
        "Super+Return".action.do-screen-transition = { };
        "Super+Shift+C".action.center-column = { };

        "Super+H".action.focus-column-left = { };
        "Super+L".action.focus-column-right = { };
        "Super+J".action.focus-window-down = { };
        "Super+K".action.focus-window-up = { };

        "Super+U".action.focus-workspace-up = { };
        "Super+I".action.focus-workspace-down = { };
        "Super+Shift+U".action.move-column-to-workspace-up = { };
        "Super+Shift+I".action.move-column-to-workspace-down = { };

        "Super+Shift+H".action.move-column-left = { };
        "Super+Shift+L".action.move-column-right = { };
        "Super+Shift+J".action.move-window-down = { };
        "Super+Shift+K".action.move-window-up = { };

        "Super+Control+H".action.set-window-width = "-10%";
        "Super+Control+L".action.set-window-width = "+10%";

        "Super+F".action.maximize-column = { };
        "Super+Shift+F".action.fullscreen-window = { };
        "Super+W".action.toggle-window-floating = { };
        "Super+O".action.toggle-overview = { };

        "Super+Minus".action.set-column-width = "-10%";
        "Super+Equal".action.set-column-width = "+10%";

        "Super+1".action.focus-workspace = 1;
        "Super+2".action.focus-workspace = 2;
        "Super+3".action.focus-workspace = 3;
        "Super+4".action.focus-workspace = 4;
        "Super+5".action.focus-workspace = 5;

        "Super+Shift+1".action.move-column-to-workspace = 1;
        "Super+Shift+2".action.move-column-to-workspace = 2;
        "Super+Shift+3".action.move-column-to-workspace = 3;
        "Super+Shift+4".action.move-column-to-workspace = 4;
        "Super+Shift+5".action.move-column-to-workspace = 5;

        "XF86MonBrightnessUp".action.spawn = [
          "brightnessctl"
          "set"
          "5%+"
        ];
        "XF86MonBrightnessDown".action.spawn = [
          "brightnessctl"
          "set"
          "5%-"
        ];
        "XF86AudioRaiseVolume".action.spawn = [
          "pamixer"
          "-i"
          "5"
        ];
        "XF86AudioLowerVolume".action.spawn = [
          "pamixer"
          "-d"
          "5"
        ];
        "XF86AudioMute".action.spawn = [
          "pamixer"
          "-t"
        ];

      };

      window-rules = [
        # {
        #   matches = [ { } ];
        #   background-effect.blur = true;
        # }
        {
          matches = [ { } ];
          geometry-corner-radius = {
            top-left = 4.0;
            top-right = 4.0;
            bottom-left = 4.0;
            bottom-right = 4.0;
          };
          clip-to-geometry = true;
        }
        {
          matches = [ { app-id = "org.kde.dolphin"; } ];
          open-floating = true;
        }
        {
          matches = [ { app-id = "pavucontrol"; } ];
          open-floating = true;
        }
        {
          matches = [ { app-id = "blueman-manager"; } ];
          open-floating = true;
        }
      ];

      gestures = {
        hot-corners.enable = false;
      };

      overview = {
        zoom = 0.75;
        backdrop-color = "#00000000";
      };

      layer-rules = [
        {
          matches = [ { namespace = "^wallpaper$"; } ];
          place-within-backdrop = true;
        }
      ];
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    configPackages = [ pkgs.niri ];
  };
}

{
  lib,
  inputs,
  pkgs,
  osConfig,
  config,
  ...
}:
let
  powermenu = pkgs.writeShellScriptBin "powermenu" ''
    shutdown="$(printf '\uf16f')"
    reboot="$(printf '\ue5d5')"
    suspend="$(printf '\uef44')"
    logout="$(printf '\ue9ba')"
    chosen="$(echo -e "$shutdown\n$reboot\n$suspend\n$logout" | rofi -dmenu -config "$HOME/.config/rofi/powermenu.rasi")"
    case "$chosen" in
      "$shutdown") poweroff ;;
      "$reboot") reboot ;;
      "$suspend") systemctl suspend ;;
      "$logout") niri msg action quit ;;
      *) exit 0 ;;
    esac
  '';
  overviewlistener = pkgs.writeShellScriptBin "overviewlistener" ''
    niri msg --json event-stream | jq -c --unbuffered 'select(.OverviewOpenedOrClosed != null)' | \
    while read -r event; do
        is_open=$(echo "$event" | jq -r '.OverviewOpenedOrClosed.is_open')
        if [ "$is_open" = "true" ]; then
            pkill -SIGUSR2 waybar
        else
            pkill -SIGUSR1 waybar
        fi
    done
  '';
in
{
  programs.niri = {
    settings = {
      input = {
        keyboard = {
          xkb = {
            layout = if osConfig.solSys.form.type == "laptop" then "jp" else "us";
            options = "ctrl:nocaps";
          };
        };
        touchpad = {
          tap = true;
          natural-scroll = false;
          accel-speed = 1.0;
          accel-profile = "adaptive";
        };
        mouse = {
          accel-speed = 0.5;
          accel-profile = "adaptive";
        };
      };

      outputs."eDP-1" = {
        scale = 1.0;
      };
      outputs."HDMI-A-1" = {
        scale = 1.0;
      };

      cursor = {
        hide-when-typing = true;
      };

      layout = {
        gaps = 10;
        center-focused-column = "never";
        default-column-width.proportion = 0.5;
        focus-ring = {
          enable = true;
          active = {
            # color = "#1f1f1f";
            color = "#312e28";
          };
          inactive = {
            color = "#${config.lib.stylix.colors.base02}";
          };
          width = 2;
        };
        border.enable = false;
      };

      animations.enable = true;

      prefer-no-csd = true;

      spawn-at-startup = [
        { command = [ "awww-daemon" ]; }
        {
          command = [
            "bash"
            "-c"
            "sleep 2 && awww img ${inputs.wallpapers}/desk.jpg"
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
        {
          command = [
            "fcitx5"
            "-d"
            "-r"
          ];
        }
      ];

      binds =
        {
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

          "Super+Shift+Backspace".action.spawn = [ "${powermenu}/bin/powermenu" ];

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

        }
        // lib.optionalAttrs (osConfig.solSys.desktop.shell == "none") {
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

      # blur = {
      #   passes = 3;
      #   offset = 3.0;
      #   noise = 0.02;
      #   saturation = 1.5;
      # };

      window-rules = [
        # {
        #   matches = [ { } ];
        #   background-effect.blur = true;
        # }
        {
          matches = [ { } ];
          geometry-corner-radius = {
            top-left = 0.0;
            top-right = 0.0;
            bottom-left = 0.0;
            bottom-right = 0.0;
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
        zoom = 0.6;
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
    configPackages = [ osConfig.solSys.desktop.niri.package ];
  };

  systemd.user.services.overviewlistener = {
    Unit = {
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      Requisite = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${overviewlistener}/bin/overviewlistener";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  xdg.configFile."rofi/themes/powermenu.rasi".text = ''
    * {
        font: "Material Symbols Rounded 48";
        background-color: transparent;
        text-color: rgba(255, 255, 255, 1);
    }
    window {
        fullscreen: true;
        background-color: rgba(0, 0, 0, 0.7);
    }
    mainbox {
        enabled: true;
        padding: 40% 13%;
        children: ["listview"];
    }
    listview {
        columns: 4;
        spacing: 2em;
        flow: horizontal;
        cycle: false;
    }
    element {
        padding: 0.9em;
        border-radius: 5px;
    }
    element-text {
        horizontal-align: 0.5;
    }
    element.selected {
        background-color: rgba(32, 32, 32, 0.85);
    }
  '';

  xdg.configFile."rofi/powermenu.rasi".text = ''
    @theme "themes/powermenu.rasi"
  '';

}

{ pkgs, lib, ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        exclusive = true;
        passthrough = false;
        fixed-center = true;
        ipc = true;
        height = 20;
        margin-right = 0;
        margin-left = 0;
        margin-top = 0;

        modules-left = [
          "custom/menu"
          "custom/separator#blank_2"
          "clock"
        ];
        modules-right = [
          "battery"
          "custom/swaync"
          "custom/separator#blank"
          "tray"
          "custom/separator#blank"
          "mpris"
          "custom/separator#blank"
          "pulseaudio"
          "custom/separator#blank"
          "pulseaudio#microphone"
          "custom/separator#blank"
          "custom/power"
        ];

        "clock" = {
          format = "{:%H:%M - %d/%b}";
          tooltip = false;
        };

        "mpris" = {
          interval = 10;
          format = "{player_icon} ";
          format-paused = "{status_icon} <i>{dynamic}</i>";
          on-click-middle = "playerctl play-pause";
          on-click = "playerctl previous";
          on-click-right = "playerctl next";
          scroll-step = 5.0;
          smooth-scrolling-threshold = 1;
          player-icons = {
            default = "";
            spotify = "";
            mpv = "󰐹";
            vlc = "󰕼";
            firefox = "";
            chromium = "";
          };
          status-icons = {
            paused = "󰐎";
            playing = "";
            stopped = "";
          };
          max-length = 30;
        };

        "pulseaudio" = {
          format = "{icon}  {volume}%";
          format-bluetooth = "{icon} 󰂰 {volume}%";
          format-muted = "󰖁";
          format-icons = {
            headphone = " ";
            headset = " ";
            phone = "";
            default = [
              ""
              ""
              "󰕾"
              ""
            ];
          };
          scroll-step = 5.0;
          on-click = "pavucontrol -t 3";
          smooth-scrolling-threshold = 1;
        };
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          tooltip-format = "{timeTo} — {power}W";
        };
        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          on-click-right = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          scroll-step = 5;
        };

        "tray" = {
          icon-size = 15;
          spacing = 8;
        };

        "custom/menu" = {
          format = "{}";
          exec = "echo ; echo 󱓟 app launcher";
          interval = 86400;
          tooltip = true;
          on-click = "pkill rofi || rofi -show drun -modi run;drun,filebrowser,window";
        };

        "custom/power" = {
          format = "⏻ ";
          exec = "echo ; echo 󰟡 power";
          on-click = "wlogout";
          interval = 86400;
          tooltip = true;
        };

        "custom/swaync" = {
          tooltip = true;
          format = "{icon} {}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "sleep 0.1 && swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        "custom/separator#blank" = {
          format = "";
          interval = "once";
          tooltip = false;
        };
        "custom/separator#blank_2" = {
          format = "  ";
          interval = "once";
          tooltip = false;
        };
      };
    };
    style = lib.mkForce (builtins.readFile ./waybar.css);
    systemd.enable = true;
  };
}

{ pkgs, inputs, ... }:
let
  common = import ../common.nix pkgs;
in
{
  home.packages =
    common
    ++ (with pkgs; [
      # applications
      prismlauncher
      wine
      sbctl
      r2modman
      signal-desktop
      google-chrome
      vesktop
      zoom-us
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      logisim-evolution
      gimp

      # wayland desktop utils
      wl-clipboard
      grim
      slurp
      swappy
      pavucontrol
      waypaper
      swaybg
      awww
      pamixer
      brightnessctl
      chafa
      libnotify

      # theming
      bibata-cursors
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.qt5ct
      kdePackages.qtsvg

      # file management
      kdePackages.dolphin

      # system tools
      pciutils
      usbutils
      gpu-screen-recorder

      (pkgs.writeShellScriptBin "volume-control" ''
        step=0.01
        case "$1" in
            up)
                wpctl set-mute @DEFAULT_SINK@ 0
                wpctl set-volume @DEFAULT_SINK@ "''${step}+"
                ;;
            down)
                wpctl set-mute @DEFAULT_SINK@ 0
                wpctl set-volume @DEFAULT_SINK@ "''${step}-"
                ;;
            mute)
                wpctl set-mute @DEFAULT_SINK@ toggle
                ;;
        esac
        volume=$(wpctl get-volume @DEFAULT_SINK@)
        vol_value=$(echo "$volume" | awk '{printf "%d", $2 * 100}')
        vol_status=$(echo "$volume" | cut -d" " -f3)
        if [ "$vol_status" = "[MUTED]" ]; then
            notify-send -a "muted" -h int:value:"$vol_value" ""
            exit 0
        fi
        notify-send -a "volume" -h int:value:"$vol_value" ""
      '')

      (pkgs.writeShellScriptBin "powermenu" ''
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
      '')
    ]);

}

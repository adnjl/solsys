{ lib, pkgs, ... }:
let
  hyprnome = "${lib.getExe pkgs.hyprnome}";
in
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      "$mod, B, exec, firefox-devedition"
      "$mod, T, exec, kitty"
      "$mod, E, exec, dolphin"
      "$mod, R, exec, pavucontrol"
      "$mod, Bracketright, exec, waybar"

      "$mod+Shift, Q, killactive"
      "$mod, W, togglefloating"
      "$mod, V, togglesplit"
      "$mod, Y, fullscreen"
      "$mod, F, layoutmsg, fit active"
      "$mod+Shift, F, layoutmsg, fit all"

      "$mod, apostrophe, layoutmsg, move +col"
      "$mod, semicolon,  layoutmsg, move -col"

      "$mod, $Left,  layoutmsg, focus l"
      "$mod, $Right, layoutmsg, focus r"
      "$mod, $Up,    layoutmsg, focus u"
      "$mod, $Down,  layoutmsg, focus d"

      "$mod+Shift, $Left,  layoutmsg, movewindowto l"
      "$mod+Shift, $Right, layoutmsg, movewindowto r"
      "$mod+Shift, $Up,    layoutmsg, movewindowto u"
      "$mod+Shift, $Down,  layoutmsg, movewindowto d"

      "$mod+Ctrl, $Right, layoutmsg, colresize +0.1"
      "$mod+Ctrl, $Left,  layoutmsg, colresize -0.1"

      "$mod+Shift, D, exec, ${hyprnome} --move"
      "$mod+Shift, U, exec, ${hyprnome} --previous --move"
      "$mod, D, exec, ${hyprnome}"
      "$mod, U, exec, ${hyprnome} --previous"

      "$mod, Space, exec, pkill -x rofi || rofi -show drun"
      "$mod, G,     exec, pkill -x rofi || rofi -show window"

      ''$mod, P, exec, grim -g "$(slurp)" - | swappy -f -''
      "$mod+Shift, P, exec, hyprpicker -a"

      "$mod+Shift, Backspace, exec, wlogout"
      "$mod+Shift+Ctrl, I, exec, hyprlock"

      "$mod+Shift, Z, exec, gpu-screen-recorder -w screen -f 60 -r 5 -c mp4 -k hevc -o ~/Videos/Replays -df yes"
      "$mod+Shift, Bracketleft, exec, kill -USR1 $(pgrep gpu-screen-reco)"

      ",XF86AudioMute, exec, pamixer -t"
      "$mod+Shift, A, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod, Z, movewindow"
      "$mod, X, resizewindow"
    ];

    bindel = [
      ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ",XF86MonBrightnessUp,   exec, brightnessctl set 5%+"
      ",XF86AudioRaiseVolume,  exec, pamixer -i 5"
      ",XF86AudioLowerVolume,  exec, pamixer -d 5"
    ];
  };
}

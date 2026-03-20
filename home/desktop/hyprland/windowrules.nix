{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "opacity 0.90 0.90, match:class librewolf"
      "opacity 0.80 0.80, match:class (Steam|steam|steamwebhelper)"
      "opacity 0.80 0.80, match:class Spotify"
      "opacity 0.80 0.80, match:initial_title (Spotify Premium|Spotify Free)"
      "opacity 0.80 0.80, match:class (Code|code-url-handler)"
      "opacity 0.80 0.80, match:class kitty"
      "opacity 0.80 0.80, match:class org.kde.dolphin"
      "opacity 0.80 0.80, match:class org.kde.ark"
      "opacity 0.80 0.80, match:class (nwg-look|kvantummanager|waypaper)"
      "opacity 0.80 0.80, match:class (qt5ct|qt6ct)"
      "opacity 0.80 0.80, match:class org.pulseaudio.pavucontrol"
      "opacity 0.80 0.80, match:class com.obsproject.Studio"
      "opacity 0.80 0.80, match:class net.davidotek.pupgui2"
      "opacity 0.80 0.80, match:class yad"
      "opacity 0.80 0.80, match:class signal"
      "opacity 0.80 0.80, match:class lutris"
      "opacity 0.80 0.70, match:class pavucontrol"
      "opacity 0.80 0.70, match:class blueman-manager"
      "opacity 0.80 0.70, match:class (nm-applet|nm-connection-editor)"

      "float on, match:title Picture-in-Picture"
      "float on, match:class librewolf"
      "float on, match:class vlc"
      "float on, match:class (kvantummanager|qt5ct|qt6ct|nwg-look)"
      "float on, match:class org.kde.ark"
      "float on, match:class org.pulseaudio.pavucontrol"
      "float on, match:class net.davidotek.pupgui2"
      "float on, match:class yad"
      "float on, match:class (pavucontrol|blueman-manager|nm-applet|nm-connection-editor)"

      "pseudo on, match:class fcitx"
    ];

    layerrule = [
      "blur on, match:namespace rofi"
      "blur on, match:namespace notifications"
      "blur on, match:namespace swaync-notification-window"
      "blur on, match:namespace swaync-control-center"
      "blur on, match:namespace logout_dialog"
      "blur on, match:namespace waybar"
      "ignore_alpha 0.5, match:namespace rofi"
      "ignore_alpha 0.5, match:namespace notifications"
      "ignore_alpha 0.5, match:namespace swaync-notification-window"
      "ignore_alpha 0.5, match:namespace swaync-control-center"
      "ignore_alpha 0.5, match:namespace waybar"
    ];
  };
}

{
  system,
  osConfig,
  ...
}:
{
  imports =
    [
      ../../home/core.nix
      ../../home/terminal
      ../../home/programs/${system}
      ../../home/packages/${system}
    ]
    ++ (
      if osConfig.solSys.desktop.wm == "hyprland" then
        [ ../../home/wm/hyprland ]
      else if osConfig.solSys.desktop.wm == "niri" then
        [ ../../home/wm/niri ]
      else
        [ ]
    )
    ++ (
      if osConfig.solSys.desktop.shell == "quickshell" then
        [ ../../home/shell/quickshell ]
      else if osConfig.solSys.desktop.shell == "dms" then
        [ ../../home/shell/dms ]
      else
        [ ../../home/shell/waybar ]
    );
}

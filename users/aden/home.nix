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
      ../../home/shell
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
    );
}

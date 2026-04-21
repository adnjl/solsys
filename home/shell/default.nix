{ osConfig, system, ... }:
{

  # if osConfig.solSys.desktop.shell == "quickshell" then
  #   [ ../quickshell ]
  imports =
    [

    ]
    ++ (
      if osConfig.solSys.desktop.shell == "dms" then
        [ ../dms ]
      else
        [
          ./waybar
          ./mako
        ]
    );
}

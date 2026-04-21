{ lib, ... }:
{

  services.mako = {
    enable = true;
    settings = {
      # font = "JetBrainsMono Nerd Font 10";
      background-color = lib.mkForce "#16161D";
      border-size = 0;
      border-radius = 8;

      "app-name=volume" = {
        anchor = "bottom-center";
        group-by = "app-name";
        format = "<b>%s</b>\\n%b";
        width = 200;
        border-size = 28;
        border-radius = 14;
        border-color = lib.mkForce "#000000e6";
        background-color = lib.mkForce "#16161D";
        progress-color = lib.mkForce "source #C8C093";
        outer-margin = "0,0,20,0";
        padding = 1;
        layer = "overlay";
        default-timeout = 1000;
      };

      "app-name=muted" = {
        anchor = "bottom-center";
        group-by = "app-name";
        format = "<b>%s</b>\\n%b";
        width = 200;
        border-size = 28;
        border-radius = 14;
        border-color = lib.mkForce "#00000080";
        background-color = lib.mkForce "#32323280";
        progress-color = lib.mkForce "source #43242B";
        outer-margin = "0,0,20,0";
        padding = 1;
        layer = "overlay";
        default-timeout = 1000;
      };

      "anchor=bottom-center" = {
        max-visible = 1;
      };

      "hidden=true" = {
        invisible = 1;
      };
    };
  };
}

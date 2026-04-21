{ lib, ... }:
{

  services.mako = {
    enable = true;
    settings = {
      # font = "JetBrainsMono Nerd Font 10";
      background-color = lib.mkForce "#1D1C19";
      border-size = 2;
      border-radius = 0;
      outer-margin = "12, 12, 0, 0";
      margin = 10;
      padding = 12;
      default-timeout = 5000;
      ignore-timeout = 0;
      layer = "overlay";

      "app-name=volume" = {
        anchor = "bottom-center";
        group-by = "app-name";
        format = "<b>%s</b>\\n%b";
        width = 200;
        border-size = 20;
        border-radius = 2;
        border-color = lib.mkForce "#00000080";
        background-color = lib.mkForce "#32323280";
        progress-color = lib.mkForce "source #2D4F67";
        outer-margin = "0,0,185,0";
        padding = 1;
        layer = "overlay";
        default-timeout = 2000;
      };

      "app-name=muted" = {
        anchor = "bottom-center";
        group-by = "app-name";
        format = "<b>%s</b>\\n%b";
        width = 200;
        border-size = 20;
        border-radius = 2;
        border-color = lib.mkForce "#00000080";
        background-color = lib.mkForce "#32323280";
        progress-color = lib.mkForce "source #43242B";
        outer-margin = "0,0,185,0";
        padding = 1;
        layer = "overlay";
        default-timeout = 2000;
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

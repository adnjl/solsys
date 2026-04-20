{ pkgs, lib, ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        exclusive = true;
        passthrough = false;
        start-hidden = true;
        margin-top = 233;

        modules-center = [
          "clock"
          "custom/separator"
          "battery"
        ];
        "clock" = {
          format = " {:%H:%M}";
          tooltip = false;
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
            ""
            ""
            ""
            ""
            ""
          ];
          tooltip-format = "{timeTo} — {power}W";
        };
        "custom/separator" = {
          format = "󰇙";
          tooltip = false;
        };
      };
    };
    style = lib.mkForce (builtins.readFile ./style.css);
    systemd.enable = true;
  };
}

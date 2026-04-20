{ pkgs, lib, ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        exclusive = false;
        passthrough = false;
        start-hidden = true;
        margin-top = 200;

        modules-center = [
          "clock"
          "custom/separator"
          "battery"
        ];
        "clock" = {
          format = "{:%H:%M}";
          tooltip = false;
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}%";
          format-charging = "{capacity}%";
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

{ config, lib, ... }:

let
  cfg = config.solSys.skhd;
in
{
  options.solSys.skhd = {
    enable = lib.mkEnableOption "skhd hotkey daemon" // {
      default = true;
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra skhd keybindings appended after the defaults.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.skhd = {
      enable = true;
      skhdConfig = ''
        # Navigation
        alt - h : yabai -m window --focus west
        alt - j : yabai -m window --focus south
        alt - k : yabai -m window --focus north
        alt - l : yabai -m window --focus east

        # Moving windows
        shift + alt - h : yabai -m window --warp west
        shift + alt - j : yabai -m window --warp south
        shift + alt - k : yabai -m window --warp north
        shift + alt - l : yabai -m window --warp east

        # Resize windows
        lctrl + alt - h : yabai -m window --resize left:-50:0; yabai -m window --resize right:-50:0
        lctrl + alt - j : yabai -m window --resize bottom:0:50; yabai -m window --resize top:0:50
        lctrl + alt - k : yabai -m window --resize top:0:-50; yabai -m window --resize bottom:0:-50
        lctrl + alt - l : yabai -m window --resize right:50:0; yabai -m window --resize left:50:0

        # Balance / gaps
        lctrl + alt - e : yabai -m space --balance
        lctrl + alt - g : yabai -m space --toggle padding; yabai -m space --toggle gap

        # Space focus
        cmd + lctrl - h : yabai -m space --focus prev
        cmd + lctrl - l : yabai -m space --focus next

        # Float / fullscreen
        shift + alt - space : yabai -m window --toggle float; yabai -m window --toggle border
        alt - f             : yabai -m window --toggle zoom-fullscreen
        shift + alt - f     : yabai -m window --toggle native-fullscreen

        ${cfg.extraConfig}
      '';
    };
  };
}

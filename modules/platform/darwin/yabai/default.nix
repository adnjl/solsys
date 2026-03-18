{ config, lib, ... }:

let
  cfg = config.solSys.yabai;
in
{
  options.solSys.yabai = {
    enable = lib.mkEnableOption "yabai tiling WM" // {
      default = true;
    };
    layout = lib.mkOption {
      type = lib.types.enum [
        "bsp"
        "stack"
        "float"
      ];
      default = "bsp";
    };
    gaps = lib.mkOption {
      type = lib.types.int;
      default = 3;
    };
  };

  config = lib.mkIf cfg.enable {
    services.yabai = {
      enable = true;
      enableScriptingAddition = true;
      config = {
        focus_follows_mouse = "autoraise";
        mouse_follows_focus = "on";
        window_placement = "second_child";
        window_opacity = "on";
        top_padding = cfg.gaps;
        bottom_padding = cfg.gaps;
        left_padding = cfg.gaps;
        right_padding = cfg.gaps;
        window_gap = cfg.gaps;
        split_ratio = 0.5;
        split_type = "auto";
        layout = cfg.layout;
        mouse_modifier = "fn";
        mouse_action1 = "move";
        mouse_action2 = "resize";
        mouse_drop_action = "swap";
      };
      extraConfig = ''
        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        sudo yabai --load-sa
      '';
    };
  };
}

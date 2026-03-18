{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.solSys.greeter;
in
{
  options.solSys.greeter = {
    backend = lib.mkOption {
      type = lib.types.enum [
        "greetd"
        "sddm"
        "none"
      ];
      default = "greetd";
    };
    session = lib.mkOption {
      type = lib.types.str;
      default = "Hyprland";
      description = "Default session command to launch.";
    };
  };

  config = lib.mkIf (cfg.backend != "none") {
    services.greetd = lib.mkIf (cfg.backend == "greetd-tuigreet") {
      enable = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${cfg.session} --remember";
        user = "greeter";
      };
    };

    systemd.services.greetd = lib.mkIf (cfg.backend == "greetd-tuigreet") {
      serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "tty";
        StandardError = "journal";
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };
    };

    services.displayManager.sddm.enable = lib.mkIf (cfg.backend == "sddm") true;
  };
}

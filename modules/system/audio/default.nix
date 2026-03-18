{ config, lib, ... }:

let
  cfg = config.solSys.audio;
in
{
  options.solSys.audio = {
    backend = lib.mkOption {
      type = lib.types.enum [
        "pipewire"
        "pulseaudio"
        "none"
      ];
      default = "pipewire";
    };
    jack = lib.mkEnableOption "JACK support";
  };

  config = lib.mkIf (cfg.backend != "none") {
    services.pulseaudio.enable = false;

    services.pipewire = lib.mkIf (cfg.backend == "pipewire") {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = cfg.jack;
    };
  };
}

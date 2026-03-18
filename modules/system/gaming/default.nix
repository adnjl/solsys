{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.solSys.gaming;
in
{
  options.solSys.gaming = {
    enable = lib.mkEnableOption "gaming support (Steam, Proton, gamescope)";
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        osu-lazer-bin
        mangohud
        lunar-client
        lutris
      ];
    };
    steam = {
      remotePlay = lib.mkEnableOption "Steam Remote Play" // {
        default = true;
      };
      dedicatedServer = lib.mkEnableOption "Steam Dedicated Server" // {
        default = true;
      };
      localTransfers = lib.mkEnableOption "Steam Local Game Transfers" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        protonup-ng
        protonup-qt
      ]
      ++ cfg.extraPackages;

    programs.gamescope.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = cfg.steam.remotePlay;
      dedicatedServer.openFirewall = cfg.steam.dedicatedServer;
      localNetworkGameTransfers.openFirewall = cfg.steam.localTransfers;
    };
  };
}

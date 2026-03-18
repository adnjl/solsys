# == fenghuang : aarch64-darwin (macOS) =========================================
{ inputs, ... }:
{
  imports = [
    ../../modules/platform/darwin
    ../../modules/platform/darwin/brew
    ../../modules/platform/darwin/yabai
    ../../modules/platform/darwin/skhd
  ];

  networking.hostName = "fenghuang";
  nixpkgs.hostPlatform = "aarch64-darwin";
  ids.gids.nixbld = 350;
  programs.fish.enable = true;
  system.stateVersion = 4;

  launchd.user.agents = {
    yabai.serviceConfig.EnvironmentVariables.SHELL = "/bin/dash";
    skhd.serviceConfig.EnvironmentVariables.SHELL = "/bin/dash";
  };

  solSys.brew = {
    user = "soems";
  };

  solSys.yabai = {
    enable = true;
    layout = "bsp";
    gaps = 3;
  };

  solSys.skhd.enable = true;
}

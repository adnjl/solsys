{
  config,
  pkgs,
  lib,
  username,
  ...
}:

let
  cfg = config.solSys.users;
in
{
  options.solSys.users = {
    username = lib.mkOption {
      type = lib.types.str;
      default = username;
    };
    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "networkmanager"
        "wheel"
      ];
    };
    shell = lib.mkOption {
      type = lib.types.package;
      default = pkgs.fish;
    };
    sudoNoPassword = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    gsr = lib.mkEnableOption "gpu-screen-recorder kms wrapper";
  };

  config = {
    users.users.${cfg.username} = {
      isNormalUser = true;
      description = cfg.username;
      extraGroups = cfg.extraGroups;
      ignoreShellProgramCheck = true;
      shell = cfg.shell;
    };

    programs.fish.enable = true;
    security.sudo.wheelNeedsPassword = !cfg.sudoNoPassword;
    console.useXkbConfig = true;

    security.wrappers.gsr-kms-server = lib.mkIf cfg.gsr {
      source = lib.getExe' pkgs.gpu-screen-recorder "gsr-kms-server";
      capabilities = "cap_sys_admin+ep";
      owner = "root";
      group = "root";
    };
  };
}

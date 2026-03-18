{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.solSys.boot;
in
{
  options.solSys.boot = {
    bootloader = lib.mkOption {
      type = lib.types.enum [
        "grub"
        "systemd-boot"
        "none"
      ];
      default = "grub";
    };
    grubTheme = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a GRUB theme directory.";
    };
    kernelBuild = lib.mkOption {
      type = lib.types.enum [
        "default"
        "latest"
        "zen"
        "cachyos"
      ];
      default = "default";
    };
    luksDevices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "LUKS device UUIDs to unlock at boot (without the luks- prefix).";
    };
    kernelParams = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = {
    boot = {
      kernelPackages =
        if cfg.kernelBuild == "latest" then
          pkgs.linuxPackages_latest
        else if cfg.kernelBuild == "zen" then
          pkgs.linuxPackages_zen
        else if cfg.kernelBuild == "cachyos" then
          pkgs.linuxPackages_cachyos-gcc
        else
          pkgs.linuxPackages;

      kernelParams = cfg.kernelParams;

      initrd.luks.devices = lib.listToAttrs (
        map (uuid: {
          name = "luks-${uuid}";
          value = {
            device = "/dev/disk/by-uuid/${uuid}";
          };
        }) cfg.luksDevices
      );

      loader = {
        timeout = lib.mkDefault 10;
        efi.canTouchEfiVariables = true;

        systemd-boot = lib.mkIf (cfg.bootloader == "systemd-boot") {
          enable = true;
          consoleMode = "0";
        };

        grub = lib.mkIf (cfg.bootloader == "grub") {
          enable = true;
          efiSupport = true;
          useOSProber = true;
          copyKernels = true;
          device = "nodev";
          configurationLimit = 10;
          theme = lib.mkIf (cfg.grubTheme != null) (lib.mkForce cfg.grubTheme);
          extraEntries = ''
            menuentry "Reboot"   { reboot }
            menuentry "Shutdown" { halt }
          '';
        };
      };
    };
  };
}

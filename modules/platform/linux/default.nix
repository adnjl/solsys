{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.solSys.hardware;
in
{
  options.solSys.hardware = {
    gpu = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "nvidia"
          "amd"
          "intel"
        ]
      );
      default = null;
    };
    cpu = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "amd"
          "intel"
        ]
      );
      default = null;
    };
    bluetooth = lib.mkEnableOption "Bluetooth";
    tablet = lib.mkEnableOption "opentabletdriver";
    nvidia = {
      open = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      powerManagement = lib.mkEnableOption "NVIDIA power management" // {
        default = true;
      };
    };
  };

  config = {
    hardware.graphics.enable = true;

    hardware.nvidia = lib.mkIf (cfg.gpu == "nvidia") {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      modesetting.enable = true;
      powerManagement.enable = cfg.nvidia.powerManagement;
      powerManagement.finegrained = false;
      nvidiaSettings = true;
      open = cfg.nvidia.open;
    };

    services.xserver.videoDrivers =
      if cfg.gpu == "nvidia" then
        [ "nvidia" ]
      else if cfg.gpu == "intel" then
        [ "modesetting" ]
      else
        [ ];

    boot.kernelParams = lib.mkIf (cfg.gpu == "nvidia") [ "nvidia_drm.modeset=1" ];

    # Intel: enable VA-API hardware video decode (useful for video calls on SV1)
    hardware.graphics.extraPackages = lib.mkIf (cfg.gpu == "intel") (
      with pkgs;
      [
        intel-media-driver # iHD — required for Tiger Lake Iris Xe
        intel-compute-runtime
        intel-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
      ]
    );

    hardware.cpu.amd = lib.mkIf (cfg.cpu == "amd") {
      updateMicrocode = true;
      ryzen-smu.enable = true;
    };
    hardware.cpu.intel = lib.mkIf (cfg.cpu == "intel") {
      updateMicrocode = config.hardware.enableRedistributableFirmware;
    };

    hardware.bluetooth.enable = cfg.bluetooth;
    services.blueman.enable = cfg.bluetooth;

    hardware.opentabletdriver.enable = cfg.tablet;

    services.xserver = {
      enable = true;
      displayManager.startx.enable = true;
      xkb = {
        layout = "us";
        options = "ctrl:nocaps";
        variant = "";
      };
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      LIBVA_DRIVER_NAME = "iHD";
    };

    networking.networkmanager.enable = true;

    virtualisation.podman.enable = true;
    services.flatpak.enable = true;

    fonts = {
      fontconfig.enable = true;
      enableDefaultPackages = true;
      packages = with pkgs; [
        jetbrains-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        liberation_ttf
        fira-code
        fira-code-symbols
        ipafont
        kochi-substitute
        proggyfonts
        (nerd-fonts.caskaydia-cove)
      ];
    };
  };
}

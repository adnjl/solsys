# Panasonic Let's Note CF-SV1
# Intel 11th Gen Tiger Lake (i5-1145G7 / i7-1165G7)
# Intel Iris Xe Graphics (integrated, no discrete GPU)
# 12.1" WUXGA 1920x1200 display (eDP-1)
# NVMe SSD, Thunderbolt 4, Wi-Fi 6, Bluetooth 5.1
#
# Replace UUIDs below with output of: sudo blkid
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Tiger Lake initrd modules
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "sdhci_pci" # SD card reader
  ];
  boot.initrd.kernelModules = [ ];

  boot.kernelModules = [
    "kvm-intel"
    "i915" # Intel Iris Xe / Tiger Lake GPU
  ];

  boot.extraModulePackages = [ ];

  # ── Filesystems ─────────────────────────────────────────────────────────────
  # Replace these UUIDs with the output of `sudo blkid` on your machine.
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2fa1e825-b3bc-44e6-bbd1-4e916151ce69";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0676-0377";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ ];
  # Uncomment and set size if you want a swapfile instead:
  # swapDevices = [{ device = "/var/lib/swapfile"; size = 8 * 1024; }];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Tiger Lake microcode
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

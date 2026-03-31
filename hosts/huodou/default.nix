# == huodou : aarch64-linux (Apple Silicon NixOS) =============================
{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/core
    ../../modules/system/audio
    ../../modules/system/users
    ../../modules/system/boot
    ../../modules/system/form
    ../../modules/desktop/wm
    ../../modules/desktop/greeter
    ../../modules/desktop/theming
    ../../modules/platform/linux
    inputs.apple-silicon.nixosModules.apple-silicon-support
  ];

  networking.hostName = "huodou";

  solSys.form.type = "desktop";

  solSys.boot = {
    bootloader = "systemd-boot";
    kernelBuild = "default";
  };

  solSys.hardware = {
    gpu = null;
    cpu = null;
    bluetooth = true;
  };

  solSys.desktop = {
    wm = "hyprland";
    monitor = [ "HDMI-A-1, 1920x1080@60, 0x0, 1" ];
    gaps = {
      inner = 5;
      outer = 10;
    };
    blur = true;
  };

  solSys.desktop.hyprland.layout = "scrolling";

  solSys.greeter = {
    backend = "greetd";
    session = "Hyprland";
  };

  solSys.theming = {
    wallpaper = "${inputs.wallpapers}/desk.jpg";
    colorScheme = "kanagawa-dragon";
    cursor = {
      name = "Bibata-Modern-Ice";
      size = 26;
    };
    fonts.monospace = "CaskaydiaCove Nerd Font";
  };

  system.stateVersion = "25.05";
}

# == qilin : x86_64-linux desktop ===========================================
{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/core
    ../../modules/system/audio
    ../../modules/system/gaming
    ../../modules/system/users
    ../../modules/system/boot
    ../../modules/system/form
    ../../modules/desktop/wm
    ../../modules/desktop/greeter
    ../../modules/desktop/theming
    ../../modules/platform/linux
  ];

  networking.hostName = "qilin";

  solSys.form.type = "desktop";

  solSys.boot = {
    bootloader = "grub";
    grubTheme = ../../components/grub-themes/virtuaverse;
    kernelBuild = "cachyos";
    luksDevices = [ "614153e3-61be-43f4-b833-d19e3d83db0a" ];
  };

  solSys.hardware = {
    gpu = "nvidia";
    cpu = "amd";
    tablet = true;
    bluetooth = true;
  };

  solSys.gaming = {
    enable = true;
    extraPackages = [ ];
  };

  solSys.core = {
    inputMethod = "fcitx5";
    ssh.enable = true;
  };

  solSys.desktop = {
    wm = "niri";
    monitor = [ "HDMI-A-1, 1600x900@72, 0x0, 1" ];
    gaps = {
      inner = 5;
      outer = 10;
    };
    blur = true;
    tearing = true;
    terminal = "kitty";
    browser = "firefox-devedition";
    fileManager = "dolphin";
    extraPackages = [ ];
  };

  solSys.desktop.hyprland = {
    layout = "scrolling";
    extraConfig = "";
  };

  solSys.greeter = {
    backend = "greetd";
    session = "niri-session";
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

  solSys.users.gsr = true;

  system.stateVersion = "25.05";

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  systemd.tpm2.enable = false;
}

# == fuzhu : Panasonic Let's Note CF-SV1 (x86_64 linux) ============
{ inputs, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/core
    ../../modules/system/audio
    ../../modules/system/users
    ../../modules/system/boot
    ../../modules/system/form
    ../../modules/system/gaming
    ../../modules/desktop/wm
    ../../modules/desktop/greeter
    ../../modules/desktop/theming
    ../../modules/platform/linux
  ];

  networking.hostName = "fuzhu";

  services.upower.enable = true;
  environment.systemPackages = with pkgs; [
    powertop
    acpi
  ];
  programs.nix-ld.libraries = with pkgs; [
    libayatana-appindicator
  ];

  solSys.form.type = "laptop";

  solSys.laptop = {
    builtinDisplay = "eDP-1";

    powerManagement = {
      enable = true;
      backend = "tlp";
      tlp = {
        cpuScalingGovernorOnAc = "performance";
        cpuScalingGovernorOnBat = "powersave";
        startThreshold = 20;
        stopThreshold = 80;
      };
    };

    backlight = {
      enable = true;
      backend = "brightnessctl";
    };

    touchpad = {
      enable = true;
      naturalScrolling = true;
      tapToClick = true;
      disableWhileTyping = true;
      accelProfile = "adaptive";
    };

    lid = {
      action = "suspend";
      actionOnExternalPower = "ignore";
    };

    battery.alertPercent = 15;
  };
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          muhenkan = "leftmeta";
        };
      };
    };
  };
  solSys.boot = {
    bootloader = "grub";
    grubTheme = ../../components/grub-themes/virtuaverse;
    kernelBuild = "cachyos";
    kernelParams = [
      "mem_sleep_default=deep"
      "i915.enable_psr=0"
      "i915.enable_fbc=1"
    ];
  };

  solSys.hardware = {
    gpu = "intel";
    cpu = "intel";
    bluetooth = true;
    tablet = false;
  };

  solSys.core = {
    # The SV1 has a Japanese keyboard layout — keep fcitx5 for input switching
    inputMethod = "fcitx5";
    ssh.enable = true;
  };

  solSys.desktop = {
    wm = "niri";
    monitor = [ "eDP-1, 1920x1200@75, 0x0, 1" ];
    gaps = {
      inner = 4;
      outer = 6;
    };
    blur = true;
    tearing = true;
    terminal = "kitty";
    browser = "firefox-devedition";
    fileManager = "dolphin";
  };

  solSys.desktop.hyprland = {
    layout = "scrolling";
    extraConfig = ''
      # lid switch handled by logind via solSys.laptop.lid
      # close lid with external monitor: keep running
      bindl = , switch:Lid Switch, exec, hyprctl dispatch dpms toggle eDP-1
      input {
        kb_layout = jp
      }
    '';
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
      size = 22;
    };
    fonts.monospace = "CaskaydiaCove Nerd Font";
  };

  solSys.gaming = {
    enable = true;
    # extraPackages = [ ];
  };

  solSys.users.gsr = false;

  system.stateVersion = "25.05";

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };
}

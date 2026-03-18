{ pkgs, inputs, ... }:
let
  common = import ../common.nix pkgs;
in
{
  home.packages =
    common
    ++ (with pkgs; [
      # applications
      prismlauncher
      wine
      sbctl
      r2modman
      signal-desktop
      google-chrome
      vesktop
      zoom-us
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

      # wayland desktop utils
      wl-clipboard
      grim
      slurp
      swappy
      pavucontrol
      waypaper
      swaybg
      pamixer
      brightnessctl
      chafa

      # theming
      bibata-cursors
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.qt5ct
      kdePackages.qtsvg

      # file management
      kdePackages.dolphin

      # system tools
      pciutils
      usbutils
      gpu-screen-recorder
    ]);
}

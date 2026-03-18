{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
let
  commonPrograms = import ../default.nix { inherit pkgs inputs config; };
in
{
  imports = [
    commonPrograms
    inputs.spicetify-nix.homeManagerModules.default
    ./swaync
    ./rofi
  ];

  services.easyeffects = {
    enable = true;
    package = pkgs.easyeffects;
  };

  services.syncthing.enable = true;

  programs.fzf.enable = true;

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      enable = true;
      alwaysEnableDevTools = true;
      wayland = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle
        fullAppDisplay
        history
      ];
      enabledCustomApps = with spicePkgs.apps; [
        lyricsPlus
        marketplace
        betterLibrary
      ];
      theme = lib.mkForce spicePkgs.themes.text;
      colorScheme = lib.mkForce "Kanagawa";
    };
}

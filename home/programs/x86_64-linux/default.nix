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
  ];

  services.easyeffects = {
    enable = true;
    package = pkgs.easyeffects;
  };

  services.syncthing.enable = true;

  programs.fzf.enable = true;

  stylix.targets.vicinae.enable = false;
  programs.vicinae = {
    enable = true;
  };

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
      colorScheme = lib.mkForce "custom";

      customColorScheme = lib.mkForce {
        main = "181616";
        accent-inactive = "181616";

        highlight = "2D4F67";
        border-inactive = "312e28";
        header = "7a8382";

        accent = "8ba4b0";
        accent-active = "8ba4b0";
        banner = "87a987";
        border-active = "c4b28a";

        text = "7a8382";
        subtext = "737c73";

        notification = "8992a7";
        notification-error = "c4746e";
      };
    };
}

{
  system,
  lib,
  ...
}:
{
  imports = [
    ../../home/core.nix
    ../../home/shell
    ../../home/packages/${system}
  ];

  # macOS home directory override
  home.homeDirectory = lib.mkForce "/Users/soems";

  programs.git = {
    enable = true;
    userName = "Aden Lung";
    userEmail = "soemscontact@gmail.com";
    extraConfig.commit.gpgsign = "false";
    extraConfig.init.defaultBranch = "main";
  };

  programs.fish.enable = true;

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}

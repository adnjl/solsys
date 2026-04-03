{ username, lib, ... }:
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";
  };
  home.file.".mozilla/firefox/aden/chrome" = {
    source = lib.mkForce ../components/firefox;
    recursive = lib.mkForce true;
  };
  programs.home-manager.enable = true;
}

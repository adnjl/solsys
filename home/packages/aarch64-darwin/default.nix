{ pkgs, ... }:
let
  common = import ../common.nix pkgs;
in
{
  home.packages =
    common
    ++ (with pkgs; [
      zoxide
      eza
      neofetch
    ]);
}

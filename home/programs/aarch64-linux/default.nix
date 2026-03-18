{ pkgs, inputs, ... }:
let
  commonPrograms = import ../default.nix { inherit pkgs inputs; };
in
{
  imports = [ commonPrograms ];
  # aarch64-linux-specific packages are declared in home/packages/aarch64-linux
}

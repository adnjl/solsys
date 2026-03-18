{
  system,
  ...
}:
{
  imports = [
    ../../home/core.nix
    ../../home/shell
    ../../home/hyprland
    ../../home/programs/${system}
    ../../home/packages/${system}
  ];
}

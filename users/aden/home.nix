{
  system,
  ...
}:
{
  imports = [
    ../../home/core.nix
    ../../home/shell
    ../../home/desktop/niri
    ../../home/programs/${system}
    ../../home/packages/${system}
  ];
}

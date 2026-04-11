{
  config,
  lib,
  ...
}:
let
  cfg = config.solSys.desktop.shell;
in
{
  options.solSys.desktop = {
    shell = lib.mkOption {
      type = lib.types.enum [
        "none"
        "quickshell"
        "dms"
      ];
      default = "none";
      description = ''
        Which graphical shell to enable.
        "none" lets you manage your GUI entirely yourself.
      '';

    };
  };
}

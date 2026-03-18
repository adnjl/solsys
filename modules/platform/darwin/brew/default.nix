{
  inputs,
  config,
  lib,
  ...
}:

let
  cfg = config.solSys.brew;
in
{
  options.solSys.brew = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "Homebrew owner user.";
    };
    mutableTaps = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    extraTaps = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Additional taps as name→flake-input pairs.";
    };
  };

  config = {
    nix-homebrew = {
      enable = true;
      user = cfg.user;
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      } // cfg.extraTaps;
      mutableTaps = cfg.mutableTaps;
    };
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.solSys.core;
in
{
  options.solSys.core = {
    timezone = lib.mkOption {
      type = lib.types.str;
      default = "America/Los_Angeles";
    };
    locale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
    };
    inputMethod = lib.mkOption {
      type = lib.types.enum [
        "fcitx5"
        "ibus"
        "none"
      ];
      default = "none";
    };
    fcitx5Addons = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
    };
    ssh = {
      enable = lib.mkEnableOption "OpenSSH" // {
        default = true;
      };
      x11Forwarding = lib.mkEnableOption "X11 forwarding" // {
        default = true;
      };
    };
    allowUnfree = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    flakes = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = {
    time.timeZone = cfg.timezone;

    i18n = {
      defaultLocale = cfg.locale;
      extraLocaleSettings = lib.genAttrs [
        "LC_ADDRESS"
        "LC_IDENTIFICATION"
        "LC_MEASUREMENT"
        "LC_MONETARY"
        "LC_NAME"
        "LC_NUMERIC"
        "LC_PAPER"
        "LC_TELEPHONE"
        "LC_TIME"
      ] (_: cfg.locale);
      inputMethod = lib.mkIf (cfg.inputMethod != "none") {
        type = cfg.inputMethod;
        enable = true;
        fcitx5.addons = lib.mkIf (cfg.inputMethod == "fcitx5") cfg.fcitx5Addons;
      };
    };

    services.openssh = lib.mkIf cfg.ssh.enable {
      enable = true;
      settings = {
        X11Forwarding = cfg.ssh.x11Forwarding;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };

    nixpkgs.config.allowUnfree = cfg.allowUnfree;

    nix.settings = {
      trusted-users = [ config.solSys.users.username ];
      experimental-features = lib.mkIf cfg.flakes [
        "nix-command"
        "flakes"
      ];
    };

    networking.firewall.enable = true;
    services.printing.enable = true;
    programs.dconf.enable = true;
    security.polkit.enable = true;
    services.power-profiles-daemon.enable = lib.mkDefault false;
    services.dbus.packages = [ pkgs.gcr ];
    services.geoclue2.enable = true;
  };
}

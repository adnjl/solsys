{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.solSys.form;
  lCfg = config.solSys.laptop;
  isLaptop = cfg.type == "laptop";
  isServer = cfg.type == "server";
in
{
  options.solSys = {
    form.type = lib.mkOption {
      type = lib.types.enum [
        "desktop"
        "laptop"
        "server"
      ];
      default = "desktop";
      description = ''
        Form factor. Automatically sets power, backlight, touchpad, lid defaults.
        Any individual sub-option can still be overridden.
      '';
    };

    laptop = {
      powerManagement = {
        enable = lib.mkEnableOption "laptop power management" // {
          default = true;
        };
        backend = lib.mkOption {
          type = lib.types.enum [
            "tlp"
            "power-profiles-daemon"
            "auto-cpufreq"
          ];
          default = "tlp";
          description = "tlp = fine-grained; power-profiles-daemon = simple; auto-cpufreq = automatic.";
        };
        tlp = {
          cpuScalingGovernorOnAc = lib.mkOption {
            type = lib.types.str;
            default = "performance";
          };
          cpuScalingGovernorOnBat = lib.mkOption {
            type = lib.types.str;
            default = "powersave";
          };
          startThreshold = lib.mkOption {
            type = lib.types.int;
            default = 20;
          };
          stopThreshold = lib.mkOption {
            type = lib.types.int;
            default = 80;
          };
        };
      };

      backlight = {
        enable = lib.mkEnableOption "backlight control" // {
          default = true;
        };
        backend = lib.mkOption {
          type = lib.types.enum [
            "brightnessctl"
            "xbacklight"
          ];
          default = "brightnessctl";
        };
      };

      touchpad = {
        enable = lib.mkEnableOption "touchpad" // {
          default = true;
        };
        naturalScrolling = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        tapToClick = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        disableWhileTyping = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        accelProfile = lib.mkOption {
          type = lib.types.enum [
            "adaptive"
            "flat"
          ];
          default = "adaptive";
        };
      };

      lid = {
        action = lib.mkOption {
          type = lib.types.enum [
            "suspend"
            "hibernate"
            "lock"
            "ignore"
          ];
          default = "suspend";
        };
        actionOnExternalPower = lib.mkOption {
          type = lib.types.enum [
            "suspend"
            "hibernate"
            "lock"
            "ignore"
          ];
          default = "ignore";
        };
      };

      battery.alertPercent = lib.mkOption {
        type = lib.types.int;
        default = 15;
      };

      builtinDisplay = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "eDP-1";
        description = "Connector name of the built-in display.";
      };
    };
  };

  config = lib.mkMerge [
    # Laptop
    (lib.mkIf isLaptop {
      services.tlp = lib.mkIf (lCfg.powerManagement.enable && lCfg.powerManagement.backend == "tlp") {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = lCfg.powerManagement.tlp.cpuScalingGovernorOnAc;
          CPU_SCALING_GOVERNOR_ON_BAT = lCfg.powerManagement.tlp.cpuScalingGovernorOnBat;
          START_CHARGE_THRESH_BAT0 = lCfg.powerManagement.tlp.startThreshold;
          STOP_CHARGE_THRESH_BAT0 = lCfg.powerManagement.tlp.stopThreshold;
        };
      };

      services.power-profiles-daemon.enable = lib.mkIf (
        lCfg.powerManagement.enable && lCfg.powerManagement.backend == "power-profiles-daemon"
      ) true;

      services.auto-cpufreq =
        lib.mkIf (lCfg.powerManagement.enable && lCfg.powerManagement.backend == "auto-cpufreq")
          {
            enable = true;
            settings = {
              battery.governor = "powersave";
              battery.turbo = "auto";
              charger.governor = "performance";
              charger.turbo = "auto";
            };
          };

      environment.systemPackages = lib.optionals (
        lCfg.backlight.enable && lCfg.backlight.backend == "brightnessctl"
      ) [ pkgs.brightnessctl ];

      services.libinput = lib.mkIf lCfg.touchpad.enable {
        enable = true;
        touchpad = {
          naturalScrolling = lCfg.touchpad.naturalScrolling;
          tapping = lCfg.touchpad.tapToClick;
          disableWhileTyping = lCfg.touchpad.disableWhileTyping;
          accelProfile = lCfg.touchpad.accelProfile;
        };
      };

      services.logind = {
        settings.Login = {
          IdleAction = "suspend";
          IdleActionSec = "10min";
          HandleLidSwitchExternalPower = lCfg.lid.actionOnExternalPower;
          HandleLidSwitch = lCfg.lid.action;
          HandlePowerKey = lib.mkDefault "suspend";

        };
      };

      services.udev.extraRules = ''
        SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", \
          ATTR{capacity}=="[0-${toString lCfg.battery.alertPercent}]", \
          RUN+="${pkgs.libnotify}/bin/notify-send -u critical 'Low battery' \
            'Battery below ${toString lCfg.battery.alertPercent}%%'"
      '';
    })

    # ── Server ────────────────────────────────────────────────────────────────
    (lib.mkIf isServer {
      services.xserver.enable = lib.mkForce false;
      programs.hyprland.enable = lib.mkForce false;
      services.power-profiles-daemon.enable = lib.mkForce false;
      powerManagement.cpuFreqGovernor = lib.mkForce "performance";
      services.logind.settings.Login = {
        HandleSuspendKey = "ignore";
        HandleHibernateKey = "ignore";
        HandleLidSwitch = "ignore";
      };
    })

    # ── Desktop ───────────────────────────────────────────────────────────────
    (lib.mkIf (!isLaptop && !isServer) {
      powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
    })
  ];
}

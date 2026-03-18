# solSys 🌌

A modular NixOS / nix-darwin configuration framework built around opt-in modules and a unified `solSys.*` option namespace.

## Features

- **Single file per host** — one `hosts/<n>/default.nix` controls everything
- **Opt-in modules** — import only what you need, configure with options
- **Form factors** — `desktop`, `laptop`, `server` with automatic defaults
- **WM switcher** — swap between Hyprland, Sway, niri, or i3 with one line
- **Named colour schemes** — `kanagawa-dragon`, `catppuccin-mocha`, `gruvbox-dark`, `rose-pine` or inline base16
- **Multi-platform** — NixOS (x86_64, aarch64) and macOS (nix-darwin)

## Structure

```
hosts/<n>/        per-machine config
modules/          opt-in system/desktop/platform modules
home/             shared home-manager config (shell, hyprland, programs)
users/<n>/        per-user home.nix
lib/              builder functions (keeps flake.nix clean)
components/       assets (GRUB themes etc.)
```

## Adding a host

**1.** `flake.nix` — two lines:
```nix
nixosConfigurations = lib.buildNixosHosts {
  hosts.mymachine = { system = "x86_64-linux"; user = "alice"; };
};
```

**2.** `hosts/mymachine/default.nix`:
```nix
{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/core
    ../../modules/system/boot
    ../../modules/system/users
    ../../modules/system/form
    ../../modules/desktop/wm
    ../../modules/desktop/theming
    ../../modules/platform/linux
  ];

  networking.hostName    = "mymachine";
  solSys.form.type       = "desktop";
  solSys.boot            = { bootloader = "systemd-boot"; kernelBuild = "cachyos"; };
  solSys.hardware        = { gpu = "amd"; cpu = "amd"; };
  solSys.desktop.wm      = "hyprland";
  solSys.desktop.monitor = [ "DP-1, 2560x1440@144, 0x0, 1" ];
  solSys.theming         = { wallpaper = ./wallpaper.jpg; colorScheme = "kanagawa-dragon"; };

  system.stateVersion = "25.05";
}
```

**3.** Generate hardware config on the target machine:
```bash
nixos-generate-config --show-hardware-config > hosts/mymachine/hardware-configuration.nix
```

**4.** Deploy:
```bash
nh os switch -H mymachine
```

## Key options

| Option | Values |
|--------|--------|
| `solSys.form.type` | `"desktop"` `"laptop"` `"server"` |
| `solSys.boot.kernelBuild` | `"default"` `"latest"` `"zen"` `"cachyos"` |
| `solSys.boot.bootloader` | `"grub"` `"systemd-boot"` |
| `solSys.hardware.gpu` | `"nvidia"` `"amd"` `"intel"` `null` |
| `solSys.desktop.wm` | `"hyprland"` `"sway"` `"niri"` `"i3"` `"none"` |
| `solSys.theming.colorScheme` | `"kanagawa-dragon"` `"catppuccin-mocha"` `"gruvbox-dark"` `"rose-pine"` |
| `solSys.audio.backend` | `"pipewire"` `"pulseaudio"` `"none"` |

Laptop form factor enables TLP, libinput touchpad, lid switch, backlight, and battery alerts automatically — all individually overrideable via `solSys.laptop.*`.

## Daily commands

```bash
nh os switch           # apply immediately
nh os boot             # apply on next boot
nix flake update       # update all inputs
nix-collect-garbage -d # garbage collect
```

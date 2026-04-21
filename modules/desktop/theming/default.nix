{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  cfg = config.solSys.theming;

  builtinSchemes = {
    "kanagawa-dragon" = {
      system = "base16";
      name = "kanagawa";
      author = "rebelot";
      variant = "dragon";
      palette = {
        base00 = "181616";
        base01 = "0d0c0c";
        base02 = "8ba4b0";
        base03 = "a6a69c";
        base04 = "7fb4ca";
        base05 = "c5c9c5";
        base06 = "938aa9";
        base07 = "c5c9c5";
        base08 = "c4746e";
        base09 = "e46876";
        base0A = "c4b28a";
        base0B = "8a9a7b";
        base0C = "8ea4a2";
        base0D = "8ba4b0";
        base0E = "a292a3";
        base0F = "7aa89f";
      };
    };
    "catppuccin-mocha" = {
      system = "base16";
      name = "catppuccin-mocha";
      author = "catppuccin";
      variant = "mocha";
      palette = {
        base00 = "1e1e2e";
        base01 = "181825";
        base02 = "313244";
        base03 = "45475a";
        base04 = "585b70";
        base05 = "cdd6f4";
        base06 = "f5c2e7";
        base07 = "b4befe";
        base08 = "f38ba8";
        base09 = "fab387";
        base0A = "f9e2af";
        base0B = "a6e3a1";
        base0C = "94e2d5";
        base0D = "89b4fa";
        base0E = "cba6f7";
        base0F = "f2cdcd";
      };
    };
    "gruvbox-dark" = {
      system = "base16";
      name = "gruvbox-dark";
      author = "dawikur";
      variant = "hard";
      palette = {
        base00 = "1d2021";
        base01 = "3c3836";
        base02 = "504945";
        base03 = "665c54";
        base04 = "bdae93";
        base05 = "d5c4a1";
        base06 = "ebdbb2";
        base07 = "fbf1c7";
        base08 = "fb4934";
        base09 = "fe8019";
        base0A = "fabd2f";
        base0B = "b8bb26";
        base0C = "8ec07c";
        base0D = "83a598";
        base0E = "d3869b";
        base0F = "d65d0e";
      };
    };
    "rose-pine" = {
      system = "base16";
      name = "rose-pine";
      author = "rose-pine";
      variant = "main";
      palette = {
        base00 = "191724";
        base01 = "1f1d2e";
        base02 = "26233a";
        base03 = "6e6a86";
        base04 = "908caa";
        base05 = "e0def4";
        base06 = "e0def4";
        base07 = "524f67";
        base08 = "eb6f92";
        base09 = "f6c177";
        base0A = "ebbcba";
        base0B = "31748f";
        base0C = "9ccfd8";
        base0D = "c4a7e7";
        base0E = "f6c177";
        base0F = "524f67";
      };
    };
  };

  resolvedScheme =
    if builtins.isString cfg.colorScheme then
      builtinSchemes.${cfg.colorScheme} or (throw ''
        solSys.theming.colorScheme: unknown scheme '${cfg.colorScheme}'.
        Available: ${builtins.concatStringsSep ", " (builtins.attrNames builtinSchemes)}
      '')
    else
      cfg.colorScheme;

in
{
  # stylix must be imported at top level — imports inside config = {} is invalid
  imports = [ inputs.stylix.nixosModules.stylix ];

  options.solSys.theming = {
    enable = lib.mkEnableOption "stylix theming" // {
      default = true;
    };

    wallpaper = lib.mkOption {
      type = lib.types.path;
      description = "Path to the desktop wallpaper.";
    };

    colorScheme = lib.mkOption {
      type = lib.types.either lib.types.str lib.types.attrs;
      default = "kanagawa-dragon";
      description = ''
        Named scheme (kanagawa-dragon | catppuccin-mocha | gruvbox-dark | rose-pine)
        or an inline base16 palette attrset.
      '';
    };

    polarity = lib.mkOption {
      type = lib.types.enum [
        "dark"
        "light"
        "either"
      ];
      default = "dark";
    };

    opacity.popups = lib.mkOption {
      type = lib.types.float;
      default = 0.9;
    };

    cursor = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Bibata-Modern-Ice";
      };
      size = lib.mkOption {
        type = lib.types.int;
        default = 24;
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.bibata-cursors;
      };
    };

    fonts = {
      serif = lib.mkOption {
        type = lib.types.str;
        default = "Noto Serif";
      };
      sansSerif = lib.mkOption {
        type = lib.types.str;
        default = "Noto Sans";
      };
      monospace = lib.mkOption {
        type = lib.types.str;
        default = "JetBrainsMono Nerd Font";
      };
      emoji = lib.mkOption {
        type = lib.types.str;
        default = "Noto Color Emoji";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      image = cfg.wallpaper;
      base16Scheme = resolvedScheme;
      polarity = cfg.polarity;
      opacity.popups = cfg.opacity.popups;

      fonts = {
        serif = {
          name = cfg.fonts.serif;
          package = pkgs.noto-fonts;
        };
        sansSerif = {
          name = cfg.fonts.sansSerif;
          package = pkgs.noto-fonts;
        };
        emoji = {
          name = cfg.fonts.emoji;
          package = pkgs.noto-fonts-color-emoji;
        };
        monospace = {
          name = cfg.fonts.monospace;
          package = pkgs.nerd-fonts.caskaydia-cove;
        };
      };

      cursor = {
        package = cfg.cursor.package;
        name = cfg.cursor.name;
        size = cfg.cursor.size;
      };
    };
  };
}

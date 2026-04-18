{ lib, config, ... }:
{
  programs.rofi = {
    enable = true;
    theme = lib.mkForce (
      let
        inherit (config.lib.formats.rasi) mkLiteral;
        inherit (config.lib.stylix) colors;

        mkRgba =
          opacity: name:
          let
            r = colors."${name}-rgb-r";
            g = colors."${name}-rgb-g";
            b = colors."${name}-rgb-b";
          in
          mkLiteral "rgba ( ${r}, ${g}, ${b}, ${opacity}% )";
        mkRgb = mkRgba "100";

        rofiOpacity = builtins.toString (builtins.ceil (config.stylix.opacity.popups * 100));

        palette = {
          fg = mkRgb "base05";
          bg = mkRgba rofiOpacity "base00";
          accent = mkRgba rofiOpacity "base0D";
          accentText = mkRgb "base01";
          muted = mkRgba rofiOpacity "base02";
        };
      in
      {
        "*" = {
          font = "${config.stylix.fonts.monospace.name} ${toString config.stylix.fonts.sizes.popups}";
          text-color = palette.fg;
          background-color = palette.bg;
        };
        "window" = {
          height = mkLiteral "20em";
          width = mkLiteral "30em";
          border-radius = mkLiteral "4px";
          border-width = mkLiteral "0px";
        };
        "mainbox" = {
          background-color = palette.bg;
        };
        "prompt" = {
          enabled = false;
        };
        "inputbar" = {
          width = "100%";
        };
        "entry" = {
          placeholder = " ";
          text-color = palette.fg;
          background-color = palette.bg;
          padding = mkLiteral "1em 1em";
          border-radius = mkLiteral "2px";
        };
        "element-text" = {
          padding = mkLiteral "1em 1em";
          margin = mkLiteral "0 0.5em";
        };
        "element-text selected" = {
          background-color = palette.accent;
          text-color = palette.accentText;
          border-radius = mkLiteral "2px";
        };
      }
    );
  };
}

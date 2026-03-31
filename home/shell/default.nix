{ pkgs, lib, ... }:
{
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    font.name = "CaskaydiaCove Nerd Font";
    settings = {
      font_size = 12;
      window_padding_width = "8 8 0";
      confirm_os_window_close = -1;
      shell_integration = "enabled";
      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty";
      scrollback_pager = ''nvim --noplugin -c "set signcolumn=no showtabline=0" -c "silent write! /tmp/kitty_scrollback_buffer | te cat /tmp/kitty_scrollback_buffer - "'';
    };
    keybindings = {
      "kitty_mod+h" = "show_scrollback";
      "ctrl+v" = "paste_from_clipboard";
    };
  };

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    shortcut = "a";
    keyMode = "vi";
    extraConfig = lib.mkForce (builtins.readFile ./.tmux.conf);
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = lib.mkForce (pkgs.lib.importTOML ./starship.toml);
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza -l --icons=auto";
      vim = "nvim";
      rebuild = "nh os switch";
    };
    interactiveShellInit = ''
      if test -n "$DISTROBOX_HOST"
        functions -e ls 2>/dev/null
      end
      fish_vi_key_bindings
      set -g fish_greeting

      set -gx NH_FLAKE $HOME/solSys
    '';
    plugins = [
      {
        name = "autopair";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "autopair.fish";
          rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
          hash = "sha256-qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqZJ/oRIT1A=";
        };
      }
      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "8920367cf85eee5218cc25a11e209d46e2591e7a";
          hash = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
        };
      }
      {
        name = "sponge";
        src = pkgs.fetchFromGitHub {
          owner = "meaningful-ooo";
          repo = "sponge";
          rev = "384299545104d5256648cee9d8b117aaa9a6d7be";
          hash = "sha256-MdcZUDRtNJdiyo2l9o5ma7nAX84xEJbGFhAVhK+Zm1w=";
        };
      }
      {
        name = "done";
        src = pkgs.fetchFromGitHub {
          owner = "franciscolourenco";
          repo = "done";
          rev = "eb32ade85c0f2c68cbfcff3036756bbf27a4f366";
          hash = "sha256-DMIRKRAVOn7YEnuAtz4hIxrU93ULxNoQhW6juxCoh4o=";
        };
      }
    ];
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };
}

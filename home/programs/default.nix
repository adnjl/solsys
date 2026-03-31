{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.textfox.homeManagerModules.textfox ];

  programs.bash.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "Aden Lung";
      user.email = "soemscontact@gmail.com";
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
  };

  programs.delta = {
    enableGitIntegration = true;
    enable = true;
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never";
      };
    };
  };

  programs.bat.enable = true;
  programs.ripgrep.enable = true;
  programs.fd.enable = true;

  programs.readline = {
    enable = true;
    extraConfig = "set editing-mode vi";
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "$HOME/solSys";
  };

  programs.gh.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      theme_background = false;
    };
  };

  programs.htop.enable = true;

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    # plugins.mediainfo = pkgs.fetchFromGitHub {
    #   owner = "Ape";
    #   repo = "mediainfo.yazi";
    #   rev = "c69314e80f5b45fe87a0e06a10d064ed54110439";
    #   hash = "sha256-8xdBPdKSiwB7iRU8DJdTHY+BjfR9D3FtyVtDL9tNiy4=";
    # };
    # settings.plugin.prepend_previewers = [
    #   {
    #     mime = "{image,audio,video}/*";
    #     run = "mediainfo";
    #   }
    #   {
    #     mime = "application/x-subrip";
    #     run = "mediainfo";
    #   }
    # ];
    shellWrapperName = "yy";
  };

  stylix.targets.firefox.profileNames = [ "aden" ];
  programs.firefox = {
    enable = true;
    # package = pkgs.firefox-devedition-unwrapped;
    profiles.aden = {
      extensions.force = true;
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        yomitan
        auto-tab-discard
        enhancer-for-youtube
        h264ify
        refined-github
        sidebery
        simple-translate
        stylus
        multi-account-containers
      ];
    };
  };
  textfox = {
    enable = true;
    profiles = [ "aden" ];
    config = {
      # background.color = "#${config.lib.stylix.colors.base00}";
      # border.color = "#${config.lib.stylix.colors.base0D}";
      # font.family = config.stylix.fonts.monospace.name;
      # font.accent = "#${config.lib.stylix.colors.base0D}";
      displayWindowControls = false;
      displayNavButtons = true;
      displaySidebarTools = false;
      tabs.vertical.enable = true;
    };
  };
}

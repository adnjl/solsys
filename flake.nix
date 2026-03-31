{
  description = "solSys";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stablepkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    bleedingpkgs.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable-small.url = "github:nixos/nixpkgs/nixos-unstable-small";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
	flake-parts = {
	  url = "github:hercules-ci/flake-parts";
	  inputs.nixpkgs-lib.follows = "nixpkgs";
	};

	stylix = {
	  url = "github:danth/stylix";
	  inputs.nixpkgs.follows = "nixpkgs";
	  inputs.flake-parts.follows = "flake-parts";
	};

	lanzaboote = {
	  url = "github:nix-community/lanzaboote/v0.4.1";
	  inputs.nixpkgs.follows = "nixpkgs";
	  inputs.flake-parts.follows = "flake-parts";
	};
    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    textfox = {
      url = "github:adriankarlen/textfox";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wallpapers = {
      url = "github:adnjl/wallpapers";
      flake = false;
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      ...
    }:
    let
      lib = import ./lib { inherit inputs nixpkgs; };
    in
    {
      nixosConfigurations = lib.buildNixosHosts {
        hosts = {
          qilin = {
            system = "x86_64-linux";
            user = "aden";
          };
          huodou = {
            system = "aarch64-linux";
            user = "aden";
          };
          fuzhu = {
            system = "x86_64-linux";
            user = "aden";
          };
        };
      };

      darwinConfigurations = lib.buildDarwinHosts {
        hosts = {
          fenghuang = {
            system = "aarch64-darwin";
            user = "soems";
          };
        };
      };
    };
}

{ inputs, nixpkgs }:

let
  inherit (nixpkgs) lib;

  mkSpecialArgs = { system, username }: { inherit inputs system username; } // inputs;

  mkHomeManager =
    { username, specialArgs }:
    {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = specialArgs;
      users.${username} = import ../users/${username}/home.nix;
      sharedModules = [
        inputs.niri.homeModules.niri
      ];
    };

  overlays = import ../pkgs/overlays { inherit inputs; };

in
{
  # == NixOS =================================================================
  # To add a host: hosts.myMachine = { system = "x86_64-linux"; user = "monko"; };
  buildNixosHosts =
    { hosts }:
    lib.mapAttrs (
      hostName: hostCfg:
      let
        username = hostCfg.user;
        system = hostCfg.system;
        specialArgs = mkSpecialArgs { inherit system username; };
      in
      nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ../hosts/${hostName}
          inputs.chaotic.nixosModules.nyx-cache
          inputs.chaotic.nixosModules.nyx-overlay
          inputs.chaotic.nixosModules.nyx-registry
          inputs.nix-ld.nixosModules.nix-ld
          inputs.home-manager.nixosModules.home-manager
          { home-manager = mkHomeManager { inherit username specialArgs; }; }
          { programs.nix-ld.dev.enable = true; }
          { nixpkgs.overlays = [ inputs.nur.overlays.default ] ++ overlays; }
          {
            nix.settings = {
              max-jobs = "auto";
              cores = 0;

              http-connections = 50;
              connect-timeout = 5;

              auto-optimise-store = true;

              substituters = [
                "https://cache.nixos.org"
                "https://cache.chaotic.cx"
                "https://hyprland.cachix.org"
                "https://nix-community.cachix.org"
                "https://niri.cachix.org"
              ];
              trusted-public-keys = [
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
		"cache.chaotic.cx:yoJJQuzZMoW12TO0e66ChJuAo9HJFSCGSvYVBw98fME="
                "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCUSeBo="
                "niri.cachix.org-1:Wv0OmO7PsuocRKzfx7LRyy92urStukFr9YRVy6tiuNI="
              ];
            };
          }
        ];
      }
    ) hosts;

  # == nix-darwin ============================================================
  # To add a host: hosts.myMac = { system = "aarch64-darwin"; user = "monko"; };
  buildDarwinHosts =
    { hosts }:
    lib.mapAttrs (
      hostName: hostCfg:
      let
        username = hostCfg.user;
        system = hostCfg.system;
        specialArgs = mkSpecialArgs { inherit system username; };
      in
      inputs.nix-darwin.lib.darwinSystem {
        inherit specialArgs;
        modules = [
          ../hosts/${hostName}
          inputs.home-manager.darwinModules.home-manager
          { home-manager = mkHomeManager { inherit username specialArgs; }; }
        ];
      }
    ) hosts;
}

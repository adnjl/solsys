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
    };

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
          { nixpkgs.overlays = [ inputs.nur.overlays.default ]; }
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

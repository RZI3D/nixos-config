{
  description = "RZI3D's NixOS Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-dotfiles = {
      url = "github:Xellor-Dev/caelestia-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, caelestia-dotfiles, nix4vscode, ... }@inputs:
    let
      mkSystem = { homeModules }: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/e14-nix/default.nix
          {
            nixpkgs.overlays = [ nix4vscode.overlays.default ];
            nixpkgs.config.allowUnfree = true;
          }
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.zackariyyasattaur = {
              home.username = "zackariyyasattaur";
              home.homeDirectory = "/home/zackariyyasattaur";
              home.stateVersion = "24.11";
              imports = homeModules;
            };
          }
        ];
      };
    in
    {
      nixosConfigurations.caelestia = mkSystem {
        homeModules = [
          ./modules/desktop/caelestia.nix
          inputs.caelestia-dotfiles.homeManagerModules.default
          ./modules/devtools/common.nix
          ./modules/productivity
        ];
      };

      nixosConfigurations.rzi-hypr = mkSystem {
        homeModules = [
          ./modules/desktop/rzi-hypr.nix
          ./modules/devtools/common.nix
        ];
      };
    };
}

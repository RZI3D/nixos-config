{
  description = "RZI3D's NixOS Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs.config.allowUnfree = true;
    };
  };

  outputs = { self, nixpkgs, home-manager, caelestia-shell, ... }@inputs: {
    nixosConfigurations.caelestia = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      ./hosts/e14-nix/default.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; }; 
          home-manager.users.zackariyyasattaur = {
            home.username = "zackariyyasattaur";
            home.homeDirectory = "/home/zackariyyasattaur";
            home.stateVersion = "24.11";
            imports = [
              ./modules/desktop/caelestia.nix
              inputs.caelestia-shell.homeManagerModules.default
              ./modules/devtools/common.nix
            ];
          };
        }
      ];
    };
    nixosConfigurations.rzi-config = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
      ./hosts/e14-nix/default.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.zackariyyasattaur = import ./rzi-hypr.nix;
        }
      ];
    };
  };
}

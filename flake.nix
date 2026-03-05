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
    nix4vscode = { 
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, caelestia-shell, nix4vscode, ... }@inputs: {
    nixosConfigurations.caelestia = nixpkgs.lib.nixosSystem {
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
            imports = [
              ./modules/desktop/caelestia.nix
              inputs.caelestia-shell.homeManagerModules.default
              ./modules/devtools/common.nix
              ./modules/productivity/browsers.nix
            ];
          };
        }
      ];
    };
    nixosConfigurations.rzi-hypr = nixpkgs.lib.nixosSystem {
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
            imports = [
              ./modules/desktop/rzi-hypr.nix
              ./modules/devtools/common.nix
            ];
          };
        }
      ];
    };
  };
}

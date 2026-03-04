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

  outputs = { self, nixpkgs, home-manager, caelestia-shell, ... }: {
    nixosConfigurations.caelestia = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./hosts/e14-nix/default.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.zackariyyasattaur = {
            home.username = "zackariyyasattaur";
            home.homeDirectory = "/home/zackariyyasattaur";
            home.stateVersion = "24.11";
            imports = [
              ./modules/desktop/caelestia.nix
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

{
  description = "RZI3D's NixOS Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # The magic ingredient: end4's logic turned into a Nix module
    illogical-flake = {
      url = "github:soymou/illogical-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, illogical-flake, ... }: {
    nixosConfigurations.end4-config = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./hosts/e14-nix/default.nix
      ({ pkgs, ... }: {
        nixpkgs.overlays = [
          (final: prev: {
            pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
              (python-final: python-prev: {
                kde-material-you-colors = python-final.callPackage ./kde-material-fix.nix { };
              })
            ];
          })
        ];
        })
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.zackariyyasattaur = {
            home.username = "zackariyyasattaur";
            home.homeDirectory = "/home/zackariyyasattaur";
            home.stateVersion = "24.11";
            imports = [
              illogical-flake.homeManagerModules.default
              ./modules/desktop/illogical-impulse.nix
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

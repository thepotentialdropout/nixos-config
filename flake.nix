{
  description = "Nixos config flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-26.05";
    };

    nvf = {
      url = "github:notashelf/nvf";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = {
    home-manager,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # packages

    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/laptop/configuration.nix
          ./nixos-modules
        ];
      };
      pc = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/pc/configuration.nix
          ./nixos-modules
        ];
      };
      server = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          inputs.disko.nixosModules.disko
          ./hosts/server/configuration.nix
          ./hosts/server/hardware-configuration.nix
          #./nixos-modules/server.nix
          ./services
        ];
      };
    };

    homeConfigurations = {
      laptop = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./hosts/laptop/home.nix
          ./home-manager-modules
          inputs.nvf.homeManagerModules.default
        ];
      };
      pc = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./hosts/pc/home.nix
          ./home-manager-modules
          inputs.nvf.homeManagerModules.default
        ];
      };
      server = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./hosts/server/home.nix
          ./home-manager-modules/server.nix
        ];
      };
    };
  };
}

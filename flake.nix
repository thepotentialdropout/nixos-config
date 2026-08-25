{
  description = "Nixos config flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
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

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixarr = {
      url = "github:nix-media-server/nixarr";
    };

  };

  outputs = {
    home-manager,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    vars = import ./vars.nix;
  in {
    # packages

    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          inputs.sops-nix.nixosModules.sops
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
        specialArgs = { inherit vars; };
        modules = [
          inputs.disko.nixosModules.disko
          inputs.nixarr.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          ./hosts/server/configuration.nix
          ./hosts/server/hardware-configuration.nix
          # ./nixos-modules/server.nix
        ];
      };
    };

    homeConfigurations = {
      laptop = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          inputs.sops-nix.homeManagerModules.sops
          ./hosts/laptop/home.nix
          ./home-manager-modules
          inputs.nvf.homeManagerModules.default
          inputs.plasma-manager.homeModules.plasma-manager
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

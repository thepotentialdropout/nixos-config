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

    # kwin-effects-glass flake module
    kwin-effects-glass = {
      url = "github:4v3ngR/kwin-effects-glass";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
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
    };

    homeConfigurations = {
      laptop = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};
        modules = [
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
    };
  };
}

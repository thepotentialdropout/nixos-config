{
  description = "Nixos config flake";

  inputs = {
    nixpkgs = { 
      url = "github:nixos/nixpkgs/nixos-24.11";
    };

    nvf = {
      url = "github:notashelf/nvf";
      };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nvf, ... }@inputs: {
    nixosConfigurations = {

      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/laptop/configuration.nix
          inputs.home-manager.nixosModules.default
	  # ./nixos-modules
        ];
      };
    };

    homeManagerModules.default = ./home-manager-modules;
  };
}

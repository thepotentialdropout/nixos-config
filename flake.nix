{
  description = "Nixos config flake";

  inputs = {
    nixpkgs = { 
      url = "github:nixos/nixpkgs/nixos-25.05";
    };

    nvf = {
      url = "github:notashelf/nvf";
      };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { home-manager, nixpkgs, nvf, ... }@inputs: let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {

    # packages

    homeConfigurations = {

      laptop = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
	
        modules = [
	  ./hosts/laptop/home.nix
	  ./home-manager-modules
	  nvf.homeManagerModules.default
        ];
      };
    };
  };
}

{inputs, ... }: 

{
  home-manager."user" = {
    extraSpecialArgs = { inherit inputs: };
    users = {
      modules = [
        ./home.nix
	inputs.self.outputs.homeManagerModules.default
	];
      };
  };

}

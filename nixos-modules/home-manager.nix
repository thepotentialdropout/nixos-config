{inputs, ... }: 

{
  home-manager."user" = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      modules = [
        ./../hosts/laptop/home.nix
	inputs.self.outputs.homeManagerModules.default
	];
      };
  };

}

{
  pkgs,
  lib,
  ...
}: {
  imports = [
    # ./plasma-manager.nix
    ./git.nix
    ./alacritty.nix
    ./nvf-configuration.nix
    ./shell-aliases.nix
    ./aria2.nix
  ];
}

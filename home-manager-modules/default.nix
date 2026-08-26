{
  pkgs,
  lib,
  ...
}: {
  imports = [
    # ./plasma-manager.nix
    ./git.nix
    ./alacritty.nix
    ./nvf.nix
    ./shell-aliases.nix
    ./aria2.nix
    ./firefox.nix
  ];
}

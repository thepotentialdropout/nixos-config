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
    ./zsh.nix
    ./aria2.nix
    ./firefox.nix
  ];
}

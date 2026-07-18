{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./git.nix
    ./alacritty.nix
    ./nvf-configuration.nix
    ./shell-aliases.nix
  ];
}

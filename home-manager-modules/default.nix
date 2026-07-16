{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./nvf-configuration.nix
    ./shell-aliases.nix
    ./aria2.nix
  ];
}

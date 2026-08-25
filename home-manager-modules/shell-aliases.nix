{
  lib,
  pkgs,
  config,
  ...
}: {
  options.shell-aliases = {
    enable = lib.mkEnableOption "enable shell aliases";
  };

  config = lib.mkIf config.shell-aliases.enable {
    programs.zsh = {
      enable = true;
      shellAliases = {
        rebuildsystem = ''sudo nixos-rebuild switch --flake /home/user/.dotfiles/hosts#laptop'';
        rebuild = ''home-manager switch --flake ~/.dotfiles/#laptop'';
        rebuildsystempc = ''sudo nixos-rebuild switch -I nixos-config=/home/user/.dotfiles/hosts/pc/configuration.nix'';
        rebuildpc = ''home-manager switch --flake ~/.dotfiles/#pc'';
        flup = ''sudo nix flake update'';
        resysserver = ''sudo nixos-rebuild switch --flake /home/user/.dotfiles#server'';
      };
    };
  };
}

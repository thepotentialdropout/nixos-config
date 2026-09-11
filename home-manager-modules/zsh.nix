{
  lib,
  pkgs,
  config,
  ...
}: {
  options.zsh-config = {
    enable = lib.mkEnableOption "enable shell aliases";
  };

  config = lib.mkIf config.zsh-config.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history.size = 10000;

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "dirhistory" "history" ];
      };

      shellAliases = {
        rebuildsystem = "sudo nixos-rebuild switch --flake /home/user/.dotfiles/hosts#laptop";
        rebuild = "home-manager switch --flake ~/.dotfiles/#laptop";
        rebuildsystempc = "sudo nixos-rebuild switch -I nixos-config=/home/user/.dotfiles/hosts/pc/configuration.nix";
        rebuildpc = "home-manager switch --flake ~/.dotfiles/#pc";
        flup = "sudo nix flake update";
        resysserver = "sudo nixos-rebuild switch --flake /home/user/.dotfiles#server";
        ll = "ls -la";
        
        ".." = "cd ./..";
        "..." = "cd ./../..";
        "...." = "cd ./../../..";
      };
    };
  };
}

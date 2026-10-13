{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.zsh-config = {
    enable = lib.mkEnableOption "enable shell aliases";
  };

  config = lib.mkIf config.zsh-config.enable {
    # home.packages = home.packages ++ [
    #   pkgs.any-nix-shell
    # ];
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history.size = 10000;

      initContent = ''
        any-nix-shell zsh --info-right | source /dev/stdin
      '';

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "dirhistory"
          "history"
        ];
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

        # todo: make conditional
        gs = "git status";
        ga = "git add -A";
        gp = "git push github main";

      };
    };
  };
}

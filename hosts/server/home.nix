{ pkgs,
  ... }:
{
  home.enableNixpkgsReleaseCheck = false;
  programs = {
    zellij = {
      enable = true;
      settings = {
        theme = "solarized_dark";
      };
    };
    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "user";
  home.homeDirectory = "/home/user";

  home.stateVersion = "25.05"; # Please read the comment before changing.
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    git
  ];
  programs.home-manager.enable = true;
}

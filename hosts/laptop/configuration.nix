{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.graphics = {
    enable = true;
  };
  

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.kernelPackages = pkgs.linuxPackages_latest;
   
  networking.hostName = "laptop"; 

  networking.networkmanager.enable = true;
  rtwfixes.enable = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  users.users.user = {
    isNormalUser = true;
    description = "user";
    extraGroups = ["networkmanager" "wheel" "dialout"];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };


  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.systemPackages = with pkgs; [
    vim 
    wget
    alacritty
    git
    home-manager
  ];

  nix.settings.experimental-features = ["nix-command flakes"];

  services.openssh.enable = true;

  system.stateVersion = "25.05"; 

}

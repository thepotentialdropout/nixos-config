{
  inputs,
  pkgs,
  ... 
  }:
{
  imports = [
    ./disko-config.nix

  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
    timeout = 10;
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  users.users.user = {
    isNormalUser = true;
    description = "user";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.bash;
  };

  nix.nixPath = [
    "nixpkgs=${pkgs.path}"
  ];

  services = {
    openssh = {
      enable = true;
      # settings = {
      #   PermitRootLogin = "no";
      #   PasswordAuthentication = false;
      # };
      openFirewall = true;
    };
    fstrim.enable = true;
  };

  networking = {
    firewall.enable = true;
    networkmanager.enable = true;
  };

  programs.zsh.enable = true;
  time.timeZone = "Europe/London";

  networking.hostName = "server";

  system.stateVersion = "25.05";
}

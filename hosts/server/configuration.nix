{
  inputs,
  pkgs,
  ... 
  }:
{
  imports = [
    ./disko-config.nix
    ./../../home-manager-modules/git.nix

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

  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  # sops.defaultSopsFile = "/root/.sops/secrets/example.yaml";
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  # This is using an age key that is expected to already be in the filesystem
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = true;

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
    firewall.allowedTCPPorts = [ 80 443 8096 7878 5055 9696 8989 8191 5252 ];
    networkmanager.enable = true;
  };

  programs.vim.enable = true;
  time.timeZone = "Europe/London";

  networking.hostName = "server";

  system.stateVersion = "25.05";
}

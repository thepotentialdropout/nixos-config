{ 
  config,
  vars,
  pkgs,
  ...  }:
{

  sops.secrets = {
    "samba_password" = {
      format = "binary";
      sopsFile = ./../secrets/samba_password.json ;
      };
  };

  # Make the samba user "samba_user" on the system
  users.users.samba_user = {
    description = "Write-access to samba media shares";
    # Add this user to a group with permission to access the expected files 
    extraGroups = [ "users" ];
    # Password can be set in clear text with a literal string or from a file.
    # Using sops-nix we can use the same file so that the system user and samba
    # user share the same credential (if desired).
    hashedPasswordFile = config.sops.secrets."samba_password".path;
    isNormalUser = true;
  };

services.samba = {
  enable = true;
  openFirewall = true;
  settings = {
    global = {
      "workgroup" = "WORKGROUP";
      "server string" = "smbnix";
      "netbios name" = "smbnix";
      "security" = "user";
      #"use sendfile" = "yes";
      #"max protocol" = "smb2";
      # note: localhost is the ipv6 localhost ::1
      "hosts allow" = "192.168.178. 127.0.0.1 localhost";
      "hosts deny" = "0.0.0.0/0";
    };
    "public" = {
      "path" = "/mnt/hdd01/public";
      "browseable" = "yes";
      "read only" = "no";
      "create mask" = "0644";
      "directory mask" = "0755";
      "force user" = "samba_user";
      "force group" = "users";
    };
  };
};

services.samba-wsdd = {
  enable = true;
  openFirewall = true;
};

services.avahi = {
  publish.enable = true;
  publish.userServices = true;
  # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
  nssmdns4 = true;
  # ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
  enable = true;
  openFirewall = true;
};

  # Activation scripts run every time nixos switches build profiles. So if you're
  # pulling the user/samba password from a file then it will be updated during
  # nixos-rebuild. Again, in this example we're using sops-nix with a "samba" entry
  # to avoid cleartext password, but this could be replaced with a static path.
  system.activationScripts = {
    # The "init_smbpasswd" script name is arbitrary, but a useful label for tracking
    # failed scripts in the build output. An absolute path to smbpasswd is necessary
    # as it is not in $PATH in the activation script's environment. The password
    # is repeated twice with newline characters as smbpasswd requires a password
    # confirmation even in non-interactive mode where input is piped in through stdin. 
    init_smbpasswd.text = ''
      /run/current-system/sw/bin/printf "$(/run/current-system/sw/bin/cat ${config.sops.secrets."samba_password".path})\n$(/run/current-system/sw/bin/cat ${config.sops.secrets."samba_password".path})\n" | /run/current-system/sw/bin/smbpasswd -sa samba_user
    '';
  };
}

{ config,
  pkgs,
  ...}:
{
  sops.secrets = {
    "samba_client" = {
      format = "binary";
      sopsFile = ./../secrets/samba_client_secrets.json ;
      };
  };
  # For mount.cifs, required unless domain name resolution is not needed.
  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  environment.systemPackages = [ pkgs.cifs-utils ];
  fileSystems."/mnt/share" = {
    device = "//192.168.178.33/public";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

    in ["${automount_opts},credentials=${config.sops.secrets."samba_client".path}" "nofail" ];
  };
}


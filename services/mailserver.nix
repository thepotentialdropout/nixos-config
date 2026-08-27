{
  config,
  vars,
  pkgs,
  ...
}:
{

  sops.secrets."hashedpasswordfile" = {
    format = "binary";
    sopsFile = ./../secrets/samba_password.json;
  };

  # Allow incoming HTTP connectionsfalse
  networking.firewall.allowedTCPPorts = [ 80 ];

  mailserver = {
    enable = true;
    stateVersion = 5;
    fqdn = vars.domain;
    domains = [ vars.domain ];

    # due to conflicts on port 53
    localDnsResolver = false;

    # Reference the existing ACME configuration created by nginx
    x509.useACMEHost = vars.domain;

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -s'
    accounts = {
      "personal@${vars.domain}" = {
        # Reads the password hash from a file on the server
        hashedPasswordFile = config.sops.secrets."hashedpasswordfile".path;

        # Additional addresses delivered to this mailbox
        aliases = [ "signup@${vars.domain}" ];
      };
      "work@${vars.domain}" = {
        # Provides the password hash inline
        hashedPasswordFile = config.sops.secrets."hashedpasswordfile".path;
      };
    };
  };

    services.roundcube = {
    enable = true;
    hostName = "webmail.${vars.domain}"; # the nginx vhost
    package = pkgs.roundcube.withPlugins (
      plugins: with plugins; [
        # external plugins to be included
        # https://search.nixos.org/packages?query=roundcubePlugins
        persistent_login
      ]
    );
    # activate plugins
    plugins = [
      "persistent_login"
      "managesieve" # built-in
    ];
    dicts = with pkgs.aspellDicts; [
      # https://search.nixos.org/packages?query=aspellDicts
      en
    ];
    maxAttachmentSize = config.mailserver.messageSizeLimit / 1024 / 1024;
    extraConfig = ''
      $config['imap_host'] = "ssl://${config.mailserver.fqdn}";
      $config['smtp_host'] = "ssl://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";

      $config['managesieve_host'] = "tls://${config.mailserver.fqdn}";
      $config['managesieve_port'] = 4190;
      $config['managesieve_usetls'] = true;
    '';
  };

  services.nginx.virtualHosts.${config.services.roundcube.hostName} = {
    enableACME = true;
    forceSSL = true;
  };

}

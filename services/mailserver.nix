{
  config,
  vars,
  ...
}:
{

  sops.secrets."hashedpasswordfile" = {
    format = "binary";
    sopsFile = ./../secrets/samba_password.json;
  };
  # https://letsencrypt.org/repository/#let-s-encrypt-subscriber-agreement
  security.acme.acceptTerms = true;

  # Allow incoming HTTP connectionsfalse
  networking.firewall.allowedTCPPorts = [ 80 ];

  # Enable ACME HTTP-01 challenge with nginx
  services.nginx = {
    enable = true;
    virtualHosts.${config.mailserver.fqdn}.useACMEHost = config.mailserver.fqdn ;
  };

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
}

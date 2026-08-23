{ pkgs,
  config,
  ...}:
{
  sops.secrets."nextcloud-admin-password" = {
    format = "binary";
    sopsFile = ./../secrets/nextcloud-admin-password.json;
  };

        services.nextcloud = {
          enable = true;
          hostName = "nix-nextcloud";
          package = pkgs.nextcloud33;
          database.createLocally = true;
          configureRedis = true;
          maxUploadSize = "16G";
          https = true;
          autoUpdateApps.enable = true;
          extraAppsEnable = true;
          extraApps = with config.services.nextcloud.package.packages.apps; {
            inherit
              calendar
              contacts
              mail
              notes
              tasks
              gpoddersync
              ;
          };

          settings = {
            default_phone_region = "GB";
          };
          config = {
            dbtype = "pgsql";
            adminuser = "admin";
            adminpassFile = config.sops.secrets."nextcloud-admin-password".path;
          };
        };

}


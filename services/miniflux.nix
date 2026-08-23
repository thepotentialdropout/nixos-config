{ pkgs,
  ...}: 
{
  services.miniflux = 
          enable = true;
          adminCredentialsFile = cfg.adminCredentialsFile;
          config = {
            BASE_URL = "https://${cfg.url}";
            CREATE_ADMIN = true;
            LISTEN_ADDR = "${addr}:${toString port}";
            OAUTH2_USER_CREATION = "1";
            DISABLE_LOCAL_AUTH = "true";
          };

}

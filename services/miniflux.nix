{ pkgs,
  config,
  ...}: 
{
  sops.secrets."miniflux-credentials" = {
    format = "binary";
    #todo: miniflux
    sopsFile = ./../secrets;
  };
  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.sops.secrets."miniflux-credentials".path;
    config = {
      BASE_URL = "http://localhost";
      CREATE_ADMIN = true;
      LISTEN_ADDR = "";
      OAUTH2_USER_CREATION = "1";
      DISABLE_LOCAL_AUTH = "true";
    };
  };

}

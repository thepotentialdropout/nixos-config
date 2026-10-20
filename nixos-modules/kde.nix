{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.kde-macos;
in
{
  options.kde-macos = {
    enable = lib.mkEnableOption "enable user module";

  };

  config = lib.mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;

    users.users.user.packages = with pkgs.kdePackages; [
      kate
      plasma-browser-integration
      knights
    ];
    environment.systemPackages = [
      (pkgs.callPackage ./mac-theme.nix { })
    ];
  };
}

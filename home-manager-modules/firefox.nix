{ pkgs,
  inputs,
  config,
  ...}:
{

  programs = {
    firefox = {
      configPath = ".mozilla/firefox";
      enable = true;
      profiles.user = {
        search.engines = {
          "Nix Packages" = {
             urls = [{
               template = "https://search.nixos.org/packages";
               params = [
                 { name = "type"; value = "packages"; }
                 { name = "query"; value = "{searchTerms}"; }
               ];
             }];
             icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
             definedAliases = [ "@np" ];
          };
        };
        search.force = true;

        # userChrome = builtins.readFile ./userchrome.css;

        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          bitwarden
          ublock-origin
          sponsorblock
          darkreader
          tridactyl
          youtube-shorts-block
        ];
      };
    };
  };

  # home.file.".mozilla/firefox/user/chrome" = {
  #   source = "${builtins.fetchGit {
  #     url = "https://github.com/eromatiya/blurredfox";
  #     rev = "6976b5460f47bd28b4dc53bd093012780e6bfed3";
  #   }}";
  #   recursive = true;
  # };

}

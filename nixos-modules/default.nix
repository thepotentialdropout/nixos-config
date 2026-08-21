{
  lib,
  pkgs,
  ...
}: {
  imports = [
    # ./home-manager.nix
    ./main-user.nix
    ./samba_client.nix
  ];
}

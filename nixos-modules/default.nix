{
  lib,
  pkgs,
  ...
}: {
  imports = [
    # ./home-manager.nix
    ./main-user.nix
    ./samba-client.nix
    ./sops.nix
  ];
}

{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./rtwfixes.nix
    ./main-user.nix
    ./samba-client.nix
    ./sops.nix
    ./kde-macos.nix
    ./i3.nix
  ];
}

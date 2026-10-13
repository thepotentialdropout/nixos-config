let 
  pkgs = import <nixpkgs> {};
in 
derivation {
  name = "simple";
  builder = "${pkgs.bash}/bin/bash";
  args = [ ./simple-builder.sh ];
  system = builtins.currentSystem;
  inherit (pkgs) gcc coreutils;
  src = ./simple.c;
}

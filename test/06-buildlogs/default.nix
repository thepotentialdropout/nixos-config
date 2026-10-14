let 
  pkgs = import <nixpkgs> {};
in 
  derivation {
    name = "log-vars";
    builder = "${pkgs.bash}/bin/bash";
    args = [ ./builder.sh ];
    system = builtins.currentSystem;
  }

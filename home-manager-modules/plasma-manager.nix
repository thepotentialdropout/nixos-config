{ inputs,
  pkgs,
  ...
  }:
{
  programs.plasma = {
    enable = true;

    hotkeys.commands."launch-alacritty" = {
      name = "Launch Konsole";
      key = "Meta+Alt+A";
      command = "alacritty";
    };

    fonts = {
      general = {
        family = "JetBrains Mono";
        pointSize = 12;
      };
    };

  };
}

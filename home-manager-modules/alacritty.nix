{
  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 0.97;
      colors = {
        primary.background = "#000316";
        primary.foreground = "#E2D9FF";
      };

      font = {
        size = 11.0;
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
      };
    };
  };
}

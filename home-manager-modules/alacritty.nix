{
  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 0.95;
      colors.primary.background = "#000000";

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

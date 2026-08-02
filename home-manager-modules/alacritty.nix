{
  programs.alacritty = {
    enable = true;
    theme = "solarized_dark";
    settings = {
      window.opacity = 0.87;
      colors = {
        primary.background = "#000316";
        primary.foreground = "#E2D9FF";
      };

      font = {
        size = 11.0;
        normal = {
          family = "Jetbrains mono nerd font";

        };
      };
    };
  };
}

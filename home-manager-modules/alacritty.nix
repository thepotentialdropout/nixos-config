{
  programs.alacritty = {
    enable = true;
    theme = "solarized_dark";
    settings = {
      window.opacity = 0.30;
      colors = {
        primary.background = "#000000";
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

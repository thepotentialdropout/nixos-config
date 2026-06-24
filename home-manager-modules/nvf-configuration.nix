{
  pkgs,
  lib,
  ...
}: {
  programs.nvf = {
    enable = true;
    settings.vim = {
      theme = {
        enable = true;
        name = "oxocarbon";
        style = "dark";
        transparent = true;
      };

      options = {
        tabstop = 2;
        softtabstop = 2;
        shiftwidth = 2;
        expandtab = true;
      };

      statusline.lualine.enable = true;
      telescope.enable = true;
      autocomplete.nvim-cmp.enable = true;
      lsp.enable = true;

      languages = {
        enableTreesitter = true;

        nix.enable = true;
        nix.lsp.enable = true;
        ts.enable = true;
        rust.enable = true;
        arduino.enable = true;
        assembly.enable = true;
        clang.enable = true;
        lua.enable = true;
      };
    };
  };
}

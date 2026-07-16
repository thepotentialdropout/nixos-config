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
        transparent = false;
      };

      options = {
        tabstop = 2;
        softtabstop = 2;
        shiftwidth = 2;
        expandtab = true;
      };

      diagnostics = {
        enable = true;
        config = {
          virtual_lines = false;
          virtual_text = true;
        };
      };

      telescope.enable = true;
      autocomplete.nvim-cmp.enable = true;
      lsp.enable = true;
      filetree.nvimTree.enable = true;
      statusline.lualine.enable = true;

      visuals.nvim-web-devicons.enable = true;
      # utility.oil-nvim = {
      #   enable = true;
      #   setupOpts = lib.mkLuaInline (builtins.readFile ./oil-nvim.lua);
      # };
      #
      languages = {
        enableTreesitter = true;

        nix.enable = true;
        nix.lsp.enable = true;
        typescript.enable = true;
        rust.enable = true;
        arduino.enable = true;
        assembly.enable = true;
        clang.enable = true;
        lua.enable = true;
      };
    };
  };
}

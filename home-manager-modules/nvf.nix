{
  pkgs,
  lib,
  ...
}:
{
  programs.nvf = {
    enable = true;
    defaultEditor = true;
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

      autocomplete.nvim-cmp.enable = true;
      filetree.nvimTree.enable = true;
      statusline.lualine.enable = true;
      formatter.conform-nvim.enable = true;

      lsp = {
        enable = true;
        presets = {
          emmet-ls.enable = true;
        };
      };

      navigation.harpoon = {
        enable = true;
        mappings = { };
      };

      telescope = {
        enable = true;
        extensions = [
          {
            name = "fzf";
            packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
            setup = {
              fzf = {
                fuzzy = true;
              };
            };
          }
        ];
      };

      visuals.nvim-web-devicons.enable = true;
      # utility.oil-nvim = {
      #   enable = true;
      #   setupOpts = lib.mkLuaInline (builtins.readFile ./oil-nvim.lua);
      # };
      #
      languages = {
        enableTreesitter = true;

        html = {
          enable = true;
          lsp.servers = [ "emmet-ls" ];
        };

        nix.enable = true;
        nix.lsp.enable = true;
        typescript.enable = true;
        rust.enable = true;
        arduino.enable = true;
        assembly.enable = true;
        clang.enable = true;
        lua.enable = true;
        css.enable = true;
      };

      keymaps = [
        {
          key = "<leader>m";
          mode = "n";
          silent = true;
          action = ":make<CR>";
        }
        {
          key = "<leader>f";
          mode = "n";
          silent = true;
          action = ":lua vim.lsp.buf.format()<CR>";
        }
      ];
    };
  };
}

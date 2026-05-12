{ pkgs, lib, ...}:
{
  programs.nvf = {
  enable = true;
  settings.vim = {
    theme = {
      enable = true;
      name = "onedark";
      style = "dark";
      transparent = true;
      };
    
    options = {
      tabstop = 3;
      softtabstop = 3;
      shiftwidth = 3;
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


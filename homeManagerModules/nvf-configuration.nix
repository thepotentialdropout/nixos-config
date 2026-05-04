{ pkgs, lib, ...}:
{
  programs.nvf = {
  settings.vim = {
    theme = {
      enable = true;
      mame = "moonfly";
      style = "dark";
      };

    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;

    languages = {
    enableLSP = true;
    enableTreeSitter = true;

    nix.enable = true;
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


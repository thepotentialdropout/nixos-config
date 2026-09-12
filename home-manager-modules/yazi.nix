{ 
  pkgs,
  ... 
  }:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

  };
  #todo: enable alias for yazi here
  
}

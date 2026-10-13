{ 
  pkgs,
  ... 
  }:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

  };
  #todo: enable alias for yazi here
  
}

{ lib, pkgs, config, ... }:
{
  options.rtwfixes.enable = lib.mkEnableOption "enable rtw fixes module";

  config = lib.mkIf config.rtwfixes.enable {
    boot.kernelParams = ["pcie_aspm=off"];
    boot.extraModprobeConfig = ''
      options rtw88_core disable_lps_deep=y
      options rtw88_pci disable_msi=y disable_aspm=y
    '';
    networking.networkmanager.wifi.powersave = false;
  };
}

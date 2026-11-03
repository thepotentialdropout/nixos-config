{
  lib,
  fetchFromGitHub,
  stdenvNoCC, 
  ...}:
stdenvNoCC.mkDerivation {
  pname = "MacTahoe-Kde";
  version = "unstable-2026-08-16";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "MacTahoe-kde";
    rev = "4c0ad8fe730d32c892c84ab0dcf9a104a6fd466d";
    sha256 = "sha256-6saJ9t1KZeIkCwR6ePKSnJxSsba0XRmck8g8/JDuuBE=";
  };

  installPhase  = ''
    runHook preInstall

    mkdir -p $out/share

    cd $src
    cp -r plasma $out/share
    cp -r aurorae $out/share
    cp -r color-schemes $out/share
    cp -r Kvantum/MacTahoe $out/share

    runHook postInstall
    '';

  meta = {
    description = "Port of the MacTahoe-Kde theme for Plasma";
    homepage = "https://github.com/vinceliuice/MacTahoe-kde";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;

  };
}

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
	  wineWow64Packages.stagingFull
	  wineWow64Packages.fonts
	  winetricks
    
    q4wine
    icoutils

    yabridge
  ];
}
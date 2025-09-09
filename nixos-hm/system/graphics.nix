{ config, pkgs, ... }:
{
  hardware.graphics.enable = true;
  
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
  };
}

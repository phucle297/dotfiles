{ config, pkgs, ... }:
{
  programs.fish = {
    enable = true;
    # Add fish-specific configuration here
    shellInit = ''
      # Fish shell initialization
      set -x EDITOR nvim
    '';
  };
}

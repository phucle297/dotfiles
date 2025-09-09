
{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    # Add your git configuration here
    # userName = "Your Name";
    # userEmail = "your.email@example.com";
  };
}

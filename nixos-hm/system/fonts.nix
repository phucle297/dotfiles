{ config, pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    dejavu_fonts
    fira-code
    fira-code-symbols
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];
}

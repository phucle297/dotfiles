{ config, pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./neovim.nix
    # Add more program configs as needed
  ];
}

{ inputs, config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./networking.nix
    ./locale.nix
    ./users.nix
    ./services.nix
    ./fonts.nix
    ./graphics.nix
    ./security.nix
    # ./vpn.nix
  ];

  system.stateVersion = "25.11";
  nixpkgs.config.allowUnfree = true;

  # Enable flake + nix-command
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = ["https://hyprland.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    ssl-cert-file = "/ca.crt";
  };
}

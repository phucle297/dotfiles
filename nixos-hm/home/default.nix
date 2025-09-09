{ inputs, config, pkgs, ... }:
{
  imports = [
    ./programs
    ./services
  ];

  home = {
    username = "permees";
    homeDirectory = "/home/permees";
    stateVersion = "25.11";
  };

  # User packages
  home.packages = with pkgs; [
    # Development tools
    git
    ghq
    python314
    gccgo14
    nodejs_22
    pnpm
    yarn
    docker
    docker-compose
    docker-buildx
    typos
    
    # Editors and terminals
    vim
    kitty
    
    # Browsers
    firefox
    inputs.zen-browser.packages.${pkgs.system}.default
    
    # Communication
    teams-for-linux
    slack
    
    # System utilities
    fzf
    wl-clipboard
    zip
    unzip
    ripgrep
    tree
    which
    oh-my-fish
    brightnessctl
    light
    
    # Wayland/Hyprland tools
    rofi-wayland
    waybar
    swww
    swaylock
    wlogout
    swaynotificationcenter
    hyprlock
    
    # Media
    # flameshot
    playerctl
    
    # Audio
    alsa-utils
    pavucontrol
    
    # Bluetooth
    blueman
    
    # Other
    vale


    xdg-desktop-portal
    xdg-desktop-portal-wlr
    slurp
    grim
  ];

  programs.home-manager.enable = true;
}


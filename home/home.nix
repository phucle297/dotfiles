{ config, pkgs, inputs, username, ... }:

{
  imports = [
    ./programs
    ./services
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  # Packages
  home.packages = with pkgs; [
    # Terminal and shell
    kitty
    fish
    starship
    eza  # better ls
    bat  # better cat
    fzf  # fuzzy finder
    ripgrep  # better grep
    
    # Wayland utilities
    waybar
    rofi-wayland
    swww # wallpaper
    hyprpaper # alternative wallpaper
    grim # screenshots
    slurp # area selection
    wl-clipboard
    brightnessctl
    pamixer # audio control
    
    # Development
    neovim
    git
    gcc
    nodejs
    python3
    cargo
    rustc
    
    # Media
    mpv
    imv
    pavucontrol
    
    # Utils
    file-roller
    nautilus
    firefox
    tree
    htop
    unzip
    curl
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "phucle297";  # Replace with your name
    userEmail = "somdp2907@gmail.com";  # Replace with your email
  };

  # Fish shell configuration
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
}

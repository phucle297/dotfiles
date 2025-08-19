{ config, ... }:

{
  # Copy all your existing dotfiles
  home.file = {
    # Hyprland config
    ".config/hypr" = {
      source = ../../hypr;
      recursive = true;
    };
    
    # Neovim config
    ".config/nvim" = {
      source = ../../nvim;
      recursive = true;
    };
    
    # Kitty config  
    ".config/kitty" = {
      source = ../../kitty;
      recursive = true;
    };
    
    # Waybar config
    ".config/waybar" = {
      source = ../../waybar;
      recursive = true;
    };
    
#    # Rofi config
#    ".config/rofi" = {
#      source = ../../rofi;
#      recursive = true;
#    };
    
    # Add other configs as needed
    # ".config/other-app" = {
    #   source = ../../other-app;
    #   recursive = true;
    # };
  };
}

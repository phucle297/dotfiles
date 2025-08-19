First, let's install git temporarily to get started:
```bash
# Install git temporarily (this will be managed by Nix later)
sudo nix-env -iA nixos.git

# Or if that doesn't work, try:
nix-shell -p git
```

Step 2: Clone Your Dotfiles Repository
```bash
# Navigate to your home directory
cd ~

# Clone your dotfiles repository
git clone https://github.com/phucle297/dotfiles.git

# Enter the dotfiles directory
cd dotfiles
```
Step 3: Create the Nix Configuration Structure
```
nano flake.nix
```

```
{
  description = "Personal NixOS configuration with dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs: 
  let
    system = "x86_64-linux";
    hostname = "your-hostname";  # Replace with your actual hostname
    username = "your-username";  # Replace with your actual username
  in
  {
    # NixOS configuration
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs username hostname; };
      modules = [
        ./nixos/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = import ./home/home.nix;
          home-manager.extraSpecialArgs = { inherit inputs username; };
        }
      ];
    };

    # Standalone home-manager configuration
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = { inherit inputs username; };
      modules = [
        ./home/home.nix
      ];
    };
  };
}

```

```
# Get your hostname
hostname

# Get your username
whoami
```

```
# Create necessary directories
mkdir -p nixos
mkdir -p home/programs
mkdir -p home/services
```

```
nano nixos/configuration.nix
```

```
{ config, pkgs, inputs, username, hostname, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  # Time zone and locale
  time.timeZone = "Asia/Ho_Chi_Minh";  # Adjust for Vietnam, change if needed
  i18n.defaultLocale = "en_US.UTF-8";

  # Desktop Environment - Keep GNOME but allow Hyprland
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Hyprland support
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # XDG portal for screen sharing, etc.
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

  # Audio
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Brightness control
  programs.light.enable = true;
  
  # Enable GNOME services to keep touchbar, volume, etc.
  services.gnome = {
    core-utilities.enable = true;
    gnome-keyring.enable = true;
  };

  # User account
  users.users.${username} = {
    isNormalUser = true;
    description = "Your Name";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    shell = pkgs.fish;
  };

  # Enable fish shell
  programs.fish.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    firefox
    home-manager
    kitty
  ];

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "CascadiaCode" ]; })
  ];

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Allow unfree packages (for some proprietary software if needed)
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11";
}
```

Generate hardware configuration

```
# Generate hardware configuration
sudo nixos-generate-config --show-hardware-config > nixos/hardware-configuration.nix
```
 
create home/home.nix
```
nano home/home.nix
```


```
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
    userEmail = "your.email@example.com";  # Replace with your email
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
```

```
nano home/programs/default.nix
```

```
{ ... }:

{
  imports = [
    ./dotfiles.nix
  ];
}
```

```
nano home/programs/dotfiles.nix
```

```
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
    
    # Rofi config
    ".config/rofi" = {
      source = ../../rofi;
      recursive = true;
    };
    
    # Add other configs as needed
    # ".config/other-app" = {
    #   source = ../../other-app;
    #   recursive = true;
    # };
  };
}
```

```
nano home/services/default.nix
```

```
{ ... }:

{
  # Add any services you need
  services.dunst.enable = true; # notifications for Hyprland
}
```

```
# Initialize the flake (this will create flake.lock)
nix flake update
```


```
# Check your current hostname
hostname

# Check if the flake builds correctly (replace with your actual hostname)
nix build .#nixosConfigurations.your-hostname.config.system.build.toplevel
```

```
# Apply the NixOS configuration (replace with your actual hostname)
sudo nixos-rebuild switch --flake .#your-hostname
```

Troubleshooting
```
# Check flake syntax
nix flake check

# Build without applying
nix build .#nixosConfigurations.your-hostname.config.system.build.toplevel

# View logs
journalctl -b
```

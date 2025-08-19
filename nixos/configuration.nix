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
  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "vi_VN";
      LC_IDENTIFICATION = "vi_VN";
      LC_MEASUREMENT = "vi_VN";
      LC_MONETARY = "vi_VN";
      LC_NAME = "vi_VN";
      LC_NUMERIC = "vi_VN";
      LC_PAPER = "vi_VN";
      LC_TELEPHONE = "vi_VN";
      LC_TIME = "vi_VN";
    };
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "vi_VN/UTF-8"
    ];
  };

  # Desktop Environment - Keep GNOME but allow Hyprland
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Hyprland support
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    # Let Hyprland manage its own portal
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  # XDG portal - FIXED configuration to avoid conflicts
  xdg.portal = {
    enable = true;
    wlr.enable = false; # Disable wlr portal to avoid conflicts
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    # Configure which portal to use for which desktop
    config = {
      common = {
        default = [ "gtk" ];
      };
      hyprland = {
        default = [ "hyprland" "gtk" ];
      };
      gnome = {
        default = [ "gnome" "gtk" ];
      };
    };
  };

  # Audio
  services.pulseaudio.enable = false;
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
    core-apps.enable = true;
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

  # Fonts (minimal version to avoid issues)
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
  ];

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11";
}

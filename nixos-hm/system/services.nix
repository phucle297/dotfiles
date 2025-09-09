{ inputs, config, pkgs, ... }:
let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    themeConfig = {
      FormPosition = "left";
      ForceHideCompletePassword = true;
    };
    embeddedTheme = "pixel_sakura_static";
  };
in
{
  # Hyprland
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # System services
  services = {
    openssh.enable = true;
    
    # Power management
    tlp.enable = true;
    acpid.enable = true;
    
    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    
    # Bluetooth
    blueman.enable = true;
    
    # Input devices
    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = true;
        disableWhileTyping = true;
      };
    };

    # Display Manager
    displayManager = {
      gdm.enable = false;
      sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
        extraPackages = [ sddm-astronaut ];
        theme = "sddm-astronaut-theme";
      };
    };

    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
      xkb.layout = "us";
    };
  };

  # Hardware
  hardware.bluetooth.enable = true;
  programs.light.enable = true;

  # System packages that should stay system-wide
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    iw
    wirelesstools
    brightnessctl
    light
    tlp
    powertop
    acpid
    udiskie
    polkit
    gnome-keyring
    tuigreet
    sddm-astronaut
  ];

  programs.nix-ld.enable = true;
}

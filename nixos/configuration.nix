{inputs, config, pkgs,...}:
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
  security.pki.certificates = [
  "
-----BEGIN CERTIFICATE-----
MIIC1zCCAb+gAwIBAgIUTZHaYNQ5q3SYMiycpX4ec2huf0IwDQYJKoZIhvcNAQEL
BQAwFjEUMBIGA1UEAwwLdm5fc3NsX2NlcnQwHhcNMjUwMTE2MDE1ODE4WhcNMzUw
MTE0MDE1ODE4WjAWMRQwEgYDVQQDDAt2bl9zc2xfY2VydDCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBANEofx0E0ghlEUNR8R7zt9mFi8+wctPoNH7xY0zw
CIaMu3eSQbzZ1vKNnTSeqU3J+syRT9y9TkG700HNtyy0zDPUOlGSopuucnroR41Y
jI/+p4wHAvVBS7mEKHTE6noPbS9Bq7z01u/JS5nxQpAXw4IJxMog/swDDrATcUsx
ywLNHEZWrvjw/pEJnyxBVss13Uc1ZpupGxrLRFG7JMUmBdD8z07pr1Iq4QReIAw4
kf46tE0OYr4e8LkXXorDDNB4TLiDSi/EauClSYhAWIFE2QYLoyENUyAlQ8HYTSTV
kQ6P657SUC7xX2rxVMjd98B7laFeeA+FoSa2XnLXn6+bA5sCAwEAAaMdMBswDAYD
VR0TBAUwAwEB/zALBgNVHQ8EBAMCAgQwDQYJKoZIhvcNAQELBQADggEBAIZtMr6J
QkRRmtN4dkfnn6to4p6cWl3DaCd4cJb59HJ+PusxfpPxh2wHUVBEpNPJNkkQjfBA
LR5bp5uVOfMOO5vDahzsYo78rqHLheioFGU3nGVa6cy38pe9y5K51Pe4co4tIpkh
YV11ajuMv/io60aKvjZQGgy4lNOG+BCCuaJzjUzNuRs9LDXVWUN+lCmXke4YfLxr
z6OCAwS86C5R6HQl8uEAfH7RC1lzDpvoIrB2i7pBrnC16ZTkpOC3GdkYxtY0K7Z3
tJOaXrzDfJXKLQ72rxVOmMOqhvHcM+bXLwMFou2kn7GLz2wQnZmFm1mCRepW+XXX
r0CBMBOHpwxXIjw=
-----END CERTIFICATE-----
  "
  ];
	imports = [./hardware-configuration.nix];
	system.stateVersion = "25.11";

  	nixpkgs.config.allowUnfree = true;
	#Bootloader
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	
	#Networking
	networking.networkmanager.enable = true;
	
	#Time + locale
	time.timeZone = "Asia/Ho_Chi_Minh";
	i18n.defaultLocale = "en_US.UTF-8";
	i18n.inputMethod = {
	 enable = true;
	 type = "fcitx5";
	 fcitx5.addons = with pkgs; [
	   fcitx5-gtk
	   fcitx5-configtool
	   kdePackages.fcitx5-qt
	   kdePackages.fcitx5-unikey
	 ];
	};

	#User
	users.users.permees = {
		isNormalUser = true;
		extraGroups = [ "wheel" "networkmanager" ];
		shell = pkgs.fish;
	};
	
	#Enable fish globally
	programs.fish.enable = true;
	programs.hyprland = {
		enable = true;
		package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
		portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
	};
	
	environment.systemPackages = with pkgs; [
		git ghq
		python314 gccgo14 nodejs_22
    pnpm
    yarn
		fish vim neovim kitty 
		firefox
		vale
		networkmanagerapplet
		iw wirelesstools
		brightnessctl light
		tlp powertop acpid
		pipewire wireplumber alsa-utils pavucontrol pulseaudio
		blueman bluez kdePackages.bluez-qt
		fzf
		rofi-wayland waybar swww swaylock 
		teams-for-linux
		slack
		wlogout
		udiskie polkit gnome-keyring
		_1password-gui
		wl-clipboard
		swaynotificationcenter
		flameshot
		playerctl
		hyprlock
		zip
		unzip
		ripgrep
		tree
		which
    oh-my-fish
    typos
    docker
    docker-compose
    docker-buildx
    tuigreet
    sddm-astronaut
	];

  programs.nix-ld.enable = true;

	#Services
	services.openssh.enable = true;
	#Power management
	services.tlp.enable = true;
	services.acpid.enable = true;
	#Audio
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		pulse.enable = true;
		jack.enable = true;
	};
	#Bluetooth
	services.blueman.enable = true;
	hardware.bluetooth.enable = true;
	# hardware.firmware = [ pkgs.linux-firmware ];
	#Display and Brightness
	programs.light.enable = true;
	#Input devices
	services.libinput = {
		enable = true;
		touchpad.tapping = true;
		touchpad.naturalScrolling = true;
		touchpad.disableWhileTyping = true;
	};
	#Fonts
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
	services.displayManager = {
    gdm.enable = false;
    sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
      extraPackages = [ sddm-astronaut ];
      theme = "sddm-astronaut-theme";
    };
  };
  services.xserver.enable = true;
  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
  };
	#Enable flake + nix-command
	nix.settings = {
		experimental-features = [ "nix-command" "flakes" ];
		substituters = ["https://hyprland.cachix.org"];
		trusted-substituters = ["https://hyprland.cachix.org"];
		trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
	};
}

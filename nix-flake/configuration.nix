{inputs, config, pkgs,...}:

{
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
		nodejs python314 gccgo14
		fish vim neovim kitty 
		firefox
		vale
		networkmanagerapplet
		iw wirelesstools
		brightnessctl light
		tlp powertop acpid
		pipewire wireplumber alsa-utils pavucontrol pulseaudio
		blueman bluez libsForQt5.bluez-qt
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
	];

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

	#Keyboard
	services.xserver.xkb = {
	  layout = "us";
	  variant = "";
	};
	# Keymap
	console.keyMap = "us";

	
	#Enable flake + nix-command
	nix.settings = {
		experimental-features = [ "nix-command" "flakes" ];
		substituters = ["https://hyprland.cachix.org"];
		trusted-substituters = ["https://hyprland.cachix.org"];
		trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
	};
}

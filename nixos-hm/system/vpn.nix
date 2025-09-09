{ config, pkgs, ... }:

let
  # Create FHS environment for PulseSecure
  pulsesecure-fhs = pkgs.buildFHSEnv {
    name = "pulsesecure-env";
    targetPkgs = pkgs: with pkgs; [
      # SSL/TLS libraries (critical for VPN functionality)
      openssl_1_1  # Many VPN clients require older OpenSSL
      openssl      # Current version as fallback
      
      # Core system libraries
      glibc
      stdenv.cc.cc.lib
      zlib
      libxml2
      libxslt
      
      # Network libraries
      curl
      wget
      
      # GUI libraries (if PulseSecure has a GUI)
      gtk3
      gtk2
      glib
      cairo
      pango
      atk
      gdk-pixbuf
      
      # X11 libraries
      xorg.libX11
      xorg.libXext
      xorg.libXrender
      xorg.libXtst
      xorg.libXi
      
      # Font libraries
      fontconfig
      freetype
      
      # Audio (sometimes needed for notifications)
      alsa-lib
      
      # Other common dependencies
      dbus
      udev
      systemd
      
      # Development tools (sometimes needed)
      gcc
      binutils
      
      # Python (some VPN clients use Python scripts)
      python3
      
      # Java (some enterprise VPN tools require it)
      openjdk8
      
      # Network tools
      iproute2
      iptables
      nettools
      
      # File system tools
      util-linux
      coreutils
      findutils
      gnugrep
      gnused
      gawk
      bash
    ];
    
    multiPkgs = pkgs: with pkgs; [
      # 32-bit compatibility libraries
      openssl_1_1
    ];
    
    # Set up the environment
    profile = ''
      # Set up SSL certificates
      export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      export CURL_CA_BUNDLE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      
      # Set up library paths
      export LD_LIBRARY_PATH="/usr/lib:/usr/lib32:/lib:/lib32:$LD_LIBRARY_PATH"
      
      # Add your custom CA certificate if needed
      if [ -f "/ca.crt" ]; then
        export SSL_CERT_FILE="/ca.crt:$SSL_CERT_FILE"
      fi
      
      echo "PulseSecure FHS environment loaded"
      echo "SSL_CERT_FILE: $SSL_CERT_FILE"
    '';
    
    runScript = "bash";
  };

in
{
  # Add the FHS environment to system packages
  environment.systemPackages = [ pulsesecure-fhs ];
  
  # Enable necessary kernel modules for VPN
  boot.kernelModules = [ "tun" ];
  
  # Network configuration for VPN
  networking.firewall = {
    # Allow VPN traffic (adjust ports as needed)
    allowedTCPPorts = [ 443 4433 ];
    allowedUDPPorts = [ 4500 500 ];
  };
  
  # Ensure TUN/TAP devices are available with proper permissions
  services.udev.extraRules = ''
    KERNEL=="tun", GROUP="networkmanager", MODE="0660", OPTIONS+="static_node=net/tun"
    KERNEL=="tap*", GROUP="networkmanager", MODE="0660"
  '';
}

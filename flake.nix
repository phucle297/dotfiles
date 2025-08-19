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
    hostname = "nixos";  # Your actual hostname
    username = "permees";  # Your actual username
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

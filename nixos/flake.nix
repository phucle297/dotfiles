{
	description = "My Nixos config";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		hyprland.url = "github:hyprwm/Hyprland";
	};

	outputs = { nixpkgs,... } @ inputs:
		{
			nixosConfigurations.permees = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit inputs; };
				modules = [ ./configuration.nix ];
			};	
		};
}

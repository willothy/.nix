{
  description = "Willothy's Main Nix Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { 
		self, 
		nixpkgs, 
		home-manager,
		... 
	}: let 
    system = "x86_64-linux";

		pkgs = import nixpkgs {
			inherit system;

			config = {
				allowUnfree = true;
			};
		};
  in {

    nixosConfigurations = {
      nostromo = nixpkgs.lib.nixosSystem {
				specialArgs = {
					inherit system;
				};

        modules = [
          ./configuration.nix
          ./services/xserver.nix
        ];
      };
    };

    homeConfigurations = {
      willothy = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./home.nix
        ];
      };
    };

  };
}

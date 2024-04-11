{
  description = "Willothy's Main Nix Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
		self,
		nixpkgs,
		home-manager,
		...
	}@inputs: let
    system = "x86_64-linux";

		pkgs = import nixpkgs {
			inherit system;

      overlays = [
        inputs.neovim-nightly-overlay.overlay
      ];

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
          ./services/1password.nix
        ];
      };
    };

    homeConfigurations = {
      willothy = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        #configuration.nixpkgs.overlays = overlays;

        modules = [
          ./home.nix
        ];
      };
    };

  };
}

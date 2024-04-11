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
    system = {
      system = "x86_64-linux";
      hostname = "nostromo";
      timezone = "America/Los_Angeles";
      locale = "en_US.UTF-8";
    };

    user = rec {
      username = "willothy";
      name = "Will Hopkins";
      email = "willothyh@gmail.com";
      dotfilesDir = "~/.dotfiles/";
      wm = "awesome";
      wmType = "x11";
      browser = "brave";
      editor = "nvim";
      editorVisual = "nvim -b";
      terminal = "wezterm";
      # Public key, obviously
      sshSigningKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuB3Fm5F9/qUWn2Ok7EXZc8OkKmvy6AHI+Wit0+XDiV";

      homeDir = "/home/${username}";
    };

		pkgs = import nixpkgs {
			inherit (system) system;

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
          inherit user;
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

        extraSpecialArgs = {
          inherit system;
          inherit user;
        };

        modules = [
          ./home.nix
        ];
      };
    };

  };
}

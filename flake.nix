{
  description = "MacOS Nix Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    _1password-shell-plugins.url = "github:1Password/shell-plugins";

    #neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, home-manager, darwin, flake-utils, ... }@inputs: {
    packages = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;

          overlays = [
            #inputs.neovim-nightly-overlay.overlays.default
            (import ./overlays/spider-cli.nix)
            (import ./overlays/bufbuild.nix)
          ];
        };


        globalConfig = {
          system.configurationRevision = self.rev or self.dirtyRev or null;
        };

        globalUserInfo = rec {
          userName = "willothy";
          fullName = "Will Hopkins";
          email = "willothyh@gmail.com";
          homeDir =
            if (system == "aarch64-darwin") then
              "/Users/${userName}"
            else
              "/home/${userName}";
          confDir = "~/.dotfiles";
          editor = "nvim";
          editorVisual = "nvim -b";
          pager = "delta";
          terminal = "wezterm";
          browser = "brave";
          # Public key, obviously
          sshSigningKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuB3Fm5F9/qUWn2Ok7EXZc8OkKmvy6AHI+Wit0+XDiV";
        };

        flakeContext = {
          inherit inputs;
          inherit globalUserInfo;
        };
      in
      {
        darwinConfigurations = {
          macbonk = darwin.lib.darwinSystem {
            inherit system pkgs;

            specialArgs = flakeContext;

            modules = [
              globalConfig
              ./hosts/macos
              ./system/macos
              ./system/shared
            ];
          };
        };

        nixosConfigurations = {
          nostromo = {
            inherit system pkgs;

            specialArgs = flakeContext;

            modules = [
              globalConfig
              ./hosts/nixos
              ./system/nixos
              ./system/shared
            ];
          };
        };

        homeConfigurations = {
          willothy = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            extraSpecialArgs = flakeContext;

            modules = [
              ./user/shared
            ] ++ (if (system == "aarch64-darwin") then
              [ ./user/macos ]
            else
              [ ./user/nixos ]
            );
          };
        };
      });
  };
}

{
  description = "Willothy's Main Nix Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    picom-flake = {
      # url = "github:yshui/picom/next";
      url = "github:FT-Labs/picom";
    };
    apple-fonts-flake.url = "github:Lyndeno/apple-fonts.nix";
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs =
    { self, nixpkgs, home-manager, nixgl, ... }@inputs:
    let
      system = {
        system = "x86_64-linux";
        hostname = "nostromo";
        timezone = "America/Los_Angeles";
        locale = "en_US.UTF-8";
        configsDir = ./configs;
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
        pager = "delta";
        terminal = "wezterm";
        # Public key, obviously
        sshSigningKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuB3Fm5F9/qUWn2Ok7EXZc8OkKmvy6AHI+Wit0+XDiV";

        homeDir = "/home/${username}";
      };

      overlays =
        [
          (import ./overlays/awesome-git.nix)
          (import ./overlays/spider_cli.nix)
          inputs.picom-flake.overlay."${system.system}"
          (final: prev: {
            apple-fonts = inputs.apple-fonts-flake.packages."${system.system}";
          })
          nixgl.overlay
          inputs.neovim-nightly-overlay.overlays.default
        ];

      pkgs = import nixpkgs {
        inherit (system) system;

        overlays = overlays;

        config = {
          allowUnfree = true;
        };
      };

    in
    {

      nixosConfigurations = {
        nostromo = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit pkgs;
            inherit system;
            inherit user;
            # apple-fonts = inputs.apple-fonts-flake.packages."${system.system}";
          };

          modules = [
            ./boot/refind
            ./system/configuration.nix
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
            ./user/home.nix
          ];
        };
      };

    };
}

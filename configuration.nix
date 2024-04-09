# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }: let
  hostName = "nostromo";
  userName = "willothy";
  timeZone = "America/Los_Angeles";
in {
  imports = [ 
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ 
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  boot.loader = {
    # Default: Use the systemd-boot EFI boot loader.
    systemd-boot.enable = true;

    # grub = {
    #   enable = true;
    #   useOSProber = true;
    #   default = "saved";
    #
    #   efiSupport = true;
    #   # "nodev" is needed for UEFI too I guess
    #   device = "nodev";
    # };

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };

    nvidia = {
      modesetting.enable = true;

      powerManagement.finegrained = false;

      open = false;

      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  security.polkit.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;

  networking = {
    inherit hostName;

    networkmanager.enable = true;
  };

  # Set locale and timezone
  i18n.defaultLocale = "en_US.UTF-8";
  time = {
    inherit timeZone;
    # Fixes desync between Windows and Linux time tracking.
    hardwareClockInLocalTime = true;
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    #useXkbConfig = true; # use xkb.options in tty.
  };

  users = {
    defaultUserShell = pkgs.zsh;

    users.willothy = {
      isNormalUser = true;
      initialPassword = "letmein";	
      extraGroups = [ 
        "networkmanager" 
        "audio"
        "wheel" 
      ];
      packages = with pkgs; [
        brave
        gnome.nautilus
        wezterm
        discord
        pavucontrol
      ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      # system essentials
      wget
      btrfs-progs
      bluez
      bluez-tools
      xdg-utils
      pipewire
      wireplumber

      # CLI tools I want globally available
      bottom
      jq
      ripgrep
      fd
      hexyl
    ];

    # Globally set editor to nvim
    variables.EDITOR = "nvim";

    shells = with pkgs; [
      zsh
    ];
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  }; 

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      # Temporary config for initial nixos setup
      customRC = ''
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set scrolloff=10
      '';
    };
  };

  programs.seahorse.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ userName ];
  };
  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        brave
      '';
      mode = "0755";
    };
    #"X11/xorg.conf".source = ./xorg.conf;
  };

  programs.zsh.enable = true;
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
    };
    prompt.enable = true;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}


{ config, lib, pkgs, user, system, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./programs
    ./services
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
    # systemd-boot.enable = true;
    systemd-boot.enable = lib.mkForce false;

    refind = {
      enable = true;
      extraConfig = ''
        resolution 0
        dont_scan_dirs NIX-BOOT:/EFI/nixos
        hideui banner,editor
        showtools shutdown reboot firmware
        use_graphics_for linux,windows
        include themes/refind-theme-regular/theme.conf
      '';
    };

    grub.enable = lib.mkForce false;
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

  networking = {
    hostName = system.hostname;

    networkmanager.enable = true;
  };

  # Set locale and timezone
  i18n.defaultLocale = system.locale;
  time = {
    timeZone = system.timezone;
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

    users."${user.username}" = {
      name = user.username;
      description = user.name;
      createHome = true;
      openssh.authorizedKeys.keys = [
        "${user.sshSigningKey}"
      ];
      extraGroups = [
        "networkmanager"
        "audio"
        "video"
        "wheel"
      ];
      initialPassword = "letmein";
      isNormalUser = true;
      packages = with pkgs; [
        brave
        gnome.nautilus
        discord
      ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      # system essentials
      wget
      btrfs-progs
      unzip

      # UX essentials
      polkit_gnome
      volctl
      xsel

      # CLI tools I want globally available
      bottom
      jq
      ripgrep
      fd
      hexyl
      fzf

      # Build tools
      gnumake
      cmake

      # Libraries
      sqlite

      # Language-specific packages
      nodejs_21
      python312
      rustup
      gcc
      luajit
    ];

    # Globally set editor to nvim
    variables.EDITOR = "nvim";

    shells = with pkgs; [
      zsh
    ];
  };

  # Auto defrag disk
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    # Handles nested subvolumes automatically
    fileSystems = [ "/" ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      # Basic global config for initial nixos setup
      # and editing as root.
      customRC = ''
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set scrolloff=10
      '';
    };
  };

  programs.ssh = {
    startAgent = false;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;

  security = {
    pam.services.lightdm.enableGnomeKeyring = true;
    polkit.enable = true;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  programs.zsh.enable = true;
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
    };
    prompt.enable = true;
  };

  # Global font config
  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "FiraMono"
      ];
    })
    maple-mono-NF
  ];
  fonts.fontDir.enable = true;
  fonts.fontconfig.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}


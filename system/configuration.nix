{ config, pkgs, user, system, ... }:
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

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  # nixgl.auto = {
  #   nixGLDefault = true;
  #   nixGLNvidia = true;
  #   nixVulkanNvidia = true;
  # };

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

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };
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
      shell = pkgs.fish;
      createHome = true;
      openssh.authorizedKeys.keys = [
        "${user.sshSigningKey}"
      ];
      extraGroups = [
        "networkmanager"
        "audio"
        "video"
        "wheel"
        "docker"
      ];
      initialPassword = "letmein";
      isNormalUser = true;
    };
  };

  environment = {
    shells = with pkgs; [
      zsh
    ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  programs.ssh = {
    startAgent = false;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  programs.fish.enable = true;
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


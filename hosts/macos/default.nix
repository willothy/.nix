{ config, pkgs, globalUserInfo, ... }: {
  nix = {
    gc = {
      user = "root";
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
    package = pkgs.nix;
  };
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "aarch64-darwin";
  };
  services.nix-daemon.enable = true;

  system.stateVersion = 4;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  system.defaults = {
    finder.AppleShowAllExtensions = true;
    dock.autohide = true;
  };

  environment.systemPath = [ "/opt/homebrew/bin" ];
  environment.pathsToLink = [ "/Applications" ];

  homebrew = {
    enable = true; 
    caskArgs.no_quarantine = true;
    global.brewfile = true;

    masApps = { };
    casks = [ 
      "1password"
    ];
    taps = [ ];
    brews = [ ];
  };
}

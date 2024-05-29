{ config, pkgs, globalUserInfo, ... }: {
  config.environment.systemPath = [ 
    "/opt/homebrew/bin"
  ];

  config.homebrew = {
    enable = true; 
    caskArgs.no_quarantine = true;
    global.brewfile = true;

    masApps = { };
    casks = [ 
      "1password"
      "amethyst"
      "insomnia"
      "warp"
    ];
    taps = [ ];
    brews = [ ];
  };
}

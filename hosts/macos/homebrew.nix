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
      "insomnia"
      "warp"
    ];
    taps = [ ];
    brews = [ ];
  };
}

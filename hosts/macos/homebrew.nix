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
      "middleclick"
      "rectangle"
      "nikitabobko/tap/aerospace"
    ];
    taps = [ 
      "koekeishiya/formulae"
      #"nikitabobko/tap"
    ];
    brews = [ 
      "koekeishiya/formulae/yabai"
    ];
  };
}

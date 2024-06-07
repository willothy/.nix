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
      "1password" # Password manager (GUI)
      "insomnia" # API Client / Tester
      "warp" # Fancy terminal
      "middleclick" # Three-finger click = middle click
      "hammerspoon" # Automation
      "nikitabobko/tap/aerospace" # Tiling WM
      "orbstack" # Docker Desktop alternative
    ];
    taps = [
      "localstack/tap"
      "codecrafters-io/tap"
    ];
    brews = [
      "localstack-cli" # Local AWS Dev Stack
      "codecrafters"
    ];
  };
}

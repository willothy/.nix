{ config, pkgs, globalUserInfo, ... }: {
  config.environment.systemPath = [
    "/opt/homebrew/bin"
    "~/.cargo/bin"
    "~/.local/bin"
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
      "orbstack" # Docker Desktop alternative
    ];
    taps = [
      "localstack/tap"
      "codecrafters-io/tap"
    ];
    brews = [
      "localstack-cli" # Local AWS Dev Stack
      "codecrafters"
      #"tailscale"
    ];
  };
}

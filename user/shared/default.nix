{ config, pkgs, globalUserInfo, lib, ... }:
{
  imports = [
    ./programs/neovim.nix
    ./programs/git.nix
    ./programs/starship.nix
    ./programs/wezterm.nix
    ./wip.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = globalUserInfo.userName;
  home.homeDirectory = globalUserInfo.homeDir;

  home.sessionVariables = { 
    VISUAL = globalUserInfo.editorVisual;
    BROWSER = globalUserInfo.browser;
    PAGER = globalUserInfo.pager;

    SSH_AUTH_SOCK = "${globalUserInfo.homeDir}/.1password/agent.sock";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # UI / Fonts
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "FiraMono"
      ];
    })
    maple-mono-NF

    # Apps
    discord
    spotify
    zoom-us
    # brave # seems to not be on Nixpkgs with MacOS compat
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

{ pkgs, user, ... }:
let
  shellAliases = {
    ll = "ls -l";
    la = "ls -a";
    ".." = "cd ..";
    gs = "git status";
    gc = "git commit";
    ga = "git add";
    gaa = "git add --all";
    gau = "git add --update";
    v = "nvim";
    ":q" = "exit";
    #cd = "z";
  };
in
{
  imports = [
    ./programs
    ./services
  ];

  home.username = user.username;
  home.homeDirectory = user.homeDir;

  home.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "FiraMono"
      ];
    })
    maple-mono-NF
    awesome-luajit-git
  ];

  home.sessionVariables = {
    EDITOR = user.editor;
    VISUAL = user.editorVisual;
    BROWSER = user.browser;

    # 1password ssh agent
    SSH_AUTH_SOCK = "${user.homeDir}/.1password/agent.sock";
  };

  fonts.fontconfig.enable = true;

  xsession.windowManager.awesome = {
    package = pkgs.awesome-luajit-git;
    enable = true;
    luaModules = with pkgs.luajitPackages; [
      luarocks
      luadbi-mysql
      lgi
    ];
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "30m";
      style = "auto";
    };
    flags = [
      "--disable-up-arrow"
    ];
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent ${user.homeDir}/.1password/agent.sock
    '';
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    options = [
      "--cmd cd"
    ];
  };
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    icons = true;
    git = true;
  };
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  programs.bottom = {
    enable = true;
  };
  programs.carapace = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  programs.gh = {
    enable = true;
    extensions = [ ];
    settings = {
      git_protocol = "ssh";
      aliases = { };
    };
  };

  programs.fish = {
    enable = true;
    inherit shellAliases;
  };
  programs.bash = {
    enable = true;
    inherit shellAliases;
  };
  programs.zsh = {
    enable = true;
    # initExtraFirst = ''
    #   exec fish
    # '';
    inherit shellAliases;
  };

  programs.bat.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}

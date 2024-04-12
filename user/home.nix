{ pkgs, lib, user, ... }:
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
    tela-icon-theme
    whitesur-cursors
  ];

  home.sessionVariables = {
    EDITOR = user.editor;
    VISUAL = user.editorVisual;
    BROWSER = user.browser;

    # 1password ssh agent
    SSH_AUTH_SOCK = "${user.homeDir}/.1password/agent.sock";
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = false;
    name = "WhiteSur-cursors";
    package = pkgs.whitesur-cursors;
    size = 24;
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    iconTheme = {
      name = "Tela";
      package = pkgs.tela-icon-theme;
    };
    cursorTheme = {
      name = "WhiteSur-cursors";
      package = pkgs.whitesur-cursors;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk3";
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "30m";
      sync = {
        record = true;
      };
      keymap_mode = "vim-insert";
      keymap_cursor = {
        emacs = "steady-block";
        vim_insert = "steady-bar";
        vim_normal = "steady-block";
      };
      style = "compact";
      inline_height = 12;
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
    # enableFishIntegration = true;
    # enableBashIntegration = true;
    # enableZshIntegration = true;
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
    shellInitLast = ''
      set -g fish_greeting

      fish_vi_cursor
      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_visual block
      set fish_vi_force_cursor 1

      bind -e -M insert \t
      bind -M insert \t forward-word
      bind -M insert -k up history-prefix-search-backward
      bind -M insert -k down history-prefix-search-forward
    '';
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

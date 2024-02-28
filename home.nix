{ config, pkgs, ... }:

{
  home.username = "willothy";
  home.homeDirectory = "/home/willothy";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    jq
    ripgrep
    fd
    eza            # nicer LS
    bat            # nicer cat
    delta          # nicer diff
    hexyl          # hex viewer

    starship       # prompt

    lastpass-cli   # password manager

    # zsh

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionPath = [

  ];

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/willothy/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim -b";
    BROWSER = "brave";
    SUDO_ASKPASS="/usr/bin/xaskpass";
    SSH_ASKPASS="/usr/bin/xaskpass";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # programs.zsh = {
  #   enable = true;
  #   plugins = [
  #     # local plugins
  #     {
  #       name = "zsh-config";
  #       file = ".zshrc";
  #       src = pkgs.fetchTree {
  #         type = "file";
  #         url = "file:///home/willothy/.config/zsh/";
  #       };
  #     }
  #   ];
  # };

  programs.git = {
    enable = true;
    userName = "Will Hopkins";
    userEmail = "willothyh@gmail.com";
  };
}

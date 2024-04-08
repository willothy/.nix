{ config, pkgs, ... }: let
  shellAliases = {
    ll = "ls -l";
    la = "ls -a";
    ".." = "cd ..";
  };
in {

  home = {
    username = "willothy";
    homeDirectory = "/home/willothy";

    packages = with pkgs; [ ];

    file = { };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim -b";
      BROWSER = "brave";
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent ~/.1password/agent.sock
    '';
  };

  programs.git = {
    enable = true;
    userName = "Will Hopkins";
    userEmail = "willothyh@gmail.com";
    delta = {
      enable = true;
    };
  };
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    icons = true;
    git = true;
  };
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.bash = {
    enable = true;
    inherit shellAliases;
  };
  programs.zsh  = {
    enable = true;
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

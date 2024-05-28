{ config, pkgs, globalUserInfo, inputs, ... }: {
  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [ "@admin" globalUserInfo.userName ];
  };

  environment.systemPackages = with pkgs; [
    bottom
    jq
    ripgrep
    fd
    hexyl
    fzf

    curl
    wget
    unzip

    neovim

    # _1password-gui # install using Homebrew on mac
  ];

  programs._1password.enable = true;

  programs.vim = {
    enable = true;
    vimConfig = ''
      filetype plugin indent on
      syntax on

      set shiftwidth=2
      set tabstop=2
      set expandtab

      set showtabline=3
      set scrolloff=10

      set number relativenumber

      set nowrap hlsearch incsearch showmode
    '';
  };

  programs.zsh.enable = true;

  environment.shells = with pkgs; [ bash zsh ];
  environment.loginShell = pkgs.zsh;

  environment.variables = {
    LANG = "en_US.UTF-8";
  };
}

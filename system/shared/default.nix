{ pkgs, globalUserInfo, ... }: {
  imports = [
    ./programs/nh.nix
    ./programs/cli-tools.nix
    ./programs/languages.nix
    ./programs/libraries.nix
  ];

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [ "@admin" globalUserInfo.userName ];
  };

  environment.systemPackages = with pkgs; [
    # neovim

    # _1password-gui # install using Homebrew on mac

    ((vim_configurable.override { }).customize {
      name = "vim";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ vim-nix vim-lastplace ];
        opt = [ ];
      };
      vimrcConfig.customRC = ''
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
    })
  ];

  programs.nh = {
    enable = true;
    flake = "${globalUserInfo.homeDir}/.dotfiles";
  };

  programs._1password-cli.enable = true;

  # programs.vim = {
  #   enable = true;
  # };

  programs.zsh.enable = true;
  programs.fish.enable = true;

  environment.shells = with pkgs; [ zsh fish bash ];

  environment.variables = {
    LANG = "en_US.UTF-8";
  };
}

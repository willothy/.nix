# Things I need to refactor into their own modules
{ config, pkgs, globalUserInfo, lib, ... }: let
  shellAliases = {
    ll = "ls -l";
    la = "ls -a";
    ls = "eza -s type";
    lt = "eza --tree -s type";
    ".." = "cd ..";
    gs = "git status";
    gc = "git commit";
    ga = "git add";
    gaa = "git add --all";
    gau = "git add --update";
    v = "nvim";
    ":q" = "exit";
    pls = "sudo";
    #cd = "z";
  };
in {
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
    extraConfig = let
      socket = if (pkgs.system == "aarch64-darwin") then
        "${globalUserInfo.homeDir}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      else
        "${globalUserInfo.homeDir}/.1password/agent.sock"
      ;
    in  ''
      Host *
        IdentityAgent "${socket}"
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

      source ${globalUserInfo.homeDir}/.config/op/plugins.sh
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
}

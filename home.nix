{ config, pkgs, ... }: let
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
    cd = "z";
  };
in {
  home = {
    username = "willothy";
    homeDirectory = "/home/willothy";

    packages = with pkgs; [
      neovim-nightly
    ];

    file = {
      # lua/plugins/* gets autoloaded by Lazy, so I use this to
      # do required nix-specific setup.
      ".config/nvim/lua/plugins/nix.lua" = {
        enable = true;
        text = ''
          vim.g.sqlite_clib_path = "${pkgs.sqlite.out}/lib/libsqlite3.so"

          return {}
        '';
      };
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim -b";
      BROWSER = "brave";

      # 1password ssh agent
      SSH_AUTH_SOCK = "/home/willothy/.1password/agent.sock";
    };
  };

  programs.neovim = {
    package = pkgs.neovim-nightly;
    enable = true;
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent /home/willothy/.1password/agent.sock
    '';
  };

  programs.git = {
    enable = true;
    userName = "Will Hopkins";
    userEmail = "willothyh@gmail.com";
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuB3Fm5F9/qUWn2Ok7EXZc8OkKmvy6AHI+Wit0+XDiV";
      signByDefault = true;
    };
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
      };
    };
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      color.pager = "yes";
      gpg.format = "ssh";
      "gpg \"ssh\"" = {
        program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      };
      pull = {
        rebase = true;
      };
    };
  };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    options = [ ];
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
  programs.gh = {
    enable = true;
    extensions = [ ];
    settings = {
      git_protocol = "ssh";
      aliases = { };
    };
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

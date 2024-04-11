{ config, lib, pkgs, system, user, ... }: let
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
  ];

  home.sessionVariables = {
    EDITOR = user.editor;
    VISUAL = user.editorVisual;
    BROWSER = user.browser;

    # 1password ssh agent
    SSH_AUTH_SOCK = "${user.homeDir}/.1password/agent.sock";
  };

  fonts.fontconfig.enable = true;

  # lua/plugins/* gets autoloaded by Lazy, so I use this to
  # do required nix-specific setup.
  home.file.".config/nvim/lua/plugins/nix.lua" = {
    text = ''
      -- set sqlite library path for sqlite.lua
      vim.g.sqlite_clib_path = "${pkgs.sqlite.out}/lib/libsqlite3.so"

      return {}
    '';
  };

  home.file.".config/wezterm" = {
    source = ./configs/wezterm;
    recursive = true;
  };

  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "30m";
      style = "auto";
    };
    flags = [
      "--disable-up-arrow"
    ];
  };

  programs.neovim = {
    package = pkgs.neovim-nightly;
    enable = true;
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent ${user.homeDir}/.1password/agent.sock
    '';
  };

  programs.git = {
    enable = true;
    userName = user.name;
    userEmail = user.email;
    signing = {
      key = user.sshSigningKey;
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
  # TODO: Move this into its own file
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_status"
        "$git_state"
        "$\{custom.sesh\}"
        "$battery"
        "$rust"
        "$lua"
        "$python"
        "$nodejs"
        "$c"
        "$line_break"
        "$jobs"
        "$\{custom.vi_mode\}"
        "$character"
      ];
      directory = {
        truncation_length = 4;
        style = "#5de4c7";
      };
      git_branch = {
        style = "#89ddff";
        format = "on [$symbol](#8da3bf)[$branch(:$remote_branch)]($style)";
        only_attached = true;
      };
      git_commit = {
        style = "#89ddff";
      };
      git_status = {
        style = "#91b4d5";
        conflicted = "=";
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇕ $ahead_count$behind_count";
        up_to_date = "";
        untracked = "?";
        stashed = "\\$";
        modified = "!";
        renamed = "»";
        deleted = "✘";
        format = "[$all_status$ahead_behind]($style) ";
      };
      custom = {
        sesh = {
          style = "#5de4c7";
          command = "echo \"$SESH_NAME\"";
          when = " test \"$SESH_NAME\" != \"\" ";
          format = "\\[[$output]($style)\\] ";
        };
        vi_mode = {
          disabled = false;
          command = "echo $ZVM_MODE_PROMPT";
          when = " test \"$ZVM_MODE_PROMPT\" != \"\" ";
          format = "$output ";
        };
      };
      battery = {
        display = {
          threshold = 40;
        };
      };
      rust = {
        style = "red";
        format = "[$symbol]($style) ";
        symbol = "";
      };
      lua = {
        style = "blue";
        format = "[$symbol]($style) ";
        symbol = "󰢱 ";
      };
      nodejs = {
        style = "green";
        format = "[$symbol]($style) ";
      };
      c = {
        style = "149";
        format = "[$symbol]($style) ";
      };
      python = {
        style = "yellow";
        format = "[$symbol]($style) ";
      };
      jobs = {
        style = "blue";
        format = "[$number]($style)";
        disabled = false; # there's an issue with the char width of the symbol in zsh
        symbol_threshold = 0;
        number_threshold = 1;
      };
      line_break = {
        disabled = false;
      };
      character = {
        disabled = false;
        success_symbol = "[->](green)";
        error_symbol = "[->](red)";
        vimcmd_symbol = "[<-](green)";
        vimcmd_visual_symbol = "[<-](yellow)";
      };
    };
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

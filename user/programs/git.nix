{ pkgs, user, ... }: {
  home.packages = with pkgs; [
    git-subrepo
  ];

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
}

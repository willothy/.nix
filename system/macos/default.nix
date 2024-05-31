{ pkgs, globalUserInfo, ... }: {
  imports = [
    ./programs/_1password.nix
  ];

  security.pam.enableSudoTouchIdAuth = true;

  programs.zsh.enable = true;
  programs.zsh.interactiveShellInit = ''
    [[ -f "${globalUserInfo.homeDir}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${globalUserInfo.homeDir}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
  '';
}


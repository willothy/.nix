{ pkgs, globalUserInfo, ... }: {
  imports = [ ];

  programs.zsh.initExtraFirst = ''
      [[ -f "${globalUserInfo.homeDir}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${globalUserInfo.homeDir}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
    '';
}

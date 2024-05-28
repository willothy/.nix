{ system, ... }: {
  #home.file.".config/wezterm" = {
  #  source = "${system.configsDir}/wezterm";
  #  recursive = true;
  #};
  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}

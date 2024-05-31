{ pkgs, inputs, globalUserInfo, ... }: {
  home.file.".config/hammerspoon" = {
    recursive = true;
    source = "/${inputs.self}/configs/macos/hammerspoon";
  };
}





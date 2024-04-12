{ pkgs, system, ... }: {
  xsession.windowManager.awesome = {
    package = pkgs.awesome-luajit-git;
    enable = true;
    luaModules = with pkgs.luajitPackages; [
      luarocks
      luadbi-mysql
      lgi
    ];
  };

  home.file.".config/awesome" = {
    source = "${system.configsDir}/awesome";
    recursive = true;
  };
}

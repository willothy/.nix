{ config, pkgs, globalUserInfo, ... }: {
  programs.ssh =
    let
      darwin = pkgs.system == "aarch64-darwin";
      socket =
        if darwin then
          "${globalUserInfo.homeDir}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
        else
          "${globalUserInfo.homeDir}/.1password/agent.sock"
      ;
      orbstack =
        if darwin then
          ''
            Include ${globalUserInfo.homeDir}/.orbstack/ssh/config
          ''
        else
          ''
          ''
      ;
    in
    {
      enable = true;
      forwardAgent = true;
      matchBlocks = {
        "*" = {
          host = "*";
          extraOptions.IdentityAgent = ''"${socket}"'';
        };
      };
      extraConfig = ''
        ${orbstack}
      '';
    };
}

{ config, pkgs, globalUserInfo, ... }: {
  programs.ssh = let
    socket = if (pkgs.system == "aarch64-darwin") then
      "${globalUserInfo.homeDir}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else
      "${globalUserInfo.homeDir}/.1password/agent.sock"
    ;
  in {
    enable = true;
    forwardAgent = true;
    matchBlocks = {
      "*" = {
        host = "*"; 
        extraOptions.IdentityAgent = ''"${socket}"'';
      };
    };
  };
}

{ pkgs, globalUserInfo, ... }: {
  imports = [ 
    ./programs/yabai.nix
    ./programs/aerospace.nix
  ];

}

{
  pkgs,
  lib,
  ...
}:
{
  services.xserver = {
    enable = true;
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    # Configure keymap in X11
    xkb.layout = "us";
    # Remaps. Probably don't need this bc of ZMK remaps.
    # xkb.options = "caps:escape";

    displayManager = {
      defaultSession = "none+awesome";
      lightdm = {
        enable = true;
      };
    };

    desktopManager.xterm.enable = false;

    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks
        luadbi-mysql
        lgi
      ];
    };

    xrandrHeads = [
      {
        output = "HDMI-1";
        monitorConfig = ''
        '';
      } 
      {
        output = "DP-1";
        primary = true;
        monitorConfig = ''
          Option "RightOf" "HDMI-1"
        '';
      }
    ];
  };
}

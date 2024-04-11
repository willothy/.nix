{ pkgs, lib, ... }:
{
  services.xserver = {
    enable = true;
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    # Configure keymap in X11
    xkb.layout = "us";
    # Remaps. Probably don't need this bc of ZMK remaps.
    # xkb.options = "caps:escape";

    videoDrivers = [ "nvidia" ];

    displayManager = {
      defaultSession = "awesome";
      lightdm = {
        enable = true;
      };
      # Fixes xrandrHeads order, which seems to be broken
      setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --mode "1920x1080" --left-of DP-4 --output DP-4 --mode "2560x1080" --primary
      '';
      session = [
        {
          manage = "desktop";
          name = "awesome";
          start = ''exec awesome'';
        }
      ];
    };

    xrandrHeads = [
      "HDMI-0"
      {
        output = "DP-4";
        primary = true;
      }
    ];
  };
}

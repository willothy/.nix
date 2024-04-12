{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xorg.xinput
  ];

  services.xserver = {
    enable = true;
    # Enable touchpad support (enabled default in most desktopManager).
    libinput = {
      enable = true;
    };
    # Configure keymap in X11
    xkb.layout = "us";
    # Remaps. Probably don't need this bc of ZMK remaps.
    # xkb.options = "caps:escape";

    videoDrivers = [ "nvidia" ];

    displayManager = {
      lightdm = {
        enable = true;
      };
      # Fixes xrandrHeads order, which seems to be broken
      setupCommands = ''
        ${pkgs.autorandr}/bin/autorandr --change
      '';
      session = [
        {
          manage = "desktop";
          name = "awesome";
          start = ''exec awesome'';
        }
      ];
    };

    # xrandrHeads = [
    #   "HDMI-0"
    #   {
    #     output = "DP-4";
    #     primary = true;
    #   }
    # ];
  };
}

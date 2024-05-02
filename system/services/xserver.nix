{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xorg.xinput
  ];

  services.libinput = {
    enable = true;
  };

  services.xserver = {
    enable = true;
    # Enable touchpad support (enabled default in most desktopManager).
    # Configure keymap in X11
    xkb.layout = "us";
    # Remaps. Probably don't need this bc of ZMK remaps.
    # xkb.options = "caps:escape";

    videoDrivers = [ "nvidia" ];

    displayManager = {
      lightdm = {
        enable = true;
        greeters = {
          gtk = {
            enable = true;
            theme = {
              name = "Colloid-Dark";
              package = pkgs.colloid-gtk-theme;
            };
            iconTheme = {
              name = "Tela";
              package = pkgs.tela-icon-theme;
            };
            cursorTheme = {
              name = "WhiteSur-cursors";
              package = pkgs.whitesur-cursors;
            };
            indicators = [
              "~host"
              "~spacer"
              "~clock"
              "~spacer"
              "~session"
              "~power"
            ];
          };
        };
      };
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
  };
}

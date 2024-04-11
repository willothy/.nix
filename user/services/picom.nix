{ pkgs, ... }: {
  services.picom = {
    enable = true;
    package = pkgs.picom;
    fade = true;
    fadeExclude = [
      "class_g = 'spad'"
    ];
    shadow = true;
    shadowExclude = [
      "class_g = 'Rofi'"
    ];
    wintypes = {
      popup_menu = {
        opacity = 0.8;
        animation = false;
      };
      normal = {
        opacity = 1.0;
      };
      toolbar = { };
      dropdown_menu = {
        opacity = 0.8;
      };
      menu = {
        opacity = 0.8;
      };
      popup = {
        opacity = 0.8;
        shadow = false;
      };
      dnd = {
        shadow = false;
      };
      dock = {
        shadow = true;
        opacity = 0.8;
        blur-background = true;
      };
      tooltip = {
        fade = true;
        shadow = true;
        opacity = 0.7;
        focus = true;
      };
      notification = {
        fade = true;
        shadow = true;
        opacity = 0.85;
        focus = true;
      };
    };
    settings = {
      backend = "glx";
      vsync = true;
      corner-radius = 8;
      rounded-corners-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
      ];
      blur-method = "dual_kawase";
      blur-background = true;

      animations = true;
      animation-clamping = true;

      animation-for-open-window = "zoom";
      animation-for-ummap-window = "minimize";
      animation-for-transient-window = "zoom";
      enable-fading-next-tag = true;
      animation-for-next-tag = "slide-down";
      enable-fading-prev-tag = true;
      animation-for-prev-tag = "slide-up";
    };
  };
}

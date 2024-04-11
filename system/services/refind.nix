{ ... }: {
  boot.loader.refind = {
    enable = true;
    extraConfig = ''
      resolution 0
      dont_scan_dirs NIX-BOOT:/EFI/nixos
      hideui banner,editor
      showtools shutdown reboot firmware
      use_graphics_for linux,windows
      include themes/refind-theme-regular/theme.conf
    '';
  };
}

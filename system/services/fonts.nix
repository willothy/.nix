{ pkgs, ... }: {
  # Global font config
  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "FiraMono"
      ];
    })
    maple-mono-NF
  ];
  fonts.fontDir.enable = true;
  fonts.fontconfig.enable = true;
}

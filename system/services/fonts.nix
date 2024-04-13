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
    apple-fonts.sf-pro
    apple-fonts.sf-mono
    apple-fonts.sf-compact
    apple-fonts.ny
  ];
  fonts.fontDir.enable = true;

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [
        "New York Medium"
        "DejaVu Serif"
      ];
      sansSerif = [
        "SF Pro"
        "DejaVu Sans"
      ];
      monospace = [
        "SF Mono"
        "DejaVu Sans Mono"
      ];
    };
  };
}

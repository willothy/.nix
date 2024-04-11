{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Languages
    nodejs_21
    python312
    rustup
    gcc
    luajit

    # Build tools
    gnumake
    cmake

    # Libraries
    sqlite
  ];
}

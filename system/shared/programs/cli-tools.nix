{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Essentials
    curl
    wget
    unzip

    # Utilities
    bottom
    jq
    ripgrep
    fd
    hexyl
    fzf

    # Dev / Build Tools
    gnumake
    cmake
    ccache
    pkg-config
  ];
}

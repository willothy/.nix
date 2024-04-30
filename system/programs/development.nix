{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Languages
    nodejs
    python312
    rustup
    gcc
    go
    llvmPackages_18.clang-unwrapped
    luajit

    # Language servers / linters / formatters
    lua-language-server
    stylua
    uncrustify

    # Build tools
    gnumake
    cmake
    ccache
    pkg-config

    # Deployment
    docker
    docker-compose

    # Libraries
    sqlite
  ];
}

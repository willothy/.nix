{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Languages
    nodejs_21
    python312
    rustup
    gcc
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

    # Libraries
    sqlite
  ];
}

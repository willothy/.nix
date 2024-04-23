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

    # Build tools
    gnumake
    cmake

    # Libraries
    sqlite
  ];
}

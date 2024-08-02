{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    nodejs_22
    bun

    luajit
    luajitPackages.luarocks

    poetry
    poetryPlugins.poetry-plugin-export
    python312

    go
    clang
    rustup

    protobuf
  ];
}


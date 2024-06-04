{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    nodejs_22
    bun

    luajit
    luajitPackages.luarocks

    poetry
    python312

    go
    clang
    rustup

    protobuf
  ];
}


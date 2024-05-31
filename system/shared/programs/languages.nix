{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    nodejs_22
    bun
    luajit

    go
    clang
    rustup

    protobuf
  ];
}


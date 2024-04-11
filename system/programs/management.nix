{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # system essentials
    wget
    unzip
  ];
}

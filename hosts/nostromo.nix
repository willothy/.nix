{ config, pkgs, ... }: {
  imports = [
    ../common.nix
  ];

  # networking.hostName = "";

  # Fixes time desync due to Windows dual boot
  time.hardwareClockInLocalTime = true;
}

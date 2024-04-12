{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bluez
    blueman
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;
}

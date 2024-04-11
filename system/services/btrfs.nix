{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    btrfs-progs
  ];

  # Auto defrag disk
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    # Handles nested subvolumes automatically
    fileSystems = [ "/" ];
  };
}

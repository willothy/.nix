{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # UX essentials
    polkit_gnome
    volctl
  ];
}

{ pkgs, user, ... }: {
  environment.systemPackages = with pkgs; [
    gnome.nautilus
  ];

  services.gnome.sushi.enable = true;

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "${user.terminal}";
  };
}

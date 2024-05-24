{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    neovim
  ];

  # Globally set editor to nvim
  environment.variables.EDITOR = "nvim";

  # Basic global config for initial nixos setup
  # and editing as root.
  programs.neovim = {
    # package = pkgs.neovim-nightly;
    package = pkgs.neovim;
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = ''
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set scrolloff=10
      '';
    };
  };
}

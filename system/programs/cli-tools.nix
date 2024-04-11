{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # CLI tools I want globally available
    bottom
    jq
    ripgrep
    fd
    hexyl
    fzf

    # Clipboard
    xsel
  ];
}

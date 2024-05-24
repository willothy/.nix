{ pkgs, ... }: {
  programs.neovim = {
    package = pkgs.neovim; #-nightly;
    enable = true;
  };

  # lua/plugins/* gets autoloaded by Lazy, so I use this to
  # do required nix-specific setup.
  home.file.".config/nvim/lua/plugins/nix.lua" = {
    text = ''
      -- set sqlite library path for sqlite.lua
      vim.g.sqlite_clib_path = "${pkgs.sqlite.out}/lib/libsqlite3.so"

      return {}
    '';
  };
}

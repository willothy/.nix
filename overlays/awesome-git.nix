final: prev:
let
  mkAwesome = name: pkgs:
    let
      package = {
        version = "8b1f8958b46b3e75618bc822d512bb4d449a89aa";
        src = pkgs.fetchFromGitHub {
          owner = "awesomeWM";
          repo = "awesome";
          rev = "8b1f8958b46b3e75618bc822d512bb4d449a89aa";
          fetchSubmodules = false;
          sha256 = "sha256-ZGZ53IWfQfNU8q/hKexFpb/2mJyqtK5M9t9HrXoEJCg=";
        };
        date = "2024-03-23";
      };
      extraGIPackages = with pkgs; [ networkmanager upower playerctl ];
    in
    (pkgs.awesome.override { gtk3Support = true; }).overrideAttrs (old: {
      inherit (package) src version;

      patches = [ ];

      postPatch = ''
        patchShebangs tests/examples/_postprocess.lua
        patchShebangs tests/examples/_postprocess_cleanup.lua
      '';

      cmakeFlags = old.cmakeFlags ++ [ "-DGENERATE_MANPAGES=OFF" ];

      GI_TYPELIB_PATH =
        let
          mkTypeLibPath = pkg: "${pkg}/lib/girepository-1.0";
          extraGITypeLibPaths = prev.lib.forEach extraGIPackages mkTypeLibPath;
        in
        prev.lib.concatStringsSep ":" (extraGITypeLibPaths ++ [ (mkTypeLibPath prev.pango.out) ]);
    });
in
{
  awesome-git = mkAwesome "awesome" prev;

  awesome-luajit-git = final.awesome-git.override {
    lua = prev.luajit;
    gtk3Support = true;
  };
}

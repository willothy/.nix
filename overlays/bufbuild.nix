self: super:
let
  version = "1.32.2";
  sha256 = "sha256-B9XGX4x2uyW2yxo82GqnbJB8/PJ4dfJbDus0svaxwxI=";

  platform =
    if super.stdenv.system == "x86_64-darwin" then
      "Darwin-x86_64"
    else if super.stdenv.system == "x86_64-linux" then
      "Linux-x86_64"
    else if super.stdenv.system == "aarch64-linux" then
      "Linux-aarch64"
    else if super.stdenv.system == "aarch64-darwin" then
      "Darwin-arm64"
    else
      throw "unsupported platform"
  ;
in
{
  buf = super.stdenv.mkDerivation rec {
    pname = "buf";
    inherit version;

    src = super.fetchurl {
      url = "https://github.com/bufbuild/buf/releases/download/v${version}/buf-${platform}";
      inherit sha256;
    };

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/buf
      chmod +x $out/bin/buf
    '';

    meta = with super.lib; {
      description = "A new way of working with Protocol Buffers.";
      homepage = "https://buf.build";
      license = licenses.asl20;
      platforms = platforms.linux ++ platforms.darwin;
    };
  };
}

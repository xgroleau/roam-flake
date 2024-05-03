{ stdenv, fetchurl, dpkg, ... }:
let
in stdenv.mkDerivation rec {
  name = "ro.am";
  src = fetchurl {
    url =
      "https://download.ro.am/Roam/8a86d88cfc9da3551063102e9a4e2a83/latest/linux/x64/Roam.deb";
    sha256 = "1faqb5vr1n6q9hlxpih5rgfxznygzsb8vz3bmsvjh1si6k4gzy13";
  };

  buildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -x $src $out
  '';

  installPhase = ''
    # Custom installation steps if necessary
  '';
}

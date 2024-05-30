{ lib, stdenv, makeWrapper, fetchurl, dpkg, alsa-lib, dbus, fontconfig, freetype
, glib, mesa, nspr, nss, gobject-introspection, wrapGAppsHook, libGL, libnotify
, libsecret, libX11, libXScrnSaver, libXcomposite, libXcursor, libXdamage
, libXext, libXfixes, libXi, libXrandr, libXrender, libXtst, libxcb
, libxshmfence, nghttp2, libudev0-shim, glibc, curl, openssl, autoPatchelfHook
}:
let
  runtimeLibs = lib.makeLibraryPath [
    curl
    glibc
    libudev0-shim
    libGL
    libnotify
    nghttp2
    openssl
    stdenv.cc.cc.lib

  ];
in stdenv.mkDerivation rec {
  name = "roam";
  src = fetchurl {
    url =
      "https://download.ro.am/Roam/8a86d88cfc9da3551063102e9a4e2a83/latest/linux/x64/Roam.deb";
    sha256 = "08dfhxsrlzkcw2qkil3f8dmr8d33byiv7dbmcvi36dngyl8yr4wc";
  };

  nativeBuildInputs =
    [ autoPatchelfHook dpkg makeWrapper gobject-introspection wrapGAppsHook ];

  buildInputs = [
    alsa-lib
    dbus
    fontconfig
    freetype
    glib
    libsecret.dev
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXi
    libXrandr
    libXrender
    libxcb
    libxshmfence
    mesa # for libgbm
    nspr
    nss
  ];

  dontBuild = true;
  dontConfigure = true;
  dontWrapGApps = true;
  unpackPhase = "dpkg --fsys-tarfile $src | tar --extract";

  installPhase = ''
    mkdir -p $out
    mv usr/* $out
  '';

  preFixup = ''
    wrapProgramShell "$out/bin/roam" \
        "''${gappsWrapperArgs[@]}" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}" \
        --prefix LD_LIBRARY_PATH : ${runtimeLibs}
  '';
}

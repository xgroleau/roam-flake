{ lib, stdenv, makeWrapper, fetchurl, dpkg, alsa-lib, atk, cairo, cups, dbus
, expat, fontconfig, freetype, gdk-pixbuf, glib, pango, mesa, nspr, nss, gtk3
, at-spi2-atk, gsettings-desktop-schemas, gobject-introspection, wrapGAppsHook
, libsecret, libX11, libXScrnSaver, libXcomposite, libXcursor, libXdamage
, libXext, libXfixes, libXi, libXrandr, libXrender, libXtst, libxcb
, libxshmfence, nghttp2, libudev0-shim, glibc, curl, openssl, autoPatchelfHook
}:
let
  runtimeLibs = lib.makeLibraryPath [
    curl
    glibc
    libudev0-shim
    nghttp2
    openssl
    stdenv.cc.cc.lib
  ];
in stdenv.mkDerivation rec {
  name = "ro.am";
  src = fetchurl {
    url =
      "https://download.ro.am/Roam/8a86d88cfc9da3551063102e9a4e2a83/latest/linux/x64/Roam.deb";
    sha256 = "1faqb5vr1n6q9hlxpih5rgfxznygzsb8vz3bmsvjh1si6k4gzy13";
  };

  nativeBuildInputs =
    [ autoPatchelfHook dpkg makeWrapper gobject-introspection wrapGAppsHook ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    pango
    gtk3
    gsettings-desktop-schemas
    libsecret.dev
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
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

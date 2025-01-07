{ stdenv
, lib
, fetchurl
, meta
, pname
, version
, sha256
, ...
}:
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://talonvoice.com/dl/latest/talon-linux.tar.xz";
    inherit sha256;
  };

  preferLocalBuild = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/talon
    cp -a * $out/opt/talon/

    mkdir -p "$out/etc/udev/rules.d"
    cp 10-talon.rules $out/etc/udev/rules.d
    # Remove udev compatibility hack using plugdev for older debian/ubuntu
    # This breaks NixOS usage of these rules (see https://github.com/NixOS/nixpkgs/issues/76482)
    substituteInPlace $out/etc/udev/rules.d/10-talon.rules --replace 'GROUP="plugdev",' ""

    mkdir -p $out/share/applications
    cat << EOF > $out/share/applications/talon.desktop
      [Desktop Entry]
      Categories=Utility;
      Exec=talon
      Name=Talon
      Terminal=false
      Type=Application
    EOF

    mkdir -p $out/bin
    ln -s $out/opt/talon/talon $out/bin/talon
    ln -s $out/opt/talon/lib $out

    runHook postInstall
  '';

  meta = meta // {
    platforms = with lib.platforms; linux;
  };
}
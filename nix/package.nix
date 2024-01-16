{ lib, stdenv, pkgs }:

stdenv.mkDerivation rec {
  name = "pp-to-epp";

  propagatedBuildInputs = [ pkgs.power-profiles-daemon pkgs.python3 ];
  unpackPhase = ":";
  installPhase = "install -m755 -D ${../pp-to-epp} $out/bin/pp-to-epp";

  meta = {
    description = "Power Profiles Daemon to AMD & Intel P-STATE EPP";
    mainProgram = "pp-to-epp";
  };

}



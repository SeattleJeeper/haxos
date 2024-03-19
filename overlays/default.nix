{ config, pkgs, lib, ... }:
{
  nixpkgs.overlays = [
    (final: prev: rec {
      awesome-git = prev.awesome.overrideAttrs (old: {
        pname = "awesome-git";
        version = "master";
        src = prev.fetchFromGitHub {
          owner = "awesomeWM";
          repo = "awesome";
          rev = "75758b07f3c3c326d43ac682896dbcf18fac4bd7";
          hash = "sha256-pT9gCia+Cj3huTbDcXf/O6+EL6Bw4PlvL00IJ1gT+OY=";
        };
        nativeBuildInputs = with prev.pkgs; [
          cmake
          doxygen
          imagemagick
          makeWrapper
          pkg-config
          xmlto
          docbook_xml_dtd_45
          docbook_xsl
          findXMLCatalogs
          asciidoctor
          gobject-introspection
          lua53Packages.busted
          lua53Packages.luacheck
        ];
        patches = [ ];
        cmakeFlags = old.cmakeFlags ++ [
          "-DGENERATE_DOC=OFF"
          "-DGENERATE_MANPAGES=OFF"
        ];
      });
      awesome = awesome-git.override { lua = prev.lua5_3; };
    })
  ];
}

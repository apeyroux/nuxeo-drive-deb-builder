with import <nixpkgs> {} ;

stdenv.mkDerivation {
  name = "nuxeo-drive-builder";
  buildInputs = [ gnumake ];
}

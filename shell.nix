with import <nixpkgs> { };
mkShell {
  buildInputs = [
    gcc
    zlib
    zlib.static
  ];
}

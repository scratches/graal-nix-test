with import <nixpkgs> { };
mkShell {
  buildInputs = [
    gcc
    zlib.static
  ];
}

with import <nixpkgs> { };
mkShell {
  name ="native";
  buildInputs = [
    glibc.static
    zlib.static
    gcc
   ];
}

with import <nixpkgs> { };
runCommand "native" {
  buildInputs = [
    glibc.static
    zlib.static
    gcc
   ];
} ""

with import <nixpkgs> { };
mkShell {
  buildInputs = [
    gcc
    zlib
    zlib.static
  ];
  shellHook = ''
    export GRAAL_FLAGS=$(env | grep ^NIX | sed -e 's/=.*//' | tr '\n' ' ' | sed -e 's/ *$//' | sed -e 's/ / -E/g' | sed -e 's/^NIX/-ENIX/')
  '';
}

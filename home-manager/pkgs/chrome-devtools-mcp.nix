# chrome-devtools-mcp: pre-bundled npm tarball (rollup bundle → no runtime deps).
# Version and integrity live in ./chrome-devtools-mcp.json; bump via ../pkgs/update.
{ fetchurl, runCommand, makeWrapper, nodejs }:

let
  meta = builtins.fromJSON (builtins.readFile ./chrome-devtools-mcp.json);
  src = fetchurl {
    url = "https://registry.npmjs.org/${meta.npm}/-/${meta.npm}-${meta.version}.tgz";
    hash = meta.hash;
  };
in
runCommand "chrome-devtools-mcp-${meta.version}"
  {
    nativeBuildInputs = [ makeWrapper ];
    passthru = { inherit (meta) version; };
  }
  ''
    mkdir -p $out/lib/chrome-devtools-mcp $out/bin
    tar xzf ${src} -C $out/lib/chrome-devtools-mcp --strip-components=1
    makeWrapper ${nodejs}/bin/node $out/bin/chrome-devtools \
      --add-flags $out/lib/chrome-devtools-mcp/build/src/bin/chrome-devtools.js
    makeWrapper ${nodejs}/bin/node $out/bin/chrome-devtools-mcp \
      --add-flags $out/lib/chrome-devtools-mcp/build/src/bin/chrome-devtools-mcp.js
  ''

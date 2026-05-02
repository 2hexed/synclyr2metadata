{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "synclyr2metadata";
  version = "1.0.0";

  # Points to the current directory
  src = ./.;

  # Dependencies needed at build time (like pkg-config)
  nativeBuildInputs = [ 
    pkgs.pkg-config 
    pkgs.makeWrapper 
  ];

  # Libraries the program links against
  buildInputs = [ 
    pkgs.curl 
    pkgs.taglib 
    pkgs.zlib 
  ];

  # Nix runs 'make native' to compile
  buildPhase = ''
    make native
  '';

  # Standard install phase to move the binary and wrap it
  installPhase = ''
    mkdir -p $out/bin
    cp synclyr2metadata $out/bin/
    
    # This 'bakes' the library paths into the binary so you 
    # never have to export LD_LIBRARY_PATH manually again.
    wrapProgram $out/bin/synclyr2metadata \
      --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ pkgs.curl pkgs.taglib pkgs.zlib ]}"
  '';

  meta = {
    description = "A lightweight command-line tool that reads local .lrc files or automatically downloads synchronized lyrics from LRCLIB and embeds them directly into your audio files' metadata.";
    homepage = "https://github.com/2hexed/synclyr2metadata";
    license = pkgs.lib.licenses.gpl3;
    platforms = pkgs.lib.platforms.linux;
  };
}

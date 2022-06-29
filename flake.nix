{
  description = "blog";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    xmin = {
      url = "github:yihui/hugo-xmin";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, xmin }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [ pkgs.hugo ];
          shellHook = ''
            mkdir -p themes
            ln -sf ${xmin} themes/xmin
          '';
        };
        packages.default = pkgs.stdenvNoCC.mkDerivation {
          name = "blog";
          src = ./.;
          buildInputs = [ pkgs.hugo ];
          buildPhase = ''
            mkdir -p themes
            ln -sf ${xmin} themes/xmin
            hugo
          '';
          installPhase = ''
            cp -r public $out
          '';
        };
      });
}

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
            ln -sf ${xmin} ./themes/xmin
          '';
        };
      });
}

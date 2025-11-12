{
  inputs = rec {
    common.url = "github:YuMingLiao/common";
    nixpkgs.follows = "common/nixpkgs";
  };
  outputs =
    inputs@{ self, common, ... }:
    common.lib.mkFlake { inherit inputs; } {
      perSystem =
        {
          self',
          pkgs,
          config,
          system,
          ...
        }:

        {

          haskellProjects.default = {
            basePackages = config.haskellProjects.ghc9101.outputs.finalPackages;
            projectRoot = builtins.toString (
              pkgs.lib.fileset.toSource {
                root = ./.;
                fileset = pkgs.lib.fileset.difference ./. ./flake.nix;
              }
            );
            settings = {
            };
            packages = {
            };
            devShell = {
              tools = hp: {
                haskell-language-server = null;
                hlint = null;
              };

              hoogle = false;
            };
            otherOverlays = [
            ];
          };
          packages.default = self'.packages.indexed-extras;
          devShells.final = pkgs.mkShell {
            name = "A shell that has the final indexed-extras";
            inputsFrom = [ config.haskellProjects.default.outputs.devShell ];
            nativeBuildInputs = [
              (config.haskellProjects.default.outputs.finalPackages.ghcWithPackages (
                p: with p; [
                  indexed-extras
                ]
              ))
            ];
          };
          checks.default = pkgs.stdenv.mkDerivation {
            name = "test";
            src = ./test;
            buildInputs = [
              (config.haskellProjects.default.outputs.finalPackages.ghcWithPackages (
                p: with p; [
                  indexed-extras 
                ]
              ))
            ];
            buildPhase = ''
            '';

          };
        };
    };
}

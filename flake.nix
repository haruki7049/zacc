{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = { self, nixpkgs, flake-utils, treefmt-nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pname = "zacc";
        pkgs = import nixpkgs { inherit system; };
        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        zacc = pkgs.stdenv.mkDerivation {
          inherit pname;
          version = "dev";
          src = ./.;

          nativeBuildInputs = [
            pkgs.zig_0_13.hook
          ];

          zigBuildFlags = [
            "-Doptimize=Debug"
          ];
        };
      in
      {
        # Use `nix fmt`
        formatter = treefmtEval.config.build.wrapper;

        # Use `nix flake check`
        checks = {
          inherit zacc;
          formatting = treefmtEval.config.build.check self;
        };

        # nix build .
        # nix build .#default
        packages = {
          inherit zacc;
          default = zacc;
        };

        # nix run .#default
        apps.default = flake-utils.lib.mkApp {
          drv = zacc;
        };

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            zig_0_13
            zls
            nil
          ];

          shellHook = ''
            export PS1="\n[nix-shell:\w]$ "
          '';
        };
      });
}

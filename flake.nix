{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
        buildNodeJs = pkgs.callPackage "${nixpkgs}/pkgs/development/web/nodejs/nodejs.nix" {
          python = pkgs.python3;
        };
        nodejs = buildNodeJs {
          enableNpm = true;
          version = "20.5.1";
          sha256 = "sha256-Q5xxqi84woYWV7+lOOmRkaVxJYBmy/1FSFhgScgTQZA=";
        };
      in rec {
        flakedPkgs = pkgs;
        devShell = pkgs.mkShell {
          shellHook = ''
            export NPM_CONFIG_PREFIX="$PWD/npm_config_prefix"
            export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
          '';
          buildInputs = with pkgs; [
            nodejs
          ];
        };
      }
    );
}

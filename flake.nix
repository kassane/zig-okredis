{
  description = "Zero-allocation Client for Redis 6+";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    zigpkgs.url = "github:mitchellh/zig-overlay";
  };

  outputs = { self, nixpkgs, gitignore, flake-utils, zigpkgs }:
  let
    systems = [ "x86_64-linux" ];
    inherit (gitignore.lib) gitignoreSource;
  in flake-utils.lib.eachSystem systems (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      zig = zigpkgs.packages.${system}.master;
    in rec {
      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          zls
        ] ++ [zig];
      };
    }
  );
}

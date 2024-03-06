{
  description = "NixOS integration tests example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    forAllSystems = nixpkgs.lib.genAttrs ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];
    echoServerOverlay = final: prev: {
      echo-server = final.callPackage ./echo-server/echo-server.nix {pkgs = final;};
    };
  in {
    nixosModules.echo-server = import ./echo-server/echo-server-module.nix;
    checks = forAllSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [echoServerOverlay];
      };
    in {
      echo-server = pkgs.callPackage ./echo-server/tests/echo-server.nix {inherit self pkgs;};
    });
  };
}

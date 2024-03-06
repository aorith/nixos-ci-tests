{
  description = "Very simple NixOS test";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs: let
    forAllSystems = inputs.nixpkgs.lib.genAttrs ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];
  in {
    checks = forAllSystems (system: let
      pkgs = import inputs.nixpkgs {inherit system;};
    in {
      simple = pkgs.callPackage ./test.nix {inherit pkgs;};
    });
  };
}

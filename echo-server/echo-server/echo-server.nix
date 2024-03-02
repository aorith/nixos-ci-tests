{pkgs ? import <nixpkgs> {}}:
pkgs.buildGoModule {
  name = "echo-server";
  src = ./.;
  vendorHash = null;
}

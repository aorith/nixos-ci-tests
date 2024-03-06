{pkgs ? import <nixpkgs> {}}:
pkgs.buildGoModule {
  name = "echo-server";
  src = ./src;
  vendorHash = null;
}

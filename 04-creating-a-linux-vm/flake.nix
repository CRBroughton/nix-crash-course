{
  description = "Creating a Linux VM with NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem
      [
        "aarch64-darwin"
        "x86_64-darwin"
      ]
      (
        system:
        let
          inherit (nixpkgs) lib;
          hostPkgs = nixpkgs.legacyPackages.${system};
          guestSystem = lib.replaceStrings [ "darwin" ] [ "linux" ] system;

          nixos = nixpkgs.lib.nixosSystem {
            modules = [
              ./configuration.nix
              {
                nixpkgs.hostPlatform = guestSystem;
                virtualisation.host.pkgs = hostPkgs;
              }
            ];
          };
        in
        {
          packages = {
            nixos-vm = nixos.config.system.build.vm;
            default = hostPkgs.darwin.linux-builder;
          };
        }
      );
}

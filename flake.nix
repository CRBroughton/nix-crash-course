{
  description = "Nix crash course";

  inputs = {
    nix-format.url = "github:CRBroughton/nix-flakes?dir=nix-format";
    nixpkgs.follows = "nix-format/nixpkgs";
    flake-utils.follows = "nix-format/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      nix-format,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = nix-format.packages.${system}.default;
        apps.format = nix-format.apps.${system}.format;

        devShells.default = pkgs.mkShell {
          inputsFrom = [ nix-format.devShells.${system}.default ];
          packages = with pkgs; [
            just
          ];

          NIX_PATH = "nixpkgs=${pkgs.path}";
        };
      }
    );
}

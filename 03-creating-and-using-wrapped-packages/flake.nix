{
  description = "Wrapped Nix Demo";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    wrappers = {
      url = "github:nix-community/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      wrappers,
      ...
    }:
    let
      zshWrapper = wrappers.lib.evalModule ./zsh.nix;
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = zshWrapper.config.wrap {
          inherit pkgs;
          extraRc = ''
            echo "Hello from a wrapped zsh"
          '';
        };
      }
    );
}

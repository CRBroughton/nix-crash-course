{
  pkgs ? import <nixpkgs> { },
}:

let
  app = pkgs.writeScriptBin "hello" ''
    #!${pkgs.nodejs}/bin/node
    console.log("Hello from a Nix-built Docker image!");
  '';
in
pkgs.dockerTools.buildImage {
  name = "hello-nix";
  tag = "latest";

  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths = with pkgs; [
      app
      nodejs
    ];
  };

  config = {
    Cmd = [ "${app}/bin/hello" ];
  };
}

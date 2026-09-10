{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
{
  imports = [ wlib.modules.default ];

  options = {
    extraRc = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra commands appended to the generated .zshrc";
    };

    prompt = lib.mkOption {
      type = lib.types.str;
      default = "%F{cyan}nix-zsh%f %~ %# ";
      description = "Zsh prompt string";
    };
  };

  config = {
    package = pkgs.zsh;

    constructFiles.zshrc = {
      relPath = "zdot/.zshrc";
      content = ''
        PROMPT='${config.prompt}'
        ${config.extraRc}
      '';
    };

    env.ZDOTDIR = dirOf config.constructFiles.zshrc.path;
  };
}

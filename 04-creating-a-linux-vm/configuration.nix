{ modulesPath, pkgs, ... }:
{
  imports = [
    "${modulesPath}/virtualisation/qemu-vm.nix"
  ];

  networking.hostName = "demo";

  services.getty.autologinUser = "demo";
  users.users.demo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "demo";
  };
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    cowsay
  ];

  virtualisation = {
    graphics = false;
    memorySize = 1024;
    cores = 2;
  };

  system.stateVersion = "25.11";
}

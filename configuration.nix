{ config, pkgs, lib, modulesPath, ... }:
{
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.firewall.trustedInterfaces = [
    "tun0"
  ];

  programs.zsh.enable = true;
  virtualisation.docker.enable = true;

  services.xserver = {
    enable = true;
    windowManager.awesome.enable = true;
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "haxos";
      
      sessionCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --newmode "3440x1440_60.00" 419.11 3440 3688 4064 4688 1440 1441 1444 1490 -HSync +VSync &&
        ${pkgs.xorg.xrandr}/bin/xrandr --addmode Virtual-1 3440x1440_60.00 &&
        ${pkgs.xorg.xrandr}/bin/xrandr --output Virtual-1 --mode 3440x1440_60.00 
      '';
    };
  };

  services.spice-vdagentd.enable = true;

  users.users.haxos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker"];
    initialPassword = "nix";
    shell = pkgs.zsh;
  };

  environment.shells = with pkgs; [ zsh ];

  environment.sessionVariables = {
    WINIT_X11_SCALE_FACTOR = "1.44"; 
  };

  environment.etc.hosts.mode = "0644";

  system.build.qcow = lib.mkForce (import "${toString modulesPath}/../lib/make-disk-image.nix" {
    inherit lib config pkgs;
    diskSize = "auto";
    additionalSpace = "5G";
    format = "qcow2";
    partitionTableType = "hybrid";
  });

  system.stateVersion = "23.05";
}

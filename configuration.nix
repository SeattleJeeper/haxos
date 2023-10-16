{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.zsh.enable = true;

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
    extraGroups = [ "wheel" ];
    initialPassword = "nix";
    shell = pkgs.zsh;
  };

  environment.shells = with pkgs; [ zsh ];

  environment.sessionVariables = {
    WINIT_X11_SCALE_FACTOR = "1.44"; 
  };

  environment.etc.hosts.mode = "0644";

  system.stateVersion = "23.05";
}

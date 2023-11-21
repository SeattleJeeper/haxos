{ config, pkgs, lib, ... }:
let
  dotfiles = pkgs.fetchgit {
    url = "https://github.com/vncsb/dotfiles.git";
    rev = "53a857901e2e90f7c5df339cbb9d62ba83b3d00c";
    hash = "sha256-ILc+nWmDUVvpXwapnIiSBQXdIs2ZdXrgmPlv717Q9/o=";
    fetchSubmodules = true;
  };
  gobuster = pkgs.callPackage ./pkgs/gobuster.nix { };
  seclists = pkgs.callPackage ./pkgs/seclists.nix { };
  raccoon = pkgs.callPackage ./pkgs/raccoon.nix { };

  python-packages = ps: with ps; [
    impacket
    pwntools
  ];
in
{
  home.username = "haxos";
  home.homeDirectory = "/home/haxos";
  home.stateVersion = "23.05";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    git
    gcc
    zsh
    alacritty
    neovim
    chromium
    firefox
    eza
    meslo-lgs-nf
    terminus-nerdfont
    gobuster
    nodejs
    xsel
    ripgrep
    fd
    wget
    rustup
    go
    openvpn
    unzip
    raccoon
    metasploit
    nmap
    nssTools
    zap
    (python3.withPackages python-packages)
    bruno
    cadaver
    thc-hydra
    openldap
    enum4linux
    crackmapexec
    samba
    kerbrute
  ];

  xsession.windowManager.awesome = {
    enable = true;
  };

  programs.home-manager.enable = true;

  xdg.configFile = {
    "awesome" = {
      source = "${dotfiles}/.config/awesome";
      recursive = true;
    };
    "nvim" = {
      source = "${dotfiles}/.config/nvim";
      recursive = true;
    };
    "alacritty" = {
      source = "${dotfiles}/.config/alacritty";
      recursive = true;
    };
  };

  home.file = {
    ".zshrc".source = "${dotfiles}/.zshrc";
    ".p10k.zsh".source = "${dotfiles}/.p10k.zsh";
    "wordlists/seclists".source = seclists;
  };

  home.activation.install-root-certificate =
    let
      zap = "${pkgs.zap}/bin/zap";
      certutil = "${pkgs.nssTools}/bin/certutil";
      awkPath = "${pkgs.gawk}/bin";
    in
      lib.hm.dag.entryAfter [ "installPackages" ] ''
        export PATH="$PATH:${awkPath}"
        $DRY_RUN_CMD ${zap} -addoninstall network -cmd $VERBOSE_ARG
        $DRY_RUN_CMD ${zap} -certpubdump $HOME/zap-certificate.cer -cmd $VERBOSE_ARG
        $DRY_RUN_CMD mkdir -p $HOME/.pki/nssdb
        $DRY_RUN_CMD ${certutil} -d $HOME/.pki/nssdb -N --empty-password
        $DRY_RUN_CMD ${certutil} -d sql:$HOME/.pki/nssdb/ -A -t "CP,CP," -n zap-certificate -i $HOME/zap-certificate.cer $VERBOSE_ARG
      '';
}

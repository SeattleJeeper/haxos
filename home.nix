{ config, pkgs, lib, dotfiles, notes, ... }:
let
  gobuster = pkgs.callPackage ./pkgs/gobuster.nix { };
  seclists = pkgs.callPackage ./pkgs/seclists.nix { };
  raccoon = pkgs.callPackage ./pkgs/raccoon.nix { };
  openvpn = pkgs.callPackage ./overrides/openvpn.nix { };
  gitdumper = pkgs.python3Packages.callPackage ./pkgs/gitdumper.nix { };
  dirsearch = pkgs.python3Packages.callPackage ./pkgs/dirsearch.nix { };

  python-packages = ps: with ps; [
    impacket
    pwntools
    pyftpdlib
    dirsearch
  ];
in
{
  home.username = "haxos";
  home.homeDirectory = "/home/haxos";
  home.stateVersion = "23.05";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    gcc
    git
    tmux
    zsh
    alacritty
    neovim
    chromium
    firefox-devedition
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
    burpsuite
    (python3.withPackages python-packages)
    bruno
    cadaver
    thc-hydra
    openldap
    enum4linux
    netexec
    samba
    kerbrute
    updog
    rclone
    exploitdb
    john
    evil-winrm
    bloodhound
    bloodhound-py
    sslscan
    wpscan
    gitdumper
    wine
    winetricks
    mono
    sqlmap
    wireshark
    exiftool
    whatweb
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
    ".tmux.conf".source = "${dotfiles}/.tmux.conf";
    "wordlists/seclists".source = seclists;
    "notes".source = notes;
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

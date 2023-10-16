{ config, pkgs, lib, ... }:
let
  dotfiles = pkgs.fetchgit {
    url = "https://github.com/vncsb/dotfiles.git";
    rev = "39ba3fefc87a5dd674d848a34c9da662cb288372";
    hash = "sha256-zHjdXlDkoN669yZewWi/e3jsyYf99BbC3q2ezjFwY6c=";
    fetchSubmodules = true;
  };
  gobuster = pkgs.callPackage ./pkgs/gobuster.nix {};
  seclists = pkgs.callPackage ./pkgs/seclists.nix {}; 
  raccoon = pkgs.callPackage ./pkgs/raccoon.nix {};
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
    python3
    metasploit
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
}

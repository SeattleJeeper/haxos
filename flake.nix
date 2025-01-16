{
  inputs = {
    nixpkgs.url = "nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    dotfiles = {
      url = "github:SeattleJeeper/dotfiles";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, nixpkgs-stable, nixos-generators, home-manager, dotfiles }:
  let
    system = "x86_64-linux";
  in
  {
    packages.x86_64-linux = {
      qcow = nixos-generators.nixosGenerate {
        inherit system;
        modules = [
          ./configuration.nix
          ./overlays/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.haxos = import ./home.nix;
            home-manager.extraSpecialArgs = {
              inherit dotfiles;
              pkgs-stable = import nixpkgs-stable {
                inherit system;
              };
            };
          }
        ];
        format = "qcow";
      };
    };
  };
}

{
  inputs = {
    nixpkgs.url = "nixpkgs/master";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    dotfiles.url = "github:vncsb/dotfiles";
    notes.url = "git+ssh://git@github.com/vncsb/notes";
  };
  outputs = { self, nixpkgs, nixos-generators, home-manager, dotfiles, notes }: {
    packages.x86_64-linux = {
      qcow = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.haxos = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit dotfiles notes; };
          }
        ];
        format = "qcow";
      };
    };
  };
}

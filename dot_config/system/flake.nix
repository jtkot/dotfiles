{
  inputs = {
    nixpkgs-nixos.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs-nixos";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
  outputs =
    {
      home-manager,
      lanzaboote,
      nix-index-database,
      nixpkgs,
      nixpkgs-nixos,
      ...
    }@inputs:
    {
      nixosConfigurations.jan-pc = nixpkgs-nixos.lib.nixosSystem {
        modules = [
          ./nixos.nix
          ./jan-pc.nix
          lanzaboote.nixosModules.lanzaboote
          nix-index-database.nixosModules.default
        ];
        specialArgs = { inherit inputs; };
      };

        homeConfigurations.jan = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [
            ./home.nix
          ];
          extraSpecialArgs = { inherit inputs; };
        };
    };
}

{
  inputs = {
    nixpkgs-nixos.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

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
      nix-darwin,
      nix-index-database,
      nixpkgs,
      nixpkgs-nixos,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
    in
    {
      nixosConfigurations.jan-pc = nixpkgs-nixos.lib.nixosSystem {
        modules = [
          ./system-common.nix
          ./nixos.nix
          ./jan-pc.nix
          lanzaboote.nixosModules.lanzaboote
        ];
        specialArgs = { inherit inputs; };
      };

      darwinConfigurations.jan-macbook = nix-darwin.lib.darwinSystem {
        modules = [
          ./system-common.nix
          ./darwin.nix
          ./jan-macbook.nix
        ];
        specialArgs = { inherit inputs; };
      };

      packages = nixpkgs.lib.genAttrs systems (system: {
        homeConfigurations.jan = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./home.nix
            nix-index-database.homeModules.default
          ];
          extraSpecialArgs = { inherit inputs; };
        };
      });
    };
}

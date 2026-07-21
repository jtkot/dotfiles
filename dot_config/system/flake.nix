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
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
    in
    {
      nixosConfigurations.jan-pc = nixpkgs-nixos.lib.nixosSystem {
        modules = [
          ./nixos.nix
          ./jan-pc.nix
          lanzaboote.nixosModules.lanzaboote
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

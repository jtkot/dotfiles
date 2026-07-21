{
  description = "My NixOS setup";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      lanzaboote,
      nix-index-database,
    }:
    let
      backportsModule = import ./backports.nix nixpkgs;
    in
    {
      nixosConfigurations.jan-pc = nixpkgs.lib.nixosSystem {
        modules = [
          ./base.nix
          ./jan-pc.nix
          backportsModule
          lanzaboote.nixosModules.lanzaboote
          nix-index-database.nixosModules.default
        ];
      };
    };
}

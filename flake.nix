{
  description = "murs nixos";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];

    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    vscode-server.url = "github:nix-community/nixos-vscode-server";

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };

    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , vscode-server
    , agenix
    , home-manager
    , arion
    , ...
    }:
    let
      makeNixosSystem = obj: nixpkgs.lib.nixosSystem (obj // {
        specialArgs = (obj.specialArgs or { }) // {
          inherit inputs;
          abs = path: ./. + ("/" + path);
        };
      });
    in
    {
      nixosConfigurations = {
        srv04 = makeNixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
            ./hosts/srv04/configuration.nix
          ];
        };
      };
    };
}
